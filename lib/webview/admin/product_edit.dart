import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sbgelectric/services/firestore.dart';
import 'package:sbgelectric/services/models.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:path/path.dart';
import 'package:uuid/uuid.dart';
import '../../core/shared/shared.dart';
import 'add_product.dart';

class ProductEdit extends StatelessWidget {
  const ProductEdit({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: const BoxDecoration(color: Color(0xFFF8F8F8)),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Бараанууд',
                          style: TextStyle(
                              fontSize: 36, fontWeight: FontWeight.bold),
                        ),
                        ElevatedButton.icon(
                            onPressed: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const AddProductScreen(),
                                )),
                            icon: const Icon(Icons.add),
                            label: const Text('Бараа нэмэх'))
                      ],
                    ),
                  ),
                  const ProductsWidget(),
                ],
              )
            ],
          ),
        ));
  }
}

class ProductsWidget extends StatelessWidget {
  const ProductsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width - 40;
    return Container(
      padding: const EdgeInsets.all(20),
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: width / 5 * 2.5,
                padding: const EdgeInsets.only(top: 10, bottom: 10, left: 5),
                decoration: BoxDecoration(border: Border.all()),
                child: const Text(
                  'Нэр',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                width: width / 5 * 1,
                padding: const EdgeInsets.only(top: 10, bottom: 10, left: 5),
                decoration: BoxDecoration(border: Border.all()),
                child: const Text(
                  'Ангилал',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                width: width / 5 * 1,
                padding: const EdgeInsets.only(top: 10, bottom: 10, left: 5),
                decoration: BoxDecoration(border: Border.all()),
                child: const Text(
                  'Үнэ',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                  width: width / 5 * 0.5,
                  padding: const EdgeInsets.only(top: 8, bottom: 8, left: 5),
                  decoration: BoxDecoration(border: Border.all()),
                  child: ElevatedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.edit),
                      label: const Text('Засах'))),
            ],
          ),
          FutureBuilder<List<Item>>(
            future: FirestoreService().getItems(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const LoadingScreen();
              } else if (snapshot.hasError) {
                return Center(
                  child: ErrorMessage(message: snapshot.error.toString()),
                );
              } else if (snapshot.hasData) {
                var items = snapshot.data!;

                return Column(
                  children: items.map((item) {
                    var width = MediaQuery.of(context).size.width - 40;
                    return Row(
                      children: [
                        Container(
                          width: width / 5 * 2.5,
                          padding: const EdgeInsets.only(
                              top: 10, bottom: 10, left: 5),
                          decoration: BoxDecoration(border: Border.all()),
                          child: Text(
                            item.name,
                            style: const TextStyle(
                              fontSize: 18,
                            ),
                          ),
                        ),
                        Container(
                          width: width / 5 * 1,
                          padding: const EdgeInsets.only(
                              top: 10, bottom: 10, left: 5),
                          decoration: BoxDecoration(border: Border.all()),
                          child: Text(
                            item.category,
                            style: const TextStyle(
                              fontSize: 18,
                            ),
                          ),
                        ),
                        Container(
                          width: width / 5 * 1,
                          padding: const EdgeInsets.only(
                              top: 10, bottom: 10, left: 5),
                          decoration: BoxDecoration(border: Border.all()),
                          child: Text(
                            item.price,
                            style: const TextStyle(
                              fontSize: 18,
                            ),
                          ),
                        ),
                        Container(
                            width: width / 5 * 0.5,
                            padding: const EdgeInsets.only(
                                top: 8, bottom: 8, left: 5),
                            decoration: BoxDecoration(border: Border.all()),
                            child: ElevatedButton.icon(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            ProductEditScreen(item: item),
                                      ));
                                },
                                icon: const Icon(Icons.edit),
                                label: const Text('Засах'))),
                      ],
                    );
                  }).toList(),
                );
              } else {
                return const Text(
                    'No Category found in Firestore. Check database');
              }
            },
          )
        ],
      ),
    );
  }
}

class ProductEditScreen extends StatefulWidget {
  final Item item;
  const ProductEditScreen({Key? key, required this.item}) : super(key: key);

  @override
  State<ProductEditScreen> createState() => _ProductEditScreenState();
}

class _ProductEditScreenState extends State<ProductEditScreen> {
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
            appBar: AppBar(
              centerTitle: true,
              title: Text('Бараа засах: ${widget.item.name}'),
            ),
            body: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
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
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: NetworkImage(widget.item.img),
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
                                  labelText: widget.item.name,
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
                            Text(widget.item.category,
                                style: const TextStyle(
                                    fontSize: 21, fontWeight: FontWeight.bold)),
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
                              decoration: InputDecoration(
                                  border: const OutlineInputBorder(),
                                  labelText: widget.item.price,
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
                                text: 'Бараа Засах',
                                onClicked: () async {
                                  var itemID = widget.item.id;
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

                                  if (isValid) {
                                    _formKey.currentState!.save();
                                    if (file == null) {
                                      //Prep form data for firebase
                                      var data = {
                                        'id': itemID,
                                        'name': _name,
                                        'category': _category,
                                        'img': widget.item.img,
                                        'price': _price,
                                      };
                                      ref
                                          .set(data)
                                          .then(
                                              (value) => message = 'Амжилттай')
                                          .catchError(
                                              (error) => message = error);
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(snackBar);

                                      Navigator.pushNamed(
                                          context, '/admin-panel');
                                    } else {
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
                                          .then(
                                              (value) => message = 'Амжилттай')
                                          .catchError(
                                              (error) => message = error);
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(snackBar);

                                      Navigator.pushNamed(
                                          context, '/admin-panel');
                                    }
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
                            const SizedBox(
                              height: 20,
                            ),
                            ButtonWidget(
                                icon: FontAwesomeIcons.trash,
                                color: Colors.red,
                                text: 'Бараа Устгах',
                                onClicked: () async {
                                  try {
                                    var itemID = widget.item.id;
                                    //validate and check the form with functio
                                    var ref = FirebaseFirestore.instance
                                        .collection('item')
                                        .doc(itemID);
                                    ref.delete().catchError((error) => {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                            content: Text(error),
                                            backgroundColor: Colors.red,
                                          ))
                                        });
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(const SnackBar(
                                      content: Text('Бараа устгагдлаа'),
                                      backgroundColor: Colors.red,
                                    ));
                                    Navigator.pushNamed(
                                        context, '/admin-panel');
                                  } catch (e) {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(
                                      content: Text(e.toString()),
                                      backgroundColor: Colors.red,
                                    ));
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
