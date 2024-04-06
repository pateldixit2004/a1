// import 'dart:async';
//
// import 'package:aaaanewlearing/con.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
// void main() {
//   runApp(const MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         // This is the theme of your application.
//         //
//         // TRY THIS: Try running your application with "flutter run". You'll see
//         // the application has a purple toolbar. Then, without quitting the app,
//         // try changing the seedColor in the colorScheme below to Colors.green
//         // and then invoke "hot reload" (save your changes or press the "hot
//         // reload" button in a Flutter-supported IDE, or press "r" if you used
//         // the command line to start the app).
//         //
//         // Notice that the counter didn't reset back to zero; the application
//         // state is not lost during the reload. To reset the state, use hot
//         // restart instead.
//         //
//         // This works for code too, not just values: Most code changes can be
//         // tested with just a hot reload.
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
//         useMaterial3: true,
//       ),
//       home: MyPage(),
//     );
//   }
// }
//
//
// class MyPage extends StatelessWidget {
//   final DataController controller = Get.put(DataController());
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Data Page'),
//       ),
//       body: Obx(() {
//         if (controller.isLoading.value) {
//           return Column(
//             children: [
//               Center(child: CircularProgressIndicator()),
//               Text("data")
//             ],
//           );
//         }
//         return ListView.builder(
//           itemCount: controller.dataList.length,
//           itemBuilder: (context, index) {
//             return ListTile(
//               title: Text(controller.dataList[index].title),
//
//               // Add more UI components as needed
//             );
//           },
//         );
//       }),
//     );
//   }
// }
import 'package:aaaanewlearing/con.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Image Upload Demo',
      home: ImageUploadScreen(),
    );
  }
}

class ImageUploadScreen extends StatefulWidget {
  @override
  _ImageUploadScreenState createState() => _ImageUploadScreenState();
}

class _ImageUploadScreenState extends State<ImageUploadScreen> {
  File _imageFile=File("");
  DataController controller=Get.put(DataController());
  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);

    setState(() {
      if (pickedFile != null) {
        _imageFile = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  Future<void> _uploadImage() async {
    if (_imageFile == null) {
      print('No image selected.');
      return;
    }

    var url = 'https://postb.in/1591233944248-8388763039516'; // Replace with your PostBin URL
    var request = http.MultipartRequest('POST', Uri.parse(url));
    request.files.add(await http.MultipartFile.fromPath('image', _imageFile.path));

    try {
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        print('Image uploaded successfully');
      } else {
        print('Failed to upload image: ${response.body}');
      }
    } catch (e) {
      print('Error uploading image: $e');
    }
  }

  // Future<void> _uploadImage() async {
  //   if (_imageFile == null) {
  //     print('No image selected.');
  //     return;
  //   }
  //
  //   var url = 'https://pos.nsbitsolution.in/TestImage/';
  //   var request = http.MultipartRequest('POST', Uri.parse(url));
  //   request.files.add(await http.MultipartFile.fromPath('image', _imageFile.path));
  //
  //   try {
  //     final streamedResponse = await request.send();
  //     final response = await http.Response.fromStream(streamedResponse);
  //
  //     if (response.statusCode == 200) {
  //       print('Image uploaded successfully');
  //     } else {
  //       print('Failed to upload image: ${response.body}');
  //     }
  //   } catch (e) {
  //     print('Error uploading image: $e');
  //   }
  // }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image Upload Demo'),
      ),
      body: Column(
        children: [
          // Center(
          //   child: _imageFile == null
          //       ? Text('No image selected')
          //       : Image.file(_imageFile),
          // ),
        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          FloatingActionButton(
            onPressed: () => controller.sendCustomerDetailsApi(),
            tooltip: 'Take Photo',
            child: Icon(Icons.camera),
          ), FloatingActionButton(
            onPressed: () => _pickImage(ImageSource.camera),
            tooltip: 'Take Photo',
            child: Icon(Icons.camera),
          ),
          SizedBox(height: 16),
          FloatingActionButton(
            onPressed: () => _pickImage(ImageSource.gallery),
            tooltip: 'Pick Image from Gallery',
            child: Icon(Icons.photo_library),
          ),
          SizedBox(height: 16),
          FloatingActionButton(
            onPressed: _uploadImage,
            tooltip: 'Upload Image',
            child: Icon(Icons.cloud_upload),
          ),
        ],
      ),
    );
  }
}
