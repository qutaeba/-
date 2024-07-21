// ignore_for_file: sized_box_for_whitespace, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

class AddPlayer extends StatefulWidget {
  String id;
  AddPlayer({super.key, required this.id});

  @override
  State<AddPlayer> createState() => _AddPlayerState();
}

class _AddPlayerState extends State<AddPlayer> {
  TextEditingController nameController = TextEditingController();
  TextEditingController startController = TextEditingController();
  TextEditingController endController = TextEditingController();
  File? file;

  String? url;

  getImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? imageCamera =
        await picker.pickImage(source: ImageSource.gallery);
    if (imageCamera != null) {
      file = File(imageCamera.path);

      var imageName = basename(imageCamera.path);

      var refStorage = FirebaseStorage.instance.ref('playersImages/$imageName');
      await refStorage.putFile(file!);
      url = await refStorage.getDownloadURL();
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(25),
                bottomRight: Radius.circular(25)),
            gradient: LinearGradient(colors: [
              Color.fromRGBO(255, 88, 88, 1),
              Color.fromRGBO(240, 152, 25, 1),
            ], begin: Alignment.topLeft, end: Alignment.bottomRight),
          ),
        ),
        centerTitle: true,
        title: Text(
          'اضافة لاعب',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                  contentPadding: EdgeInsets.only(right: 20),
                  border: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.yellow.shade900)),
                  hintText: 'اسم المشترك'),
            ),
            TextField(
              controller: startController,
              decoration: InputDecoration(
                  contentPadding: EdgeInsets.only(right: 20),
                  border: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.yellow.shade900)),
                  hintText: 'تاريخ البدء'),
            ),
            TextField(
              controller: endController,
              decoration: InputDecoration(
                  contentPadding: EdgeInsets.only(right: 20),
                  border: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.yellow.shade900)),
                  hintText: 'تاريخ الانتهاء'),
            ),
            Container(
              height: 150,
              width: 150,
              child: url != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        '$url',
                        height: 120,
                        width: 120,
                        fit: BoxFit.cover,
                      ))
                  : InkWell(
                      onTap: () {
                        getImage();
                      },
                      child: Container(
                        height: 50,
                        width: 172,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.yellow.shade900),
                            borderRadius: BorderRadius.circular(10)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              'تحميل صورة',
                              style: TextStyle(
                                color: Colors.yellow.shade900,
                                fontWeight: FontWeight.w500,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
            ),
            InkWell(
              onTap: () {
                CollectionReference comments = FirebaseFirestore.instance
                    .collection('folders')
                    .doc(widget.id)
                    .collection('players');
                url != null
                    ? comments.add({
                        'name': nameController.text,
                        'start': startController.text,
                        'end': endController.text,
                        'url': url,
                      })
                    : SnackBar(content: Text('انتظر تحميل الصورة'));

                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AddPlayer(
                              id: widget.id,
                            )));
              },
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [
                    Color.fromRGBO(255, 88, 88, 1),
                    Color.fromRGBO(240, 152, 25, 1),
                  ], begin: Alignment.topLeft, end: Alignment.bottomRight),
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
    );
  }
}
