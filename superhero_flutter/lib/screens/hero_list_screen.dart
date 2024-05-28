import 'package:flutter/material.dart';
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
              const Text("Search"),
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
        });
  }
}
