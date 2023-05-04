import 'package:flutter/material.dart';
import 'package:teste_api/controllers/information_controller.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final controller = Informationcontroller();

  @override
  void initState() {
    super.initState();
    controller.addListener(() {
      setState(() {});
    });
    controller.list();
  }

  @override
  dispose() {
    super.dispose();
    controller.dispose();
  }

  Widget _showMessageError(String message) {
    return Column(children: [
      const Padding(
        padding: EdgeInsets.symmetric(vertical: 20),
        child: Text(
          'A API respondeu com erro!',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      Text(controller.messageError),
    ]);
  }

  List<Widget> _showItensOfCategory(String category) {
    return controller.info[category]!.map<Widget>((e) {
      var tile = e.description.length >= 15
          ? SizedBox(
              height: 55,
              child: ListTile(
                title: Text(e.title),
                subtitle: Text(e.description),
              ),
            )
          : SizedBox(
              height: 35,
              child: ListTile(
                title: Text(e.title),
                trailing: Text(e.description),
              ),
            );
      return Card(
        margin: const EdgeInsets.symmetric(horizontal: 8),
        child: tile,
      );
    }).toList();
  }

  List<Widget> _showCategories() {
    return controller.categories
        .map<Widget>((category) => Column(children: [
              Card(
                color: Colors.blueAccent,
                child: Text(category),
              ),
              Column(
                children: controller.info[category] == null
                    ? []
                    : _showItensOfCategory(category),
              ),
            ]))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Informações')),
      body: Center(
        child: controller.isLoading
            ? const CircularProgressIndicator()
            : controller.messageError.isNotEmpty
                ? _showMessageError(controller.messageError)
                : Column(children: _showCategories()),
      ),
    );
  }
}
