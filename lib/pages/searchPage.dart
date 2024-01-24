import 'package:flutter/cupertino.dart';
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
      setState(() {
        searchHistory.remove(searchTerm);
        searchHistory.add(searchTerm);
      });

      return;
    }
    setState(() {
      searchHistory.add(searchTerm);
      if (searchHistory.length > historyMax) {
        searchHistory.removeRange(0, searchHistory.length - historyMax);
      }

      filterSearchHistory = filterSearchTerms(filter: '');
    });
  }

  void removeSearch({required String searchTerm}) {
    setState(() {
      searchHistory.removeWhere((term) => term == searchTerm);
      filterSearchHistory = filterSearchTerms(filter: '');
    });
  }

  void putTermFirst(String searchTerm) {
    setState(() {
      removeSearch(searchTerm: searchTerm);
      addSearch(searchTerm: searchTerm);
    });
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
        // body
        body: FloatingSearchBarScrollNotifier(
          child: SearchResultListView(
            searchTerm: searchTerm.text,
          ),
        ),
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
          controller.close();
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

        // the suggestion box
        builder: (BuildContext context, Animation<double> transition) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Material(
              color: Colors.white,
              elevation: 4,
              child: Builder(
                builder: (context) {
                  if (filterSearchHistory.isEmpty && controller.query.isEmpty) {
                    return const SizedBox(
                      height: 56,
                      width: double.infinity,
                      child: Center(
                        child: Text(
                          'Start searching...',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                    );
                  } else if (filterSearchHistory.isEmpty) {
                    return ListTile(
                      onTap: () {
                        addSearch(searchTerm: controller.query);
                        setState(() {
                          searchTerm.text = controller.query;
                        });
                        controller.close();
                      },
                      leading: const Icon(
                        CupertinoIcons.search,
                        size: 18,
                      ),
                      title: Text(controller.query),
                    );
                  }

                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: filterSearchHistory
                        .map(
                          (history) => ListTile(
                            onTap: () {
                              setState(() {
                                searchTerm.text = history;
                              });
                              putTermFirst(history);
                              controller.close();
                            },
                            leading: const Icon(
                              CupertinoIcons.clock,
                              size: 18,
                            ),
                            title: Text(history),
                            trailing: GestureDetector(
                              onTap: () => removeSearch(searchTerm: history),
                              child: const Icon(
                                CupertinoIcons.multiply,
                                size: 14,
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
