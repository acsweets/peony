// import 'dart:convert';
//
// import 'package:http/http.dart' as http;
//
// Future<void> fetchMarkdownFile() async {
//   String url = "https://api.github.com/repos/acsweets/books/contents/README.md";
//
//   try {
//     var response = await http.get(Uri.parse(url));
//
//     if (response.statusCode == 200) {
//       var jsonResponse = jsonDecode(response.body);
//       String encodedContent = jsonResponse['content']; // 获取 Base64 编码内容
//       String decodedContent =
//           utf8.decode(base64.decode(encodedContent.replaceAll('\n', ''))); // 解码
//
//       print("📄 解码后的 Markdown 内容:\n$decodedContent");
//     } else {
//       print("❌ 请求失败: ${response.statusCode} - ${response.body}");
//     }
//   } catch (e) {
//     print("⚠️ 请求异常: $e");
//   }
// }
//
// void main() async {
//   await fetchMarkdownFile();
// }

import 'dart:convert';
import 'package:http/http.dart' as http;
///# 仓库信息
// owner = "your-username"  # 替换为你的 GitHub 用户名
// repo = "your-repo"  # 替换为你的仓库名
// file_path = "docs/example.md"  # 替换为你的 Markdown 文件路径
//
// # API 请求 URL
// url = f"https://api.github.com/repos/{owner}/{repo}/contents/{file_path}"
///将github 白嫖到底
Future<List<Map<String, String>>> fetchMarkdownFiles() async {
  //acsweets/peony/tree/main/assets/data
  ///      "https://api.github.com/repos/acsweets/books/contents/tips";
  String folderUrl =
      "https://api.github.com/repos/acsweets/peony/contents/assets/data";
  List<Map<String, String>> markdownFiles = [];

  try {
    var response = await http.get(Uri.parse(folderUrl));

    if (response.statusCode == 200) {
      List<dynamic> files = jsonDecode(response.body);

      for (var file in files) {
        if (file['name'].endsWith('.MD')) {
          String fileUrl = file['url'];
          String content = await fetchMarkdownContent(fileUrl);
          markdownFiles.add({
            "name": file['name'],
            "content": content,
          });
        }
      }
    } else {
      print("❌ 请求失败: ${response.statusCode} - ${response.body}");
    }
  } catch (e) {
    print("⚠️ 请求异常: $e");
  }

  return markdownFiles;
}

Future<String> fetchMarkdownContent(String fileUrl) async {
  try {
    var response = await http.get(Uri.parse(fileUrl));

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      String encodedContent = jsonResponse['content'];
      return utf8.decode(base64.decode(encodedContent.replaceAll('\n', '')));
    } else {
      print("❌ 文件请求失败: ${response.statusCode} - ${response.body}");
    }
  } catch (e) {
    print("⚠️ 文件请求异常: $e");
  }

  return "";
}

void main() async {
  List<Map<String, String>> markdownFiles = await fetchMarkdownFiles();
  print(markdownFiles);
  for (var file in markdownFiles) {
    print("📄 文件名: ${file['name']}");
    print("📝 内容:\n${file['content']}");
    print("\n============================\n");
  }
}
