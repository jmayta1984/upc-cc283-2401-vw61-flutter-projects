import 'package:flutter/material.dart';
import 'package:turismo_app/dao/package_dao.dart';
import 'package:turismo_app/models/package.dart';

class FavoriteListScreen extends StatelessWidget {
  const FavoriteListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: const FavoriteList(),
    );
  }
}

class FavoriteList extends StatefulWidget {
  const FavoriteList({super.key});

  @override
  State<FavoriteList> createState() => _FavoriteListState();
}

class _FavoriteListState extends State<FavoriteList> {
  List<Package> _favorites = [];
  final PackageDao _packageDao = PackageDao();

  fetchFavorites() {
    _packageDao.fetchFavorites().then(
      (value) {
        if (mounted) {
          setState(() {
            _favorites = value;
          });
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    fetchFavorites();
    return ListView.builder(
        itemCount: _favorites.length,
        itemBuilder: (context, index) => FavoriteItem(
            favorite: _favorites[index],
            callback: () {
              _packageDao.delete(_favorites[index]);
            }));
  }
}

class FavoriteItem extends StatelessWidget {
  const FavoriteItem({
    super.key,
    required this.favorite,
    required this.callback,
  });

  final Package favorite;
  final Function callback;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width / 5;
    return Card(
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              height: width,
              width: width,
              favorite.image,
              fit: BoxFit.cover,
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                favorite.name,
              ),
            ),
          ),
          IconButton(
              onPressed: () {
                callback();
              },
              icon: const Icon(Icons.delete))
        ],
      ),
    );
  }
}
