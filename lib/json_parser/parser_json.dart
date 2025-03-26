import 'dart:convert';

import 'package:flutter/material.dart';

/// 颜色定义
class FieldColor {
  static const keyColor = Colors.grey;
  static const intColor = Colors.deepOrange;
  static const stringColor = Colors.green;
  static const nullColor = Colors.blueGrey;
  static const arrayColor = Colors.blue;
  static const objectColor = Colors.purple;
}

/// 基础类型抽象类
abstract class BaseValue<T> {
  final String? key;
  final T value;
  bool isExpanded;

  BaseValue(this.value, {this.key, this.isExpanded = true});

  Widget buildValue();
}

/// 整数值
class IntValue extends BaseValue<int> {
  IntValue(super.value, {super.key});

  @override
  Widget buildValue() {
    return Text(value.toString(),
        style: const TextStyle(color: FieldColor.intColor));
  }
}

/// 字符串值
class StringValue extends BaseValue<String> {
  StringValue(super.value, {super.key});

  @override
  Widget buildValue() {
    return Text('"$value"',
        style: const TextStyle(color: FieldColor.stringColor));
  }
}

/// Null 值
class NullValue extends BaseValue<Null> {
  NullValue({super.key}) : super(null);

  @override
  Widget buildValue() {
    return const Text('null', style: TextStyle(color: FieldColor.nullColor));
  }
}

/// 数组值
class ArrayValue extends BaseValue<List<dynamic>> {
  ArrayValue(super.value, {super.key});

  @override
  Widget buildValue() {
    return StatefulBuilder(builder: (context, setState) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () {
              setState(() {
                isExpanded = !isExpanded;
              });
            },
            child: Row(
              children: [
                Icon(isExpanded ? Icons.arrow_drop_down : Icons.arrow_right,
                    color: FieldColor.arrayColor),
                const Text('(Array)【',
                    style: TextStyle(color: FieldColor.arrayColor)),
                if (!isExpanded)
                  const Text('】',
                      style: TextStyle(color: FieldColor.arrayColor)),
              ],
            ),
          ),
          if (isExpanded) ...[
            Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: value.map((e) => parseJson(e).buildValue()).toList(),
              ),
            ),
            const Text('】', style: TextStyle(color: FieldColor.arrayColor)),
          ]
        ],
      );
    });
  }
}

/// 对象值
class ObjectValue extends BaseValue<Map<String, dynamic>> {
  ObjectValue(super.value, {super.key});

  @override
  Widget buildValue() {
    return StatefulBuilder(
      builder: (context, setState) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              onTap: () {
                setState(() {
                  isExpanded = !isExpanded; // 触发 UI 重新渲染
                });
              },
              child: Row(
                children: [
                  Icon(isExpanded ? Icons.arrow_drop_down : Icons.arrow_right,
                      color: FieldColor.objectColor),
                  const Text('(Object) {',
                      style: TextStyle(color: FieldColor.objectColor)),
                  if (!isExpanded)
                    const Text('}',
                        style: TextStyle(color: FieldColor.objectColor)),
                ],
              ),
            ),
            if (isExpanded) ...[
              Padding(
                padding: const EdgeInsets.only(left: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: value.entries
                      .map((e) =>
                          KeyBlock(keyText: e.key, value: parseJson(e.value)))
                      .toList(),
                ),
              ),
              const Text('}', style: TextStyle(color: FieldColor.objectColor)),
            ]
          ],
        );
      },
    );
  }
}

/// 键值对组件
class KeyBlock extends StatelessWidget {
  final String keyText;
  final BaseValue value;

  const KeyBlock({super.key, required this.keyText, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('$keyText: ',
            style: const TextStyle(
                color: FieldColor.keyColor, fontWeight: FontWeight.bold)),
        Expanded(child: value.buildValue()),
      ],
    );
  }
}

/// 解析 JSON 数据
BaseValue parseJson(dynamic json, {String? key}) {
  if (json == null) return NullValue(key: key);
  if (json is int) return IntValue(json, key: key);
  if (json is String) return StringValue(json, key: key);
  if (json is List) return ArrayValue(json, key: key);
  if (json is Map<String, dynamic>) return ObjectValue(json, key: key);
  return StringValue(json.toString(), key: key);
}

/// JSON 解析工具 UI
class JsonAnalysisTool extends StatefulWidget {
  const JsonAnalysisTool({super.key});

  @override
  State<JsonAnalysisTool> createState() => _JsonAnalysisToolState();
}

class _JsonAnalysisToolState extends State<JsonAnalysisTool> {
  final TextEditingController _controller = TextEditingController();
  BaseValue? _parsedData;
  String? _error;

  void _parseJson() {
    setState(() {
      _error = null;
      try {
        final parsed = jsonDecode(_controller.text);
        _parsedData = parseJson(parsed);
      } catch (e) {
        _error = 'JSON 解析失败: $e';
        _parsedData = null;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('JSON 解析工具')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _controller,
              maxLines: 6,
              decoration: const InputDecoration(
                labelText: '输入 JSON',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          TextButton(
            onPressed: _parseJson,
            child: const Text('确认',style: TextStyle(fontSize: 16),),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: _error != null
                  ? Text(_error!, style: const TextStyle(color: Colors.red))
                  : _parsedData?.buildValue() ?? const Text('请输入 JSON'),
            ),
          ),
        ],
      ),
    );
  }
}
