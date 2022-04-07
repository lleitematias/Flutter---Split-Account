import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.cyan,
        fontFamily: 'Raleway',
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // VARIAVEIS
  final _tTotal = TextEditingController();
  final _tTotalSemBebida = TextEditingController();
  final _tQuantPessoas = TextEditingController();
  final _tPorcentagem = TextEditingController();
  final _tQuantPessoasBeberam = TextEditingController();
  var _infoText = "Valor garçom:";
  var _valorTotal = "Valor total";
  var _valorIndividual = "Valor Individual:";
  var _valorIndividualQuemBebe = "Valor Individual com Bebida:";
  var _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Racha Conta"),
        centerTitle: true,
        actions: <Widget>[
          IconButton(icon: Icon(Icons.refresh), onPressed: _resetFields)
        ],
      ),
      body: _body(),
    );
  }

  // PROCEDIMENTO PARA LIMPAR OS CAMPOS
  void _resetFields() {
    _tTotal.text = "";
    _tTotalSemBebida.text = "";
    _tQuantPessoas.text = "";
    _tQuantPessoasBeberam.text = "";
    _tPorcentagem.text = "";
    setState(() {
      _infoText = "Valor garçom: R\$\n";
      _valorTotal = "Valor total: R\$\n";
      _valorIndividual = "Valor Individual: R\$\n";
      _valorIndividualQuemBebe = "Valor Individual com bebida: R\$\n";
      _formKey = GlobalKey<FormState>();
    });
  }

  _body() {
    return SingleChildScrollView(
        padding: EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              _editText("Digite o valor da conta:", _tTotal),
              _editText("Digite o valor das bebidas:", _tTotalSemBebida),
              _editText("Digite a número de pessoas:", _tQuantPessoas),
              _editText("Digite a número de pessoas que beberam:",
                  _tQuantPessoasBeberam),
              _editText("Porcentagem do garçom:", _tPorcentagem),
              _buttonCalcularConta(),
              _textInfoGarcom(),
              _textInfoTotal(),
              _textInfoIndividual(),
              _textInfoIndividualBebida(),
            ],
          ),
        ));
  }

  _editText(String field, TextEditingController controller) {
    return TextFormField(
      controller: controller,
      validator: (s) => _validate(s, field),
      keyboardType: TextInputType.numberWithOptions(decimal: true),
      style: TextStyle(
        fontSize: 18,
        color: Colors.black,
      ),
      decoration: InputDecoration(
        labelText: field,
        labelStyle: TextStyle(
          height: 0,
          fontSize: 16,
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  String _validate(String text, String field) {
    field = "campos";
    if (text.isEmpty) {
      return "Complete os $field";
    }
    return null;
  }

  _buttonCalcularConta() {
    return Container(
      margin: EdgeInsets.only(top: 15.0, bottom: 20),
      height: 30,
      child: RaisedButton(
        color: Colors.grey,
        child: Text(
          "Calcular total a pagar",
          style: TextStyle(
            color: Colors.black,
            fontSize: 17,
          ),
        ),
        onPressed: () {
          if (_formKey.currentState.validate()) {
            _calcularIndividual();
            _calcularTotal();
            _calcularGarcom();
          }
        },
      ),
    );
  }

  void _calcularIndividual() {
    setState(() {
      double calPorcent =
          (double.parse(_tTotal.text) * int.parse(_tPorcentagem.text) / 100);
      double valorSemBebida =
          double.parse(_tTotal.text) - double.parse(_tTotalSemBebida.text);
      double totalInd =
          (valorSemBebida + calPorcent) / double.parse(_tQuantPessoas.text);
      double totalQuemBebe = totalInd +
          (double.parse(_tTotalSemBebida.text) /
              double.parse(_tQuantPessoasBeberam.text));
      String total2 = totalInd.toStringAsPrecision(4);
      String total4 = totalQuemBebe.toStringAsPrecision(4);
      _valorIndividual =
          "Valor Individual quem não bebeu:  R\$" + total2 + "\n";
      _valorIndividualQuemBebe =
          "Valor Individual quem bebeu:  R\$" + total4 + "\n";
    });
  }

  void _calcularGarcom() {
    setState(() {
      double porcent = int.parse(_tPorcentagem.text) / 100;
      double totalGar = (double.parse(_tTotal.text) * porcent);
      String total3 = totalGar.toStringAsPrecision(4);
      _infoText = "Valor garçom:  R\$" + total3 + "\n";
    });
  }

  void _calcularTotal() {
    setState(() {
      double porcent = int.parse(_tPorcentagem.text) / 100;
      double totalGar = (double.parse(_tTotal.text) * porcent);
      double total = double.parse(_tTotal.text) + totalGar;
      String total4 = total.toStringAsPrecision(4);
      _valorTotal = "Valor total:  R\$" + total4 + "\n";
    });
  }

  // // Widget text
  _textInfoGarcom() {
    return Text(
      _infoText,
      textAlign: TextAlign.left,
      style: TextStyle(
          color: Colors.black, fontSize: 16.0, fontWeight: FontWeight.bold),
    );
  }

  _textInfoTotal() {
    return Text(
      _valorTotal,
      textAlign: TextAlign.left,
      style: TextStyle(
          color: Colors.black, fontSize: 16.0, fontWeight: FontWeight.bold),
    );
  }

  _textInfoIndividual() {
    return Text(
      _valorIndividual,
      textAlign: TextAlign.left,
      style: TextStyle(
          color: Colors.black, fontSize: 16.0, fontWeight: FontWeight.bold),
    );
  }

  _textInfoIndividualBebida() {
    return Text(
      _valorIndividualQuemBebe,
      textAlign: TextAlign.left,
      style: TextStyle(
          color: Colors.black, fontSize: 16.0, fontWeight: FontWeight.bold),
    );
  }
}
