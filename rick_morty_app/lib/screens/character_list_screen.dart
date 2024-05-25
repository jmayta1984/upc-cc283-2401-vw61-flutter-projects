import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:rick_morty_app/models/character.dart';
import 'package:rick_morty_app/services/character_service.dart';

class CharacterListScreen extends StatelessWidget {
  const CharacterListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Characters"),
      ),
      body: const CharacterList(),
    );
  }
}

class CharacterList extends StatefulWidget {
  const CharacterList({super.key});

  @override
  State<CharacterList> createState() => _CharacterListState();
}

class _CharacterListState extends State<CharacterList> {
  final CharacterService _characterService = CharacterService();
  static const _pageSize = 20;

  final PagingController<int, dynamic> _pagingController =
      PagingController(firstPageKey: 1);

  @override
  void initState() {
    _pagingController.addPageRequestListener(
      (pageKey) {
        _fetchPage(pageKey);
      },
    );
    super.initState();
  }

  _fetchPage(int pageKey) async {
    try {
      final newItems = await _characterService.getAll(pageKey);
      final isLastPage = newItems.length < _pageSize;
      if (isLastPage) {
        _pagingController.appendLastPage(newItems);
      } else {
        final nextPageKey = pageKey + 1;
        _pagingController.appendPage(newItems, nextPageKey);
      }
    } catch (error) {
      _pagingController.error = error;
    }
  }

  @override
  Widget build(BuildContext context) {
    return PagedGridView<int, dynamic>(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 8.0,
        crossAxisSpacing: 8.0,
      ),
      pagingController: _pagingController,
      builderDelegate: PagedChildBuilderDelegate(
        itemBuilder: (context, item, index) => CharacterItem(
          character: item,
        ),
      ),
    );
  }
}

class CharacterItem extends StatelessWidget {
  const CharacterItem({super.key, required this.character});

  final Character character;

  @override
  Widget build(BuildContext context) {
    MaterialColor color;
    switch (character.status) {
      case "Alive":
        color = Colors.green;
        break;
      case "Dead":
        color = Colors.red;
        break;
      default:
        color = Colors.grey;
        break;
    }

    return Card(
      child: Column(
        children: [
          Expanded(child: Image.network(character.image)),
          Padding(
            padding: const EdgeInsets.all(2.0),
            child: Text(
              character.name,
              maxLines: 1,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(2.0),
            child: Row(
              children: [
                Icon(Icons.person, color: color),
                Expanded(child: Text(character.species, maxLines: 1,))
              ],
            ),
          )
        ],
      ),
    );
  }
}
