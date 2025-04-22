// import 'dart:convert';
// import 'dart:developer';
//
// import 'package:flutter/material.dart';
//
// class Parser {
//   ///  树结构
//   ///  不同类型的字段颜色
//   ///  解析
//   ///
// }
//
// ///  key
// ///  int
// ///  string
// ///  null
// /// 数组
// /// 对象
//
// class FieldColor {
//   static const keyColor = Color(0xFF7F8C8D); // 灰色 (键)
//   static const intColor = Color(0xFFD35400); // 深橙色 (整数)
//   static const stringColor = Color(0xFF27AE60); // 绿色 (字符串)
//   static const nullColor = Color(0xFF95A5A6); // 浅灰色 (null)
//   static const arrayColor = Color(0xFF2980B9); // 蓝色 (数组)
//   static const objectColor = Color(0xFF8E44AD); // 紫色 (对象)
// }
//
// // key 对应的是不同的东西
//
// abstract class BaseValue<T> {
//   BaseValue(this.value, {this.keyValue});
//
//   final KeyValue? keyValue;
//   final T value;
//
//   ///构建对应的界面
//   Widget buildValue();
// }
//
// class KeyValue extends BaseValue {
//   KeyValue(super.value);
//
//   @override
//   Widget buildValue() {
//     return Text(
//       "$value",
//       style: const TextStyle(color: FieldColor.keyColor),
//     );
//   }
// }
//
// class IntValue extends BaseValue {
//   IntValue(super.value);
//
//   @override
//   Widget buildValue() {
//     // TODO: implement buildValue
//     throw UnimplementedError();
//   }
// }
//
// class StringValue extends BaseValue {
//   StringValue(super.value);
//
//   @override
//   Widget buildValue() {
//     // TODO: implement buildValue
//     throw UnimplementedError();
//   }
// }
//
// class NullValue extends BaseValue {
//   NullValue(super.value);
//
//   @override
//   Widget buildValue() {
//     // TODO: implement buildValue
//     throw UnimplementedError();
//   }
// }
//
// class ArrayValue extends BaseValue {
//   ArrayValue(super.value);
//
//   @override
//   Widget buildValue() {
//     // TODO: implement buildValue
//     throw UnimplementedError();
//   }
// }
//
// class AbjectValue extends BaseValue {
//   AbjectValue(super.value);
//
//   @override
//   Widget buildValue() {
//     return ObjectBlock(baseValue: value);
//   }
// }
//
// /// 怎么把 key和值组合起来组合
//
// class ObjectBlock extends StatelessWidget {
//   final BaseValue baseValue;
//
//   const ObjectBlock({super.key, required this.baseValue});
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Text('{'),
//         baseValue.buildValue(),
//         Text('}'),
//       ],
//     );
//   }
// }
//
// class KeyBlock extends StatelessWidget {
//   final BaseValue baseValue;
//
//   const KeyBlock({super.key, required this.baseValue});
//
//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: [
//         baseValue.keyValue!.buildValue(),
//         const Text(':'),
//         baseValue.buildValue(),
//       ],
//     );
//   }
// }
//
// ///拿到String类型的json 做错误处理后解析成 map
// /// TODO 更高级的错误提示
//
// class ParserJson {
//   final String rawData;
//
//   ParserJson(this.rawData) {
//     analysis();
//   }
//
//   Map<String, dynamic> _data = {};
//
//   Map<String, dynamic> get data => _data;
//
//   void analysis() {
//     try {
//       _data = jsonDecode(rawData);
//     } catch (e) {
//       log('解析失败');
//     }
//   }
//
//   BaseValue handleData() {
//     if (_data.isNotEmpty) {
//       for (var entry in _data.entries) {
//         if (entry.value is int) {
//           return IntValue(entry.value);
//         }
//       }
//     }
//     return NullValue(null);
//   }
// }
//
// class JsonAnalysisTool extends StatefulWidget {
//   const JsonAnalysisTool({super.key});
//
//   @override
//   State<JsonAnalysisTool> createState() => _JsonAnalysisToolState();
// }
//
// class _JsonAnalysisToolState extends State<JsonAnalysisTool> {
//   final TextEditingController _editingController = TextEditingController();
//   String _dataText = '';
//
//   @override
//   void initState() {
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('JSON 解析'),
//         centerTitle: true,
//       ),
//       body: Container(
//         color: Theme.of(context).cardColor,
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(20),
//         ),
//         child: Row(
//           children: [
//             Expanded(
//                 child: SingleChildScrollView(
//                     child: TextField(
//               controller: _editingController,
//               onChanged: (e) {
//                 setState(() {
//                   _dataText = e;
//                 });
//               },
//             ))),
//             Expanded(
//                 child: SingleChildScrollView(
//               child: ObjectBlock(
//                 baseValue: ParserJson(_dataText).handleData(),
//               ),
//             ))
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'dart:convert';

// import 'package:flutter/material.dart';
//
// /// 不同类型字段的颜色
// class FieldColor {
//   static const keyColor = Color(0xFF0BDBEB); // 灰色 (键)
//   static const intColor = Color(0xFFD35400); // 深橙色 (整数)
//   static const stringColor = Color(0xFF27AE60); // 绿色 (字符串)
//   static const nullColor = Color(0xFF95A5A6); // 浅灰色 (null)
//   static const arrayColor = Color(0xFF2980B9); // 蓝色 (数组)
//   static const objectColor = Color(0xFF8E44AD); // 紫色 (对象)
// }
//
// /// 基础类型抽象类
// abstract class BaseValue<T> {
//   BaseValue(this.value, {this.key});
//
//   final String? key; // 可选的 key
//   final T value;
//
//   Widget buildValue();
// }
//
// /// 键值
// class KeyValue extends StatelessWidget {
//   final String keyText;
//
//   const KeyValue(this.keyText, {super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Text(
//       keyText,
//       style: const TextStyle(color: FieldColor.keyColor, fontWeight: FontWeight.bold),
//     );
//   }
// }
//
// /// 整数值
// class IntValue extends BaseValue<int> {
//   IntValue(super.value, {super.key});
//
//   @override
//   Widget buildValue() {
//     return Text(
//       value.toString(),
//       style: const TextStyle(color: FieldColor.intColor),
//     );
//   }
// }
//
// /// 字符串值
// class StringValue extends BaseValue<String> {
//   StringValue(super.value, {super.key});
//
//   @override
//   Widget buildValue() {
//     return Text(
//       '"$value"',
//       style: const TextStyle(color: FieldColor.stringColor),
//     );
//   }
// }
//
// /// 空值
// class NullValue extends BaseValue<Null> {
//   NullValue({super.key}) : super(null);
//
//   @override
//   Widget buildValue() {
//     return const Text(
//       'null',
//       style: TextStyle(color: FieldColor.nullColor),
//     );
//   }
// }
//
// /// 数组值
// class ArrayValue extends BaseValue<List<dynamic>> {
//   ArrayValue(super.value, {super.key});
//
//   @override
//   Widget buildValue() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Text('[', style: TextStyle(color: FieldColor.arrayColor)),
//         ...value.map((item) => Row(
//           children: [
//             const SizedBox(width: 10),
//             Expanded(child: parseJson(item).buildValue()),
//           ],
//         )),
//         const Text(']', style: TextStyle(color: FieldColor.arrayColor)),
//       ],
//     );
//   }
// }
//
// /// 对象值
// class ObjectValue extends BaseValue<Map<String, dynamic>> {
//   ObjectValue(super.value, {super.key});
//
//   @override
//   Widget buildValue() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Text('{', style: TextStyle(color: FieldColor.objectColor)),
//         ...value.entries.map((entry) => KeyBlock(
//           keyText: entry.key,
//           value: parseJson(entry.value),
//         )),
//         const Text('}', style: TextStyle(color: FieldColor.objectColor)),
//       ],
//     );
//   }
// }
//
// /// 键值对组件
// class KeyBlock extends StatelessWidget {
//   final String keyText;
//   final BaseValue value;
//
//   const KeyBlock({super.key, required this.keyText, required this.value});
//
//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         KeyValue(keyText),
//         const Text(': '),
//         Expanded(child: value.buildValue()),
//       ],
//     );
//   }
// }
//
// /// 解析 JSON 数据
// BaseValue parseJson(dynamic json, {String? key}) {
//   if (json == null) {
//     return NullValue(key: key);
//   } else if (json is int) {
//     return IntValue(json, key: key);
//   } else if (json is String) {
//     return StringValue(json, key: key);
//   } else if (json is List) {
//     return ArrayValue(json, key: key);
//   } else if (json is Map<String, dynamic>) {
//     return ObjectValue(json, key: key);
//   } else {
//     return StringValue(json.toString(), key: key);
//   }
// }
//
// /// JSON 解析类
// class ParserJson {
//   final String rawData;
//
//   ParserJson(this.rawData);
//
//   BaseValue? _data;
//
//   BaseValue? get data => _data;
//
//   void analysis() {
//     try {
//       final parsed = jsonDecode(rawData);
//       _data = parseJson(parsed);
//     } catch (e) {
//       log('解析失败: $e');
//       _data = null;
//     }
//   }
// }
//
// /// JSON 解析工具 UI
// class JsonAnalysisTool extends StatefulWidget {
//   const JsonAnalysisTool({super.key});
//
//   @override
//   State<JsonAnalysisTool> createState() => _JsonAnalysisToolState();
// }
//
// class _JsonAnalysisToolState extends State<JsonAnalysisTool> {
//   final TextEditingController _editingController = TextEditingController();
//   BaseValue? _parsedData;
//   String? _errorMessage;
//
//   void _parseJson() {
//     setState(() {
//       _errorMessage = null;
//       try {
//         final parser = ParserJson(_editingController.text);
//         parser.analysis();
//         _parsedData = parser.data;
//       } catch (e) {
//         _errorMessage = 'JSON 解析失败: $e';
//         _parsedData = null;
//       }
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('JSON 解析工具'),
//         centerTitle: true,
//       ),
//       body: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: TextField(
//               controller: _editingController,
//               maxLines: 6,
//               decoration: InputDecoration(
//                 labelText: '输入 JSON',
//                 border: const OutlineInputBorder(),
//                 suffixIcon: IconButton(
//                   icon: const Icon(Icons.check),
//                   onPressed: _parseJson,
//                 ),
//               ),
//             ),
//           ),
//           Expanded(
//             child: SingleChildScrollView(
//               child: _errorMessage != null
//                   ? Text(
//                 _errorMessage!,
//                 style: const TextStyle(color: Colors.red),
//               )
//                   : _parsedData?.buildValue() ?? const Text('请输入 JSON'),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

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

  BaseValue(this.value, {this.key, this.isExpanded = false});

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
      // return Column(
      //   crossAxisAlignment: CrossAxisAlignment.start,
      //   children: [
      //     InkWell(
      //       onTap: () {
      //         setState(() {
      //           isExpanded = !isExpanded; // 触发 UI 重新渲染
      //         });
      //       },
      //       child: Row(
      //         children: [
      //           Icon(isExpanded ? Icons.arrow_drop_down : Icons.arrow_right,
      //               color: FieldColor.arrayColor),
      //           const Text('[Array]',
      //               style: TextStyle(color: FieldColor.arrayColor)),
      //         ],
      //       ),
      //     ),
      //     if (isExpanded)
      //       Padding(
      //         padding: const EdgeInsets.only(left: 16),
      //         child: Column(
      //           crossAxisAlignment: CrossAxisAlignment.start,
      //           children: value.map((e) => parseJson(e).buildValue()).toList(),
      //         ),
      //       ),
      //   ],
      // );
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
                Icon(
                  isExpanded ? Icons.arrow_drop_down : Icons.arrow_right,
                ),
                const Text('(Array） [', style: TextStyle(color: Colors.blue)),
              ],
            ),
          ),
          if (isExpanded)
            Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: value.map((e) => parseJson(e).buildValue()).toList(),
              ),
            ),
          const Text(']', style: TextStyle(color: Colors.blue)),
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
                  const Text('{Object}',
                      style: TextStyle(color: FieldColor.objectColor)),
                ],
              ),
            ),
            if (isExpanded)
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
              decoration: InputDecoration(
                labelText: '输入 JSON',
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.check),
                  onPressed: _parseJson,
                ),
              ),
            ),
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

///================================================

class ObjectBlock extends StatefulWidget {
  final Map<String, dynamic> data;

  const ObjectBlock({super.key, required this.data});

  @override
  State<ObjectBlock> createState() => _ObjectBlockState();
}

class _ObjectBlockState extends State<ObjectBlock> {
  bool isExpanded = true; // 记录展开/收起状态

  @override
  Widget build(BuildContext context) {
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
              Icon(isExpanded ? Icons.expand_less : Icons.expand_more),
              const Text('Object {', style: TextStyle(color: Colors.purple)),
            ],
          ),
        ),
        if (isExpanded)
          Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Column(
              children: widget.data.entries.map((entry) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('"${entry.key}": ',
                        style: const TextStyle(color: FieldColor.keyColor)),
                    JsonNode(value: entry.value), // 递归解析不同类型的值
                  ],
                );
              }).toList(),
            ),
          ),
        const Text('}'),
      ],
    );
  }
}

class ArrayBlock extends StatefulWidget {
  final List<dynamic> data;

  const ArrayBlock({super.key, required this.data});

  @override
  State<ArrayBlock> createState() => _ArrayBlockState();
}

class _ArrayBlockState extends State<ArrayBlock> {
  bool isExpanded = true;

  @override
  Widget build(BuildContext context) {
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
              Icon(isExpanded ? Icons.expand_less : Icons.expand_more),
              const Text('Array [', style: TextStyle(color: Colors.blue)),
            ],
          ),
        ),
        if (isExpanded)
          Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Column(
              children: widget.data.asMap().entries.map((entry) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('[${entry.key}]: ',
                        style: const TextStyle(color: Colors.grey)),
                    JsonNode(value: entry.value), // 递归解析值
                  ],
                );
              }).toList(),
            ),
          ),
        const Text(']'),
      ],
    );
  }
}

class JsonNode extends StatelessWidget {
  final dynamic value;

  const JsonNode({super.key, required this.value});

  @override
  Widget build(BuildContext context) {
    if (value is int) {
      return Text('$value', style: const TextStyle(color: FieldColor.intColor));
    } else if (value is String) {
      return Text('"$value"',
          style: const TextStyle(color: FieldColor.stringColor));
    } else if (value is Map<String, dynamic>) {
      return ObjectBlock(data: value);
    } else if (value is List<dynamic>) {
      return ArrayBlock(data: value);
    } else if (value == null) {
      return const Text('null', style: TextStyle(color: FieldColor.nullColor));
    } else {
      return Text(value.toString(),
          style: const TextStyle(color: Colors.black));
    }
  }
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: const JsonViewerScreen(),
    );
  }
}

class JsonViewerScreen extends StatelessWidget {
  const JsonViewerScreen({super.key});

  final Map<String, dynamic> jsonData = const {
    "name": "Alice",
    "age": 25,
    "skills": ["Flutter", "Dart", "Firebase"],
    "address": {"city": "New York", "zip": "10001"},
    "active": true,
    "projects": [
      {"title": "Project A", "completed": true},
      {"title": "Project B", "completed": false}
    ]
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("JSON Viewer")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: JsonNode(value: jsonData),
      ),
    );
  }
}
