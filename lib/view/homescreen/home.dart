import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  static const String playerX = "X";
  static const String playerY = "O";

  late String currentPlayer;
  late bool gameEnd;
  late List<String> occupied;

  @override
  void initState() {
    initializeGame();
    super.initState();
  }

  void initializeGame() {
    currentPlayer = playerX;
    gameEnd = false;
    occupied = ["", "", "", "", "", "", "", "", ""];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigo,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            headerText(),
            gameContainer(),
            elevatedButton(),
          ],
        ),
      ),
    );
  }

  Widget headerText() {
    return Column(
      children: [
        Text(
          "TIC TAC TOE",
          style: TextStyle(
              fontSize: 30, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        Text("$currentPlayer turn",
            style: TextStyle(
              fontSize: 25,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ))
      ],
    );
  }

  Widget gameContainer() {
    return Container(
      height: MediaQuery.of(context).size.height / 2,
      width: MediaQuery.of(context).size.height / 2,
      margin: EdgeInsets.all(8),
      child: GridView.builder(
        itemCount: 9,
        gridDelegate:
            SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
        itemBuilder: (context, index) {
          return box(index);
        },
      ),
    );
  }

  Widget box(index) {
    return InkWell(
      onTap: () {
        //Return if game is over or box is already occupied
        if (gameEnd || occupied[index].isNotEmpty) {
          return;
        }

        setState(() {
          occupied[index] = currentPlayer;
          changeTurn();
          winnerCheck();
          drawCheck();
        });
      },
      child: Container(
        margin: EdgeInsets.all(10),
        color: occupied[index].isEmpty
            ? const Color.fromARGB(255, 255, 255, 255)
            : occupied[index] == playerX
                ? const Color.fromARGB(255, 245, 162, 156)
                : const Color.fromARGB(255, 245, 199, 131),
        child: Center(
          child: Text(
            occupied[index],
            style: TextStyle(fontSize: 30),
          ),
        ),
      ),
    );
  }

  changeTurn() {
    if (currentPlayer == playerX) {
      currentPlayer = playerY;
    } else {
      currentPlayer = playerX;
    }
  }

  winnerCheck() {
    List<dynamic> winningList = [
      [0, 1, 2],
      [3, 4, 5],
      [6, 7, 8],
      [0, 4, 8],
      [2, 4, 6],
      [0, 3, 6],
      [1, 4, 7],
      [2, 5, 8]
    ];

    for (var winpos in winningList) {
      String p0 = occupied[winpos[0]];
      String p1 = occupied[winpos[1]];
      String p2 = occupied[winpos[2]];

      if (p0.isNotEmpty) {
        if (p0 == p1 && p0 == p2) {
          gameOverMessage("Player $p0 Won");
          gameEnd = true;
          return;
        }
      }
    }
  }

  gameOverMessage(String message) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Game Over"),
            content: Text(message),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    initializeGame();
                    setState(() {});
                  },
                  child: Text("Play Again"))
            ],
          );
        });
  }

  drawCheck() {
    if (gameEnd) {
      return;
    }
    bool draw = true;
    for (var occupiedPlayer in occupied) {
      if (occupiedPlayer.isEmpty) {
        draw = false;
      }
    }
    if (draw) {
      gameOverMessage("Game Draw");
      gameEnd = true;
    }
  }

  elevatedButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const Home()),
        );
      },
      child: const Text('Restart'),
    );
  }
}
