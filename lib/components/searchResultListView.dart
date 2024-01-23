import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SearchResultListView extends StatelessWidget {
  const SearchResultListView({
    super.key,
    required this.searchTerm,
  });

  final String searchTerm;

  @override
  Widget build(BuildContext context) {
    return searchTerm.isEmpty
        ? Center(
            child: Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 5,
              children: [
                const Icon(
                  CupertinoIcons.search,
                  size: 30,
                ),
                Text(
                  'Start Searching',
                  style: Theme.of(context).textTheme.headlineSmall,
                )
              ],
            ),
          )
        : SizedBox(
            height: MediaQuery.sizeOf(context).height,
            child: Padding(
              padding: EdgeInsets.only(top: MediaQuery.paddingOf(context).top),
              child: ListView(
                children: List.generate(
                  10,
                  (index) => ListTile(
                    leading: const Icon(
                      CupertinoIcons.clock,
                      size: 18,
                    ),
                    title: Text('$searchTerm $index '),
                    trailing: const Icon(
                      CupertinoIcons.chevron_right,
                      size: 14,
                    ),
                  ),
                ),
              ),
            ),
          );
  }
}
