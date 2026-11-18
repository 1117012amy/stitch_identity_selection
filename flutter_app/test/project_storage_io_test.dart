// 儲存層（lib/core/project_storage_io.dart）的單元測試。
//
// 在 Dart VM 上執行（flutter test），不需要手機或 Visual Studio。
// path_provider 會被導向一個暫時資料夾，所以不會碰到真正的 App 資料。
//
// 注意：這裡驗證的是「儲存邏輯」，不是真實裝置上的 path_provider 外掛，
// 也不是畫面操作。這兩部分仍需要真機或 Windows 桌面版驗證。

import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:obscure_app/core/app_theme.dart';
import 'package:obscure_app/core/project_storage_io.dart';

// 與 project_storage_io.dart 內的檔名保持一致；檔名改了這裡要一起改。
const _projectsFile = 'obscure_designer_projects.v1.json';
const _roleFile = 'obscure_role.v1.json';

DesignerSavedProject _project(String title, {int seed = 1}) {
  return DesignerSavedProject(
    title: title,
    concept: '$title 的概念說明',
    tags: ['標籤A', '標籤B'],
    fieldTags: ['品牌'],
    styleTags: ['極簡'],
    imageBytes: Uint8List.fromList([seed, seed + 1, seed + 2]),
    imageBytesList: [
      Uint8List.fromList([seed, seed + 1, seed + 2]),
      Uint8List.fromList([seed + 10, seed + 11]),
    ],
    imageAspectRatio: 1.5,
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const channel = MethodChannel('plugins.flutter.io/path_provider');
  late Directory tempDir;

  File fileIn(String name) => File('${tempDir.path}/$name');

  setUp(() {
    tempDir = Directory.systemTemp.createTempSync('obscure_storage_test_');

    // 攔截 path_provider，讓「App 私有資料夾」變成這個暫時資料夾。
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (call) async {
          if (call.method == 'getApplicationSupportDirectory') {
            return tempDir.path;
          }
          return null;
        });

    // AppTheme 是 static 全域狀態，每個測試開始前先還原，避免互相影響。
    AppTheme.isDesigner = false;
    AppTheme.designerProjects.clear();
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
    if (tempDir.existsSync()) {
      tempDir.deleteSync(recursive: true);
    }
  });

  group('讀寫往返', () {
    test('作品存入後重新讀取，內容完全一致', () async {
      await ProjectStorage.saveDesignerProjects([
        _project('作品一', seed: 1),
        _project('作品二', seed: 20),
      ]);

      final loaded = await ProjectStorage.loadDesignerProjects();

      expect(loaded.length, 2);
      expect(loaded[0].title, '作品一');
      expect(loaded[0].concept, '作品一 的概念說明');
      expect(loaded[0].tags, ['標籤A', '標籤B']);
      expect(loaded[0].fieldTags, ['品牌']);
      expect(loaded[0].styleTags, ['極簡']);
      expect(loaded[0].imageAspectRatio, 1.5);
      expect(loaded[0].imageBytes, orderedEquals([1, 2, 3]));
      expect(loaded[0].imageBytesList.length, 2);
      expect(loaded[0].imageBytesList[1], orderedEquals([11, 12]));
      expect(loaded[1].title, '作品二');
      expect(loaded[1].imageBytes, orderedEquals([20, 21, 22]));
    });

    test('角色與暱稱存入後能讀回，且能切換', () async {
      await ProjectStorage.saveRoleState(
        isDesigner: true,
        designerNickname: '小明',
      );
      expect(await ProjectStorage.loadRoleState(), {
        'role': 'designer',
        'designerNickname': '小明',
      });

      await ProjectStorage.saveRoleState(
        isDesigner: false,
        designerNickname: '小明',
      );
      expect((await ProjectStorage.loadRoleState())['role'], 'customer');
    });

    test('寫入完成後不會殘留 .tmp 暫存檔', () async {
      await ProjectStorage.saveDesignerProjects([_project('作品')]);
      await ProjectStorage.saveRoleState(
        isDesigner: true,
        designerNickname: 'Mia',
      );

      final leftovers = tempDir
          .listSync()
          .whereType<File>()
          .where((f) => f.path.endsWith('.tmp'));
      expect(leftovers, isEmpty);
      expect(fileIn(_projectsFile).existsSync(), isTrue);
      expect(fileIn(_roleFile).existsSync(), isTrue);
    });
  });

  group('容錯讀取（不可崩潰，一律回傳空資料）', () {
    test('檔案不存在時回傳空', () async {
      expect(await ProjectStorage.loadDesignerProjects(), isEmpty);
      expect(await ProjectStorage.loadRoleState(), isEmpty);
    });

    test('檔案是空的時回傳空', () async {
      fileIn(_projectsFile).writeAsStringSync('');
      fileIn(_roleFile).writeAsStringSync('');
      expect(await ProjectStorage.loadDesignerProjects(), isEmpty);
      expect(await ProjectStorage.loadRoleState(), isEmpty);
    });

    test('JSON 損壞時回傳空', () async {
      fileIn(_projectsFile).writeAsStringSync('{這不是合法的 json');
      fileIn(_roleFile).writeAsStringSync('[[[');
      expect(await ProjectStorage.loadDesignerProjects(), isEmpty);
      expect(await ProjectStorage.loadRoleState(), isEmpty);
    });

    test('JSON 合法但結構或型別不對時回傳空', () async {
      // 最外層不是清單
      fileIn(_projectsFile).writeAsStringSync('{"a": 1}');
      expect(await ProjectStorage.loadDesignerProjects(), isEmpty);

      // 欄位型別錯誤（title 應該是字串）
      fileIn(_projectsFile).writeAsStringSync('[{"title": 123}]');
      expect(await ProjectStorage.loadDesignerProjects(), isEmpty);

      // role 不是字串時要被忽略
      fileIn(_roleFile).writeAsStringSync('{"role": 5, "designerNickname": 7}');
      expect(await ProjectStorage.loadRoleState(), isEmpty);
    });

    test('壞檔案之後仍能正常寫入並讀回', () async {
      fileIn(_projectsFile).writeAsStringSync('壞掉的內容');
      await ProjectStorage.saveDesignerProjects([_project('修復後')]);

      final loaded = await ProjectStorage.loadDesignerProjects();
      expect(loaded.single.title, '修復後');
    });
  });

  group('寫入排隊', () {
    test('連續快速儲存多次，最後讀到的是最新內容', () async {
      final futures = <Future<void>>[];
      for (var i = 1; i <= 5; i++) {
        // 刻意不逐一 await，模擬畫面上連續觸發儲存。
        futures.add(
          ProjectStorage.saveDesignerProjects([
            for (var j = 0; j < i; j++) _project('作品$j'),
          ]),
        );
      }
      await Future.wait(futures);

      final loaded = await ProjectStorage.loadDesignerProjects();
      expect(loaded.length, 5);
    });
  });

  group('模擬重開 App（經由 AppTheme 的真實流程）', () {
    test('設定角色、新增作品後，清掉記憶體狀態再載入能還原', () async {
      await AppTheme.setRole(designer: true, nickname: 'Mia');
      AppTheme.saveDesignerProject(_project('我的第一件作品'));
      // saveDesignerProject 不會等待寫入；寫入有排隊，
      // 所以再排一次寫入並等它完成，就等於等前一次寫入結束。
      await ProjectStorage.saveDesignerProjects(AppTheme.designerProjects);

      // 模擬「App 被完全關掉」：記憶體裡的狀態全部消失。
      AppTheme.isDesigner = false;
      AppTheme.designerProjects.clear();

      // 模擬「重新開啟」：main() 啟動時會做的事。
      await AppTheme.loadDesignerProjects();

      expect(AppTheme.isDesigner, isTrue);
      expect(AppTheme.designerNickname, 'Mia');
      expect(AppTheme.designerProjects.length, 1);
      expect(AppTheme.designerProjects.first.title, '我的第一件作品');
    });
  });
}
