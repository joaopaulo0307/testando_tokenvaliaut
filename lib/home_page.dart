import 'package:flutter/material.dart';
import 'api_service.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final ApiService api = ApiService();
  List<dynamic> items = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    carregarDados();
  }

  void carregarDados() async {
    try {
      final dados = await api.getData();
      setState(() {
        items = dados;
        loading = false;
      });
    } catch (e) {
      setState(() => loading = false);
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Integração REST")),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, i) => ListTile(
                title: Text(items[i]["nome"].toString()),
              ),
            ),
    );
  }
}
