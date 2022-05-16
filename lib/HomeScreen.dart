import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:english_study_app/FlashCardScreen.dart';
import 'package:english_study_app/LoginScreen.dart';
import 'package:english_study_app/SignUpScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'Bottom_Navigation.dart';
import 'package:flutter/material.dart';
import 'package:translator/translator.dart';

import 'History_Storage.dart';
import 'TopicPage.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Tạo đối tượng Authentication:
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  //
  TextEditingController fromController = TextEditingController();
  TextEditingController toController = TextEditingController();
  String? selectLanguage1;
  String? selectLanguage2;
  final translator = GoogleTranslator();
  String? value;
  final items = ["Tiếng Việt", "English"];
  DropdownMenuItem<String> buildMenuItem(String item) => DropdownMenuItem(
        value: item,
        child: Text(item,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      );
  _translateLang() {
    String s1 = "en";
    String s2 = "vi";
    if (selectLanguage1 == "Tiếng Việt" && selectLanguage2 == "Tiếng Việt") {
      s1 = "vi";
      s2 = "vi";
    } else if (selectLanguage1 == "English" && selectLanguage2 == "English") {
      s1 = "en";
      s2 = "en";
    } else if (selectLanguage1 == "Tiếng Việt" &&
        selectLanguage2 == "English") {
      s1 = "vi";
      s2 = "en";
    } else {
      s1 = "en";
      s2 = "vi";
    }
    if (fromController.toString().isNotEmpty ||
        fromController.toString() == "") {
      translator
          .translate(fromController.text, from: s1, to: s2)
          .then((result) {
        setState(() {
          toController.text = result.toString();
        });
        addSearchedtoStorage(fromController.text, toController.text);
      });
    }
  }

  Future<void> addSearchedtoStorage(String fromSearch, String toSearch) {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    User? user = FirebaseAuth.instance.currentUser;
    CollectionReference addStorage =
        FirebaseFirestore.instance.collection('searched');
    return addStorage.add({
      'uid': user?.uid,
      'fromSearch': fromSearch,
      'toSearch': toSearch,
      'timeSearch': DateTime.now()
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 213, 235, 247),
      body: SafeArea(
        child: Stack(children: <Widget>[
          //insert image background
          Container(
            height: 380,
            decoration: const BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: [
                      0.1,
                      0.9
                    ],
                    colors: [
                      Color.fromRGBO(13, 209, 33, 1),
                      Color.fromRGBO(255, 236, 66, 1)
                    ]),
                // color: Color.fromRGBO(13, 209, 33, 1),
                image: DecorationImage(
                  alignment: Alignment.centerRight,
                  image: AssetImage("assets/images/png_02.png"),
                )),
          ),
          //insert icon logout
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Align(
                alignment: Alignment.topLeft,
                child: InkWell(
                  onTap: () {
                    // Logout currentUser
                    signOut();
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginScreen()));
                  },
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: const BoxDecoration(
                      color: Colors.amber,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.arrow_back),
                  ),
                ),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text(
                'Doulingo',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              )
            ],
          ),

          //Translate function
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(children: [
              Padding(
                padding: const EdgeInsets.all(15),
                child: TextField(
                  controller: fromController,
                  decoration: const InputDecoration(hintText: 'Enter Text'),
                  onChanged: (value) => setState(() => toController.text = ""),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15),
                child: TextField(
                  readOnly: true,
                  controller: toController,
                  decoration:
                      const InputDecoration(hintText: 'translated Text'),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                    ),
                    child: SizedBox(
                      height: 50,
                      child: Container(
                        color: const Color.fromRGBO(18, 27, 240, 1),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: selectLanguage1,
                            items: items.map(buildMenuItem).toList(),
                            onChanged: (value) =>
                                setState(() => selectLanguage1 = value),
                            hint: const Text(
                              "English",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                    ),
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.green,
                          onPrimary: Colors.yellow,
                        ),
                        child:
                            const Icon(Icons.arrow_forward_outlined, size: 50),
                        onPressed: _translateLang),
                  ),
                  Container(
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                    ),
                    child: SizedBox(
                      height: 50,
                      child: Container(
                        color: const Color.fromRGBO(18, 27, 240, 1),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            itemHeight: null,
                            value: selectLanguage2,
                            items: items.map(buildMenuItem).toList(),
                            onChanged: (value) =>
                                setState(() => selectLanguage2 = value),
                            hint: const Text(
                              "Tiếng Việt",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
              //GridView menu home
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  childAspectRatio: 1.0,
                  crossAxisSpacing: 8.0,
                  mainAxisSpacing: 8.0,
                  children: <Widget>[
                    CategoryCard(
                      pathImg: "assets/images/game.png",
                      title: "Play game",
                      Press: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: ((context) => const TopicPage())));
                      },
                    ),
                    CategoryCard(
                      pathImg: "assets/images/music.png",
                      title: "Listen Music",
                      Press: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: ((context) => const MyStoragePage())));
                      },
                    ),
                    CategoryCard(
                      pathImg: "assets/images/flash_card.png",
                      title: "Flash Card",
                      Press: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const FlashCardScreen()),
                        );
                      },
                    ),
                    CategoryCard(
                      pathImg: "assets/images/notification.png",
                      title: "Notification",
                      Press: () {},
                    ),
                  ],
                ),
              )
            ]),
          ),
        ]),
      ),
    );
  }

  signOut() async {
    await _firebaseAuth.signOut();
  }
}

class CategoryCard extends StatelessWidget {
  final pathImg;
  final title;
  final Press;
  const CategoryCard({
    Key? key,
    this.pathImg,
    this.title,
    this.Press,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return
        //  ClipRRect(
        // borderRadius: BorderRadius.circular(8),
        // child:
        Container(
      // padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
          color: const Color.fromARGB(255, 248, 245, 245),
          borderRadius: BorderRadius.circular(8),
          boxShadow: const [
            BoxShadow(
                offset: Offset(4, 18),
                blurRadius: 17,
                spreadRadius: -10,
                color: Color.fromARGB(255, 110, 107, 104))
          ]),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: Press,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: <Widget>[
                Image(
                    image: AssetImage(pathImg),
                    width: 100,
                    height: 100,
                    alignment: Alignment.center),
                const Spacer(),
                Text(
                  title,
                  style: const TextStyle(
                      color: Colors.black87, fontWeight: FontWeight.bold),
                )
              ],
            ),
          ),
        ),
      ),
      // ),
    );
  }
}
