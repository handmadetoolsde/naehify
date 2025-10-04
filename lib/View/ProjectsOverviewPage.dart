import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sewingcalculator/Database/database.dart';
import 'package:sewingcalculator/Provider/database_provider.dart';
import 'package:sewingcalculator/View/PaywallPage.dart';
import 'package:sewingcalculator/View/SettingsPage.dart';
import 'package:url_launcher/url_launcher.dart';

class ProjectsOverviewPage extends StatefulWidget {
  const ProjectsOverviewPage({super.key});

  @override
  _ProjectsOverviewPageState createState() => _ProjectsOverviewPageState();
}

class _ProjectsOverviewPageState extends State<ProjectsOverviewPage> {
  late DatabaseProvider _databaseProvider;

  // Neu: Suche
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;
  String _query = '';

  static const String _supportEmail = 'support@naehify.de';


  @override
  void initState() {
    super.initState();
    _databaseProvider = Provider.of<DatabaseProvider>(context, listen: false);

    _searchController.addListener(() {
      setState(() {
        _query = _searchController.text;
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _contactSupport() async {
    final subject = Uri.encodeComponent('Frage zu Nähify');
    final body = Uri.encodeComponent(
      'Hallo Team,\n\nich habe eine Frage zu ...\n\n'
          'App-Version: <VERSION>\n'
          'Gerät/OS: <GERÄT UND VERSION>\n'
          '\nVielen Dank!',
    );

    final uri = Uri(
      scheme: 'mailto',
      path: _supportEmail,
      query: 'subject=$subject&body=$body',
    );

    await launchUrl(uri);

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            _isSearching
                ? TextField(
                  controller: _searchController,
                  autofocus: true,
                  textInputAction: TextInputAction.search,
                  decoration: InputDecoration(
                    hintText: 'Projekte suchen...',
                    border: InputBorder.none,
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon:
                        (_query.isNotEmpty)
                            ? IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () => _searchController.clear(),
                            )
                            : null,
                  ),
                )
                : const Text('Nähify Projekte'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: Icon(_isSearching ? Icons.close : Icons.search),
            tooltip: _isSearching ? 'Suche beenden' : 'Suche',
            onPressed: () {
              setState(() {
                if (_isSearching) {
                  _isSearching = false;
                  _searchController.clear();
                } else {
                  _isSearching = true;
                }
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsPage()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.mail_outline),
            tooltip: 'Support kontaktieren',
            onPressed: _contactSupport,
          )

        ],

      ),
      body: StreamBuilder<List<Project>>(
        stream: _databaseProvider.watchAllProjects(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final allProjects = snapshot.data ?? [];

          if (allProjects.isEmpty) {
            // Keine Daten insgesamt (nicht nur wegen Filter)
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.calculate_outlined,
                    size: 80,
                    color: Colors.grey,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Keine Kalkulationen vorhanden',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Erstelle eine neues Projekt mit dem + Button',
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.add),
                    label: const Text('Neues Projekt'),
                    onPressed: () => _createNewProject(context),
                  ),
                ],
              ),
            );
          }

          // Filtern nach Query (nur Name; passe bei Bedarf an)
          final projects =
              (_query.isEmpty)
                  ? allProjects
                  : allProjects
                      .where(
                        (p) =>
                            p.name.toLowerCase().contains(_query.toLowerCase()),
                      )
                      .toList();

          if (projects.isEmpty) {
            // Es gibt Daten, aber keine Treffer für die aktuelle Suche
            return const Center(
              child: Text('Keine Treffer für die aktuelle Suche'),
            );
          }

          return ListView.builder(
            itemCount: projects.length,
            itemBuilder: (context, index) {
              final project = projects[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  title: Text(
                    project.name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    'Erstellt am: ${DateFormat('dd.MM.yyyy').format(project.createdAt)}',
                  ),
                  leading: const CircleAvatar(child: Icon(Icons.calculate)),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () => _openProject(context, project),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed:
                            () => _confirmDeleteProject(context, project),
                      ),
                    ],
                  ),
                  onTap: () => _openProject(context, project),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _createNewProject(context),
        tooltip: 'Neues Projekt',
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _createNewProject(BuildContext context) async {
    final canCreate = await _databaseProvider.canCreateNewProject();

    if (!canCreate) {
      // Show paywall if user can't create more projects
      if (!mounted) return;

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const PaywallPage()),
      );
      return;
    }

    if (!mounted) return;

    // Show dialog to enter project name
    final projectName = await showDialog<String>(
      context: context,
      builder: (context) => _NewProjectDialog(),
    );

    if (projectName != null && projectName.isNotEmpty) {
      final projectId = await _databaseProvider.createProject(projectName);

      if (!mounted) return;

      // Navigate to calculation screen with the new project ID
      Navigator.pushNamed(context, '/calculation', arguments: projectId);
    }
  }

  void _openProject(BuildContext context, Project project) {
    // Navigate to calculation screen with the project ID
    Navigator.pushNamed(context, '/calculation', arguments: project.id);
  }

  Future<void> _confirmDeleteProject(
    BuildContext context,
    Project project,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Projekt löschen'),
            content: Text(
              'Möchtest du das Projekt "${project.name}" wirklich löschen?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Abbrechen'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Löschen'),
              ),
            ],
          ),
    );

    if (confirmed == true) {
      await _databaseProvider.deleteProject(project.id);
    }
  }
}

class _NewProjectDialog extends StatefulWidget {
  @override
  _NewProjectDialogState createState() => _NewProjectDialogState();
}

class _NewProjectDialogState extends State<_NewProjectDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Neues Projekt'),
      content: Form(
        key: _formKey,
        child: TextFormField(
          controller: _nameController,
          decoration: const InputDecoration(
            labelText: 'Name',
            hintText: 'z.B. Sommerkleid',
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Bitte gib einen Namen ein';
            }
            return null;
          },
          autofocus: true,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Abbrechen'),
        ),
        TextButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              Navigator.pop(context, _nameController.text);
            }
          },
          child: const Text('Erstellen'),
        ),
      ],
    );
  }
}
