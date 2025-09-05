// import 'dart:io' show File;
// import 'package:flutter/foundation.dart' show kIsWeb;
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:translator/translator.dart';
//
// class MyIntro extends StatefulWidget {
//   @override
//   _MyIntroState createState() => _MyIntroState();
// }
//
// class _MyIntroState extends State<MyIntro> {
//   int _selectedIndex = 0;
//
//   /// ---- Shared state ----
//   XFile? _image;
//   List<Map<String, dynamic>> _predictions = [];
//   final picker = ImagePicker();
//
//   final translator = GoogleTranslator();
//   String dropdownValue = "en"; // default
//   final Map<String, String> languages = {
//     "hi": "Hindi",
//     "pa": "Punjabi",
//     "en": "English",
//   };
//
//   /// Cache translations: {"Hello": {"hi": "नमस्ते"}}
//   final Map<String, Map<String, String>> _translationCache = {};
//
//   String? confirmedBreed;
//
//   /// ---- Translation helper ----
//   Future<String> t(String text) async {
//     if (dropdownValue == "en") return text;
//
//     // if already translated in cache
//     if (_translationCache[text] != null &&
//         _translationCache[text]![dropdownValue] != null) {
//       return _translationCache[text]![dropdownValue]!;
//     }
//
//     // otherwise fetch
//     final result = await translator.translate(text, to: dropdownValue);
//     _translationCache[text] ??= {};
//     _translationCache[text]![dropdownValue] = result.text;
//     return result.text;
//   }
//
//   /// ---- Image Picking ----
//   Future<void> _getImage(bool fromCamera) async {
//     final picked = await picker.pickImage(
//         source: fromCamera ? ImageSource.camera : ImageSource.gallery);
//     if (picked != null) {
//       setState(() => _image = picked);
//
//       // Fake demo predictions (since ML removed)
//       setState(() {
//         _predictions = [
//           {"label": "Gir", "confidence": 0.72},
//           {"label": "Sahiwal", "confidence": 0.18},
//           {"label": "Crossbred", "confidence": 0.10},
//         ];
//       });
//     }
//   }
//
//   Widget _previewImage() {
//     if (_image == null) return const SizedBox();
//
//     return kIsWeb
//         ? Image.network(_image!.path, height: 220, fit: BoxFit.cover)
//         : Image.file(File(_image!.path), height: 220, fit: BoxFit.cover);
//   }
//
//   void _confirmPrediction(String breed) {
//     setState(() => confirmedBreed = breed);
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text("✅ Confirmed: $breed")),
//     );
//   }
//
//   void _correctPrediction() {
//     final controller = TextEditingController();
//     showDialog(
//       context: context,
//       builder: (_) => AlertDialog(
//         title: const Text("Correct Breed"),
//         content: TextField(
//           controller: controller,
//           decoration: const InputDecoration(hintText: "Enter correct breed"),
//         ),
//         actions: [
//           TextButton(
//             onPressed: () {
//               Navigator.pop(context);
//               setState(() => confirmedBreed = controller.text);
//               ScaffoldMessenger.of(context).showSnackBar(
//                 SnackBar(content: Text("Breed corrected to: ${controller.text}")),
//               );
//             },
//             child: const Text("Submit"),
//           )
//         ],
//       ),
//     );
//   }
//
//   Widget _homeTab() {
//     return FutureBuilder(
//       future: Future.wait([
//         t("Camera"),
//         t("Gallery"),
//         t("Result"),
//       ]),
//       builder: (context, snapshot) {
//         if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
//         final texts = snapshot.data as List<String>;
//
//         return SingleChildScrollView(
//           padding: const EdgeInsets.all(16),
//           child: Column(
//             children: [
//               _previewImage(),
//               const SizedBox(height: 10),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: [
//                   ElevatedButton.icon(
//                     icon: const Icon(Icons.camera_alt,color: Colors.white,),
//                     label: Text(texts[0],style: const TextStyle(color: Colors.white)),
//                     onPressed: () => _getImage(true),
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.blueAccent, // 👈 Gallery button background
//                       padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(20),
//                       ),
//                     ),
//                   ),
//                   ElevatedButton.icon(
//                     icon: const Icon(Icons.photo,color: Colors.white),
//                     label: Text(texts[1],style: const TextStyle(color: Colors.white),),
//                     onPressed: () => _getImage(false),
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.blueAccent, // 👈 Gallery button background
//                       padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(20),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               const Divider(),
//               Text(texts[2], style: const TextStyle(fontSize: 18)),
//               ..._predictions.map((p) => Card(
//                 child: ListTile(
//                   title: Text("${p['label']}"),
//                   subtitle: LinearProgressIndicator(
//                     value: p['confidence'],
//                     color: Colors.green,
//                     backgroundColor: Colors.white,
//                   ),
//                   trailing: Text(
//                       "${(p['confidence'] * 100).toStringAsFixed(1)}%"),
//                   onTap: () => _confirmPrediction(p['label']),
//                 ),
//               )),
//             ],
//           ),
//         );
//       },
//     );
//   }
//
//   Widget _activityTab() {
//     final payload = {
//       "animal_id": "TEMP1234",
//       "breed": confirmedBreed ?? "Not confirmed",
//       "timestamp": DateTime.now().toIso8601String(),
//     };
//
//     return FutureBuilder(
//       future: Future.wait([
//         t("Confirmed Breed:"),
//         t("Correct Breed"),
//         t("Payload ready for BPA:"),
//       ]),
//       builder: (context, snapshot) {
//         if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
//         final texts = snapshot.data as List<String>;
//
//         return Padding(
//           padding: const EdgeInsets.all(16),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text("${texts[0]} ${confirmedBreed ?? "None"}",
//                   style: const TextStyle(fontSize: 20)),
//               const SizedBox(height: 20),
//               ElevatedButton(
//                 onPressed: () => _correctPrediction(),
//                 child: Text(texts[1]),
//               ),
//               const SizedBox(height: 30),
//               Text("📦 ${texts[2]}\n$payload",
//                   style: const TextStyle(fontSize: 14)),
//             ],
//           ),
//         );
//       },
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final tabs = [_homeTab(), _activityTab()];
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         backgroundColor: Colors.blueAccent,
//         elevation: 0,
//         title: FutureBuilder(
//           future: t("PashuSaarthi"),
//           builder: (context, snapshot) =>
//               Text(snapshot.data?.toString() ?? "PashuSaarthi",
//                 style: const TextStyle(color: Colors.white),),
//         ),
//         actions: [
//           DropdownButton<String>(
//             value: dropdownValue,
//             dropdownColor: Colors.black87,
//             underline: const SizedBox(),
//             style: const TextStyle(color: Colors.white),
//             icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
//             items: languages.entries
//                 .map((e) => DropdownMenuItem(
//               value: e.key,
//               child: Text(e.value, style: const TextStyle(color: Colors.white)),
//             ))
//                 .toList(),
//             onChanged: (val) => setState(() => dropdownValue = val!),
//           ),
//         ],
//       ),
//       body: tabs[_selectedIndex],
//       bottomNavigationBar: BottomNavigationBar(
//         currentIndex: _selectedIndex,
//         onTap: (i) => setState(() => _selectedIndex = i),
//         type: BottomNavigationBarType.fixed,
//         backgroundColor: Colors.blueAccent,
//         selectedItemColor: Colors.white,
//         unselectedItemColor: Colors.white70,
//         items: [
//           BottomNavigationBarItem(
//               icon: const Icon(CupertinoIcons.house_fill),
//               label: languages[dropdownValue] == "English"
//                   ? "Home"
//                   : dropdownValue == "hi"
//                   ? "होम"
//                   : "ਘਰ"),
//           BottomNavigationBarItem(
//               icon: const Icon(CupertinoIcons.square_grid_4x3_fill),
//               label: languages[dropdownValue] == "English"
//                   ? "Activity"
//                   : dropdownValue == "hi"
//                   ? "गतिविधि"
//                   : "ਗਤੀਵਿਧੀ"),
//         ],
//       ),
//     );
//   }
// }
//---------------------------------------------
import 'dart:io' show File;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:translator/translator.dart';
import 'package:pashusaarthi/Authentication/Authentication.dart';

class MyIntro extends StatefulWidget {
  @override
  _MyIntroState createState() => _MyIntroState();
}

class _MyIntroState extends State<MyIntro> {
  int _selectedIndex = 0;

  /// ---- Shared state ----
  List<XFile> _images = []; // store up to 2 images
  List<Map<String, dynamic>> _predictions = [];
  final picker = ImagePicker();

  final translator = GoogleTranslator();
  String dropdownValue = "en"; // default
  final Map<String, String> languages = {
    "hi": "Hindi",
    "pa": "Punjabi",
    "en": "English",
  };

  /// Cache translations
  final Map<String, Map<String, String>> _translationCache = {};

  String? confirmedBreed;

  /// ---- Activity Log ----
  List<Map<String, dynamic>> activityLog = [];

  /// ---- Translation helper ----
  Future<String> t(String text) async {
    if (dropdownValue == "en") return text;

    if (_translationCache[text] != null &&
        _translationCache[text]![dropdownValue] != null) {
      return _translationCache[text]![dropdownValue]!;
    }

    final result = await translator.translate(text, to: dropdownValue);
    _translationCache[text] ??= {};
    _translationCache[text]![dropdownValue] = result.text;
    return result.text;
  }

  /// ---- Image Picking (2 images only) ----
  Future<void> _getImage(bool fromCamera) async {
    final picked = await picker.pickImage(
        source: fromCamera ? ImageSource.camera : ImageSource.gallery);

    if (picked != null) {
      setState(() {
        if (_images.length < 2) {
          _images.add(picked);
        }

        // When 2 images selected, trigger predictions
        if (_images.length == 2) {
          _predictions = [
            {"label": "Gir", "confidence": 0.72},
            {"label": "Sahiwal", "confidence": 0.18},
            {"label": "Crossbred", "confidence": 0.10},
          ];
        }
      });
    }
  }

  /// ---- Preview Images ----
  Widget _previewImage() {
    if (_images.isEmpty) return const SizedBox();

    return Column(
      children: _images
          .map((img) => kIsWeb
          ? Image.network(img.path, height: 180, fit: BoxFit.cover)
          : Image.file(File(img.path), height: 180, fit: BoxFit.cover))
          .toList(),
    );
  }

  void _confirmPrediction(String breed) {
    if (_images.length < 2) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("⚠ Please upload 2 images first")),
      );
      return;
    }

    setState(() {
      confirmedBreed = breed;

      /// Add to activity log
      activityLog.add({
        "animal_id": "TEMP${activityLog.length + 1}",
        "breed": breed,
        "images": _images.map((e) => e.path).toList(),
        "timestamp": DateTime.now().toIso8601String(),
      });

      /// Reset images for next upload
      _images = [];
      _predictions = [];
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("✅ Confirmed: $breed")),
    );
  }

  void _editCattle(int index) {
    final controller = TextEditingController(
      text: activityLog[index]["breed"],
    );

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Edit Breed"),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: "Enter correct breed"),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                activityLog[index]["breed"] = controller.text;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: Text("Breed updated to: ${controller.text}")),
              );
            },
            child: const Text("Submit"),
          )
        ],
      ),
    );
  }

  void _deleteCattle(int index) {
    setState(() {
      activityLog.removeAt(index);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Cattle Record Deleted")),
    );
  }

  void _uploadtoserver(int index) {
    // setState(() {
    //   activityLog.removeAt(index);
    // });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Data Successfully Uploaded")),
    );
  }

  Widget _homeTab() {
    return FutureBuilder(
      future: Future.wait([
        t("Camera"),
        t("Gallery"),
        t("Result"),
      ]),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        final texts = snapshot.data as List<String>;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              _previewImage(),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    icon: const Icon(Icons.camera_alt, color: Colors.white),
                    label: Text(texts[0],
                        style: const TextStyle(color: Colors.white)),
                    onPressed: () => _getImage(true),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.photo, color: Colors.white),
                    label: Text(texts[1],
                        style: const TextStyle(color: Colors.white)),
                    onPressed: () => _getImage(false),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ],
              ),
              const Divider(),
              Text(texts[2], style: const TextStyle(fontSize: 18)),
              ..._predictions.map((p) => Card(
                child: ListTile(
                  title: Text("${p['label']}"),
                  subtitle: LinearProgressIndicator(
                    value: p['confidence'],
                    color: Colors.green,
                    backgroundColor: Colors.white,
                  ),
                  trailing: Text(
                      "${(p['confidence'] * 100).toStringAsFixed(1)}%"),
                  onTap: () => _confirmPrediction(p['label']),
                ),
              )),
            ],
          ),
        );
      },
    );
  }

  Widget _activityTab() {
    return FutureBuilder(
      future: Future.wait([
        t("Confirmed Breed:"),
        t("Correct Breed"),
        t("Payload ready for BPA:"),
        t("Edit"),
        t("Delete"),
        t("Upload"),
      ]),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        final texts = snapshot.data as List<String>;

        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("${texts[0]} ${confirmedBreed ?? "None"}",
                  style: const TextStyle(fontSize: 20)),
              const SizedBox(height: 20),

              /// Log of all cattle
              Expanded(
                child: ListView.builder(
                  itemCount: activityLog.length,
                  itemBuilder: (context, index) {
                    final item = activityLog[index];
                    return Card(
                      color: Colors.blueAccent,
                      child: ListTile(
                        title: Text(
                            "ID: ${item['animal_id']} | Breed: ${item['breed']}",style: const TextStyle(color: Colors.white)),
                        subtitle: Text("Time: ${item['timestamp']}",style: const TextStyle(color: Colors.white)),
                        trailing: PopupMenuButton<String>(
                          icon: Icon(CupertinoIcons.slider_horizontal_3,color: Colors.white,),
                          onSelected: (value) {
                            if (value == "edit") _editCattle(index);
                            if (value == "delete") _deleteCattle(index);
                            if (value == "upload") _uploadtoserver(index);
                          },
                          itemBuilder: (context) => [
                            PopupMenuItem(
                              value: "edit",
                              child: Text(texts[3]),
                            ),
                            PopupMenuItem(
                              value: "delete",
                              child: Text(texts[4]),
                            ),
                            PopupMenuItem(
                              value: "upload",
                              child: Text(texts[5]),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 20),
              // Text("${texts[2]}",
              //     style: const TextStyle(fontSize: 14)),
              // Text(activityLog.toString(),
              //     style: const TextStyle(fontSize: 12)),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final tabs = [_homeTab(), _activityTab()];
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        elevation: 0,
        title: FutureBuilder(
          future: t("PashuSaarthi"),
          builder: (context, snapshot) => Text(
            snapshot.data?.toString() ?? "PashuSaarthi",
            style: const TextStyle(color: Colors.white),
          ),
        ),
        actions: [

          DropdownButton<String>(
            value: dropdownValue,
            dropdownColor: Colors.black87,
            underline: const SizedBox(),
            style: const TextStyle(color: Colors.white),
            icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
            items: languages.entries
                .map((e) => DropdownMenuItem(
              value: e.key,
              child: Text(e.value,
                  style: const TextStyle(color: Colors.white)),
            ))
                .toList(),
            onChanged: (val) => setState(() => dropdownValue = val!),
          ),
          IconButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => Login()),
              );
            },
            icon: Icon(Icons.logout, color: Colors.white),
          ),
        ],
      ),
      body: tabs[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (i) => setState(() => _selectedIndex = i),
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.blueAccent,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
        items: [
          BottomNavigationBarItem(
              icon: const Icon(CupertinoIcons.house_fill),
              label: languages[dropdownValue] == "English"
                  ? "Home"
                  : dropdownValue == "hi"
                  ? "होम"
                  : "ਘਰ"),
          BottomNavigationBarItem(
              icon: const Icon(CupertinoIcons.square_grid_4x3_fill),
              label: languages[dropdownValue] == "English"
                  ? "Activity"
                  : dropdownValue == "hi"
                  ? "गतिविधि"
                  : "ਗਤੀਵਿਧੀ"),
        ],
      ),
    );
  }
}
