import 'dart:math';

import 'package:collection/collection.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:peony/widgets/searchbar_base_model.dart';
import 'debounce_notifier.dart';
import 'enabledable_callback_action.dart';
import 'searchbar.dart';

class MPSearchbarOverlay extends StatefulWidget {
  const MPSearchbarOverlay({
    super.key,
    required this.barState,
  });

  final SearchbarState barState;

  @override
  State<MPSearchbarOverlay> createState() => MPSearchbarOverlayState();
}

class MPSearchbarOverlayState extends State<MPSearchbarOverlay> {
  static HighlightIndexWithTotal? highlightedOptionIndex;

  late final _previousOptionAction =
      EnabledableCallbackAction<AutocompletePreviousOptionIntent>(
    onInvoke: _highlightPreviousOption,
  );
  late final _nextOptionAction =
      EnabledableCallbackAction<AutocompleteNextOptionIntent>(
    onInvoke: _highlightNextOption,
  );

  @override
  void initState() {
    super.initState();
    widget.barState.actionMap.addAll({
      AutocompletePreviousOptionIntent: _previousOptionAction,
      AutocompleteNextOptionIntent: _nextOptionAction,
    });
    highlightedOptionIndex = HighlightIndexWithTotal(
      0,
      total: widget.barState.widget.predicateList.length,
    );
  }

  @override
  void dispose() {
    widget.barState.actionMap.remove(AutocompletePreviousOptionIntent);
    widget.barState.actionMap.remove(AutocompleteNextOptionIntent);
    highlightedOptionIndex?.dispose();
    highlightedOptionIndex = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AutocompleteHighlightedOption(
      highlightIndexNotifier: highlightedOptionIndex!,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: AnimatedSize(
              duration: const Duration(milliseconds: 133),
              alignment: Alignment.topLeft,
              child: _SearchbarStateCore(barState: widget.barState),
            ),
          ),
          const _SearchbarTipsLabel(),
        ],
      ),
    );
  }

  void _highlightPreviousOption(AutocompletePreviousOptionIntent intent) {
    highlightedOptionIndex?.value -= 1;
  }

  void _highlightNextOption(AutocompleteNextOptionIntent intent) {
    highlightedOptionIndex?.value += 1;
  }
}

class _SearchbarStateCore extends StatefulWidget {
  const _SearchbarStateCore({required this.barState});

  final SearchbarState barState;

  @override
  State<_SearchbarStateCore> createState() => _SearchbarStateCoreState();
}

class _SearchbarStateCoreState extends State<_SearchbarStateCore> {
  late final DebounceTextController _textController;

  late SearchbarOverlayState __searchbarState = PredicateSuggestion(
    suggestions: widget.barState.widget.predicateList,
  );
  SearchbarOverlayState get _searchbarState => __searchbarState;
  set _searchbarState(SearchbarOverlayState value) {
    if (__searchbarState.equals(value)) return;
    if (mounted) {
      setState(() {
        MPSearchbarOverlayState.highlightedOptionIndex?.value = 0;
        __searchbarState = value;
        MPSearchbarOverlayState.highlightedOptionIndex?.total =
            value.highlightTotal;
      });
    }
  }

  late final _confirmHighlightOptionAction =
      EnabledableCallbackAction<ConfirmHighlightOptionIntent>(
    onInvoke: _confirmHighlight,
  );

  void _confirmHighlight(ConfirmHighlightOptionIntent intent) {
    final highlightedOptionIndex =
        MPSearchbarOverlayState.highlightedOptionIndex;
    if (highlightedOptionIndex == null) return;

    if (highlightedOptionIndex.total < 1) return;

    final index = highlightedOptionIndex.value;
    final tempTotal = _searchbarState.highlightTotal;

    if (index < tempTotal) {
      _searchbarState.onSelected(index).onSelected();
    } else {
      SearchResultViewState.data?.value?[index - tempTotal].onSelected();
    }
  }

  @override
  void initState() {
    super.initState();
    _textController = Searchbar.controller!;
    _textController.debounceCallback = _update;
    widget.barState.actionMap[ConfirmHighlightOptionIntent] =
        _confirmHighlightOptionAction;
  }

  void _update() {
    final text = _textController.text;
    if (text.isEmpty) {
      _searchbarState = PredicateSuggestion(
        suggestions: widget.barState.widget.predicateList,
      );
    } else {
      final textSplit = text.split(':');

      final temp = widget.barState.widget.predicateList
          .where((e) => e.keyword.startsWith(textSplit.first))
          .toList();

      switch (textSplit.length) {
        case < 2:
          _searchbarState = PredicateSuggestion(suggestions: temp);
        case == 2:
          final objectText = textSplit[1];
          final currentPredicate =
              temp.singleWhereOrNull((e) => e.keyword == textSplit.first);
          if (currentPredicate == null) {
            _searchbarState = const PredicateSuggestion.empty();
          } else {
            if (objectText.isEmpty) {
              _searchbarState =
                  ObjectSuggestion.fromPredicate(currentPredicate);
            } else {
              _searchbarState = ObjectSuggestion(
                predicate: currentPredicate,
                suggestions: currentPredicate.objectSuggestion
                    .where((e) => e.keyword.startsWith(objectText))
                    .toList(),
              );
            }
          }
        case > 2:
          final currentPredicate = temp.singleWhereOrNull(
            (e) => e.keyword == textSplit.first,
          );
          if (currentPredicate == null) {
            _searchbarState = const PredicateSuggestion.empty();
            break;
          }
          final currentObject = currentPredicate.objectSuggestion
              .singleWhereOrNull((e) => e.keyword == textSplit[1]);
          if (currentObject == null) {
            _searchbarState = const PredicateSuggestion.empty();
            break;
          }
          _searchbarState = ResultSeggestion(
            object: currentObject,
            filterWords: textSplit.sublist(2).join(':'),
          );
      }
    }
  }

  @override
  void dispose() {
    _textController.debounceCallback = null;
    widget.barState.actionMap.remove(ConfirmHighlightOptionIntent);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final title = switch (_searchbarState) {
      final PredicateSuggestion _ => 'SUGGESTED FILTERS',
      final ObjectSuggestion _ => 'SUGGESTED FILTERS',
      final ResultSeggestion _ => 'SUGGESTED OPERATION',
    };

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 188),
            switchInCurve: Curves.easeOut,
            switchOutCurve: Curves.easeIn,
            layoutBuilder: _animatedSwitcherCenterLeftLayoutBuilder,
            child: Text(
              title,
              key: ValueKey(title),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ),
        const SizedBox(height: 8),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 188),
          switchInCurve: Curves.easeOut,
          switchOutCurve: Curves.easeIn,
          layoutBuilder: animatedSwitcherTopLayoutBuilder,
          child: switch (_searchbarState) {
            final PredicateSuggestion e => _HighlightListView(
                key: ValueKey(e),
                itemLenght: e.suggestions.length,
                itemBuilder: (context, listIndex) {
                  final item = e.suggestions[listIndex];

                  return item.searchbarItemBuilder(
                    context,
                    listIndex,
                    AutocompleteHighlightedOption.of(context) == listIndex,
                  );
                },
              ),
            final ObjectSuggestion e => _HighlightListView(
                key: ValueKey(e),
                itemLenght: e.suggestions.length,
                itemBuilder: (context, listIndex) {
                  final item = e.suggestions[listIndex];

                  return item.searchbarItemBuilder(
                    context,
                    listIndex,
                    AutocompleteHighlightedOption.of(context) == listIndex,
                  );
                },
              ),
            final ResultSeggestion e => SearchResultView(
                key: ValueKey(e.object.keyword),
                barState: widget.barState,
                resultSeggestion: e,
              ),
          },
        ),
      ],
    );
  }
}

class SearchResultView extends StatefulWidget {
  const SearchResultView({
    super.key,
    required this.barState,
    required this.resultSeggestion,
  });

  final SearchbarState barState;
  final ResultSeggestion resultSeggestion;

  @override
  State<SearchResultView> createState() => SearchResultViewState();
}

class SearchResultViewState extends State<SearchResultView> {
  CancelToken _cancelToken = CancelToken();
  static ValueNotifier<List<SearchbarResultful>?>? data;

  @override
  void initState() {
    super.initState();

    data = ValueNotifier(null);

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      widget.barState.isLoading.value = true;
    });
    _updateData();
  }

  @override
  void didUpdateWidget(SearchResultView oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.resultSeggestion.filterWords !=
        oldWidget.resultSeggestion.filterWords) {
      data?.value = null;

      _cancelToken.cancel();
      _cancelToken = CancelToken();
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        widget.barState.isLoading.value = true;
      });
      _updateData();
    }
  }

  void _updateData() {
    _getResults().then(
      (value) {
        widget.barState.isLoading.value = false;
        data?.value = value;
        MPSearchbarOverlayState.highlightedOptionIndex?.total += value.length;
      },
    );
  }

  Future<List<SearchbarResultful>> _getResults() async {
    try {
      return await widget.resultSeggestion.object.getAsyncResultOptions(
        widget.resultSeggestion.filterWords,
        _cancelToken,
      );
    } catch (e) {
      return [];
    }
  }

  @override
  void dispose() {
    _cancelToken.cancel();
    data?.dispose();
    data = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final options = widget.resultSeggestion.object.resultOptions;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (options.isNotEmpty) ...[
          ...widget.resultSeggestion.object.resultOptions.mapIndexed(
            (index, e) => Builder(
              builder: (context) => e.searchbarItemBuilder(
                context,
                index,
                AutocompleteHighlightedOption.of(context) == index,
              ),
            ),
          ),
          const Divider(height: 16),
        ],
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6),
          child: Text(
            widget.resultSeggestion.object.asyncValueDesc(context),
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 8),
        ValueListenableBuilder(
          valueListenable: data!,
          builder: (context, value, child) {
            return AnimatedSwitcher(
              duration: const Duration(milliseconds: 333),
              switchInCurve: Curves.easeOut,
              switchOutCurve: Curves.easeIn,
              child: value == null
                  ? null
                  : Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ...value.mapIndexed(
                          (index, e) => Builder(
                            builder: (context) {
                              final fixedIndex = index + options.length;
                              return e.searchbarItemBuilder(
                                context,
                                fixedIndex,
                                AutocompleteHighlightedOption.of(context) ==
                                    fixedIndex,
                              );
                            },
                          ),
                        ),
                      ],
                    ),
            );
          },
        ),
      ],
    );
  }
}

class _HighlightListView extends StatelessWidget {
  const _HighlightListView({
    super.key,
    required this.itemLenght,
    required this.itemBuilder,
  });

  final int itemLenght;
  final Widget Function(BuildContext context, int listIndex) itemBuilder;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var i = 0; i < itemLenght; i++)
          Builder(
            builder: (context) {
              return itemBuilder(context, i);
            },
          ),
      ],
    );
  }
}

class SuggestionListTile extends StatelessWidget {
  const SuggestionListTile({
    super.key,
    this.onTap,
    required this.selected,
    this.trailing,
    this.title,
    required this.displayKeyword,
  });

  final bool selected;
  final VoidCallback? onTap;
  final String? trailing;
  final String? title;
  final String displayKeyword;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: _FilterLabel(value: displayKeyword),
      trailing: trailing == null
          ? null
          : Text(
              trailing!,
              style: const TextStyle(fontSize: 14),
            ),
      splashColor: Colors.transparent,
      selected: selected,
      title: title == null ? null : Text(title!),
    );
  }
}

class _FilterLabel extends StatelessWidget {
  const _FilterLabel({required this.value});

  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFFEBEEF1),
        borderRadius: BorderRadius.all(Radius.circular(4)),
      ),
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 6),
      child: Text(
        value,
        style: const TextStyle(
          fontSize: 12,
          color: Color(0xFF808490),
          height: 1,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class _SearchbarTipsLabel extends StatelessWidget {
  const _SearchbarTipsLabel();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 32,
      child: ColoredBox(
        color: const Color(0xFFF6F8FA),
        child: Align(
          alignment: Alignment.centerLeft,
          child: TextButton.icon(
            style: ButtonStyle(
              padding: const WidgetStatePropertyAll(
                EdgeInsets.symmetric(horizontal: 16),
              ),
              foregroundColor: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.hovered)) {
                  return const Color(0xFF414552);
                }
                return const Color(0xFF87909F);
              }),
              backgroundColor: const WidgetStatePropertyAll(Colors.transparent),
              visualDensity: const VisualDensity(
                horizontal: -4.0,
                vertical: -4.0,
              ),
              overlayColor: const WidgetStatePropertyAll(Colors.transparent),
            ),
            onPressed: () {},
            icon: const Icon(Icons.help, size: 18),
            label: const Text(
              'Search Tips',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                height: 1,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class HighlightIndexWithTotal extends ValueNotifier<int> {
  HighlightIndexWithTotal(super.value, {this.total = 1});

  int total;

  @override
  set value(int newValue) {
    super.value = newValue % max(1, total);
  }
}

Widget _animatedSwitcherCenterLeftLayoutBuilder(
  Widget? currentChild,
  List<Widget> previousChildren,
) {
  return Stack(
    alignment: Alignment.centerLeft,
    children: <Widget>[
      ...previousChildren,
      if (currentChild != null) currentChild,
    ],
  );
}

///为了解决[AnimatedSwitcher.defaultLayoutBuilder]默认左上角对齐的问题
Widget animatedSwitcherTopLayoutBuilder(
    Widget? currentChild,
    List<Widget> previousChildren,
    ) {
  return Stack(
    alignment: Alignment.topCenter,
    children: <Widget>[
      ...previousChildren,
      if (currentChild != null) currentChild,
    ],
  );
}
