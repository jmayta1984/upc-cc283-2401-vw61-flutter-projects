import 'package:flutter/material.dart';
import 'package:turismo_app/dao/package_dao.dart';
import 'package:turismo_app/models/package.dart';
import 'package:turismo_app/services/package_service.dart';

enum Place {
  machuPicchu(id: "s001", description: "Machu Picchu"),
  ayacucho(id: "s002", description: "Ayacucho"),
  chichenItza(id: "s003", description: "Chichen Itza"),
  cristoRedentor(id: "s004", description: "Cristo Redentor"),
  islasMalvinas(id: "s005", description: "Islas Malvinas"),
  murrallaChina(id: "s006", description: "Murralla China");

  const Place({required this.id, required this.description});
  final String id;
  final String description;
}

enum Type {
  viaje(id: "1", description: "Viaje"),
  hospedaje(id: "2", description: "Hospedaje");

  const Type({required this.id, required this.description});
  final String id;
  final String description;
}

class PackageSearchScreen extends StatefulWidget {
  const PackageSearchScreen({super.key});

  @override
  State<PackageSearchScreen> createState() => _PackageSearchScreenState();
}

class _PackageSearchScreenState extends State<PackageSearchScreen> {
  String _place = "";
  String _packageType = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          ExpansionTile(
            title: Text(
              "Places",
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            initiallyExpanded: true,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Wrap(
                  spacing: 8,
                  children: Place.values
                      .map((value) => InputChip(
                            label: Text(value.description),
                            selected: (_place == value.id),
                            onSelected: (onValue) {
                              setState(() {
                                _place = value.id;
                              });
                            },
                            selectedColor: Colors.green,
                          ))
                      .toList(),
                ),
              ),
            ],
          ),
          ExpansionTile(
            title: Text(
              "Types",
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            initiallyExpanded: true,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Wrap(
                  spacing: 8,
                  children: Type.values
                      .map((value) => FilterChip(
                            label: Text(value.description),
                            selected: (_packageType == value.id),
                            onSelected: (onValue) {
                              setState(() {
                                _packageType = value.id;
                              });
                            },
                            selectedColor: Colors.green,
                          ))
                      .toList(),
                ),
              ),
            ],
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

  checkFavorite() {
    _packageDao.isFavorite(widget.package).then(
      (value) {
        if (mounted) {
          setState(() {
            _isFavorite = value;
          });
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    checkFavorite();

    return Card(
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              widget.package.image,
              height: width * 0.75,
              width: width,
              fit: BoxFit.cover,
            ),
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
}
