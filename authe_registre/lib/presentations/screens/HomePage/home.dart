import 'package:authe_registre/business_logic/cubit/add_note_cubit.dart';
import 'package:authe_registre/presentations/screens/Login/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:authe_registre/business_logic/cubit/auth_cubit.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AddNoteCubit, AddNoteState>(
      listener: (context, state) {
        if (state is NoteSuccess) context.read<AuthCubit>().loadNotes();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Mes Notes',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          backgroundColor: const Color.fromARGB(255, 71, 132, 238),
          actions: [
            IconButton(
              icon: const Icon(Icons.exit_to_app, color: Colors.white),
              onPressed: () {
                context.read<AuthCubit>().logout();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const Login()),
                );
              },
            ),
          ],
        ),
        body: BlocBuilder<AuthCubit, AuthState>(
          builder: (context, state) {
            if (state is AuthSuccess) {
              final notes = state.notes;

              if (notes.isEmpty) {
                return const Center(
                  child: Text(
                    'Aucune note trouvée',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.all(10),
                itemCount: notes.length,
                itemBuilder: (context, index) {
                  final note = notes[index];

                  return Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    margin:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 5),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(10),
                      leading: const Icon(Icons.note,
                          color: Color.fromARGB(255, 78, 102, 235), size: 30),
                      title: Text(
                        note['title'],
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        note['description'],
                        style: const TextStyle(
                            fontSize: 16, color: Colors.black54),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.blue),
                            onPressed: () {
                              _editNote(context, note);
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              _deleteNote(context, note);
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            } else if (state is AuthLoading) {
              return const Center(child: CircularProgressIndicator());
            } else {
              return const Center(
                child: Text(
                  'Aucune note trouvée',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              );
            }
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _addNote(
                context); // Ouvrir une boîte de dialogue pour ajouter une note
          },
          backgroundColor: const Color.fromARGB(255, 71, 132, 238),
          child: const Icon(Icons.add, color: Colors.white),
        ),
      ),
    );
  }

  void _addNote(BuildContext context) {
    // Boîte de dialogue pour ajouter une note
    showDialog(
      context: context,
      builder: (context) {
        final _titleController = TextEditingController();
        final _descriptionController = TextEditingController();

        return Flexible(
          child: AlertDialog(
            title: const Text('Ajouter une note'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    labelText: 'Titre',
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                  ),
                  maxLines: 3,
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // Fermer la boîte de dialogue
                },
                child: const Text('Annuler'),
              ),
              TextButton(
                onPressed: () {
                  final title = _titleController.text;
                  final description = _descriptionController.text;

                  if (title.isNotEmpty && description.isNotEmpty) {
                    // Ajouter la note via le Cubit
                    final authState = context.read<AuthCubit>().state;
                    if (authState is AuthSuccess) {
                      context
                          .read<AddNoteCubit>()
                          .createNote(title, description);
                    }
                    Navigator.pop(context); // Fermer la boîte de dialogue
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Veuillez remplir tous les champs')),
                    );
                  }
                },
                child: const Text('Ajouter'),
              ),
            ],
          ),
        );
      },
    );
  }

  void _editNote(BuildContext context, Map<String, dynamic> note) {
    // Contrôleurs pour les champs de saisie
    final TextEditingController titleController =
        TextEditingController(text: note['title']);
    final TextEditingController descriptionController =
        TextEditingController(text: note['description']);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context)
                .viewInsets
                .bottom, // Pour éviter que le clavier couvre les champs
          ),
          child: Container(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: InputDecoration(labelText: 'Titre'),
                ),
                TextField(
                  controller: descriptionController,
                  decoration: InputDecoration(labelText: 'Description'),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    // Récupérer les nouvelles valeurs
                    final newTitle = titleController.text;
                    final newDescription = descriptionController.text;

                    // Appeler l'API pour mettre à jour la note
                    try {
                      context.read<AuthCubit>().updateNote(
                            note['_id'],
                            newTitle,
                            newDescription,
                          );

                      // Afficher un message de succès
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Note mise à jour avec succès'),
                          backgroundColor: Colors.green,
                        ),
                      );

                      // Fermer le modal
                      Navigator.pop(context);
                    } catch (e) {
                      // Afficher un message d'erreur
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text(
                                'Erreur lors de la mise à jour de la note: $e')),
                      );
                    }
                  },
                  child: Text('Enregistrer'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // void _deleteNote(BuildContext context, Map<String, dynamic> note) {
  //   context.read<AuthCubit>().deleteNote(note['_id']);
  //   ScaffoldMessenger.of(context).showSnackBar(
  //     SnackBar(content: Text('Supprimer la note: ${note['_id']}')),
  //   );
  // }

  void _deleteNote(BuildContext context, Map<String, dynamic> note) async {
    // Afficher une boîte de dialogue de confirmation
    bool confirmDelete = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmer la suppression'),
          content: Text(
              'Êtes-vous sûr de vouloir supprimer la note : ${note['title']} ?'),
          actions: <Widget>[
            TextButton(
              child: Text('Annuler'),
              onPressed: () {
                Navigator.of(context).pop(false); // Retourne false pour annuler
              },
            ),
            TextButton(
              child: Text('Supprimer'),
              onPressed: () {
                Navigator.of(context).pop(true); // Retourne true pour confirmer
              },
            ),
          ],
        );
      },
    );

    // Si l'utilisateur confirme la suppression
    if (confirmDelete == true) {
      context.read<AuthCubit>().deleteNote(note['_id']);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Note supprimée : ${note['title']}')),
      );
    }
  }
}
