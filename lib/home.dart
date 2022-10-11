import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'dart:io';

import 'package:flutter_tflite/flutter_tflite.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late File _image;
  late List _output;
  bool loading = false;
  final picker = ImagePicker();
  @override
  void initState() {
    super.initState();
    loadModel1().then((value) {
      setState(() {});
    });
  }

  detectImage(File image) async {
    var output = await Tflite.runModelOnImage(
      path: image.path,
      numResults: 2,
      threshold: 0.6,
      imageMean: 127.5,
      imageStd: 127.5,
    );
    setState(() {
      _output = output!;
      loading = true;
    });
  }

  loadModel1() async {
    await Tflite.loadModel(
        model: "assets/model_unquant.tflite", labels: "assets/labels.txt");
  }

  @override
  void dispose() {
    super.dispose();
  }

  pickImageCamera() async {
    var image = await picker.pickImage(source: ImageSource.camera);
    if (image == null) return null;
    setState(() {
      _image = File(image.path);
    });
    detectImage(_image);
  }

  pickImageGalary() async {
    var image = await picker.pickImage(source: ImageSource.gallery);
    if (image == null) return null;
    setState(() {
      _image = File(image.path);
    });
    detectImage(_image);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cat Or Dog"),
      ),
      backgroundColor: Colors.white,
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              const SizedBox(
                height: 50,
              ),
              const Text(
                "Cat Or Dog Let's Check",
                style: TextStyle(
                    color: Color.fromARGB(255, 125, 158, 158), fontSize: 20),
              ),
              const SizedBox(
                height: 5,
              ),
              const Text(
                "Cat Vs Dog App",
                style: TextStyle(
                    color: Color.fromARGB(255, 125, 158, 158),
                    fontSize: 30,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 50,
              ),
              Column(
                children: [
                  loading
                      ? Column(
                          children: [
                            SizedBox(
                                height: 300,
                                width: 300,
                                child: Image.file(_image)),
                            SizedBox.fromSize(
                              size: const Size.fromHeight(20),
                            ),
                            Text(
                              "This is a ${_output.toString().substring(38, 41)}",
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20),
                            ),
                            SizedBox.fromSize(
                              size: const Size.fromHeight(20),
                            ),
                          ],
                        )
                      : SizedBox(
                          height: 380,
                          width: 380,
                          child: Image.asset("assets/cat&dog.png")),
                  const SizedBox(
                    height: 5,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: () async {
                            await pickImageCamera();
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width - 250,
                            alignment: Alignment.center,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 25, vertical: 18),
                            decoration: BoxDecoration(
                                color: Colors.yellowAccent,
                                borderRadius: BorderRadius.circular(6)),
                            child: const Text(
                              "Capture a Photo",
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        GestureDetector(
                          onTap: () async {
                            await pickImageGalary();
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width - 250,
                            alignment: Alignment.center,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 25, vertical: 18),
                            decoration: BoxDecoration(
                                color: Colors.yellowAccent,
                                borderRadius: BorderRadius.circular(6)),
                            child: const Text(
                              "Select Photo",
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              )
            ]),
      ),
    );
  }
}
