import 'package:flutter/material.dart';
import 'package:memory_matrix/data/data.dart';
import 'package:memory_matrix/model/tile_model.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Memory Game',
      theme: ThemeData(
        primaryColor: Colors.black,
        scaffoldBackgroundColor: Colors.white,
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: Colors.black),
        ),
      ),
      home: const GetStartedPage(),
    );
  }
}

class GetStartedPage extends StatelessWidget {
  const GetStartedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Welcome to Memory Matrix')),
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'MEMORY \n  MATRIX💡',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 30),
                const Text(
                  'Sharpen your Minds with Memory Matrix!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const LoginPage()),
                    );
                  },
                  child: const Text('Get Started 🚀'),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 16,
            right: 16,
            child: const Text(
              'Akilesh',
              style: TextStyle(color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }
}

//
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();

  void _login() {
    if (_usernameController.text.isNotEmpty) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Homepage(username: _usernameController.text)),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a username')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(
                labelText: 'Username',
                hintText: 'Enter your username',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: _login,
              child: const Text('Login 🚀'),
            ),
          ],
        ),
      ),
    );
  }
}
//

class Homepage extends StatefulWidget {
  final String username;

  const Homepage({super.key, required this.username});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  List<TileModel> pairs = [];
  List<TileModel> visiblePairs = [];
  int points = 0;
  int moves = 0;
  bool selected = false;
  TileModel? selectedTile;
  int? selectedIndex;
  DateTime? startTime;

  @override
  void initState() {
    super.initState();
    pairs = getPairs();
    pairs.addAll(getPairs());
    pairs.shuffle();

    visiblePairs = pairs;
    selected = true;
    startTime = DateTime.now();
    Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        visiblePairs = getQuestions();
        selected = false;
      });
    });
  }

  void checkMatch(TileModel tile, int index) {
    setState(() {
      moves++;
    });

    if (selectedTile != null) {
      if (selectedTile!.getImageAssetPath() == tile.getImageAssetPath() && selectedIndex != index) {
        setState(() {
          points += 100;
          selectedTile = null;
          selectedIndex = null;
        });

        if (points == 800) {
          Future.delayed(const Duration(seconds: 3), showGameOverDialog);
        }
      } else {
        Future.delayed(const Duration(seconds: 1), () {
          setState(() {
            pairs[selectedIndex!].setSelected(false);
            tile.setSelected(false);
            selectedTile = null;
            selectedIndex = null;
          });
        });
      }
    } else {
      setState(() {
        selectedTile = tile;
        selectedIndex = index;
      });
    }
  }

  void showGameOverDialog() {
    final duration = DateTime.now().difference(startTime!);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(" Result ! "),
          content: Text("Awesome! ${widget.username} ✨\nYou won the game in $moves moves! 💥\nTime taken: ${duration.inMinutes} minutes and ${duration.inSeconds % 60} seconds ⚡ "),
          actions: [
            TextButton(
              child: const Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
                resetGame();
              },
            ),
          ],
        );
      },
    );
  }

  void resetGame() {
    setState(() {
      points = 0;
      moves = 0;
      pairs = getPairs();
      pairs.addAll(getPairs());
      pairs.shuffle();
      visiblePairs = pairs;
      startTime = DateTime.now();
      Future.delayed(const Duration(seconds: 3), () {
        setState(() {
          visiblePairs = getQuestions();
          selected = false;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Welcome ${widget.username} ")),
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 20),
        child: Column(
          children: <Widget>[
            const SizedBox(height: 25),
            const Text(
              "Points",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            Text(
              "$points/800",
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 50),
            Expanded(
              child: points == 800
                  ? const Center(
                child: Text(
                  " GAME OVER ! ",
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              )
                  : GridView(
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: MediaQuery.of(context).size.width / 4,
                  mainAxisSpacing: 0.0,
                ),
                children: List.generate(visiblePairs.length, (index) {
                  return Tile(
                    key: Key('tile_$index'),
                    imageAssetPath: visiblePairs[index].getImageAssetPath(),
                    selected: visiblePairs[index].getIsSelected(),
                    parent: this,
                    tileIndex: index,
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Tile extends StatefulWidget {
  final String imageAssetPath;
  final bool selected;
  final _HomepageState parent;
  final int tileIndex;

  const Tile({
    super.key,
    required this.imageAssetPath,
    required this.selected,
    required this.parent,
    required this.tileIndex,
  });

  @override
  _TileState createState() => _TileState();
}

class _TileState extends State<Tile> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (!widget.parent.selected && !widget.parent.pairs[widget.tileIndex].getIsSelected()) {
          setState(() {
            widget.parent.pairs[widget.tileIndex].setSelected(true);
          });
          widget.parent.checkMatch(widget.parent.pairs[widget.tileIndex], widget.tileIndex);
        }
      },
      child: Container(
        margin: const EdgeInsets.all(5),
        child: Image.asset(
          widget.parent.pairs[widget.tileIndex].getIsSelected()
              ? widget.parent.pairs[widget.tileIndex].getImageAssetPath()
              : widget.imageAssetPath,
        ),
      ),
    );
  }
}
