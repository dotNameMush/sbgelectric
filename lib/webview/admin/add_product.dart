import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:sbgelectric/services/firestore.dart';
import 'package:uuid/uuid.dart';

import '../../services/models.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({Key? key}) : super(key: key);

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  bool isLoading = false;
  UploadTask? task;
  final _formKey = GlobalKey<FormState>();
  XFile? file;
  String _name = '';
  String _price = '';
  String _category = '';

  List<String>? _categoryList;
  @override
  void initState() {
    super.initState();
    getCategory();
  }

  getCategory() async {
    setState(() {
      isLoading = true;
    });
    List<Category> categoryList = await FirestoreService().getCategory();
    List<String> dropList = categoryList.map((e) => e.name).toList();
    setState(() {
      _categoryList = dropList;
    });
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    String pathname = file == null ? '' : basename(file!.path);
    String errorMessageImage = '';
    return isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
            appBar: AppBar(),
            body: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width / 2,
                        child: Column(
                          children: [
                            Text(
                              errorMessageImage,
                              style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.red),
                            ),
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
                                decoration: const BoxDecoration(
                                    image: DecorationImage(
                                        image: AssetImage('assets/item.png'),
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
                              decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Нэр',
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
                            DropdownButtonFormField(
                              hint: const Text('Ангилал'),
                              onChanged: (value) {
                                setState(() {
                                  _category = value.toString();
                                });
                              },
                              validator: (value) {
                                if (value == null) {
                                  return 'Ангилал сонгоно уу!';
                                } else {
                                  return null;
                                }
                              },
                              onSaved: (value) => _category = value.toString(),
                              items: _categoryList!.map((String val) {
                                return DropdownMenuItem(
                                    value: val, child: Text(val));
                              }).toList(),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            TextFormField(
                              decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Үнэ',
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
                                text: 'Бараа нэмэх',
                                onClicked: () async {
                                  var itemID = const Uuid().v1();
                                  var uploadedPhotoUrl = '';
                                  //validate and check the form with functio
                                  var ref = FirebaseFirestore.instance
                                      .collection('item')
                                      .doc(itemID);
                                  var message = 'Амжилттай';
                                  final snackBar = SnackBar(
                                    content: Text(message),
                                    backgroundColor: Colors.green,
                                  );

                                  final isValid =
                                      _formKey.currentState!.validate();
                                  if (file == null) {
                                    setState(() {
                                      errorMessageImage = 'зураг сонгоно уу';
                                    });
                                    return;
                                  }

                                  if (isValid) {
                                    _formKey.currentState!.save();
                                    var storageref = FirebaseStorage.instance
                                        .ref()
                                        .child(
                                            'images/${basename(file!.path)}');
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
                                      'id': itemID,
                                      'name': _name,
                                      'category': _category,
                                      'img': uploadedPhotoUrl,
                                      'price': _price,
                                    };
                                    ref
                                        .set(data)
                                        .then((value) => message = 'Амжилттай')
                                        .catchError((error) => message = error);
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(snackBar);

                                    Navigator.pushNamed(
                                        context, '/admin-panel');
                                  } else {
                                    // ignore: prefer_const_declarations
                                    final message =
                                        'Амжилтгүй!\nМэдээллээ шалгаад дахин оруулна уу?';
                                    final snackBar = SnackBar(
                                      content: Text(message,
                                          style: const TextStyle(
                                              color: Colors.white)),
                                      backgroundColor: Colors.red,
                                    );
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(snackBar);
                                  }
                                }),
                            task != null
                                ? buildUploadStatus(task!)
                                : Container(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ));
  }

  Future selectFile() async {
    XFile? pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      file = pickedFile;
    });
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
}

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
