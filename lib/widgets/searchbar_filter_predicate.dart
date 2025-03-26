import 'package:flutter/widgets.dart';
import 'package:peony/widgets/searchbar.dart';
import 'package:peony/widgets/searchbar_overlay.dart';
import 'searchbar_base_model.dart';
import 'searchbar_filter_object.dart';

class IsSomethingPredicate extends SearchbarFilterPredicate {
  const IsSomethingPredicate({this.objectSuggestion = const []})
      : super(keyword: 'is', example: 'order');

  @override
  final List<SearchbarFilterObject> objectSuggestion;

  @override
  String desc(BuildContext context) => '对象类型';
}

class Last4Predicate extends SearchbarFilterPredicate {
  const Last4Predicate({this.objectSuggestion = const []})
      : super(keyword: 'last4', example: '2023');

  @override
  final List<SearchbarFilterObject> objectSuggestion;

  @override
  String desc(BuildContext context) => '最后四个';
}

class StatusPredicate extends SearchbarFilterPredicate {
  const StatusPredicate({this.objectSuggestion = const []})
      : super(keyword: 'status', example: 'disable');

  @override
  final List<SearchbarFilterObject> objectSuggestion;

  @override
  String desc(BuildContext context) => '相同的对象状态';
}

///谓词
abstract class SearchbarFilterPredicate extends SearchbarFilter {
  const SearchbarFilterPredicate({
    required this.keyword,
    required this.example,
  });

  @override
  final String keyword;
  final String example;

  List<SearchbarFilterObject> get objectSuggestion;

  @override
  String get displayKeyword => '$keyword:';

  String desc(BuildContext context);

  @override
  Widget searchbarItemBuilder(
    BuildContext context,
    int index,
    bool isSelected,
  ) {
    return SuggestionListTile(
      selected: isSelected,
      displayKeyword: displayKeyword,
      title: desc(context),
      trailing: '$keyword:$example',
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
