import 'package:flutter/material.dart';
import 'package:superhero_flutter/dao/hero_dao.dart';
import 'package:superhero_flutter/models/hero.dart';
import 'package:superhero_flutter/screens/hero_detail_screen.dart';
import 'package:superhero_flutter/services/hero_service.dart';

class HeroListScreen extends StatefulWidget {
  const HeroListScreen({super.key});

  @override
  State<HeroListScreen> createState() => _HeroListScreenState();
}

class _HeroListScreenState extends State<HeroListScreen> {
  final TextEditingController _controller = TextEditingController();
  String _name = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(100),
          child: SafeArea(
            child: Column(children: [
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.6),
                        offset: const Offset(0, 5),
                        blurRadius: 12.0,
                        spreadRadius: 0,
                      )
                    ],
                  ),
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(),
                        hintText: "Search hero by name"),
                    onChanged: (value) {
                      setState(() {
                        _name = value;
                      });
                    },
                  ),
                ),
              ),
            ]),
          )),
      body: HeroList(query: _name),
    );
  }
}

class HeroList extends StatefulWidget {
  const HeroList({super.key, required this.query});

  final String query;
  @override
  State<HeroList> createState() => _HeroListState();
}

class _HeroListState extends State<HeroList> {
  final _heroService = HeroService();
  List _heros = [];

  @override
  Widget build(BuildContext context) {
    if (widget.query.isEmpty) {
      return Container();
    }
    return FutureBuilder<List>(
        future: _heroService.getHerosByName(widget.query),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            _heros = snapshot.data ?? [];
            return ListView.builder(
              itemCount: _heros.length,
              itemBuilder: (context, index) {
                return SuperHeroItem(hero: _heros[index]);
              },
            );
          }
        });
  }
}

class SuperHeroItem extends StatefulWidget {
  const SuperHeroItem({super.key, required this.hero});
  final SuperHero hero;

  @override
  State<SuperHeroItem> createState() => _SuperHeroItemState();
}

class _SuperHeroItemState extends State<SuperHeroItem> {
  bool _isFavorite = false;
  final HeroDao _heroDao = HeroDao();

  initialize() async {
    _isFavorite = await _heroDao.isFavorite(widget.hero);
    if (mounted) {
      setState(() {
        _isFavorite = _isFavorite;
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
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => HeroDetailScreen(hero: widget.hero),
            ));
      },
      child: Card(
        child: ListTile(
          title: Text(widget.hero.name),
          subtitle: Text(widget.hero.fullName),
          leading: Hero(
            tag: widget.hero.id,
            child: Image.network(widget.hero.path)),
          trailing: IconButton(
            icon: Icon(
              Icons.favorite,
              color: _isFavorite ? Colors.red : Colors.grey,
            ),
            onPressed: () {
              setState(() {
                _isFavorite = !_isFavorite;
              });
              _isFavorite
                  ? _heroDao.insert(widget.hero)
                  : _heroDao.delete(widget.hero);
            },
          ),
        ),
      ),
    );
  }
}
