import 'package:flutter/material.dart';

/// 非英文字元（中文與全形符號）小字字距（0.7px）。
const double kSmallChineseLetterSpacing = 0.7;

/// 非英文字元（中文與全形符號）標題大字字距（2.0px）。
const double kTitleChineseLetterSpacing = 2.0;

/// 判定為「標題大字」的字體大小門檻（>= 18.0pt 視為標題大字）。
const double kTitleFontSizeThreshold = 18.0;

final RegExp _asciiRunRegex = RegExp(r'[\x00-\x7F]+');

/// 檢查字串是否包含非 ASCII（例如中文）字元。
bool containsNonEnglish(String text) {
  for (var i = 0; i < text.length; i++) {
    if (text.codeUnitAt(i) > 0x7F) {
      return true;
    }
  }
  return false;
}

/// 依文字樣式大小決定非英文字距：標題大字（>= 18pt）為 2.0px，其餘小字為 0.7px。
double resolveNonEnglishLetterSpacing(TextStyle? style, {BuildContext? context}) {
  final fontSize = style?.fontSize ??
      (context != null ? DefaultTextStyle.of(context).style.fontSize : null) ??
      14.0;
  return fontSize >= kTitleFontSizeThreshold
      ? kTitleChineseLetterSpacing
      : kSmallChineseLetterSpacing;
}

/// 將字串依「ASCII（英文/數字/空白）」與「非 ASCII（中文等）」拆分為 TextSpan。
/// 非 ASCII 區段套用指定字距（預設依字體大小自動選 0.7px 或 2.0px），英文區段維持原本字距。
List<InlineSpan> buildSpacedTextSpans(
  String text, {
  double letterSpacing = kSmallChineseLetterSpacing,
}) {
  final spans = <InlineSpan>[];
  var cursor = 0;

  for (final match in _asciiRunRegex.allMatches(text)) {
    if (match.start > cursor) {
      spans.add(
        TextSpan(
          text: text.substring(cursor, match.start),
          style: TextStyle(letterSpacing: letterSpacing),
        ),
      );
    }
    spans.add(TextSpan(text: match.group(0)));
    cursor = match.end;
  }

  if (cursor < text.length) {
    spans.add(
      TextSpan(
        text: text.substring(cursor),
        style: TextStyle(letterSpacing: letterSpacing),
      ),
    );
  }

  return spans;
}

/// 與 [Text] 相容的 const Widget：
/// 自動讓所有非英文字元套用字距（小字 0.7px、標題大字 2.0px），英文字元維持原本樣式。
class SpacedText extends StatelessWidget {
  const SpacedText(
    this.data, {
    super.key,
    this.style,
    this.strutStyle,
    this.textAlign,
    this.textDirection,
    this.locale,
    this.softWrap,
    this.overflow,
    this.textScaler,
    this.maxLines,
    this.semanticsLabel,
    this.textWidthBasis,
    this.textHeightBehavior,
    this.selectionColor,
  });

  final String data;
  final TextStyle? style;
  final StrutStyle? strutStyle;
  final TextAlign? textAlign;
  final TextDirection? textDirection;
  final Locale? locale;
  final bool? softWrap;
  final TextOverflow? overflow;
  final TextScaler? textScaler;
  final int? maxLines;
  final String? semanticsLabel;
  final TextWidthBasis? textWidthBasis;
  final TextHeightBehavior? textHeightBehavior;
  final Color? selectionColor;

  @override
  Widget build(BuildContext context) {
    if (!containsNonEnglish(data)) {
      return Text(
        data,
        style: style,
        strutStyle: strutStyle,
        textAlign: textAlign,
        textDirection: textDirection,
        locale: locale,
        softWrap: softWrap,
        overflow: overflow,
        textScaler: textScaler,
        maxLines: maxLines,
        semanticsLabel: semanticsLabel,
        textWidthBasis: textWidthBasis,
        textHeightBehavior: textHeightBehavior,
        selectionColor: selectionColor,
      );
    }

    final spacing = resolveNonEnglishLetterSpacing(style, context: context);
    return Text.rich(
      TextSpan(
        style: style,
        children: buildSpacedTextSpans(data, letterSpacing: spacing),
      ),
      strutStyle: strutStyle,
      textAlign: textAlign,
      textDirection: textDirection,
      locale: locale,
      softWrap: softWrap,
      overflow: overflow,
      textScaler: textScaler,
      maxLines: maxLines,
      semanticsLabel: semanticsLabel,
      textWidthBasis: textWidthBasis,
      textHeightBehavior: textHeightBehavior,
      selectionColor: selectionColor,
    );
  }
}

/// 支援中文字距（小字 0.7px、大字 2.0px，英文維持原字距）的 TextEditingController。
class SpacedTextEditingController extends TextEditingController {
  SpacedTextEditingController({super.text});

  @override
  TextSpan buildTextSpan({
    required BuildContext context,
    TextStyle? style,
    required bool withComposing,
  }) {
    if (!containsNonEnglish(text)) {
      return super.buildTextSpan(
        context: context,
        style: style,
        withComposing: withComposing,
      );
    }
    final spacing = resolveNonEnglishLetterSpacing(style, context: context);
    return TextSpan(
      style: style,
      children: buildSpacedTextSpans(text, letterSpacing: spacing),
    );
  }
}
