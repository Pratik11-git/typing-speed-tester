import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

void main() {
  runApp(const TypingSpeedApp());
}
class TypingSpeedApp extends StatelessWidget {
  const TypingSpeedApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Typingspeed()
    );
  }
}



class Typingspeed extends StatefulWidget {
  const Typingspeed({super.key});

  @override
  State<Typingspeed> createState() => _TypingspeedState();
}

class _TypingspeedState extends State<Typingspeed> {

  final List<String> paragraphs=[
  "The sign of intelligence is that you are constantly wondering.Idiots are always dead sure about every damn thing they are doing in their life.",
    "When pain, misery, or anger happen, it is time to look within you, not around you.",
  "If you ask a tree how he feels to know that he's spreading his fragrance and making people happy, I don't think a tree looks at it that way. I am just like that, and it is just my nature to be like this.",
    "Too many people are hungry not because there is dearth of food. It is because there is dearth of love and care in human hearts.",
    "I am not talking about you being a spectator, I am talking about involvement. I am talking about involving yourself into life in such a way that you dissolve into it."
  ];
 late String paragraphText;
 Timer? timer;
 int secondsElapsed=0;
 bool isTyping = false;
 double progressText=0;
 double wpm=0;
 double latestWPM=0;
 TextEditingController tec=TextEditingController();
  //Generates random paragraphs
  @override
  void initState(){
    super.initState();
    selectRandomParagraph();

  }


  // it will initialize before UI to get random paragraph
 void selectRandomParagraph(){
   setState(() {
     paragraphText=paragraphs[Random().nextInt(paragraphs.length)];
     tec.clear();
     secondsElapsed=0;
     wpm=0;
     progressText=0;
     isTyping=false;
   });
 }

  void userTyping(){
    timer=Timer.periodic(Duration(seconds: 1), (timer){
      setState(() {
        secondsElapsed++;
        speedCal();
      });
    });
  }

 // this will calculate each words as user types and gives words per minute speed
 void speedCal(){
   int wordCount=paragraphText.split(' ').length;
   if(secondsElapsed>0){
     wpm=(wordCount/secondsElapsed)*60;
   }
 }

 //this will handle time as user starts typing it will increases by 1 second
  void onTyping(String text) {
    if (!isTyping) {
      isTyping = true;
      userTyping();
    }

    setState(() {
      progressText = text.length / paragraphText.length;
      speedCal();
    });

    if (text == paragraphText) {
      timer?.cancel();
      if (wpm > latestWPM) {
        latestWPM = wpm;  // Update highest WPM record
      }
      _showResultDialog();
    }
  }

  void _showResultDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Typing Speed Test Completed!"),
        content: Text("Your speed: ${wpm.toStringAsFixed(2)} WPM\nHighest: ${latestWPM.toStringAsFixed(2)} WPM"),
        actions: [
          TextButton(
            onPressed: () {
              selectRandomParagraph();
              Navigator.pop(context);
            },
            child: Text("Try Again"),
          ),
        ],
      ),
    );
  }





  @override
  Widget build(BuildContext context) {
    @override

      // Instruction Text
      Text info = Text(
        'Write Given Paragraph in provided space to know your typing speed:',
        style: TextStyle(fontSize: 19, color: Colors.redAccent),
      );

      // Display Paragraph
      Container paragraphContainer = Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.blue),
          borderRadius: BorderRadius.circular(5),
          color: Colors.blue[50],
        ),
        child: Text(
          paragraphText,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      );

      // Typing Input Field
      TextField typingField = TextField(
        controller: tec,
        onChanged: (text) {
          onTyping(text);
        },
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          hintText: "Start typing here...",
        ),
      );

      // Progress Bar
      LinearProgressIndicator progressBar = LinearProgressIndicator(
        value: progressText,
        backgroundColor: Colors.grey[300],
        color: Colors.green,
        minHeight: 8,
      );

      // Typing Speed Stats
      Text progressTextWidget = Text(
          "Progress: ${(progressText * 100).toStringAsFixed(0)}%");
      Text elapsedTime = Text("Elapsed Time: $secondsElapsed seconds");
      Text currentWPM = Text("Current WPM: ${wpm.toStringAsFixed(2)}");
      Text highestWPM = Text(
          "Highest WPM Record: ${latestWPM.toStringAsFixed(2)}");


          return Scaffold(
            appBar:AppBar(title: Text("Typing Speed Test"),centerTitle: true,backgroundColor: Colors.deepPurple,),
            body: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  info,
                  SizedBox(height: 10),
                  paragraphContainer,
                  SizedBox(height: 20),
                  typingField,
                  SizedBox(height: 20),
                  progressBar,
                  SizedBox(height: 10),
                  progressTextWidget,
                  SizedBox(height: 10),
                  elapsedTime,
                  currentWPM,
                  highestWPM,
                ],
              ),
            ),
          );




    }
  }
