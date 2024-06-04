import 'package:flutter/material.dart';
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
  List _packages = [];
  final PackageService _packageService = PackageService();

  search() async {
    _packages = await _packageService.getByPlaceAndType(
        widget.place, widget.packageType);
    if (mounted) {
      setState(() {
        _packages = _packages;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    search();
    return ListView.builder(
      itemCount: _packages.length,
      itemBuilder: (context, index) {
        return PackageItem(package: _packages[index]);
      },
    );
  }
}

class PackageItem extends StatelessWidget {
  const PackageItem({super.key, required this.package});
  final Package package;

  @override
  Widget build(BuildContext context) {
    return ListTile(title: Text(package.name));
  }
}
