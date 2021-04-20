import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class CreateTagDialog extends StatefulWidget {
  CreateTagDialog({Key? key, required User user}) : _user = user, super(key: key);

  final User _user;
  @override
  _CreateTagDialogState createState() => _CreateTagDialogState();
}

class _CreateTagDialogState extends State<CreateTagDialog> {
  int _iconValue = 5278;
  int _iconValueBack = 5278;
  late Icon tagIcon;

  final myController = TextEditingController();

  // late final List<String> listExample;
  late final List<String> mapIcons;
  late CollectionReference tags;

  @override
  void initState() {
    tags = FirebaseFirestore.instance.collection('tags/').doc('${widget._user.uid}').collection('tags/');
    // listExample = List<String>.generate(100, (i) => "Item $i");
    mapIcons = MdiIcons.getIconsName();
    tagIcon = Icon(MdiIcons.fromString(mapIcons[5278]));
    super.initState();
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pink.shade900,
        title: Text('Crear Etiqueta'),
        actions: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: TextButton(
              style: TextButton.styleFrom(primary: Colors.white),
              onPressed: () {
                addTag(myController.text, mapIcons[_iconValueBack]);
                Navigator.of(context).pop();
              },
              child: Text("GUARDAR"),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.only(right: 16, left: 4, top: 16, bottom: 16),
        child: Row(
          children: <Widget>[
            IconButton(
              padding: EdgeInsets.only(left: 0),
              icon: tagIcon,
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return  AlertDialog(
                        title: Text('Icono'),
                        titlePadding: EdgeInsets.all(20.0),
                        insetPadding: EdgeInsets.symmetric(vertical: 4),
                        contentPadding: EdgeInsets.symmetric(horizontal: 0),
                        content: StatefulBuilder(
                            builder: (BuildContext context, StateSetter setState) {
                              return SingleChildScrollView(
                            child: Container(
                              width: double.maxFinite * 0,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Divider(
                                    height: 1.0,
                                    color: Colors.grey,
                                  ),
                                  ConstrainedBox(
                                    constraints: BoxConstraints(
                                      maxHeight: MediaQuery.of(context).size.height * 0.4,
                                    ),
                                    child: ListView.builder(
                                      itemCount: mapIcons.length,
                                      itemBuilder: (context, index) => TagIconTile(
                                        index: index,
                                        doc: mapIcons[index],
                                        onChanged: (dynamic value) {
                                          setState(() {
                                            _iconValue = value;
                                          });
                                        },
                                        groupValue: _iconValue,
                                      ),
                                    ),
                                  ),
                                  Divider(
                                    height: 1.0,
                                    color: Colors.grey,
                                  ),
                                ],
                              ),
                            ),
                          );
                            }
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                              setState(() {
                                _iconValue = _iconValueBack;
                              });
                            },
                            child: Text('CANCELAR'),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                              setState(() {
                                _iconValueBack = _iconValue;
                                print('VALUE => $_iconValueBack');
                                tagIcon = Icon(MdiIcons.fromString(mapIcons[_iconValue]));
                              });
                            },
                            child: Text('ACEPTAR'),
                          ),
                        ],
                      );
                    }
                );
              },
            ),
            Expanded(
              child: TextFormField(
                autofocus: true,
                controller: myController,
                decoration: InputDecoration(
                  filled: true,
                  labelText: 'Título',
                  labelStyle: TextStyle(
                    color: Colors.deepOrange,
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.deepOrange),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> addTag(String name, String icon) {
    return tags.add({
      'icon': icon,
      'name': name
    });
  }
}

class TagIconTile extends StatefulWidget {
  TagIconTile({
    Key? key,
    required this.doc,
    required this.index,
    required this.groupValue,
    this.onChanged,
  }) : super(key: key);

  final String doc;
  final int index;
  final Object? groupValue;
  final void Function(Object?)? onChanged;

  @override
  _TagIconTileState createState() => _TagIconTileState();
}

class _TagIconTileState extends State<TagIconTile> {

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(widget.doc),
      leading: Icon(MdiIcons.fromString(widget.doc)),
      trailing: Radio(
        value: widget.index,
        groupValue: widget.groupValue,
        onChanged: widget.onChanged,
      ),
    );
  }
}
