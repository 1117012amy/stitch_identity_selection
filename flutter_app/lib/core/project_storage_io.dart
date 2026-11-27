// Android / iOS / Windows / macOS / Linux 使用的本機儲存實作。
//
// 對外介面（四個靜態方法）與 project_storage_web.dart、project_storage_stub.dart
// 完全相同，由 app_theme.dart 的條件匯入依平台自動挑選，畫面程式碼不需要改。
// 資料格式沿用 Web 版的 JSON 結構，只是改存成 App 私有資料夾裡的檔案。

import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

import 'app_theme.dart';

class ProjectStorage {
  // 檔名帶 .v1，之後資料格式改版時可以另開新檔，不會誤讀舊資料。
  static const _projectsFileName = 'obscure_designer_projects.v1.json';
  static const _roleFileName = 'obscure_role.v1.json';
  static const _requirementFileName = 'obscure_customer_requirement.v1.json';

  // 寫入排隊：確保同一時間只有一個寫入在跑，避免兩次儲存搶用同一個暫存檔。
  static Future<void> _writeQueue = Future<void>.value();

  /// 取得 App 私有資料夾裡的檔案（其他 App 讀不到，解除安裝時會一併清除）。
  static Future<File> _fileFor(String name) async {
    final dir = await getApplicationSupportDirectory();
    await dir.create(recursive: true);
    return File('${dir.path}${Platform.pathSeparator}$name');
  }

  /// 讀取並解析 JSON。
  ///
  /// 檔案不存在、內容為空或損壞時一律回傳 null，不往外丟例外：
  /// main() 啟動時會呼叫載入，讀取失敗不應該讓整個 App 打不開。
  static Future<Object?> _readJson(String name) async {
    try {
      final file = await _fileFor(name);
      if (!await file.exists()) {
        return null;
      }
      final raw = await file.readAsString();
      if (raw.isEmpty) {
        return null;
      }
      return jsonDecode(raw);
    } catch (error) {
      debugPrint('ProjectStorage 讀取 $name 失敗：$error');
      return null;
    }
  }

  /// 以「先寫暫存檔、再改名覆蓋」的方式寫入。
  ///
  /// 若寫到一半 App 被關掉，損壞的只會是 .tmp，原本的正式檔案仍然完整。
  static Future<void> _writeJson(String name, Object data) {
    _writeQueue = _writeQueue.then((_) async {
      try {
        final file = await _fileFor(name);
        final tmp = File('${file.path}.tmp');
        await tmp.writeAsString(jsonEncode(data), flush: true);
        await tmp.rename(file.path);
      } catch (error) {
        // 呼叫端多半沒有 await（例如 AppTheme.saveDesignerProject），
        // 這裡必須自己接住，否則會變成未處理的非同步錯誤。
        debugPrint('ProjectStorage 寫入 $name 失敗：$error');
      }
    });
    return _writeQueue;
  }

  static Future<List<DesignerSavedProject>> loadDesignerProjects() async {
    final decoded = await _readJson(_projectsFileName);
    if (decoded is! List) {
      return const [];
    }
    try {
      return decoded
          .whereType<Map<String, dynamic>>()
          .map(DesignerSavedProject.fromJson)
          .toList();
    } catch (error) {
      // 檔案是合法 JSON 但欄位型別不對時（例如手動改壞），當作沒有資料。
      debugPrint('ProjectStorage 解析作品清單失敗：$error');
      return const [];
    }
  }

  static Future<void> saveDesignerProjects(
    List<DesignerSavedProject> projects,
  ) {
    // 先同步轉成 JSON 結構，避免排隊等待期間清單又被改動。
    final data = projects.map((project) => project.toJson()).toList();
    return _writeJson(_projectsFileName, data);
  }

  static Future<Map<String, String>> loadRoleState() async {
    final decoded = await _readJson(_roleFileName);
    final state = <String, String>{};
    if (decoded is Map) {
      // 只取字串值，與 Web 版回傳的格式一致：role、designerNickname。
      final role = decoded['role'];
      final nickname = decoded['designerNickname'];
      if (role is String) {
        state['role'] = role;
      }
      if (nickname is String) {
        state['designerNickname'] = nickname;
      }
    }
    return state;
  }

  static Future<void> saveRoleState({
    required bool isDesigner,
    required String designerNickname,
  }) {
    return _writeJson(_roleFileName, {
      'role': isDesigner ? 'designer' : 'customer',
      'designerNickname': designerNickname,
    });
  }

  static Future<Map<String, dynamic>?> loadCustomerRequirement() async {
    final decoded = await _readJson(_requirementFileName);
    return decoded is Map<String, dynamic> ? decoded : null;
  }

  static Future<void> saveCustomerRequirement(
    Map<String, dynamic> requirement,
  ) {
    return _writeJson(_requirementFileName, requirement);
  }
}
