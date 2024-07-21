// ignore_for_file: sized_box_for_whitespace, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:barcode_widget/barcode_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';

import 'package:qubtan_manager/add_player.dart';
import 'package:screenshot/screenshot.dart';
import 'package:path_provider/path_provider.dart';

class PlayersScreen extends StatefulWidget {
  String id;
  String title;
  PlayersScreen({super.key, required this.id, required this.title});

  @override
  State<PlayersScreen> createState() => _PlayersScreenState();
}

class _PlayersScreenState extends State<PlayersScreen> {
  ScreenshotController screenshotController = ScreenshotController();

// second

  Future<String> _getDesktopDirectory() async {
    final directory = await getApplicationDocumentsDirectory();
    final desktopDir = Directory('${directory.parent.path}/Desktop');
    return desktopDir.path;
  }

  Future<void> _takeScreenshot() async {
    final directoryPath = await _getDesktopDirectory();
    final filePath =
        '$directoryPath/screenshot_${DateTime.now().millisecondsSinceEpoch}.png';

    screenshotController
        .captureAndSave(
      directoryPath,
      fileName: 'screenshot_${DateTime.now().millisecondsSinceEpoch}.png',
    )
        .then((String? filePath) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Screenshot saved to $filePath')),
      );
    });
  }

// third
  SaveToGallery() {
    screenshotController.capture().then((Uint8List? image) {
      saveScreenshot(image!);
    });
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('تم التقاط لقطة الشاشة بنجاح')));
  }

  saveScreenshot(Uint8List bytes) async {
    final time = DateTime.now()
        .toIso8601String()
        .replaceAll('.', '_')
        .replaceAll(':', '_');
    final name = 'ScreenShoot$time';
    await ImageGallerySaver.saveImage(bytes, name: name);
  }

  List<QueryDocumentSnapshot> data = [];

  getData() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('folders')
        .doc(widget.id)
        .collection('players')
        .get();
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
          widget.title,
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => AddPlayer(
                        id: widget.id,
                      )));
        },
        child: Image.asset(
          'assets/images/add_icon.png',
          fit: BoxFit.cover,
          height: 100,
          width: 100,
        ),
      ),
      body: data.isNotEmpty
          ? Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: 3 / 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10),
                  itemCount: data.length,
                  itemBuilder: (BuildContext context, int index) {
                    return InkWell(
                      onLongPress: () {
                        AwesomeDialog(
                            dialogType: DialogType.question,
                            context: context,
                            title: 'اختر الاجراء المناسب',
                            btnCancelText: 'تحميل',
                            btnOkText: 'حذف',
                            btnOkIcon: Icons.delete,
                            btnOkColor: Colors.red,
                            btnCancelColor: Colors.teal,
                            btnCancelIcon: Icons.install_desktop,
                            btnCancelOnPress: () {
                              _takeScreenshot();
                              // SaveToGallery();
                              // SnackBar(content: Text('تم تحميل الصورة بنجاح'));
                            },
                            btnOkOnPress: () {
                              CollectionReference comment = FirebaseFirestore
                                  .instance
                                  .collection('folders')
                                  .doc(widget.id)
                                  .collection('players');
                              comment.doc(data[index].id).delete();

                              Navigator.pop(context);
                            }).show();
                      },
                      child: Screenshot(
                        controller: screenshotController,
                        child: Card(
                          elevation: 3,
                          child: Container(
                            margin: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 15),
                            height: 100,
                            width: double.infinity,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    BarcodeWidget(
                                        color: Colors.deepPurple,
                                        height: 100,
                                        width: 100,
                                        data: data[index]['end'],
                                        barcode: Barcode.qrCode()),
                                    BarcodeWidget(
                                        color: Colors.black,
                                        height: 100,
                                        width: 100,
                                        data: data[index]['url'],
                                        barcode: Barcode.qrCode()),
                                  ],
                                ),
                                Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text(
                                      data[index]['name'],
                                      style: TextStyle(
                                          color: Colors.teal,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20),
                                    ),
                                    Text(
                                      data[index]['start'],
                                      style: TextStyle(
                                          color: Colors.green,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20),
                                    ),
                                    Text(
                                      data[index]['end'],
                                      style: TextStyle(
                                          color: Colors.red,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20),
                                    ),
                                  ],
                                ),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.network(
                                    data[index]['url'],
                                    fit: BoxFit.cover,
                                    height: 120,
                                    width: 120,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
            )
          : Center(
              child: CircularProgressIndicator(
              color: Colors.yellow.shade900,
            )),
    );
  }
}
