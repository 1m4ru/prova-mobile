import 'package:flutter/material.dart';
import 'package:trade_hub/pages/cadastroDespesas.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:trade_hub/pages/graficoPage.dart';
import 'package:trade_hub/pages/graficoPage.dart';
import 'package:trade_hub/pages/cadastroDespesas.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Minha App'),
        backgroundColor: Colors.orangeAccent,
        elevation: 30,
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              elevation: 5,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Total das Dívidas',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    StreamBuilder<QuerySnapshot>(
                      stream: _firestore.collection('despesas').snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return CircularProgressIndicator();
                        }

                        var despesas = snapshot.data!.docs;
                        double totalDividas = 0.0;

                        for (var despesa in despesas) {
                          var despesaData =
                              despesa.data() as Map<String, dynamic>;
                          var valor = despesaData['valor'] ?? 0.0;
                          totalDividas += valor;
                        }

                        return Text(
                          'R\$ ${totalDividas.toStringAsFixed(2)}',
                          style: TextStyle(fontSize: 24, color: Colors.red),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Transações Recentes',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _firestore.collection('despesas').snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return CircularProgressIndicator();
                  }

                  var despesas = snapshot.data!.docs;

                  return ListView.builder(
                    itemCount: despesas.length,
                    itemBuilder: (context, index) {
                      var despesa =
                          despesas[index].data() as Map<String, dynamic>;

                      return ListTile(
                        title: Text(despesa['categoria'] ?? ''),
                        subtitle: Text('R\$ ${despesa['valor'] ?? ''}'),
                      );
                    },
                  );
                },
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                print('Botão "Ver Tudo" pressionado');
              },
              child: Text('Ver Tudo'),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.money),
            label: 'Cadastro Despesa',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.show_chart),
            label: 'Gráfico',
          ),
        ],
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HomePage()),
              );
              break;
            case 1:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CadastroDespesaPage()),
              );
              break;
            case 2:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => GraficoPage()),
              );
              break;
            default:
              break;
          }
        },
      ),
    );
  }
}
