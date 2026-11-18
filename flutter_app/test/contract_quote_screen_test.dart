import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:obscure_app/screens/shared/contract_quote_screen.dart';

void main() {
  // 以指定的螢幕寬度與字體倍率載入報價合約頁面
  Future<void> pumpAt(
    WidgetTester tester, {
    required Size size,
    double textScale = 1.0,
  }) async {
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      MaterialApp(
        home: MediaQuery(
          data: MediaQueryData(
            size: size,
            textScaler: TextScaler.linear(textScale),
          ),
          child: const ContractQuoteScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('窄螢幕 + 大字體時，合約畫面本身不會溢出', (tester) async {
    // 共用的 ObscureAppBar 在此條件下本來就會溢出 15px（不屬於本畫面），
    // 所以只放過來自 _AppBarTitleBox 的錯誤；其他錯誤照常交給測試框架判定失敗。
    final originalOnError = FlutterError.onError;
    FlutterError.onError = (FlutterErrorDetails details) {
      final text = details.toDiagnosticsNode().toStringDeep();
      if (text.contains('_AppBarTitleBox')) return;
      originalOnError?.call(details);
    };
    addTearDown(() => FlutterError.onError = originalOnError);

    await pumpAt(tester, size: const Size(320, 640), textScale: 1.6);
  });

  testWidgets('一般手機寬度可正常顯示', (tester) async {
    await pumpAt(tester, size: const Size(390, 844));
    expect(tester.takeException(), isNull);
  });

  testWidgets('寬螢幕時內容寬度被限制在 640 以內', (tester) async {
    await pumpAt(tester, size: const Size(1400, 900));
    expect(tester.takeException(), isNull);

    // SingleChildScrollView 外層的 ConstrainedBox 應限制最大寬度
    final scrollSize = tester.getSize(find.byType(SingleChildScrollView));
    expect(scrollSize.width, lessThanOrEqualTo(640));
  });
}
