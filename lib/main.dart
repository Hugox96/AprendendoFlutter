import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {  
    return MaterialApp(
      title: 'Startup Gerador de Nomes',
      theme: ThemeData (
          primaryColor: Colors.red,
      ),
      home: RandomWords(),
    );
  }
}

class _RandomWordsState extends State<RandomWords> {

final _suggestions = <WordPair>[];
//Este conjunto armazena os pares de palavras que o usuário favoritou. 
final _saved = Set<WordPair>();  
final _biggerFont = TextStyle(fontSize: 18.0);  
  

Widget _buildSuggestions() {
    return ListView.builder(
        padding: EdgeInsets.all(16.0),
        itemBuilder: /*1*/ (context, i) 
        
/* O retorno de chamada itemBuilder é chamado uma vez por par de palavras sugeridas e coloca cada sugestão em uma linha ListTile. 
Para linhas pares, a função adiciona uma linha ListTile para o par de palavras. 
Para linhas ímpares, a função adiciona um widget Divider para separar visualmente as entradas.*/
        
        {
           
      // Adiciona um widget divisor de um pixel de altura antes de cada linha em ListView. 
          if (i.isOdd) return Divider(); /*2*/

          
      // A expressão i ~ / 2 divide i por 2 e retorna um resultado inteiro. 
          final index = i ~/ 2; /*3*/
          if (index >= _suggestions.length) 
          {
            _suggestions.addAll(generateWordPairs().take(10)); /*4*/
          }
     /* Se você atingiu o final dos pares de palavras disponíveis, 
     gere mais 10 e adicione-as à lista de sugestões.*/
          return _buildRow(_suggestions[index]);
        });
  }


  Widget _buildRow(WordPair pair) {
  /* adicione uma verificação alreadySaved 
  Para garantir que um par de palavras ainda não tenha sido adicionado aos favoritos.*/
  
  final alreadySaved = _saved.contains(pair); 
  return ListTile(
    title: Text(
      pair.asPascalCase,
      style: _biggerFont,
    ),
    trailing: Icon(   
      alreadySaved ? Icons.favorite : Icons.favorite_border,
      color: alreadySaved ? Colors.red : null,
    ), 
    onTap: () {
        setState(() {
            if(alreadySaved)
            {
                _saved.remove(pair);
            }
            else 
            {
                _saved.add(pair);
            }
        });
    },               
  );
} 

/* Adicione um ícone de lista ao AppBar no método de construção para 
_RandomWordsState. Quando o usuário clica no ícone da lista, 
uma nova rota que contém os favoritos salvos é enviada ao Navegador, exibindo o ícone.*/

 @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Startup Gerador de Nomes'),
        actions: [
            IconButton(icon: Icon(Icons.list), onPressed: _pushSaved),
        ],
      ),
      body: _buildSuggestions(),
    );
  } 

/* No Flutter, o Navigator gerencia uma pilha contendo as rotas do aplicativo. 
Empurrar uma rota na pilha do Navigator atualiza a exibição dessa rota. 
Pular uma rota da pilha do Navigator retorna a exibição à rota anterior.*/



void _pushSaved() {
    Navigator.of(context).push(
        
      MaterialPageRoute<void>(
        // Add lines from here...
        builder: (BuildContext context) {
          final tiles = _saved.map(
            (WordPair pair) {
              return ListTile(
                title: Text(
                  pair.asPascalCase,
                  style: _biggerFont,
                ),
              );
            },
          );
          final divided = ListTile.divideTiles(
            context: context,
            tiles: tiles,
          ).toList();

          return Scaffold(
            appBar: AppBar(
              title: Text('Saved Suggestions'),
            ),
            body: ListView(children: divided),
          );
        }, // ...to here.
      ),
    );
  }
}  // #docregion RWS-var

class RandomWords extends  StatefulWidget {
  @override
  _RandomWordsState createState() => _RandomWordsState();
}