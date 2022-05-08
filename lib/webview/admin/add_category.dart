import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class AddCategoryScreen extends StatefulWidget {
  const AddCategoryScreen({Key? key}) : super(key: key);

  @override
  State<AddCategoryScreen> createState() => _AddCategoryScreenState();
}

class _AddCategoryScreenState extends State<AddCategoryScreen> {
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
                  const Text('Ангилал нэмэх',
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
                      var categoryid = const Uuid().v1();
                      var ref =
                          FirebaseFirestore.instance.collection('category');
                      final isValid = _formKey.currentState!.validate();
                      if (!isValid) return;

                      //post data to firestore
                      var formData = {
                        'id': categoryid,
                        'name': nameController.text.trim(),
                      };
                      try {
                        ref.doc(categoryid).set(formData).whenComplete(() {
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
