import 'dart:math';
import 'package:flutter/material.dart';

void main() => runApp(const RpsApp());

enum Move { rock, paper, scissors }

extension MoveData on Move {
  String get emoji => switch (this) {
        Move.rock => '🪨',
        Move.paper => '📄',
        Move.scissors => '✂️',
      };

  String get name => switch (this) {
        Move.rock => 'Rock',
        Move.paper => 'Paper',
        Move.scissors => 'Scissors',
      };

  String get shortRule => switch (this) {
        Move.rock => 'beats Scissors',
        Move.paper => 'beats Rock',
        Move.scissors => 'beats Paper',
      };
}

class RpsApp extends StatelessWidget {
  const RpsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'RPS Arena',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
        ),
        scaffoldBackgroundColor: const Color(0xFFF7F5FF),
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Random random = Random();

  Move? player;
  Move? cpu;

  String message = 'Choose your move';

  int wins = 0;
  int losses = 0;
  int draws = 0;

  bool darkMode = false;

  void play(Move choice) {
    final bot = Move.values[random.nextInt(3)];

    setState(() {
      player = choice;
      cpu = bot;

      if (choice == bot) {
        draws++;
        message = 'It’s a Draw! 🤝';
      } else if (
          (choice == Move.rock && bot == Move.scissors) ||
          (choice == Move.paper && bot == Move.rock) ||
          (choice == Move.scissors && bot == Move.paper)) {
        wins++;
        message = 'You Win! 🎉';
      } else {
        losses++;
        message = 'Computer Wins! 🤖';
      }
    });
  }

  void reset() {
    setState(() {
      player = null;
      cpu = null;
      message = 'Choose your move';

      wins = 0;
      losses = 0;
      draws = 0;
    });
  }

  void showRules() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('How to Play'),
        content: const Text(
          '🪨 Rock beats Scissors\n\n'
          '📄 Paper beats Rock\n\n'
          '✂️ Scissors beats Paper\n\n'
          'Choose one move and the computer will '
          'choose randomly. Win rounds to increase your score!',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Theme(
      data: darkMode
          ? ThemeData.dark(useMaterial3: true).copyWith(
              colorScheme: ColorScheme.fromSeed(
                seedColor: Colors.deepPurple,
                brightness: Brightness.dark,
              ),
            )
          : theme,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'RPS ARENA',
            style: TextStyle(
              fontWeight: FontWeight.w800,
            ),
          ),
          centerTitle: true,
          actions: [
            IconButton(
              tooltip: 'Rules',
              onPressed: showRules,
              icon: const Icon(Icons.help_outline),
            ),
            IconButton(
              tooltip: 'Theme',
              onPressed: () {
                setState(() {
                  darkMode = !darkMode;
                });
              },
              icon: Icon(
                darkMode
                    ? Icons.light_mode
                    : Icons.dark_mode,
              ),
            ),
          ],
        ),

        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(18),

              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: 720,
                ),

                child: Column(
                  children: [

                    const Text(
                      '⚔️',
                      style: TextStyle(
                        fontSize: 55,
                      ),
                    ),

                    Text(
                      'ROCK • PAPER • SCISSORS',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w900,
                      ),
                    ),

                    const SizedBox(height: 5),

                    Text(
                      'Battle the computer. Beat your best score.',
                      style: theme.textTheme.bodyMedium,
                    ),

                    const SizedBox(height: 20),

                    // SCORE
                    Row(
                      children: [
                        scoreCard(
                          'YOU',
                          wins,
                          Icons.person,
                        ),

                        const SizedBox(width: 10),

                        scoreCard(
                          'DRAWS',
                          draws,
                          Icons.handshake_outlined,
                        ),

                        const SizedBox(width: 10),

                        scoreCard(
                          'CPU',
                          losses,
                          Icons.smart_toy_outlined,
                        ),
                      ],
                    ),

                    const SizedBox(height: 18),

                    // PLAYER VS COMPUTER
                    Card(
                      elevation: 0,

                      child: Padding(
                        padding: const EdgeInsets.all(18),

                        child: Row(
                          children: [

                            movePanel(
                              'YOU',
                              player,
                            ),

                            const Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 10,
                              ),

                              child: Text(
                                'VS',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ),

                            movePanel(
                              'COMPUTER',
                              cpu,
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // RESULT
                    AnimatedSwitcher(
                      duration: const Duration(
                        milliseconds: 250,
                      ),

                      child: Text(
                        message,
                        key: ValueKey(message),
                        textAlign: TextAlign.center,

                        style: const TextStyle(
                          fontSize: 27,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),

                    const SizedBox(height: 18),

                    Align(
                      alignment: Alignment.centerLeft,

                      child: Text(
                        'MAKE YOUR MOVE',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),

                    // MOVE BUTTONS
                    Row(
                      children: Move.values.map(
                        (m) {
                          return Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 4,
                              ),

                              child: FilledButton(
                                onPressed: () => play(m),

                                style: FilledButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 15,
                                  ),

                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(18),
                                  ),
                                ),

                                child: Column(
                                  children: [

                                    Text(
                                      m.emoji,
                                      style: const TextStyle(
                                        fontSize: 34,
                                      ),
                                    ),

                                    const SizedBox(height: 4),

                                    Text(m.name),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ).toList(),
                    ),

                    const SizedBox(height: 16),

                    // RESET
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: reset,

                            icon: const Icon(
                              Icons.refresh,
                            ),

                            label: const Text(
                              'Reset Game',
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 18),

                    const Text(
                      'Rock beats Scissors • '
                      'Scissors beats Paper • '
                      'Paper beats Rock',
                      textAlign: TextAlign.center,

                      style: TextStyle(
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // SCORE CARD
  Widget scoreCard(
    String title,
    int score,
    IconData icon,
  ) {
    return Expanded(
      child: Card(
        elevation: 0,

        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 14,
          ),

          child: Column(
            children: [

              Icon(
                icon,
                size: 22,
              ),

              const SizedBox(height: 4),

              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                ),
              ),

              Text(
                '$score',
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // MOVE PANEL
  Widget movePanel(
    String title,
    Move? move,
  ) {
    return Expanded(
      child: Column(
        children: [

          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w800,
            ),
          ),

          const SizedBox(height: 10),

          AnimatedSwitcher(
            duration: const Duration(
              milliseconds: 200,
            ),

            child: Text(
              move?.emoji ?? '❔',

              key: ValueKey(move),

              style: const TextStyle(
                fontSize: 60,
              ),
            ),
          ),

          const SizedBox(height: 5),

          Text(
            move?.name ?? 'Waiting...',
          ),
        ],
      ),
    );
  }
}
