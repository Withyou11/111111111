import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:english_study_app/models/english_words.dart';
import 'package:english_study_app/packages/quotes/default_quotes.dart';
import 'package:english_study_app/packages/quotes/quote.dart';
import 'package:english_study_app/packages/quotes/quote_model.dart';
import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';

class FlashCardModel {
  String? word;
  String? quotes;
  String? wordID;

  FlashCardModel({this.word, this.quotes, this.wordID});

  factory FlashCardModel.fromMap(map) {
    return FlashCardModel(
      word: map['word'],
      quotes: map['quotes'],
    );
  }
}

class FlashCardScreen extends StatefulWidget {
  const FlashCardScreen({Key? key}) : super(key: key);

  @override
  State<FlashCardScreen> createState() => _FlashCardScreenState();
}

class _FlashCardScreenState extends State<FlashCardScreen> {
  late PageController _pageController;
  late List<FlashCardModel> listFlashCard = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.9);
    super.initState();
    reloadFlashCard();
  }

  @override
  Future reloadFlashCard() async {
    setState(() => isLoading = true);

    await FirebaseFirestore.instance
        .collection('topic')
        .get()
        .then((QuerySnapshot snapshot) {
      snapshot.docs.forEach((doc) {
        FlashCardModel obj = FlashCardModel.fromMap(doc.data());
        obj.wordID = doc.id;
        listFlashCard.add(obj);
      });
    });

    setState(() => isLoading = false);
  }

  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
              Color.fromRGBO(13, 209, 33, 1),
              Color.fromRGBO(255, 236, 66, 1)
            ])),
        child: Scaffold());
  }
}
