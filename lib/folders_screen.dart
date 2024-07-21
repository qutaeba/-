// ignore_for_file: sized_box_for_whitespace, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:qubtan_manager/players_screen.dart';

class FoldersScreen extends StatefulWidget {
  const FoldersScreen({super.key});

  @override
  State<FoldersScreen> createState() => _FoldersScreenState();
}

class _FoldersScreenState extends State<FoldersScreen> {
  TextEditingController titleController = TextEditingController();
  CollectionReference folders =
      FirebaseFirestore.instance.collection('folders');

  List<QueryDocumentSnapshot> data = [];

  getData() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('folders').get();
    data.addAll(querySnapshot.docs);
    setState(() {});
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              content: Container(
                height: 110,
                width: 320,
                child: Column(
                  children: [
                    TextField(
                      controller: titleController,
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(right: 20),
                          border: InputBorder.none,
                          hintText: 'ادخل اسم الملف'),
                    ),
                    InkWell(
                      onTap: () {
                        folders.add({
                          'title': titleController.text,
                        });
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => FoldersScreen()));
                        titleController.clear();
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                              colors: [
                                Color.fromRGBO(255, 88, 88, 1),
                                Color.fromRGBO(240, 152, 25, 1),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        height: 50,
                        width: double.infinity,
                        child: Center(
                          child: Text(
                            'اضافة',
                            style: TextStyle(
                              color: Color(0xFFFFFFFF),
                              fontWeight: FontWeight.w700,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
        child: Image.asset(
          'assets/images/add_icon.png',
          fit: BoxFit.cover,
          height: 100,
          width: 100,
        ),
      ),
      body: data.isNotEmpty ? Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                childAspectRatio: 3 / 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 33),
            itemCount: data.length,
            itemBuilder: (BuildContext context, int index) {
              return InkWell(
                onLongPress: () {
                  AwesomeDialog(
                      context: context,
                      title: 'هل تريد الحذف',
                      btnCancelText: 'تراجع',
                      btnOkText: 'حذف',
                      btnOkIcon: Icons.delete,
                      btnCancelIcon: Icons.cancel,
                      btnCancelOnPress: () {},
                      btnOkOnPress: () {
                        CollectionReference products =
                            FirebaseFirestore.instance.collection('folders');
                        products.doc(data[index].id).delete();

                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => FoldersScreen()));
                      }).show();
                },
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PlayersScreen(
                                id: data[index].id,
                                title: data[index]['title'],
                              )));
                },
                child: Column(
                  children: [
                    Image.asset(
                      'assets/images/folder_icon.png',
                      fit: BoxFit.cover,
                      height: 100,
                      width: 100,
                    ),
                    Text(data[index]['title'])
                  ],
                ),
              );
            }),
      ) : Center(child: CircularProgressIndicator(color: Colors.yellow.shade900,)),
    );
  }
}
