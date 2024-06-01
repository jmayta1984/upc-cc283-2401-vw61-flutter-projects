import 'package:flutter/material.dart';
import 'package:superhero_flutter/dao/hero_dao.dart';

class FavoriteHeroListScreen extends StatefulWidget {
  const FavoriteHeroListScreen({super.key});

  @override
  State<FavoriteHeroListScreen> createState() => _FavoriteHeroListScreenState();
}

class _FavoriteHeroListScreenState extends State<FavoriteHeroListScreen> {
  List _favoriteHeros = [];

  initialize() async {
    _favoriteHeros = await HeroDao().fetchAll();
    if (mounted) {
      setState(() {
        _favoriteHeros = _favoriteHeros;
      });
    }
  }

  @override
  void initState() {
    initialize();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: _favoriteHeros.length,
        itemBuilder: (context, index) => Card(
          child: ListTile(
            title: Text(_favoriteHeros[index].name),
            subtitle: Text(_favoriteHeros[index].fullName),
          ),
        ),
      ),
    );
  }
}
