import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
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
          child: Text(
            'Start Game',
            style: TextStyle(fontSize: 24.0),
          ),
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
          ),
        ),
      ),
    );
  }
}

class InitiatePage extends StatelessWidget {
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
              decoration: InputDecoration(
                labelText: 'Player 1 Name',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) => player1Name = value,
            ),
            SizedBox(height: 20),
            TextField(
              decoration: InputDecoration(
                labelText: 'Player 2 Name',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) => player2Name = value,
            ),
            SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                if (player1Name.isNotEmpty && player2Name.isNotEmpty) {
                  Navigator.pushReplacementNamed(context, '/game');
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Please enter names for both players.'),
                    ),
                  );
                }
              },
              child: Text(
                'Play',
                style: TextStyle(fontSize: 20.0),
              ),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
              ),
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
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Range: $minRange - $maxRange',
              style: TextStyle(fontSize: 20.0),
            ),
            SizedBox(height: 20),
            Text(
              'Current Player: $currentPlayer',
              style: TextStyle(fontSize: 20.0),
            ),
            SizedBox(height: 20),
            TextField(
              controller: guessController,
              decoration: InputDecoration(
                labelText: 'Enter your guess',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                checkGuess();
              },
              child: Text(
                'Check',
                style: TextStyle(fontSize: 20.0),
              ),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
              ),
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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please enter a valid number within the current range.'),
        ),
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
            Text(
              '$player1Name Score: $player1Score',
              style: TextStyle(fontSize: 24.0),
            ),
            Text(
              '$player2Name Score: $player2Score',
              style: TextStyle(fontSize: 24.0),
            ),
            SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/game');
              },
              child: Text(
                'Play Again',
                style: TextStyle(fontSize: 20.0),
              ),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
