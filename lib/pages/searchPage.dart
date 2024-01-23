import 'package:flutter/material.dart';
import 'package:material_floating_search_bar_2/material_floating_search_bar_2.dart';
import 'package:search_bar_ui_logic/components/searchResultListView.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController searchTerm = TextEditingController();
  late FloatingSearchBarController controller;

  static const historyMax = 5;
  List<String> searchHistory = [
    'flutter',
    'dart',
    'bloc',
    'firebase',
    'github'
  ];

  List<String> filterSearchHistory = [];

  List<String> filterSearchTerms({required String filter}) {
    return filter.isNotEmpty
        ? searchHistory.reversed
            .where((term) => term.startsWith(filter))
            .toList()
        : searchHistory.reversed.toList();
  }

  void addSearch({required String searchTerm}) {
    if (searchHistory.contains(searchTerm)) {
      searchHistory.remove(searchTerm);
      searchHistory.add(searchTerm);
      return;
    }

    searchHistory.add(searchTerm);
    if (searchHistory.length > historyMax) {
      searchHistory.removeRange(0, searchHistory.length - historyMax);
    }

    filterSearchHistory = filterSearchTerms(filter: '');
  }

  void removeSearch({required String searchTerm}) {
    searchHistory.removeWhere((term) => term == searchTerm);
    filterSearchHistory = filterSearchTerms(filter: '');
  }

  void putTermFirst(String searchTerm) {
    removeSearch(searchTerm: searchTerm);
    addSearch(searchTerm: searchTerm);
  }

  @override
  void initState() {
    controller = FloatingSearchBarController();
    filterSearchHistory = filterSearchTerms(filter: '');

    searchTerm.addListener(() {
      setState(() {});
    });

    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    searchTerm.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

    return Scaffold(
      body: FloatingSearchBar(
        hint: 'Search...',
        elevation: 0.5,
        iconColor: Colors.grey,
        borderRadius: BorderRadius.circular(10),
        border: const BorderSide(color: Colors.grey, width: 0.5),
        scrollPadding: const EdgeInsets.only(top: 16, bottom: 56),
        transitionDuration: const Duration(milliseconds: 800),
        transitionCurve: Curves.easeInOut,
        physics: const BouncingScrollPhysics(),
        axisAlignment: isPortrait ? 0.0 : -1.0,
        openAxisAlignment: 0.0,
        width: isPortrait ? 600 : 500,
        debounceDelay: const Duration(milliseconds: 500),
        onQueryChanged: (query) {
          setState(() {
            filterSearchHistory = filterSearchTerms(filter: query);
          });
        },
        onSubmitted: (query) {
          setState(() {
            addSearch(searchTerm: query);
            searchTerm.text = query;
          });
        },
        title: Text(
          searchTerm.text.isNotEmpty ? searchTerm.text : 'Search App',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        transition: CircularFloatingSearchBarTransition(),
        actions: [
          FloatingSearchBarAction(
            showIfOpened: false,
            child: CircularButton(
              icon: const Icon(Icons.place),
              onPressed: () {},
            ),
          ),
          FloatingSearchBarAction.searchToClear(
            showIfClosed: false,
          ),
        ],
        controller: controller,
        builder: (BuildContext context, Animation<double> transition) {
          return FloatingSearchBarScrollNotifier(
            child: SearchResultListView(
              searchTerm: searchTerm.text,
            ),
          );
        },
      ),
    );
  }
}
