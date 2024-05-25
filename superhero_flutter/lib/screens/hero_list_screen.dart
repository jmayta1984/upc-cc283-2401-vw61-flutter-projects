import 'package:flutter/material.dart';
import 'package:superhero_flutter/services/hero_service.dart';

class HeroListScreen extends StatelessWidget {
  const HeroListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("SuperHero"),
      ),
      body:  const HeroList(),
    );
  }
}

class HeroList extends StatefulWidget {
  const HeroList({super.key});

  @override
  State<HeroList> createState() => _HeroListState();
}

class _HeroListState extends State<HeroList> {
  List _heros = [];
  final _heroService = HeroService();

  initialize() async {
    _heros = await _heroService.getHerosByName("robin");
    setState(() {
      _heros = _heros;
    });
  }

  @override
  void initState() {
    initialize();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: _heros.length,
      itemBuilder: (context, index) {
        return Card(
          child: ListTile(
            title: Text(_heros[index].name),
            subtitle: Text(_heros[index].fullName),
            leading: Image.network(_heros[index].path),
          ),
        );
      },
    );
  }
}
