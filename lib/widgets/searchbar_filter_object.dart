import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:peony/widgets/searchbar.dart';
import 'package:peony/widgets/searchbar_overlay.dart';
import 'searchbar_base_model.dart';
import 'searchbar_filter_predicate.dart';

abstract class SearchbarFilterObject extends SearchbarFilter {
  const SearchbarFilterObject({required this.keyword, required this.predicate});

  final SearchbarFilterPredicate predicate;

  Future<List<SearchbarResultful>> getAsyncResultOptions(
    String filterWord,
    CancelToken cancelToken,
  );

  @override
  final String keyword;

  List<SearchbarResultful> get resultOptions;

  @override
  String get displayKeyword => '${predicate.keyword}:$keyword:';

  String asyncValueDesc(BuildContext context);

  @override
  Widget searchbarItemBuilder(
    BuildContext context,
    int index,
    bool isSelected,
  ) {
    return SuggestionListTile(
      selected: isSelected,
      displayKeyword: displayKeyword,
      onTap: () {
        onSearchbarSelected(index);
      },
    );
  }

  @override
  void onSelected() {
    Searchbar.controller!.updateText(displayKeyword);
  }
}
