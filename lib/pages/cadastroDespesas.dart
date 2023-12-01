import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CadastroDespesaPage extends StatefulWidget {
  const CadastroDespesaPage({Key? key}) : super(key: key);

  @override
  _CadastroDespesaPageState createState() => _CadastroDespesaPageState();
}

class _CadastroDespesaPageState extends State<CadastroDespesaPage> {
  TextEditingController dataController = TextEditingController();
  TextEditingController categoriaController = TextEditingController();
  TextEditingController valorController = TextEditingController();
  TextEditingController metodoPagamentoController = TextEditingController();
  TextEditingController descricaoController = TextEditingController();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cadastro de Despesa'),
        backgroundColor: Colors.orangeAccent,
        elevation: 30,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: dataController,
              decoration: InputDecoration(labelText: 'Data'),
              keyboardType: TextInputType.datetime,
            ),
            SizedBox(height: 16),
            TextField(
              controller: categoriaController,
              decoration: InputDecoration(labelText: 'Categoria'),
            ),
            SizedBox(height: 16),
            TextField(
              controller: valorController,
              decoration: InputDecoration(labelText: 'Valor'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 16),
            TextField(
              controller: metodoPagamentoController,
              decoration: InputDecoration(labelText: 'Método de Pagamento'),
            ),
            SizedBox(height: 16),
            TextField(
              controller: descricaoController,
              decoration: InputDecoration(labelText: 'Descrição (opcional)'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                cadastrarDespesa();
              },
              child: Text('Cadastrar Despesa'),
            ),
          ],
        ),
      ),
    );
  }

  void cadastrarDespesa() async {
    String data = dataController.text;
    String categoria = categoriaController.text;
    double valor = double.tryParse(valorController.text) ?? 0.0;
    String metodoPagamento = metodoPagamentoController.text;
    String descricao = descricaoController.text;

    try {
      await _firestore.collection('despesas').add({
        'data': data,
        'categoria': categoria,
        'valor': valor,
        'metodoPagamento': metodoPagamento,
        'descricao': descricao,
      });

      limparCampos();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Despesa cadastrada com sucesso!'),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao cadastrar despesa. Tente novamente.'),
        ),
      );
    }
  }

  void limparCampos() {
    dataController.clear();
    categoriaController.clear();
    valorController.clear();
    metodoPagamentoController.clear();
    descricaoController.clear();
  }
}
