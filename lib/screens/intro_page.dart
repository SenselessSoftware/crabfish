import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';

import '../cf_constants.dart';

class IntroPage extends StatefulWidget {
  const IntroPage({super.key});

  @override
  State<IntroPage> createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
  // 1. Define a `GlobalKey` as part of the parent widget's state
  final _introKey = GlobalKey<IntroductionScreenState>();
 // String _status = 'Waiting...';

  @override
  Widget build(BuildContext context) {
    return IntroductionScreen(
      // 2. Pass that key to the `IntroductionScreen` `key` param
      key: _introKey,
      back: const Icon(Icons.arrow_back),
      skip: const Icon(Icons.skip_next),
      next: const Text("Next"),
      done: const Text("Done", style: TextStyle(fontWeight: FontWeight.w700)),
      onDone: () {
        // On Done button pressed
        Navigator.pop(context);
      },
      onSkip: () {
        // On Skip button pressed
      },
      pages: [
        PageViewModel(
            title: Constants.tutorialText00,
            bodyWidget: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(Constants.tutorialText01),
                Text(Constants.tutorialText02),
                Text(Constants.tutorialText03),
                Text(Constants.tutorialText04),
                Text(Constants.tutorialText05),
                Text(Constants.tutorialText06),
                Text(Constants.tutorialText07),
              ],
            )
        ),
        PageViewModel(
            title: Constants.tutorialText00,
            bodyWidget: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(Constants.tutorialText10),
                Text(Constants.tutorialText11),
                Text(Constants.tutorialText12),
                Text(Constants.tutorialText13),
              ],
            )
        ),
        PageViewModel(
            title: Constants.tutorialText00,
            bodyWidget: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(Constants.tutorialText20),
                Text(Constants.tutorialText21),
                Text(Constants.tutorialText22),
                Text(Constants.tutorialText23),
                Text(Constants.tutorialText24),
                Text(Constants.tutorialText25),
                Text(Constants.tutorialText26),
                Text(Constants.tutorialText27),
                Text(Constants.tutorialText28),
                Text(Constants.tutorialText29),
                Text(Constants.tutorialText30),
                Text(Constants.tutorialText31),
              ],
            )
        ),
        PageViewModel(
            title: Constants.tutorialText00,
            bodyWidget: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(Constants.tutorialText40),
                Text(Constants.tutorialText41),
                Text(Constants.tutorialText42),
                Text(Constants.tutorialText43),
              ],
            )
        ),
      ],
      showNextButton: true,
      showDoneButton: true,
      showBackButton: true,
    );
  }
}