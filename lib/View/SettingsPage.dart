import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sewingcalculator/Provider/data_provider.dart';
import 'package:sewingcalculator/Provider/database_provider.dart';
import 'package:sewingcalculator/View/PaywallPage.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _isPremium = false;
  bool _isLoading = true;
  bool _tutorialFinished = false;
  bool _devModeEnabled = false;
  String _versionName = '1.0.0'; // Default version

  @override
  void initState() {
    super.initState();
    _loadSettings();
    _loadVersionName();
  }

  Future<void> _loadSettings() async {
    final databaseProvider = Provider.of<DatabaseProvider>(context, listen: false);
    final isPremium = await databaseProvider.isPremium();

    final prefs = await SharedPreferences.getInstance();
    final tutorialFinished = prefs.getBool('onboarding_completed') ?? false;
    final devModeEnabled = prefs.getBool('dev_mode_enabled') ?? false;

    if (mounted) {
      setState(() {
        _isPremium = isPremium;
        _tutorialFinished = tutorialFinished;
        _devModeEnabled = devModeEnabled;
        _isLoading = false;
      });
    }
  }

  Future<void> _setTutorialFinished(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_completed', value);

    if (mounted) {
      setState(() {
        _tutorialFinished = value;
      });
    }
  }

  Future<void> _showOnboardingAgain() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_completed', false);

    if (mounted) {
      setState(() {
        _tutorialFinished = false;
      });

      // Restart the app to show the onboarding screen
      Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
    }
  }

  Future<void> _setDevModeEnabled(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('dev_mode_enabled', value);

    if (mounted) {
      setState(() {
        _devModeEnabled = value;
      });
    }
  }

  Future<void> _loadVersionName() async {
    try {
      final file = File('${Directory.current.path}/android/local.properties');
      if (await file.exists()) {
        final contents = await file.readAsString();
        final lines = contents.split('\n');
        for (final line in lines) {
          if (line.startsWith('flutter.versionName=')) {
            final version = line.split('=')[1].trim();
            if (mounted) {
              setState(() {
                _versionName = version;
              });
            }
            break;
          }
        }
      }
    } catch (e) {
      // If there's an error reading the file, we'll use the default version
      print('Error reading version name: $e');
    }
  }

  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }

  Future<void> _exportData() async {
    try {
      final databaseProvider = Provider.of<DatabaseProvider>(context, listen: false);

      // Get all projects
      final projects = await databaseProvider.getAllProjects();

      // Create a map to store all data
      final Map<String, dynamic> backupData = {
        'projects': [],
      };

      // For each project, get materials, accessories, and fees
      for (final project in projects) {
        final materials = await databaseProvider.getMaterialsForProject(project.id);
        final accessories = await databaseProvider.getAccessoriesForProject(project.id);
        final fees = await databaseProvider.getFeesForProject(project.id);

        final projectData = {
          'id': project.id,
          'name': project.name,
          'createdAt': project.createdAt.toIso8601String(),
          'updatedAt': project.updatedAt.toIso8601String(),
          'materials': materials.map((m) => {
            'id': m.id,
            'projectId': m.projectId,
            'type': m.type,
            'unitIdentifier': m.unitIdentifier,
            'purchasePricePerUnit': m.purchasePricePerUnit,
            'amount': m.amount,
          }).toList(),
          'accessories': accessories.map((a) => {
            'id': a.id,
            'projectId': a.projectId,
            'type': a.type,
            'unitIdentifier': a.unitIdentifier,
            'purchasePricePerUnit': a.purchasePricePerUnit,
            'amount': a.amount,
          }).toList(),
          'fees': fees.map((f) => {
            'id': f.id,
            'projectId': f.projectId,
            'type': f.type,
            'percentage': f.percentage,
            'fixFee': f.fixFee,
            'isActive': f.isActive,
            'interactive': f.interactive,
            'onEk': f.onEk,
          }).toList(),
        };

        backupData['projects'].add(projectData);
      }

      // Convert to JSON
      final jsonData = jsonEncode(backupData);

      // Get the documents directory
      final directory = await getApplicationDocumentsDirectory();
      final timestamp = DateTime.now().toIso8601String().replaceAll(':', '-').replaceAll('.', '-');
      final filePath = '${directory.path}/naehify_backup_$timestamp.json';

      // Write to file
      final file = File(filePath);
      await file.writeAsBytes(utf8.encode(jsonData));

      // Ask user where to save the file
      final String? outputPath = await FilePicker.platform.saveFile(
        dialogTitle: 'Backup speichern',
        fileName: 'naehify_backup_$timestamp.json',
      );

      if (outputPath != null) {
        // Copy the file to the selected location
        await file.copy(outputPath);

        // Show success message
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Backup erfolgreich erstellt'),
              backgroundColor: Colors.green,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Fehler beim Erstellen des Backups: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _importData(bool keepExisting) async {
    try {
      // Ask user to select a file
      final FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['json'],
      );

      if (result != null) {
        final file = File(result.files.single.path!);
        final jsonData = await file.readAsString();
        final backupData = jsonDecode(jsonData) as Map<String, dynamic>;

        final databaseProvider = Provider.of<DatabaseProvider>(context, listen: false);

        // If not keeping existing data, delete all projects
        if (!keepExisting) {
          final projects = await databaseProvider.getAllProjects();
          for (final project in projects) {
            await databaseProvider.deleteProject(project.id);
          }
        }

        // Import projects
        final projectsList = backupData['projects'] as List;
        for (final projectData in projectsList) {
          // Create project
          final projectId = await databaseProvider.createProject(projectData['name']);

          // Import materials
          final materialsList = projectData['materials'] as List;
          for (final materialData in materialsList) {
            await databaseProvider.addMaterialToProject(
              projectId,
              materialData['type'],
              materialData['unitIdentifier'],
              materialData['purchasePricePerUnit'],
              materialData['amount'],
            );
          }

          // Import accessories
          final accessoriesList = projectData['accessories'] as List;
          for (final accessoryData in accessoriesList) {
            await databaseProvider.addAccessoryToProject(
              projectId,
              accessoryData['type'],
              accessoryData['unitIdentifier'],
              accessoryData['purchasePricePerUnit'],
              accessoryData['amount'],
            );
          }

          // Import fees
          final feesList = projectData['fees'] as List;
          for (final feeData in feesList) {
            await databaseProvider.addFeeToProject(
              projectId,
              feeData['type'],
              feeData['percentage'],
              feeData['fixFee'],
              feeData['isActive'],
              feeData['interactive'],
              feeData['onEk'],
            );
          }
        }

        // Show success message
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Backup erfolgreich importiert'),
              backgroundColor: Colors.green,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Fehler beim Importieren des Backups: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _showImportDialog() async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Backup importieren'),
          content: const Text(
            'Möchtest du die vorhandenen Daten behalten oder ersetzen?',
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _importData(true); // Keep existing data
              },
              child: const Text('Behalten'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _importData(false); // Replace existing data
              },
              child: const Text('Ersetzen'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Abbrechen'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final dataProvider = Provider.of<DataProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Einstellungen'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // VAT Settings Section
                    const Text(
                      'Berechnungseinstellungen',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // VAT Calculation Toggle
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Umsatzsteuer berechnen',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        _isPremium
                                            ? 'Deaktiviere die Berechnung der Umsatzsteuer für Kleinunternehmer'
                                            : 'Premium-Funktion: Deaktiviere die Berechnung der Umsatzsteuer für Kleinunternehmer',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: _isPremium ? Colors.grey : Colors.orange,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Switch(
                                  value: dataProvider.ust,
                                  onChanged: _isPremium
                                      ? (value) {
                                          dataProvider.setUst(value);
                                        }
                                      : null,
                                ),
                              ],
                            ),
                            if (!_isPremium)
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => const PaywallPage(),
                                      ),
                                    );
                                  },
                                  child: const Text('Premium freischalten'),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Tutorial Settings
                    const Text(
                      'App-Einstellungen',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),

                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Onboarding-Tutorial',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        'Einführungs-Tutorial beim App-Start anzeigen',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Switch(
                                  value: !_tutorialFinished,
                                  onChanged: (value) {
                                    _setTutorialFinished(!value);
                                  },
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton.icon(
                              onPressed: _showOnboardingAgain,
                              icon: const Icon(Icons.refresh),
                              label: const Text('Tutorial erneut anzeigen'),
                              style: ElevatedButton.styleFrom(
                                minimumSize: const Size.fromHeight(40),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
/*

                    const SizedBox(height: 16),

                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Entwicklermodus',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        'Premium-Funktionen temporär für Entwicklung freischalten',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Switch(
                                  value: _devModeEnabled,
                                  onChanged: (value) {
                                    _setDevModeEnabled(value);
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),*/

                    const SizedBox(height: 24),

                    // Backup Section
                    const Text(
                      'Datensicherung',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),

                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Backup & Wiederherstellung',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              _isPremium
                                  ? 'Sichere deine Projekte oder stelle ein Backup wieder her'
                                  : 'Premium-Funktion: Sichere deine Projekte oder stelle ein Backup wieder her',
                              style: TextStyle(
                                fontSize: 14,
                                color: _isPremium ? Colors.grey : Colors.orange,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Expanded(
                                  child: ElevatedButton.icon(
                                    icon: const Icon(Icons.backup),
                                    label: const Text('Backup erstellen'),
                                    onPressed: _isPremium ? _exportData : null,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: ElevatedButton.icon(
                                    icon: const Icon(Icons.restore),
                                    label: const Text('Wiederherstellen'),
                                    onPressed: _isPremium ? _showImportDialog : null,
                                  ),
                                ),
                              ],
                            ),
                            if (!_isPremium)
                              Padding(
                                padding: const EdgeInsets.only(top: 16.0),
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => const PaywallPage(),
                                      ),
                                    );
                                  },
                                  child: const Text('Premium freischalten'),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // About Section
                    const Text(
                      'Über die App',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),

                    InkWell(
                      onTap: () => _launchUrl('https://naehify.de'),
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Nähify',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Version $_versionName',
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),
                              const SizedBox(height: 16),
                              const Text(
                                'Entwickelt von',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                'Alexander Grüßung',
                                style: TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 16),
                              const Text(
                                '© 2025 Alle Rechte vorbehalten',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
