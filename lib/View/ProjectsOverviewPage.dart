import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sewingcalculator/Database/database.dart';
import 'package:sewingcalculator/Provider/database_provider.dart';
import 'package:sewingcalculator/View/PaywallPage.dart';
import 'package:sewingcalculator/View/SettingsPage.dart';
import 'package:intl/intl.dart';

class ProjectsOverviewPage extends StatefulWidget {
  const ProjectsOverviewPage({super.key});

  @override
  _ProjectsOverviewPageState createState() => _ProjectsOverviewPageState();
}

class _ProjectsOverviewPageState extends State<ProjectsOverviewPage> {
  late DatabaseProvider _databaseProvider;

  @override
  void initState() {
    super.initState();
    _databaseProvider = Provider.of<DatabaseProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meine Kalkulationen'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsPage()),
              );
            },
          ),
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

          final projects = snapshot.data ?? [];

          if (projects.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.calculate_outlined, size: 80, color: Colors.grey),
                  const SizedBox(height: 16),
                  const Text(
                    'Keine Kalkulationen vorhanden',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Erstelle eine neue Kalkulation mit dem + Button',
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.add),
                    label: const Text('Neue Kalkulation'),
                    onPressed: () => _createNewProject(context),
                  ),
                ],
              ),
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
                  leading: const CircleAvatar(
                    child: Icon(Icons.calculate),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () => _openProject(context, project),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => _confirmDeleteProject(context, project),
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
        tooltip: 'Neue Kalkulation',
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
      Navigator.pushNamed(
        context, 
        '/calculation',
        arguments: projectId,
      );
    }
  }

  void _openProject(BuildContext context, Project project) {
    // Navigate to calculation screen with the project ID
    Navigator.pushNamed(
      context, 
      '/calculation',
      arguments: project.id,
    );
  }

  Future<void> _confirmDeleteProject(BuildContext context, Project project) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Kalkulation löschen'),
        content: Text('Möchtest du die Kalkulation "${project.name}" wirklich löschen?'),
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
      title: const Text('Neue Kalkulation'),
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
