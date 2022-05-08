import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sbgelectric/webview/admin/add_category.dart';

import '../../core/shared/shared.dart';
import '../../services/firestore.dart';
import '../../services/models.dart';

class CategoryEdit extends StatelessWidget {
  const CategoryEdit({Key? key}) : super(key: key);

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
                          'Барааны ангилал',
                          style: TextStyle(
                              fontSize: 36, fontWeight: FontWeight.bold),
                        ),
                        ElevatedButton.icon(
                            onPressed: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const AddCategoryScreen(),
                                )),
                            icon: const Icon(Icons.add),
                            label: const Text('Ангилал нэмэх'))
                      ],
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width / 10 * 5,
                    child: const CategoryWidget(),
                  ),
                ],
              )
            ],
          ),
        ));
  }
}

class CategoryWidget extends StatelessWidget {
  const CategoryWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Category>>(
      future: FirestoreService().getCategory(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const LoadingScreen();
        } else if (snapshot.hasError) {
          return Center(
            child: ErrorMessage(message: snapshot.error.toString()),
          );
        } else if (snapshot.hasData) {
          var categories = snapshot.data!;

          return Wrap(
            children: categories
                .map((category) => CategoryItem(category: category))
                .toList(),
          );
        } else {
          return const Text('No Category found in Firestore. Check database');
        }
      },
    );
  }
}

class CategoryItem extends StatelessWidget {
  final Category category;
  const CategoryItem({Key? key, required this.category}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      child: InkWell(
          onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CategoryEditScreen(category: category),
              )),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 100,
                width: 100,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: const [
                      BoxShadow(
                          color: Colors.grey,
                          spreadRadius: 2,
                          blurRadius: 4,
                          offset: Offset(4, 4)),
                      BoxShadow(
                          color: Colors.white,
                          spreadRadius: 4,
                          blurRadius: 4,
                          offset: Offset(-4, -4)),
                    ]),
                child: const Center(
                  child: Icon(
                    FontAwesomeIcons.edit,
                    color: Colors.red,
                    size: 40,
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                category.name,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              )
            ],
          )),
    );
  }
}

class CategoryEditScreen extends StatefulWidget {
  final Category category;
  const CategoryEditScreen({Key? key, required this.category})
      : super(key: key);

  @override
  State<CategoryEditScreen> createState() => _CategoryEditScreenState();
}

class _CategoryEditScreenState extends State<CategoryEditScreen> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        decoration: const BoxDecoration(color: Color(0xFFF8F8F8)),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Container(
              width: MediaQuery.of(context).size.width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 30,
                  ),
                  const Text('Ангилал засах',
                      style:
                          TextStyle(fontSize: 21, fontWeight: FontWeight.bold)),
                  const SizedBox(
                    height: 30,
                  ),
                  Container(
                    width: 400,
                    child: TextFormField(
                      maxLength: 20,
                      controller: nameController,
                      cursorColor: Colors.white,
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Нэр',
                          errorBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.red))),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (title) => title != null && title.length < 2
                          ? 'Нэр богино байна'
                          : null,
                    ),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  InkWell(
                    onTap: () async {
                      var ref =
                          FirebaseFirestore.instance.collection('category');
                      final isValid = _formKey.currentState!.validate();
                      if (!isValid) return;

                      //post data to firestore
                      var formData = {
                        'id': widget.category.id,
                        'name': nameController.text.trim(),
                      };
                      try {
                        ref.doc(widget.category.id).set(formData).whenComplete(
                            () {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                                  backgroundColor: Colors.green,
                                  content: Text(
                                    'Амжилттай',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 14),
                                  )));
                        }).catchError((error) =>
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                backgroundColor: Colors.red,
                                content: Text(
                                  error,
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 14),
                                ))));
                        Navigator.of(context, rootNavigator: true).pop();
                        Navigator.pop(context);
                        Navigator.pushNamed(context, '/admin-panel');
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            backgroundColor: Colors.red,
                            content: Text(
                              e.toString(),
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 14),
                            )));
                      }
                    },
                    child: Container(
                      width: 250,
                      height: 35,
                      decoration: const BoxDecoration(color: Color(0xFF32C22F)),
                      child: const Center(
                        child: Text(
                          'Нийтлэх',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () async {
                      var ref =
                          FirebaseFirestore.instance.collection('category');

                      //post data to firestore

                      try {
                        ref.doc(widget.category.id).delete().whenComplete(() {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                                  backgroundColor: Colors.green,
                                  content: Text(
                                    'Амжилттай',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 14),
                                  )));
                        }).catchError((error) =>
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                backgroundColor: Colors.red,
                                content: Text(
                                  error,
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 14),
                                ))));
                        Navigator.of(context, rootNavigator: true).pop();
                        Navigator.pop(context);
                        Navigator.pushNamed(context, '/admin-panel');
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            backgroundColor: Colors.red,
                            content: Text(
                              e.toString(),
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 14),
                            )));
                      }
                    },
                    child: Container(
                      width: 250,
                      height: 35,
                      decoration: const BoxDecoration(color: Colors.red),
                      child: const Center(
                        child: Text(
                          'Устгах',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
