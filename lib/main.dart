import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Number Guessing Game',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => LandingPage(),
        '/initiate': (context) => InitiatePage(),
        '/game': (context) => GamePage(),
        '/result': (context) => ResultPage(),
      },
    );
  }
}

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Number Guessing Game'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.pushNamed(context, '/initiate');
          },
          child: Text('Start Game'),
        ),
      ),
    );
  }
}

class InitiatePage extends StatelessWidget {
  const InitiatePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Initiate Game'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              decoration: InputDecoration(labelText: 'Player 1 Name'),
              onChanged: (value) => player1Name = value,
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Player 2 Name'),
              onChanged: (value) => player2Name = value,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/game');
              },
              child: Text('Play'),
            ),
          ],
        ),
      ),
    );
  }
}

String player1Name = '';
String player2Name = '';

class GamePage extends StatefulWidget {
  const GamePage({super.key});

  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  String currentPlayer = player1Name;
  int minRange = 1;
  int maxRange = 100;
  int targetNumber = Random().nextInt(100) + 1;
  int player1Score = 0;
  int player2Score = 0;

  TextEditingController guessController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Game Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Range: $minRange - $maxRange'),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 50),
              child: TextField(
                controller: guessController,
                decoration: InputDecoration(labelText: 'Enter your guess'),
                keyboardType: TextInputType.number,
              ),
            ),
            SizedBox(height: 20),
            Text('Current Player: $currentPlayer'),
            ElevatedButton(
              onPressed: () {
                checkGuess();
              },
              child: Text('Check'),
            ),
          ],
        ),
      ),
    );
  }

  void checkGuess() {
    int? guess = int.tryParse(guessController.text);

    if (guess != null && guess >= minRange && guess <= maxRange) {
      if (guess == targetNumber) {
        showWinDialog(currentPlayer);
      } else {
        setState(() {
          if (currentPlayer == player1Name) {
            currentPlayer = player2Name;
          } else {
            currentPlayer = player1Name;
          }

          if (guess < targetNumber) {
            minRange = guess + 1;
          } else {
            maxRange = guess - 1;
          }
        });
        guessController.clear();
      }
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Invalid Guess'),
            content: Text('Please enter a valid number within the current range.'),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  void showWinDialog(String winner) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Congratulations!'),
          content: Text('$winner has won the game.'),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                updateScores(winner);
                Navigator.pushReplacementNamed(context, '/result', arguments: {
                  'player1Name': player1Name,
                  'player2Name': player2Name,
                  'player1Score': player1Score,
                  'player2Score': player2Score,
                });
              },
            ),
          ],
        );
      },
    );
  }

  void updateScores(String winner) {
    if (winner == player1Name) {
      player1Score++;
    } else {
      player2Score++;
    }
  }
}

class ResultPage extends StatelessWidget {
  const ResultPage({super.key});

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic>? args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;

    String player1Name = args?['player1Name'] ?? 'Player 1';
    String player2Name = args?['player2Name'] ?? 'Player 2';
    int player1Score = args?['player1Score'] ?? 0;
    int player2Score = args?['player2Score'] ?? 0;

    return Scaffold(
      appBar: AppBar(
        title: Text('Result Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('$player1Name Score: $player1Score'),
            Text('$player2Name Score: $player2Score'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/game');
              },
              child: Text('Play Again'),
            ),
          ],
        ),
      ),
    );
  }
}
