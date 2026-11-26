import 'package:flutter/material.dart';

import '../../core/app_theme.dart';
import '../../core/customer_requirement.dart';

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
  static const Color grey400 = Color(0xFFA3A3A3);
  static const Color grey500 = Color(0xFF737373);
  static const Color white80 = Color(0xCCFFFFFF); // 白色 80% 透明
}

/// 本頁各按鈕要前往的路由（集中管理，之後要改導向只改這裡）
class _Routes {
  /// 客戶刊登橫幅按鈕 → 合約報價頁
  static const String apply = '/contract_quote';

  /// 任何一張委託卡片 / 應徵 / 投遞按鈕 → 客戶委託詳情頁（View Orders）
  static const String viewOrders = '/view_orders';

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
              // 2. 客戶上傳的委託（目前只顯示一個；客戶上傳後才改成上傳內容）
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: _CommissionCard(
                      requirement: CustomerRequirementStore.current,
                      onTap: () => _go(_Routes.viewOrders),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // 右欄留空：和舊的雙欄版面一樣，卡片只佔半寬
                  const Expanded(child: SizedBox()),
                ],
              ),
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
    this.padding = EdgeInsets.zero,
  });

  final Color color;
  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: color,
        border: Border.all(color: _C.ink, width: AppStroke.regular),
        boxShadow: [BoxShadow(color: _C.ink, offset: AppTheme.hardShadowOffset)],
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

/// 帶箭頭 / 圖示的按鈕（紅、黑、黃色卡片按鈕共用）
class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.label,
    required this.icon,
    required this.background,
    required this.foreground,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final Color background;
  final Color foreground;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return _Tap(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 6),
        decoration: BoxDecoration(
          color: background,
          border: Border.all(color: _C.ink, width: AppStroke.regular),
          boxShadow: [BoxShadow(color: _C.ink, offset: AppTheme.hardShadowOffset)],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(label, style: _head(10, color: foreground)),
            const SizedBox(width: 4),
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
                              const SizedBox(width: 4),
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
                            const SizedBox(width: 4),
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
// 客戶上傳的委託卡片
// 資料來自 CustomerRequirementStore（customer_signup_screen 上傳的內容）：
//  - 圖片：客戶上傳的第一張圖片（略過 PDF）
//  - 專案名稱：圖片下方、較醒目的粗體文字
//  - 客戶姓名：專案名稱上方的灰色小字
// 客戶還沒上傳時，只顯示一個示範卡片；上傳後就改成客戶的內容。
// ------------------------------------------------------------
class _CommissionCard extends StatelessWidget {
  const _CommissionCard({required this.requirement, required this.onTap});

  final CustomerRequirement requirement;
  final VoidCallback onTap;

  /// 第一張圖片；如果檔案裡只有 PDF 就回傳 null
  RequirementFile? get _firstImage {
    for (final file in requirement.files) {
      if (!file.isPdf) return file;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final image = _firstImage;
    final hasData = !requirement.isEmpty;

    // 專案名稱：有填就用客戶的；沒填但有上傳其他內容 → 「未命名專案」；完全沒上傳 → 示範文字
    final projectName = requirement.projectName.trim().isNotEmpty
        ? requirement.projectName.trim()
        : (hasData ? '未命名專案' : '示範專案名稱');

    // 客戶姓名：同上，有上傳卻沒填姓名就不顯示這一行
    final clientName = requirement.name.trim().isNotEmpty
        ? requirement.name.trim()
        : (hasData ? '' : '客戶姓名');

    return _Tap(
      onTap: onTap,
      child: _NeoBox(
        color: _C.yellow,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 黑色標題條（舊卡片格式）
            Container(
              color: _C.ink,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Text('#001', style: _head(10, color: _C.yellow)),
            ),            // 圖片區：客戶的第一張圖；沒有圖片時顯示深色底 + 圖示
            Container(
              height: 176,
              decoration: const BoxDecoration(
                color: Color(0xFF171717),
                border: Border(
                  bottom: BorderSide(
                    color: _C.ink,
                    width: AppStroke.regular,
                  ),
                ),
              ),
              child: image == null
                  ? const Center(
                      child: Icon(
                        Icons.image_outlined,
                        size: 40,
                        color: _C.grey500,
                      ),
                    )
                  : Image.memory(
                      image.bytes,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      errorBuilder: (context, error, stackTrace) =>
                          const Center(
                            child: Icon(
                              Icons.broken_image_outlined,
                              size: 40,
                              color: _C.grey500,
                            ),
                          ),
                    ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 客戶姓名：灰色小字
                  if (clientName.isNotEmpty) ...[
                    Text(
                      clientName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: _head(
                        10,
                        color: _C.grey500,
                        weight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                  ],
                  // 專案名稱：圖片下方較醒目的文字
                  Text(
                    projectName,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: _head(14, height: 1.2),
                  ),
                  const SizedBox(height: 10),
                  _ActionButton(
                    label: '發送詢問',
                    icon: Icons.send,
                    background: _C.red,
                    foreground: _C.white,
                    onTap: onTap,
                  ),
                ],
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
