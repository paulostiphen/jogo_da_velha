import 'package:flutter/material.dart';

void main() {
  runApp(const JogoDaVelhaApp());
}

class JogoDaVelhaApp extends StatelessWidget {
  const JogoDaVelhaApp({super.key});

@override
Widget build(BuildContext context) {
  return MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Jogo da Velha',
    theme: ThemeData(
      primarySwatch: Colors.deepPurple, 
    ),
    home: const ConfigScreen(),
  );
}
}

class ConfigScreen extends StatefulWidget {
  const ConfigScreen({super.key});

  @override
  State<ConfigScreen> createState() => _ConfigScreenState();
}

class _ConfigScreenState extends State<ConfigScreen> {
  final TextEditingController _nome1Controller = TextEditingController();
  final TextEditingController _nome2Controller = TextEditingController();
  String _escolhaJogador1 = 'X';

  void _iniciarJogo() {
    if (_nome1Controller.text.isEmpty || _nome2Controller.text.isEmpty) return;

    String jogador1 = _nome1Controller.text;
    String jogador2 = _nome2Controller.text;
    String jogador1Simbolo = _escolhaJogador1;
    String jogador2Simbolo = jogador1Simbolo == 'X' ? 'O' : 'X';

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => JogoScreen(
          jogador1: jogador1,
          jogador2: jogador2,
          simbolo1: jogador1Simbolo,
          simbolo2: jogador2Simbolo,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Configurar Jogo')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _nome1Controller,
              decoration: const InputDecoration(labelText: 'Nome do Jogador 1'),
            ),
            TextField(
              controller: _nome2Controller,
              decoration: const InputDecoration(labelText: 'Nome do Jogador 2'),
            ),
            const SizedBox(height: 20),
            const Text('Jogador 1 escolhe:'),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: ['X', 'O'].map((simbolo) {
                return Row(
                  children: [
                    Radio(
                      value: simbolo,
                      groupValue: _escolhaJogador1,
                      onChanged: (value) {
                        setState(() {
                          _escolhaJogador1 = value!;
                        });
                      },
                    ),
                    Text(simbolo),
                  ],
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _iniciarJogo,
              child: const Text('Iniciar Jogo'),
            )
          ],
        ),
      ),
    );
  }
}


class JogoScreen extends StatefulWidget {
  final String jogador1;
  final String jogador2;
  final String simbolo1;
  final String simbolo2;

  const JogoScreen({
    super.key,
    required this.jogador1,
    required this.jogador2,
    required this.simbolo1,
    required this.simbolo2,
  });

  @override
  State<JogoScreen> createState() => _JogoScreenState();
}

class _JogoScreenState extends State<JogoScreen> {
  List<String> _tabuleiro = List.filled(9, '');
  bool _vezJogador1 = true;
  String _mensagem = '';
  int _pontos1 = 0;
  int _pontos2 = 0;

  void _fazerJogada(int index) {
    if (_tabuleiro[index] != '' || _mensagem.isNotEmpty) return;

    setState(() {
      _tabuleiro[index] = _vezJogador1 ? widget.simbolo1 : widget.simbolo2;
      _verificarResultado();
      _vezJogador1 = !_vezJogador1;
    });
  }

  void _verificarResultado() {
    const combinacoes = [
      [0, 1, 2],
      [3, 4, 5],
      [6, 7, 8],
      [0, 3, 6],
      [1, 4, 7],
      [2, 5, 8],
      [0, 4, 8],
      [2, 4, 6]
    ];

    for (var c in combinacoes) {
      if (_tabuleiro[c[0]] != '' &&
          _tabuleiro[c[0]] == _tabuleiro[c[1]] &&
          _tabuleiro[c[0]] == _tabuleiro[c[2]]) {
        String vencedorSimbolo = _tabuleiro[c[0]];
        String vencedor = vencedorSimbolo == widget.simbolo1
            ? widget.jogador1
            : widget.jogador2;

        if (vencedor == widget.jogador1) {
          _pontos1++;
        } else {
          _pontos2++;
        }

        _mensagem = '$vencedor venceu!';
        return;
      }
    }

    if (!_tabuleiro.contains('')) {
      _mensagem = 'Deu velha!';
    }
  }

  void _reiniciarRodada() {
    setState(() {
      _tabuleiro = List.filled(9, '');
      _mensagem = '';
      _vezJogador1 = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    String vez = _vezJogador1 ? widget.jogador1 : widget.jogador2;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Jogo da Velha'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _reiniciarRodada,
          )
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),
          Text(
            _mensagem.isEmpty ? 'Vez de $vez' : _mensagem,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          GridView.builder(
            shrinkWrap: true,
            itemCount: 9,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 4,
              crossAxisSpacing: 4,
            ),
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () => _fazerJogada(index),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.blue[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      _tabuleiro[index],
                      style: TextStyle(
                        fontSize: 48,
                        color: _tabuleiro[index] == widget.simbolo1
                            ? const Color.fromARGB(255, 5, 29, 49)
                            : const Color.fromARGB(255, 85, 20, 15),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 20),
          Text(
            '🏆 Pódio',
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text('${widget.jogador1}: $_pontos1 pts'),
          Text('${widget.jogador2}: $_pontos2 pts'),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _reiniciarRodada,
            child: const Text('Próxima Rodada'),
          )
        ],
      ),
    );
  }
}