import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SearchResultListView extends StatelessWidget {
  const SearchResultListView({super.key, required this.searchTerm});

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
        : Text(searchTerm);
  }
}
