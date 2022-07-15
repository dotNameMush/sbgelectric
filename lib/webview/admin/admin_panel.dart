import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:sbgelectric/core/app_core/auth.dart';
import 'package:path/path.dart';
import 'package:sbgelectric/webview/admin/product_edit.dart';

import '../../core/shared/shared.dart';
import '../../services/firestore.dart';
import '../../services/models.dart';
import 'category_edit.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({Key? key}) : super(key: key);

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  int _selectedIndex = 0;

  static final List<Widget> _widgetOptions = <Widget>[
    const ShowcaseEdit(),
    const CategoryEdit(),
    const ProductEdit()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Админ цэс'),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () => Navigator.pushNamed(context, '/'),
              icon: const Icon(Icons.home))
        ],
      ),
      drawer: Drawer(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(20),
                bottomRight: Radius.circular(20))),
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              ListTile(
                onTap: () => _onItemTapped(0),
                leading: const Icon(Icons.live_tv_sharp),
                title: const Text('Үзүүлэн'),
              ),
              ListTile(
                onTap: () => _onItemTapped(1),
                leading: const Icon(Icons.shopping_bag_outlined),
                title: const Text('Ангилал'),
              ),
              ListTile(
                onTap: () => _onItemTapped(2),
                leading: const Icon(Icons.shopping_bag_outlined),
                title: const Text('Бараа'),
              ),
              ListTile(
                onTap: () => AuthService().signOut(),
                leading: const Icon(Icons.logout, color: Colors.red),
                title: const Text('Sign Out'),
              ),
            ],
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(color: Color(0xFFF8F8F8)),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
    );
  }
}

class ShowcaseEdit extends StatelessWidget {
  const ShowcaseEdit({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      decoration: const BoxDecoration(color: Colors.white),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Padding(
            padding: EdgeInsets.all(20),
            child: Text('Үзүүлэнгийн бараанууд'),
          ),
          Container(
            padding: const EdgeInsets.all(5),
            height: MediaQuery.of(context).size.height - 150,
            child: FutureBuilder<List<Showcase>>(
              future: FirestoreService().getShowcase(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const LoadingScreen();
                } else if (snapshot.hasError) {
                  return Center(
                    child: ErrorMessage(message: snapshot.error.toString()),
                  );
                } else if (snapshot.hasData) {
                  var showcase = snapshot.data!;

                  return Wrap(
                    children: showcase
                        .map((showcase) => SalesCardWidget(showcase: showcase))
                        .toList(),
                  );
                } else {
                  return const Text(
                      'No Category found in Firestore. Check database');
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

class SalesCardWidget extends StatelessWidget {
  final Showcase showcase;
  const SalesCardWidget({Key? key, required this.showcase}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            spreadRadius: 0,
            blurRadius: 4,
            offset: const Offset(0, 4), // changes position of shadow
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(5),
            width: 230,
            height: 320,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: NetworkImage(showcase.img.toString()),
                    fit: BoxFit.cover)),
          ),
          Container(
            decoration: const BoxDecoration(color: Colors.white),
            padding: const EdgeInsets.all(5),
            height: 80,
            width: 230,
            child: Column(
              children: [
                Text(
                  showcase.name,
                  style: const TextStyle(color: Colors.black, fontSize: 18),
                ),
                Text(
                  showcase.price,
                  style: const TextStyle(color: Colors.blue, fontSize: 18),
                )
              ],
            ),
          ),
          ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext context) =>
                        ShowcaseItemScreen(showcase: showcase)));
              },
              child: const Text('Засах'))
        ],
      ),
    );
  }
}

class ShowcaseItemScreen extends StatefulWidget {
  final Showcase showcase;

  const ShowcaseItemScreen({Key? key, required this.showcase})
      : super(key: key);

  @override
  State<ShowcaseItemScreen> createState() => _ShowcaseItemScreenState();
}

final _formKey = GlobalKey<FormState>();

class _ShowcaseItemScreenState extends State<ShowcaseItemScreen> {
  UploadTask? task;
  XFile? file;
  String _name = '';
  String _price = '';
  @override
  Widget build(BuildContext context) {
    String pathname = file == null ? '' : basename(file!.path);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.showcase.name),
        centerTitle: true,
      ),
      body: Container(
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Text(
                          pathname,
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                        InkWell(
                          onTap: selectFile,
                          child: Container(
                            padding: const EdgeInsets.all(5),
                            width: 230,
                            height: 320,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: NetworkImage(widget.showcase.img),
                                    fit: BoxFit.cover)),
                            child: const Center(
                              child: Icon(
                                Icons.upload_rounded,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          decoration: InputDecoration(
                              border: const OutlineInputBorder(),
                              labelText: widget.showcase.name,
                              prefixText: 'Барааны нэр: '),
                          validator: (value) {
                            if (value!.length < 3) {
                              return 'Нэр бүтэн бичнэ үү!';
                            } else {
                              return null;
                            }
                          },
                          onSaved: (value) => _name = value!,
                          onChanged: (value) => _name = value,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          decoration: InputDecoration(
                              border: const OutlineInputBorder(),
                              labelText: widget.showcase.price,
                              prefixText: 'Үнэ: '),
                          validator: (value) {
                            if (value!.length < 3) {
                              return 'Үнэ бүтэн бичнэ үү!';
                            } else {
                              return null;
                            }
                          },
                          onSaved: (value) => _price = value!,
                          onChanged: (value) => _price = value,
                        ),
                        const SizedBox(
                          height: 50,
                        ),
                        ButtonWidget(
                            icon: FontAwesomeIcons.arrowUp,
                            color: const Color(0xFF223263),
                            text: 'Мэдээлэл илгээх',
                            onClicked: () async {
                              var uploadedPhotoUrl = '';
                              //validate and check the form with functio
                              var ref = FirebaseFirestore.instance
                                  .collection('showcase')
                                  .doc(widget.showcase.id);
                              var message = 'Амжилттай';
                              final snackBar = SnackBar(
                                content: Text(message),
                                backgroundColor: Colors.green,
                              );

                              final isValid = _formKey.currentState!.validate();
                              if (isValid) {
                                _formKey.currentState!.save();
                                var storageref = FirebaseStorage.instance
                                    .ref()
                                    .child('images/${basename(file!.path)}');
                                await storageref
                                    .putData(
                                        await file!.readAsBytes(),
                                        SettableMetadata(
                                            contentType: 'image/jpeg'))
                                    .whenComplete(() async {
                                  await storageref
                                      .getDownloadURL()
                                      .then((value) {
                                    setState(() {
                                      uploadedPhotoUrl = value;
                                    });
                                  });
                                });
                                //Prep form data for firebase
                                var data = {
                                  'id': widget.showcase.id,
                                  'name': _name,
                                  'img': uploadedPhotoUrl,
                                  'price': _price,
                                };
                                ref
                                    .set(data)
                                    .then((value) => message = 'Амжилттай')
                                    .catchError((error) => message = error);
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(snackBar);

                                Navigator.pushNamed(context, '/admin-panel');
                              } else {
                                // ignore: prefer_const_declarations
                                final message =
                                    'Амжилтгүй!\nМэдээллээ шалгаад дахин оруулна уу?';
                                final snackBar = SnackBar(
                                  content: Text(message,
                                      style:
                                          const TextStyle(color: Colors.white)),
                                  backgroundColor: Colors.red,
                                );
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(snackBar);
                              }
                            }),
                        task != null ? buildUploadStatus(task!) : Container(),
                      ],
                    ))
              ],
            ),
          )),
    );
  }

  Future selectFile() async {
    XFile? pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      file = pickedFile;
    });
  }
}

Widget buildUploadStatus(UploadTask task) => StreamBuilder<TaskSnapshot>(
      stream: task.snapshotEvents,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final snap = snapshot.data!;
          final progress = snap.bytesTransferred / snap.totalBytes;
          final percentage = (progress * 100).toStringAsFixed(2);

          return Text(
            '$percentage %',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          );
        } else {
          return Container();
        }
      },
    );

class ButtonWidget extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String text;
  final VoidCallback onClicked;

  const ButtonWidget({
    Key? key,
    required this.icon,
    required this.color,
    required this.text,
    required this.onClicked,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: color,
          minimumSize: const Size.fromHeight(50),
        ),
        child: buildContent(),
        onPressed: onClicked,
      );

  Widget buildContent() => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 28),
          const SizedBox(width: 16),
          Text(
            text,
            style: const TextStyle(fontSize: 22, color: Colors.white),
          ),
        ],
      );
}
