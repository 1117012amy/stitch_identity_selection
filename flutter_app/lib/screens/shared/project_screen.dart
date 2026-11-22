import 'package:flutter/material.dart';

import '../../core/app_theme.dart';

// ============================================================
// ProjectScreen：「尋找委託 (Bento Masonry)」介面
// 來源：project/code.html（把 HTML 版面改寫成 Flutter）
// 頂部列 / 底部導覽列直接使用 App 共用的 ObscureAppBar / ObscureNavBar，
// 所以外觀、五個圖示的跳轉都和 commission_in_progress 那頁一致。
// ============================================================

/// 本頁專用色票（取自 project/code.html 的 Bauhaus 配色）
class _C {
  static const Color ink = AppTheme.primary; // 墨黑 #1A1A1A
  static const Color yellow = AppTheme.accentYellow; // 黃 #FFCC00
  static const Color red = Color(0xFFFF3F3F);
  static const Color blue = Color(0xFF0055FF);
  static const Color white = Color(0xFFFFFFFF);
  static const Color cream = Color(0xFFEEE8D9);
  static const Color grey400 = Color(0xFFA3A3A3);
  static const Color grey500 = Color(0xFF737373);
  static const Color grey600 = Color(0xFF525252);
  static const Color grey700 = Color(0xFF404040);
  static const Color white80 = Color(0xCCFFFFFF); // 白色 80% 透明
}

/// 本頁用到的圖片網址（與 HTML 版相同）
const String _posterUrl =
    'https://lh3.googleusercontent.com/aida-public/AB6AXuC8IONlECFAgUjRUmAjRSRcrTPIwZJ0vk02NMZtgQBIViPJm_ocigxbthPqH4Vvcj6nvGs-XO2VkmkOHtS3hnL4-6KooSYHBH9o__fveB8IYZIYCSenfTQRXkKvxlmBZGQoCLf4XeoI_5B4veC5thZ_pSUgghrcIkUYBqTXZKCaUUV0y6Kyl7-xQvFLGnTlvCILBarg_YlSjzqx7-H0QYpnt667vyPS9jmyO0TYHnbe';
const String _perfumeUrl =
    'https://lh3.googleusercontent.com/aida-public/AB6AXuDIxj2U8rlpXXasTLMVO4ltmUQgrChfmm1ZOolK2bOLfTrYeMQWOGfGC5NQHXZEAMZWSVoFLyucGKezwYjtacaJ00XOAM4cAfZVCV159adDlPpmYiLYFMWBfPR6v8YzWGAdydKHaoaKIxbX4N-7RLjN2CE760Ce2yeK9V2jzRIN8-K1nNm_ntq6QOspvQz0j06gHrvWitE5wGWavTg-e0aZ0EfFKYAKgI0c9Nh9KeCJ';

/// 本頁各按鈕要前往的路由（集中管理，之後要改導向只改這裡）
class _Routes {
  /// 卡片、應徵 / 投遞 / 刊登按鈕 → 合約報價頁
  static const String apply = '/contract_quote';

  /// 搜尋框、快速篩選 → 搜尋分類頁
  static const String search = '/search_categories';
}

/// 標題用字樣式（Space Grotesk，粗黑體）
TextStyle _head(
  double size, {
  Color color = _C.ink,
  FontWeight weight = FontWeight.w900,
  double? height,
  double? letterSpacing,
  FontStyle style = FontStyle.normal,
}) {
  return TextStyle(
    fontFamily: 'Space Grotesk',
    fontSize: size,
    fontWeight: weight,
    color: color,
    height: height,
    letterSpacing: letterSpacing,
    fontStyle: style,
  );
}

class ProjectScreen extends StatefulWidget {
  const ProjectScreen({super.key});

  @override
  State<ProjectScreen> createState() => _ProjectScreenState();
}

class _ProjectScreenState extends State<ProjectScreen> {
  // 分類按鈕目前選到哪一個（0 = 全部）
  int _selectedCategory = 0;

  // 搜尋框的輸入內容控制器（要在 dispose 釋放）
  final TextEditingController _searchController = TextEditingController();

  // 卡片 B 右上角的書籤是否已收藏
  bool _bookmarked = false;

  static const List<String> _categories = [
    '全部 (142)',
    '品牌識別',
    '包裝結構',
    '書籍裝幀',
    'UI/UX',
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  /// 前往指定頁面（保留目前頁面在返回堆疊上）
  void _go(String route) {
    Navigator.pushNamed(context, route);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      // 最上排：與 commission_in_progress 相同的共用頂部列
      appBar: const ObscureAppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(12, 16, 12, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 1. 上方不對稱 Bento 區塊
              _HeroSection(
                searchController: _searchController,
                onFilter: () => _go(_Routes.search),
              ),
              const SizedBox(height: 16),
              // 分類按鈕列（可橫向捲動）
              _CategoryStrip(
                labels: _categories,
                selected: _selectedCategory,
                onSelected: (index) {
                  setState(() => _selectedCategory = index);
                },
              ),
              const SizedBox(height: 16),
              // 2. 雙欄 Masonry 卡片
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        _TallYellowCard(onTap: () => _go(_Routes.apply)),
                        const SizedBox(height: 12),
                        _BrandCard(onTap: () => _go(_Routes.apply)),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      children: [
                        _PackagingCard(
                          bookmarked: _bookmarked,
                          onBookmark: () {
                            setState(() => _bookmarked = !_bookmarked);
                          },
                          onTap: () => _go(_Routes.apply),
                        ),
                        const SizedBox(height: 12),
                        _DarkUiCard(onTap: () => _go(_Routes.apply)),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // 跨兩欄的焦點卡片
              _FeaturedCard(onTap: () => _go(_Routes.apply)),
              const SizedBox(height: 16),
              // 3. 底部客戶刊登橫幅
              _ClientBanner(onPost: () => _go(_Routes.apply)),
            ],
          ),
        ),
      ),
      // 最下排：與 commission_in_progress 相同的共用底部導覽列
      // 「委託」圖示會導到本頁（'/project'），所以這裡高亮它
      bottomNavigationBar: ObscureNavBar(
        pageContext: context,
        activeRoute: '/project',
      ),
    );
  }
}

// ------------------------------------------------------------
// 共用小元件
// ------------------------------------------------------------

/// 新粗獷風格方塊：粗黑框 + 無模糊的硬陰影
class _NeoBox extends StatelessWidget {
  const _NeoBox({
    required this.color,
    required this.child,
    this.shadowColor = _C.ink,
    this.padding = EdgeInsets.zero,
  });

  final Color color;
  final Widget child;
  final Color shadowColor;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: color,
        border: Border.all(color: _C.ink, width: AppStroke.regular),
        boxShadow: [BoxShadow(color: shadowColor, offset: AppTheme.hardShadowOffset)],
      ),
      child: child,
    );
  }
}

/// 可點擊區域（整塊範圍都吃點擊）
class _Tap extends StatelessWidget {
  const _Tap({required this.onTap, required this.child});

  final VoidCallback onTap;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: child,
    );
  }
}

/// 小標籤（例如「急件」「#台式」）
class _Tag extends StatelessWidget {
  const _Tag(
    this.text, {
    required this.background,
    required this.foreground,
    this.size = 8,
    this.borderColor,
  });

  final String text;
  final Color background;
  final Color foreground;
  final double size;
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: background,
        border: borderColor == null
            ? null
            : Border.all(color: borderColor!, width: AppStroke.thin),
      ),
      child: Text(text, style: _head(size, color: foreground)),
    );
  }
}

/// 黑白灰階海報圖（載入失敗時顯示深色底），可疊放標籤
class _PosterImage extends StatelessWidget {
  const _PosterImage({required this.url, required this.height, this.overlay});

  final String url;
  final double height;
  final Widget? overlay;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Color(0xFF171717),
        border: Border(bottom: BorderSide(color: _C.ink, width: AppStroke.regular)),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          // 灰階濾鏡：和 HTML 的 grayscale + contrast 效果相近
          ColorFiltered(
            colorFilter: const ColorFilter.mode(
              Colors.grey,
              BlendMode.saturation,
            ),
            child: Image.network(
              url,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) =>
                  const ColoredBox(color: Color(0xFF171717)),
            ),
          ),
          ?overlay,
        ],
      ),
    );
  }
}

/// 帶箭頭 / 圖示的按鈕（紅、黑、黃色卡片按鈕共用）
class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.label,
    required this.icon,
    required this.background,
    required this.foreground,
    required this.onTap,
    this.shadowColor = _C.ink,
    this.verticalPadding = 6,
    this.expand = true,
  });

  final String label;
  final IconData icon;
  final Color background;
  final Color foreground;
  final VoidCallback onTap;
  final Color shadowColor;
  final double verticalPadding;
  final bool expand;

  @override
  Widget build(BuildContext context) {
    return _Tap(
      onTap: onTap,
      child: Container(
        width: expand ? double.infinity : null,
        padding: EdgeInsets.symmetric(
          horizontal: expand ? 0 : 8,
          vertical: verticalPadding,
        ),
        decoration: BoxDecoration(
          color: background,
          border: Border.all(color: _C.ink, width: AppStroke.regular),
          boxShadow: [BoxShadow(color: shadowColor, offset: AppTheme.hardShadowOffset)],
        ),
        child: Row(
          mainAxisSize: expand ? MainAxisSize.max : MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(label, style: _head(10, color: foreground)),
            const SizedBox(width: AppStroke.regular),
            Icon(icon, size: 13, color: foreground),
          ],
        ),
      ),
    );
  }
}

// ------------------------------------------------------------
// 1. 上方 Bento 區塊（黃色大塊 + 藍色篩選 + 紅色急件）
// ------------------------------------------------------------
class _HeroSection extends StatelessWidget {
  const _HeroSection({required this.searchController, required this.onFilter});

  final TextEditingController searchController;
  final VoidCallback onFilter;

  @override
  Widget build(BuildContext context) {
    // 固定高度：避免 TextField 在 IntrinsicHeight 內算不準而溢位
    return SizedBox(height: 184,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 左：黃色大塊（7/12 寬）
          Expanded(
            flex: 7,
            child: _NeoBox(
              color: _C.yellow,
              padding: const EdgeInsets.all(14),
              child: Stack(
                clipBehavior: Clip.hardEdge,
                fit: StackFit.expand,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const _Tag(
                                'ISSUE // 04',
                                background: _C.ink,
                                foreground: _C.white,
                                size: 9,
                              ),
                              const SizedBox(width: AppStroke.regular),
                              Flexible(
                                child: Text(
                                  'BENTO GRID',
                                  overflow: TextOverflow.ellipsis,
                                  style: _head(9, weight: FontWeight.w700),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'FIND //',
                            style: _head(
                              24,
                              height: 1,
                              style: FontStyle.italic,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '142 筆委託',
                            style: _head(20, color: _C.red, height: 1.1),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            '前衛商業視覺、裝幀與品牌工程雙欄拼貼。',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: _head(
                              11,
                              weight: FontWeight.w700,
                              height: 1.3,
                            ),
                          ),
                        ],
                      ),
                      // 迷你搜尋框：真的可以輸入文字，輸入時不會跳到其他頁面
                      Container(
                        margin: const EdgeInsets.only(top: 8),
                        padding: const EdgeInsets.symmetric(horizontal: 6),
                        decoration: const BoxDecoration(
                          color: _C.white,
                          border: Border.fromBorderSide(
                            BorderSide(color: _C.ink, width: AppStroke.regular),
                          ),
                          boxShadow: [
                            BoxShadow(color: _C.ink, offset: AppTheme.hardShadowOffset),
                          ],
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.search,
                              size: 16,
                              color: _C.grey500,
                            ),
                            const SizedBox(width: AppStroke.regular),
                            Expanded(
                              child: TextField(
                                controller: searchController,
                                textInputAction: TextInputAction.search,
                                cursorColor: _C.ink,
                                style: _head(11, weight: FontWeight.w700),
                                decoration: InputDecoration(
                                  isDense: true,
                                  filled: false,
                                  border: InputBorder.none,
                                  enabledBorder: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                  contentPadding: const EdgeInsets.symmetric(
                                    vertical: 8,
                                  ),
                                  hintText: '搜尋專案...',
                                  hintStyle: _head(
                                    11,
                                    color: _C.grey400,
                                    weight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 10),
          // 右：藍色「快速篩選」+ 紅色「急件」（5/12 寬）
          Expanded(
            flex: 5,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: _Tap(
                    onTap: onFilter,
                    child: _NeoBox(
                      color: _C.blue,
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Icon(Icons.filter_alt, size: 18, color: _C.white),
                              Icon(
                                Icons.arrow_forward,
                                size: 14,
                                color: _C.white,
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'TAXONOMY',
                                style: _head(
                                  9,
                                  color: _C.white80,
                                  weight: FontWeight.w700,
                                  letterSpacing: 0.8,
                                ),
                              ),
                              Text(
                                '快速篩選',
                                style: _head(14, color: _C.white, height: 1),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: _NeoBox(
                    color: _C.red,
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const _Tag(
                              'URGENT',
                              background: _C.ink,
                              foreground: _C.yellow,
                              size: 9,
                            ),
                            Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                color: _C.yellow,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '急件 38 筆',
                              style: _head(18, color: _C.white, height: 1),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '即刻報價媒合',
                              style: _head(
                                9,
                                color: _C.white,
                                weight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ------------------------------------------------------------
// 分類按鈕列
// ------------------------------------------------------------
class _CategoryStrip extends StatelessWidget {
  const _CategoryStrip({
    required this.labels,
    required this.selected,
    required this.onSelected,
  });

  final List<String> labels;
  final int selected;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      // 右下留一點空間給硬陰影
      padding: const EdgeInsets.only(right: 4, bottom: 4),
      child: Row(
        children: [
          for (var i = 0; i < labels.length; i++) ...[
            if (i > 0) const SizedBox(width: 6),
            _Tap(
              onTap: () => onSelected(i),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  // 選中：黑底黃字；未選：白底黑字
                  color: i == selected ? _C.ink : _C.white,
                  border: Border.all(color: _C.ink, width: AppStroke.regular),
                  boxShadow: const [
                    BoxShadow(color: _C.ink, offset: AppTheme.hardShadowOffset),
                  ],
                ),
                child: Text(
                  labels[i],
                  style: _head(11, color: i == selected ? _C.yellow : _C.ink),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ------------------------------------------------------------
// 左欄 卡片 A：黃色高卡（海報）
// ------------------------------------------------------------
class _TallYellowCard extends StatelessWidget {
  const _TallYellowCard({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return _NeoBox(
      color: _C.yellow,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 黑色標題條
          Container(
            color: _C.ink,
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('#001 VI', style: _head(10, color: _C.yellow)),
                const _Tag('急件', background: _C.red, foreground: _C.white),
              ],
            ),
          ),
          _PosterImage(
            url: _posterUrl,
            height: 176,
            overlay: const Positioned(
              left: 4,
              bottom: 4,
              child: _Tag(
                '#海報周邊',
                background: _C.ink,
                foreground: _C.white,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 16,
                      height: 16,
                      alignment: Alignment.center,
                      color: _C.ink,
                      child: Text('AS', style: _head(9, color: _C.white)),
                    ),
                    const SizedBox(width: AppStroke.regular),
                    Expanded(
                      child: Text(
                        'Aether Studio',
                        overflow: TextOverflow.ellipsis,
                        style: _head(10),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  'CYBER-PUNK 展覽主視覺與周邊系統',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: _head(14, height: 1.2),
                ),
                const SizedBox(height: 4),
                Text(
                  '新媒體科幻展空間導視、限量吊牌與字體重組 Brutalist 規範。',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: _head(
                    10,
                    color: const Color(0xFF262626),
                    weight: FontWeight.w500,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 10),
                // 預算白框
                _NeoBox(
                  color: _C.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  child: SizedBox(
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '固定預算',
                          style: _head(
                            8,
                            color: _C.grey600,
                            weight: FontWeight.w700,
                            height: 1,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text('NT\$ 85,000', style: _head(12, height: 1)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                _ActionButton(
                  label: '應徵提案',
                  icon: Icons.arrow_forward,
                  background: _C.red,
                  foreground: _C.white,
                  onTap: onTap,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ------------------------------------------------------------
// 左欄 卡片 E：白色品牌識別卡
// ------------------------------------------------------------
class _BrandCard extends StatelessWidget {
  const _BrandCard({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return _NeoBox(
      color: _C.white,
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 標題列 + 底線
          Container(
            padding: const EdgeInsets.only(bottom: 6),
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: _C.ink, width: AppStroke.regular)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const _Tag(
                  '#004 VI',
                  background: _C.ink,
                  foreground: _C.yellow,
                  size: 9,
                ),
                Text(
                  '剩餘 5 天',
                  style: _head(
                    9,
                    color: _C.grey500,
                    weight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          const Wrap(
            spacing: 4,
            runSpacing: 4,
            children: [
              _Tag(
                '#台式',
                background: _C.cream,
                foreground: _C.ink,
                borderColor: _C.ink,
              ),
              _Tag(
                '#粗獷',
                background: _C.yellow,
                foreground: _C.ink,
                borderColor: _C.ink,
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            '獨立選物空間品牌識別手冊與招牌字體',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: _head(12, height: 1.2),
          ),
          const SizedBox(height: 4),
          Text(
            '赤峰街復古老屋改裝，需重組漢字排版與金屬招牌施工完稿。',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: _head(
              10,
              color: _C.grey600,
              weight: FontWeight.w500,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 10),
          // 預算 + 快速投遞鈕
          Container(
            padding: const EdgeInsets.only(top: 8),
            decoration: const BoxDecoration(
              border: Border(top: BorderSide(color: _C.ink, width: AppStroke.regular)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '專案預算',
                      style: _head(
                        8,
                        color: _C.grey500,
                        weight: FontWeight.w700,
                      ),
                    ),
                    Text('NT\$ 45,000', style: _head(12)),
                  ],
                ),
                _Tap(
                  onTap: onTap,
                  child: Container(
                    width: 28,
                    height: 28,
                    decoration: const BoxDecoration(
                      color: _C.ink,
                      border: Border.fromBorderSide(
                        BorderSide(color: _C.ink, width: AppStroke.regular),
                      ),
                      boxShadow: [
                        BoxShadow(color: _C.ink, offset: AppTheme.hardShadowOffset),
                      ],
                    ),
                    child: const Icon(Icons.send, size: 15, color: _C.white),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ------------------------------------------------------------
// 右欄 卡片 B：白色方形（包裝）
// ------------------------------------------------------------
class _PackagingCard extends StatelessWidget {
  const _PackagingCard({
    required this.bookmarked,
    required this.onBookmark,
    required this.onTap,
  });

  final bool bookmarked;
  final VoidCallback onBookmark;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return _NeoBox(
      color: _C.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            color: _C.ink,
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('#002 PKG', style: _head(10, color: _C.blue)),
                // 書籤：點擊切換收藏
                _Tap(
                  onTap: onBookmark,
                  child: Icon(
                    bookmarked ? Icons.bookmark : Icons.bookmark_border,
                    size: 15,
                    color: bookmarked ? _C.yellow : const Color(0xFFD4D4D4),
                  ),
                ),
              ],
            ),
          ),
          _PosterImage(
            url: _perfumeUrl,
            height: 112,
            overlay: const Positioned(
              right: 4,
              bottom: 4,
              child: _Tag('SPEC', background: _C.blue, foreground: _C.white),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Obscure Parfums',
                  overflow: TextOverflow.ellipsis,
                  style: _head(9, color: _C.grey500, weight: FontWeight.w700),
                ),
                const SizedBox(height: 2),
                Text(
                  '2025 秋冬香氛系列瓶身與結構外盒',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: _head(12, height: 1.2),
                ),
                const SizedBox(height: 10),
                // 藍色預算塊
                _NeoBox(
                  color: _C.blue,
                  padding: const EdgeInsets.all(6),
                  child: SizedBox(
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '預算上限',
                          style: _head(
                            8,
                            color: _C.white80,
                            weight: FontWeight.w700,
                            height: 1,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'NT\$ 120,000',
                          style: _head(12, color: _C.white, height: 1),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                _ActionButton(
                  label: '投遞',
                  icon: Icons.arrow_forward,
                  background: _C.ink,
                  foreground: _C.white,
                  verticalPadding: 4,
                  onTap: onTap,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ------------------------------------------------------------
// 右欄 卡片 C：黑色緊湊卡（數位 UI）
// ------------------------------------------------------------
class _DarkUiCard extends StatelessWidget {
  const _DarkUiCard({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return _NeoBox(
      color: _C.ink,
      shadowColor: _C.red,
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.only(bottom: 4),
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(color: _C.grey700, width: AppStroke.thin),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('#003 UI/UX', style: _head(9, color: _C.yellow)),
                Text(
                  '剩 12 天',
                  style: _head(9, color: _C.red, weight: FontWeight.w700),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Container(width: 8, height: 8, color: _C.yellow),
              const SizedBox(width: AppStroke.regular),
              Expanded(
                child: Text(
                  'Neo Labs Studio',
                  overflow: TextOverflow.ellipsis,
                  style: _head(
                    10,
                    color: const Color(0xFFD4D4D4),
                    weight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            '數位 UI 展示平台行動端介面',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: _head(12, color: _C.white, height: 1.2),
          ),
          const SizedBox(height: 4),
          Text(
            '30+ 頁面 Figma 原型系統，極速反饋。',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: _head(
              10,
              color: _C.grey400,
              weight: FontWeight.w500,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.only(top: 8),
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(color: Color(0xFF262626), width: AppStroke.thin),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '議價預算',
                      style: _head(
                        8,
                        color: _C.grey400,
                        weight: FontWeight.w700,
                        height: 1,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'NT\$ 65,000',
                      style: _head(12, color: _C.yellow, height: 1),
                    ),
                  ],
                ),
                _ActionButton(
                  label: '應徵',
                  icon: Icons.send,
                  background: _C.yellow,
                  foreground: _C.ink,
                  shadowColor: _C.red,
                  verticalPadding: 4,
                  expand: false,
                  onTap: onTap,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ------------------------------------------------------------
// 跨欄焦點卡片 D
// ------------------------------------------------------------
class _FeaturedCard extends StatelessWidget {
  const _FeaturedCard({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return _Tap(
      onTap: onTap,
      child: _NeoBox(
        color: _C.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 標題條
            Container(
              color: _C.ink,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Row(
                      children: [
                        const _Tag(
                          'FEATURED 跨欄焦點',
                          background: _C.yellow,
                          foreground: _C.ink,
                          size: 9,
                        ),
                        const SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            '#SPATIAL-WAYFINDING',
                            overflow: TextOverflow.ellipsis,
                            style: _head(
                              10,
                              color: const Color(0xFFD4D4D4),
                              weight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '熱門推薦',
                    style: _head(10, color: _C.red, weight: FontWeight.w700),
                  ),
                ],
              ),
            ),
            _PosterImage(
              url: _posterUrl,
              height: 144,
              overlay: const Positioned(
                left: 8,
                top: 8,
                child: _Tag(
                  '空間導視 // EXHIBITION',
                  background: _C.ink,
                  foreground: _C.yellow,
                  size: 9,
                  borderColor: _C.ink,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(
                          '發案方：KRONOS ARCHITECTURE',
                          overflow: TextOverflow.ellipsis,
                          style: _head(
                            10,
                            color: _C.grey500,
                            weight: FontWeight.w700,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '剩餘 4 天截止',
                        style: _head(
                          10,
                          color: _C.grey500,
                          weight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '新粗獷主義展覽空間導視與立體標籤系統',
                    style: _head(16, height: 1.2),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '結合冷軋鋼板、絲網印刷與幾何路徑規劃，為當代藝術雙年展量身建構空間指引系統手冊。',
                    style: _head(
                      12,
                      color: _C.grey700,
                      weight: FontWeight.w500,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Wrap(
                    spacing: 6,
                    runSpacing: 4,
                    children: [
                      _Tag(
                        '#空間指標',
                        background: AppTheme.background,
                        foreground: _C.ink,
                        size: 9,
                        borderColor: _C.ink,
                      ),
                      _Tag(
                        '#材質打樣',
                        background: AppTheme.background,
                        foreground: _C.ink,
                        size: 9,
                        borderColor: _C.ink,
                      ),
                      _Tag(
                        '#雙年展',
                        background: AppTheme.background,
                        foreground: _C.ink,
                        size: 9,
                        borderColor: _C.ink,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // 底部：預算（黃）+ 投遞提案（紅）
            Container(
              decoration: const BoxDecoration(
                border: Border(top: BorderSide(color: _C.ink, width: AppStroke.regular)),
              ),
              child: IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      width: 130,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: const BoxDecoration(
                        color: _C.yellow,
                        border: Border(
                          right: BorderSide(color: _C.ink, width: AppStroke.regular),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '專案預算',
                            style: _head(8, letterSpacing: 0.8, height: 1),
                          ),
                          const SizedBox(height: 2),
                          Text('NT\$ 150,000', style: _head(14, height: 1)),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Container(
                        color: _C.red,
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '投遞提案',
                              style: _head(12, color: _C.white),
                            ),
                            const SizedBox(width: 6),
                            const Icon(
                              Icons.arrow_forward,
                              size: 16,
                              color: _C.white,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ------------------------------------------------------------
// 3. 底部「客戶刊登」橫幅
// ------------------------------------------------------------
class _ClientBanner extends StatelessWidget {
  const _ClientBanner({required this.onPost});

  final VoidCallback onPost;

  @override
  Widget build(BuildContext context) {
    return _NeoBox(
      color: _C.yellow,
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: _C.ink,
                  border: Border.all(color: _C.ink, width: AppStroke.regular),
                ),
                child: const Icon(Icons.post_add, size: 20, color: _C.yellow),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const _Tag(
                      'FOR CLIENTS',
                      background: _C.white,
                      foreground: _C.ink,
                      size: 9,
                      borderColor: _C.ink,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '我是品牌/客戶，想要刊登新委託？',
                      style: _head(14, height: 1.3),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '全台 3,500+ 位通過認證的頂尖粗獷與前衛設計師即刻為您報價。',
                      style: _head(
                        11,
                        weight: FontWeight.w500,
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          _Tap(
            onTap: onPost,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: const BoxDecoration(
                color: _C.red,
                border: Border.fromBorderSide(
                  BorderSide(color: _C.ink, width: AppStroke.regular),
                ),
                boxShadow: [BoxShadow(color: _C.ink, offset: AppTheme.hardShadowOffset)],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('刊登全新專案委託', style: _head(12, color: _C.white)),
                  const SizedBox(width: 6),
                  const Icon(Icons.add_circle, size: 16, color: _C.white),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
