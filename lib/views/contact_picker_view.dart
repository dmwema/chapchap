import 'package:chapchap/res/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';

class ContactPickerView extends StatefulWidget {
  const ContactPickerView({super.key});

  @override
  _ContactPickerViewState createState() => _ContactPickerViewState();
}

class _ContactPickerViewState extends State<ContactPickerView> {
  List<Contact> contacts = [];

  @override
  void initState() {
    super.initState();
    loadContacts();
  }

  Future<void> loadContacts() async {
    final permissionStatus = await FlutterContacts.permissions.request(PermissionType.readWrite);
    if (permissionStatus == PermissionStatus.granted) {
      List<Contact> list = await FlutterContacts.getAll();
      setState(() {
        contacts = list;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: AppBar(title: const Text('Séléctionner un contact')),
      body: ListView.builder(
        itemCount: contacts.length,
        itemBuilder: (context, index) {
          final contact = contacts[index];
          return ListTile(
            title: Text(contact.displayName ?? "-"),
            subtitle: contact.phones.isNotEmpty
                ? Text(contact.phones.first.number)
                : const Text('Aucun numéro'),
            onTap: () {
              Navigator.pop(context, contact); // Retourne le contact sélectionné
            },
          );
        },
      ),
    );
  }
}
