import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:statemanagement/model/notion_model.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => NotionListModel(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Notion List Example',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notion List Example'),
      ),
      body: Consumer<NotionListModel>(
        builder: (context, notionListModel, child) {
          return ListView.builder(
            itemCount: notionListModel.notionItems.length,
            itemBuilder: (context, index) {
              final item = notionListModel.notionItems[index];
              return ListTile(
                title: Text(item.title),
                subtitle: Text(item.description),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    notionListModel.deleteItem(item.id);
                  },
                ),
                onTap: () {
                  _showEditNotionItemDialog(context, item);
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddNotionItemDialog(context);
        },
        tooltip: 'Add Notion Item',
        child: const Icon(Icons.add),
      ),
    );
  }
}

void _showAddNotionItemDialog(BuildContext context) {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  bool isChecked = false;

  showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text('Add Notion Item'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(labelText: 'Title'),
                ),
                TextField(
                  controller: descriptionController,
                  decoration: const InputDecoration(labelText: 'Description'),
                ),
                CheckboxListTile(
                  title: const Text('Is Checked?'),
                  value: isChecked,
                  onChanged: (value) {
                    setState(() {
                      isChecked = value!;
                    });
                  },
                ),
              ],
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  final notionListModel =
                      Provider.of<NotionListModel>(context, listen: false);
                  notionListModel.addItem(
                    titleController.text,
                    descriptionController.text,
                    isChecked,
                  );
                  Navigator.of(context).pop();
                },
                child: const Text('Add'),
              ),
            ],
          );
        },
      );
    },
  );
}

void _showEditNotionItemDialog(BuildContext context, NotionItem item) {
  TextEditingController titleController =
      TextEditingController(text: item.title);
  TextEditingController descriptionController =
      TextEditingController(text: item.description);
  bool isChecked = item.isChecked;

  showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text('Edit Notion Item'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(labelText: 'Title'),
                ),
                TextField(
                  controller: descriptionController,
                  decoration: const InputDecoration(labelText: 'Description'),
                ),
                CheckboxListTile(
                  title: const Text('Is Checked?'),
                  value: isChecked,
                  onChanged: (value) {
                    setState(() {
                      isChecked = value!;
                      item.isChecked = value;
                    });
                  },
                ),
              ],
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  final notionListModel =
                      Provider.of<NotionListModel>(context, listen: false);
                  notionListModel.updateItem(
                    item.id,
                    titleController.text,
                    descriptionController.text,
                    isChecked,
                  );
                  Navigator.of(context).pop();
                },
                child: const Text('Save'),
              ),
            ],
          );
        },
      );
    },
  );
}
