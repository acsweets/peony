import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:peony/widgets/searchbar_filter_object.dart';
import 'package:peony/widgets/searchbar_filter_predicate.dart';
import 'package:peony/widgets/searchbar_overlay.dart';

mixin SearchbarResultful {
  Widget searchbarItemBuilder(
    BuildContext context,
    int index,
    bool isSelected,
  );

  void onSelected();

  @nonVirtual
  void onSearchbarSelected(int index) {
    MPSearchbarOverlayState.highlightedOptionIndex?.value = index;
    onSelected();
  }
}

abstract class SearchbarFilter with SearchbarResultful {
  const SearchbarFilter();

  String get keyword;

  String get displayKeyword;
}

sealed class SearchbarOverlayState {
  const SearchbarOverlayState();

  int get highlightTotal;

  SearchbarResultful onSelected(int index);

  bool equals(SearchbarOverlayState other);
}

class ResultSeggestion extends SearchbarOverlayState {
  const ResultSeggestion({
    required this.object,
    required this.filterWords,
  });

  final SearchbarFilterObject object;
  final String filterWords;

  @override
  int get highlightTotal => object.resultOptions.length;

  @override
  SearchbarResultful onSelected(int index) => object.resultOptions[index];

  @override
  bool equals(SearchbarOverlayState other) => false;
}

class PredicateSuggestion extends SearchbarOverlayState {
  const PredicateSuggestion({required this.suggestions});

  const PredicateSuggestion.empty() : suggestions = const [];

  final List<SearchbarFilterPredicate> suggestions;

  @override
  int get highlightTotal => suggestions.length;

  @override
  SearchbarResultful onSelected(int index) => suggestions[index];

  @override
  bool equals(SearchbarOverlayState other) =>
      other is PredicateSuggestion &&
      listEquals(suggestions, other.suggestions);
}

class ObjectSuggestion extends SearchbarOverlayState {
  const ObjectSuggestion({required this.predicate, required this.suggestions});

  ObjectSuggestion.fromPredicate(this.predicate)
      : suggestions = predicate.objectSuggestion;

  final SearchbarFilterPredicate predicate;
  final List<SearchbarFilterObject> suggestions;

  @override
  int get highlightTotal => suggestions.length;

  @override
  SearchbarResultful onSelected(int index) => suggestions[index];

  @override
  bool equals(SearchbarOverlayState other) =>
      other is ObjectSuggestion &&
      predicate == other.predicate &&
      listEquals(suggestions, other.suggestions);
}

class ShowAllResult with SearchbarResultful {
  const ShowAllResult({
    required this.filterItem,
    required this.onSelectedResult,
  });

  final SearchbarFilter filterItem;
  final VoidCallback onSelectedResult;

  @override
  void onSelected() {
    onSelectedResult();
  }

  @override
  Widget searchbarItemBuilder(
    BuildContext context,
    int index,
    bool isSelected,
  ) {
    return ListTile(
      selected: isSelected,
      splashColor: Colors.transparent,
      title: Text.rich(
        TextSpan(
          text: filterItem.displayKeyword,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      onTap: () {
        onSearchbarSelected(index);
      },
    );
  }
}
