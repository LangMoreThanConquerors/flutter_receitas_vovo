// main.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(MeuAppReceitas());
}

class MeuAppReceitas extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Receitas da Vovó',
      theme: ThemeData(
        primarySwatch: Colors.orange,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: TelaInicial(),
    );
  }
}

class TelaInicial extends StatefulWidget {
  @override
  _TelaInicialState createState() => _TelaInicialState();
}

class _TelaInicialState extends State<TelaInicial> {
  // Lista de receitas - dados locais mesmo
  List<Map<String, dynamic>> receitas = [
    {
      'nome': 'Bolo de Cenoura',
      'ingredientes': '3 cenouras, 4 ovos, 2 xícaras de açúcar, 3 xícaras de farinha, 1 colher fermento',
      'preparo': 'Bater tudo no liquidificador e levar ao forno por 40 minutos',
      'imagem': 'bolo_cenoura',
      'favorito': false,
    },
    {
      'nome': 'Pão de Queijo',
      'ingredientes': '500g polvilho azedo, 200ml leite, 100ml óleo, 3 ovos, 200g queijo',
      'preparo': 'Misturar tudo e fazer bolinhas. Assar por 25 minutos',
      'imagem': 'pao_queijo',
      'favorito': true,
    },
    {
      'nome': 'Feijoada',
      'ingredientes': '500g feijão preto, 200g carne seca, 200g costelinha, linguiça, cebola, alho',
      'preparo': 'Cozinhar o feijão e as carnes separadas. Depois juntar tudo',
      'imagem': 'feijoada',
      'favorito': false,
    },
  ];

  // Controladores para o formulário de adição
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _ingredientesController = TextEditingController();
  final TextEditingController _preparoController = TextEditingController();

  void _adicionarReceita() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Nova Receita'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _nomeController,
                  decoration: InputDecoration(labelText: 'Nome da Receita'),
                ),
                TextField(
                  controller: _ingredientesController,
                  decoration: InputDecoration(labelText: 'Ingredientes'),
                  maxLines: 3,
                ),
                TextField(
                  controller: _preparoController,
                  decoration: InputDecoration(labelText: 'Modo de Preparo'),
                  maxLines: 3,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                if (_nomeController.text.isNotEmpty) {
                  setState(() {
                    receitas.add({
                      'nome': _nomeController.text,
                      'ingredientes': _ingredientesController.text,
                      'preparo': _preparoController.text,
                      'imagem': 'default',
                      'favorito': false,
                    });
                  });
                  _nomeController.clear();
                  _ingredientesController.clear();
                  _preparoController.clear();
                  Navigator.pop(context);
                }
              },
              child: Text('Salvar'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Minhas Receitas'),
        backgroundColor: Colors.orange,
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: BuscaReceitas(receitas: receitas),
              );
            },
          ),
        ],
      ),

      body: Column(
        children: [
          // Banner simples
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(20),
            color: Colors.orange[100],
            child: Column(
              children: [
                Text(
                  '🍳 Receitas da Vovó',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.brown[800],
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'As melhores receitas caseiras',
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),

          // Lista de receitas
          Expanded(
            child: ListView.builder(
              itemCount: receitas.length,
              itemBuilder: (context, index) {
                return CardReceita(
                  receita: receitas[index],
                  onFavoritar: () {
                    setState(() {
                      receitas[index]['favorito'] = !receitas[index]['favorito'];
                    });
                  },
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetalhesReceita(receita: receitas[index]),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),

      // Botão flutuante para adicionar
      floatingActionButton: FloatingActionButton(
        onPressed: _adicionarReceita,
        child: Icon(Icons.add),
        backgroundColor: Colors.orange,
      ),
    );
  }
}

// Widget para cada card de receita
class CardReceita extends StatelessWidget {
  final Map<String, dynamic> receita;
  final VoidCallback onFavoritar;
  final VoidCallback onTap;

  const CardReceita({
    Key? key,
    required this.receita,
    required this.onFavoritar,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.all(12),
          child: Row(
            children: [
              // Placeholder de imagem
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.orange[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    '🍽️',
                    style: TextStyle(fontSize: 30),
                  ),
                ),
              ),
              SizedBox(width: 15),

              // Informações da receita
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      receita['nome'],
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Clique para ver ingredientes...',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),

              // Botão de favorito
              IconButton(
                icon: Icon(
                  receita['favorito'] ? Icons.favorite : Icons.favorite_border,
                  color: receita['favorito'] ? Colors.red : Colors.grey,
                ),
                onPressed: onFavoritar,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Tela de detalhes da receita
class DetalhesReceita extends StatelessWidget {
  final Map<String, dynamic> receita;

  const DetalhesReceita({Key? key, required this.receita}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(receita['nome']),
        backgroundColor: Colors.orange,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Imagem ilustrativa
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.orange[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  '🍳 Imagem da Receita',
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.brown,
                  ),
                ),
              ),
            ),

            SizedBox(height: 20),

            // Título ingredientes
            Text(
              '📝 Ingredientes',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),

            // Ingredientes
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.orange[50],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                receita['ingredientes'],
                style: TextStyle(fontSize: 16),
              ),
            ),

            SizedBox(height: 20),

            // Título modo de preparo
            Text(
              '👩‍🍳 Modo de Preparo',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),

            // Modo de preparo
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.orange[50],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                receita['preparo'],
                style: TextStyle(fontSize: 16),
              ),
            ),

            SizedBox(height: 20),

            // Botão de compartilhar
            Center(
              child: ElevatedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Compartilhar receita!'),
                      duration: Duration(seconds: 1),
                    ),
                  );
                },
                icon: Icon(Icons.share),
                label: Text('Compartilhar Receita'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Classe de busca
class BuscaReceitas extends SearchDelegate {
  final List<Map<String, dynamic>> receitas;

  BuscaReceitas({required this.receitas});

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    List<Map<String, dynamic>> resultados = receitas.where((receita) {
      return receita['nome'].toLowerCase().contains(query.toLowerCase());
    }).toList();

    return ListView.builder(
      itemCount: resultados.length,
      itemBuilder: (context, index) {
        return ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.orange[100],
            child: Text('🍽️'),
          ),
          title: Text(resultados[index]['nome']),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DetalhesReceita(receita: resultados[index]),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<Map<String, dynamic>> sugestoes = receitas.where((receita) {
      return receita['nome'].toLowerCase().contains(query.toLowerCase());
    }).toList();

    return ListView.builder(
      itemCount: sugestoes.length,
      itemBuilder: (context, index) {
        return ListTile(
          leading: Icon(Icons.restaurant_menu, color: Colors.orange),
          title: Text(sugestoes[index]['nome']),
          onTap: () {
            query = sugestoes[index]['nome'];
            showResults(context);
          },
        );
      },
    );
  }
}
