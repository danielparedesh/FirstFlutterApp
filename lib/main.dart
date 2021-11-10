//LABORATORIO N°9 - Write your first Flutter app

//importamos el paquete de Flutter para utilizar Widgets
import 'package:flutter/material.dart';
//importamos paquete que genera pares de palabras aleatorias
import 'package:english_words/english_words.dart';

//utilizamos función flecha y ejecutamos la app
//funcion main, funcion principal ya sea para ejecutar flutter apps or dart code
void main() => runApp(MyApp());

//creamos la clase de nuestra app y utilizamos StatelessWidget para indicar que la clase será un widget estático
class MyApp extends StatelessWidget {
  @override
//Sobreescribimos el método build el cual describe cómo mostrar el widget en términos de los widgets hijos
  Widget build(BuildContext context) {
//clase MaterialApp usamos para crear aplicación que usará material design
    return MaterialApp(
      title: 'Startup Name Generator', //nombre de la app
      theme: ThemeData(
        //definimos propiedades de diseño
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
        ),
      ),
      home: RandomWords(), //la ruta principal, el primer widget que se mostrará
    );
  }
}

//creamos clase que extiende de State para manejar estados del Widget RandomWords (widget dinámico)
class _RandomWordsState extends State<RandomWords> {
  //variable que se le asigna array de de palabras random (WordPair)
  final _suggestions = <WordPair>[];
  //variable que se le asigna las palabras random seleccionadas
  final _saved = <WordPair>{};
  //variable que se le asigna estilo de texto
  final _biggerFont = const TextStyle(fontSize: 18.0);

//
  Widget _buildSuggestions() {
    return ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemBuilder: /*1*/ (context, i) {
          if (i.isOdd) return const Divider(); /*2*/

          final index = i ~/ 2; /*3*/
          if (index >= _suggestions.length) {
            _suggestions.addAll(generateWordPairs().take(10)); /*4*/
          }
          return _buildRow(_suggestions[index]);
        });
  }
  // #enddocregion _buildSuggestions

  // #docregion _buildRow
  Widget _buildRow(WordPair pair) {
    final alreadySaved = _saved.contains(pair);
    return ListTile(
      title: Text(
        pair.asPascalCase,
        style: _biggerFont,
      ),
      trailing: Icon(
        alreadySaved ? Icons.favorite : Icons.favorite_border,
        color: alreadySaved ? Colors.red : null,
        semanticLabel: alreadySaved ? 'Remove from saved' : 'Save',
      ),
      onTap: () {
        setState(() {
          if (alreadySaved) {
            _saved.remove(pair);
          } else {
            _saved.add(pair);
          }
        });
      },
    );
  }
  // #enddocregion _buildRow

  // #docregion RWS-build
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Startup Name Generator'),
        actions: [
          IconButton(
            icon: const Icon(Icons.list),
            onPressed: _pushSaved,
            tooltip: 'Saved Suggestions',
          ),
        ],
      ),
      body: _buildSuggestions(),
    );
  }
  // #enddocregion RWS-build

  void _pushSaved() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) {
          final tiles = _saved.map(
            (pair) {
              return ListTile(
                title: Text(
                  pair.asPascalCase,
                  style: _biggerFont,
                ),
              );
            },
          );
          final divided = tiles.isNotEmpty
              ? ListTile.divideTiles(
                  context: context,
                  tiles: tiles,
                ).toList()
              : <Widget>[];

          return Scaffold(
            appBar: AppBar(
              title: const Text('Saved Suggestions'),
            ),
            body: ListView(children: divided),
          );
        },
      ),
    );
  }
  // #docregion RWS-var
}
// #enddocregion RWS-var

class RandomWords extends StatefulWidget {
  @override
  State<RandomWords> createState() => _RandomWordsState();
}
