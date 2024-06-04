import 'package:flutter/material.dart';
import 'package:turismo_app/dao/package_dao.dart';
import 'package:turismo_app/models/package.dart';
import 'package:turismo_app/services/package_service.dart';

class PackageSearchScreen extends StatefulWidget {
  const PackageSearchScreen({super.key});

  @override
  State<PackageSearchScreen> createState() => _PackageSearchScreenState();
}

class _PackageSearchScreenState extends State<PackageSearchScreen> {
  final TextEditingController _placeController = TextEditingController();
  final TextEditingController _packageTypeController = TextEditingController();
  String _place = "";
  String _packageType = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          TextField(
            controller: _placeController,
          ),
          TextField(
            controller: _packageTypeController,
          ),
          OutlinedButton(
            onPressed: () {
              setState(() {
                _place = _placeController.text;
                _packageType = _packageTypeController.text;
              });
            },
            child: const Text("Search"),
          ),
          Expanded(
            child: PackageList(
              place: _place,
              packageType: _packageType,
            ),
          )
        ],
      ),
    );
  }
}

class PackageList extends StatefulWidget {
  const PackageList(
      {super.key, required this.place, required this.packageType});
  final String place;
  final String packageType;

  @override
  State<PackageList> createState() => _PackageListState();
}

class _PackageListState extends State<PackageList> {
  List<Package> _packages = [];
  final PackageService _packageService = PackageService();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Package>>(
        future:
            _packageService.getByPlaceAndType(widget.place, widget.packageType),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text("Error: $snapshot.error"),
            );
          } else {
            _packages = snapshot.data ?? [];
            return ListView.builder(
              itemCount: _packages.length,
              itemBuilder: (context, index) {
                return PackageItem(package: _packages[index]);
              },
            );
          }
        });
  }
}

class PackageItem extends StatefulWidget {
  const PackageItem({super.key, required this.package});
  final Package package;

  @override
  State<PackageItem> createState() => _PackageItemState();
}

class _PackageItemState extends State<PackageItem> {
  bool _isFavorite = false;
  final PackageDao _packageDao = PackageDao();

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return FutureBuilder<bool>(
      future: _packageDao.isFavorite(widget.package),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text("Error: $snapshot.error"),
          );
        } else {
          _isFavorite = snapshot.data ?? false;
          return Card(
            child: Column(
              children: [
                Image.network(
                  widget.package.image,
                  width: width / 2,
                ),
                Text(
                  widget.package.name,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                Text(widget.package.location),
                IconButton(
                  onPressed: () {
                    setState(() {
                      _isFavorite = !_isFavorite;
                    });
                    _isFavorite
                        ? _packageDao.insert(widget.package)
                        : _packageDao.delete(widget.package);
                  },
                  
                  icon: Icon(Icons.favorite,
                      color: _isFavorite
                          ? Theme.of(context).primaryColor
                          : Theme.of(context).hintColor),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(widget.package.description),
                )
              ],
            ),
          );
        }
      },
    );
  }
}
