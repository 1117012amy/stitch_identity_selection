import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../../core/app_theme.dart';
import '../../core/app_text.dart';
import '../../core/customer_requirement.dart';
import '../../core/requirement_file_gallery.dart';

// 客戶註冊頁需要記住「選了哪個檔案」與「需求文字」，所以改成 StatefulWidget
class CustomerSignupScreen extends StatefulWidget {
  const CustomerSignupScreen({super.key});

  @override
  State<CustomerSignupScreen> createState() => _CustomerSignupScreenState();
}

class _CustomerSignupScreenState extends State<CustomerSignupScreen> {
  // 需求文字的控制器：用來保存輸入內容，頁面關閉時要釋放
  final TextEditingController _requirementController = TextEditingController();

  // 稱呼、電話的控制器：送出時要一起同步到 View Orders（委託詳情頁）
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  // 專案名稱：客戶自己命名，位置在姓名 / 電話下方、需求上方
  final TextEditingController _projectNameController = TextEditingController();

  // 使用者選到的檔案（圖片或 PDF），順序 = 上傳順序；還沒選時是空的
  final List<RequirementFile> _files = [];

  // 目前在大預覽區顯示的是第幾個檔案（從 0 開始）
  int _selected = 0;

  // 最多可上傳的檔案數量
  static const int _maxFiles = 9;

  @override
  void dispose() {
    _requirementController.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    _projectNameController.dispose();
    super.dispose();
  }

  /// 把客戶填的專案名稱、稱呼、電話、需求文字與圖片 / PDF 存起來，
  /// View Orders（委託詳情頁）會讀取同一份資料顯示在對應位置。
  void _saveRequirement() {
    CustomerRequirementStore.save(
      CustomerRequirement(
        projectName: _projectNameController.text.trim(),
        name: _nameController.text.trim(),
        phone: _phoneController.text.trim(),
        description: _requirementController.text.trim(),
        files: List.of(_files),
      ),
    );
  }

  /// 開啟檔案選擇視窗，可一次選多個圖片或 PDF，會接在已選的檔案後面
  Future<void> _pickAttachment() async {
    if (_files.length >= _maxFiles) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('最多只能上傳 $_maxFiles 個檔案')));
      return;
    }
    try {
      final picked = await FilePicker.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg', 'png', 'webp', 'gif', 'pdf'],
      );
      // 使用者按取消時，清單會是空的
      if (picked.isEmpty) {
        return;
      }
      final added = <RequirementFile>[];
      var overLimit = false;
      for (final file in picked) {
        if (_files.length + added.length >= _maxFiles) {
          overLimit = true;
          break;
        }
        final bytes = await file.readAsBytes();
        final sizeBytes = await file.length();
        added.add(
          RequirementFile(
            bytes: bytes,
            name: file.name,
            sizeText: '${(sizeBytes / 1024).toStringAsFixed(1)} KB',
          ),
        );
      }
      if (!mounted) {
        return;
      }
      setState(() {
        final wasEmpty = _files.isEmpty;
        _files.addAll(added);
        // 第一次選檔案時預覽第 1 個；之後新增不改變目前預覽
        if (wasEmpty) {
          _selected = 0;
        }
      });
      if (overLimit) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('最多只能上傳 $_maxFiles 個檔案，多的已略過')));
      }
    } catch (e) {
      debugPrint('Attachment pick error: $e');
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('無法開啟檔案，請再試一次')));
    }
  }

  /// 移除第 index 個檔案，後面的檔案順序自動往前補
  void _removeAttachment(int index) {
    setState(() {
      _files.removeAt(index);
      if (_files.isEmpty) {
        _selected = 0;
      } else if (_selected >= _files.length) {
        _selected = _files.length - 1;
      }
    });
  }

  /// 上傳區塊：
  /// - 沒檔案：顯示「點擊上傳」提示
  /// - 有檔案：上方大預覽（點一下放大檢視），下方縮圖列顯示順序與數量，可再新增
  Widget _buildUploadArea() {
    if (_files.isEmpty) {
      return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: _pickAttachment,
        child: SizedBox(
          height: 200,
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFFF2F1ED),
              border: Border.all(
                color: AppTheme.primary.withValues(alpha: 0.2),
                width: AppStroke.hairline,
              ),
            ),
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.image_outlined,
                  size: 28,
                  color: AppTheme.primary.withValues(alpha: 0.25),
                ),
                const SizedBox(height: 4),
                Text(
                  '${CustomerSignupText.uploadImage} / PDF',
                  style: TextStyle(
                    fontFamily: 'Space Grotesk',
                    fontWeight: FontWeight.bold,
                    fontSize: 10,
                    color: AppTheme.primary.withValues(alpha: 0.25),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final current = _files[_selected];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // 大預覽：點一下開啟全螢幕檢視（可左右滑動看其他張）
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => showRequirementViewer(context, _files, _selected),
          child: SizedBox(
            height: 200,
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFFF2F1ED),
                border: Border.all(
                  color: AppTheme.primary.withValues(alpha: 0.2),
                  width: AppStroke.hairline,
                ),
              ),
              clipBehavior: Clip.hardEdge,
              alignment: Alignment.center,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  if (current.isPdf)
                    // PDF：顯示圖示、檔名與大小
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.picture_as_pdf,
                          size: 40,
                          color: AppTheme.accentRed,
                        ),
                        const SizedBox(height: 6),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Text(
                            current.name,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontFamily: 'Space Grotesk',
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                              color: AppTheme.primary,
                            ),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          current.sizeText,
                          style: TextStyle(
                            fontFamily: 'Space Grotesk',
                            fontSize: 10,
                            color: AppTheme.primary.withValues(alpha: 0.5),
                          ),
                        ),
                      ],
                    )
                  else
                    Image.memory(
                      current.bytes,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          const Center(
                            child: Icon(Icons.broken_image_outlined),
                          ),
                    ),
                  // 左上角：目前是第幾個 / 共幾個
                  Positioned(
                    top: 0,
                    left: 0,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      color: const Color(0xFF0055FF),
                      child: Text(
                        '${_selected + 1} / ${_files.length}',
                        style: const TextStyle(
                          fontFamily: 'Space Grotesk',
                          fontWeight: FontWeight.w900,
                          fontSize: 12,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  // 底部提示：點一下可放大
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: Container(
                      color: AppTheme.primary.withValues(alpha: 0.7),
                      padding: const EdgeInsets.symmetric(vertical: 3),
                      child: const Text(
                        '點擊放大查看',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Space Grotesk',
                          fontWeight: FontWeight.bold,
                          fontSize: 10,
                          color: AppTheme.paper,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        // 已選數量與順序說明
        Text(
          '已選 ${_files.length} / $_maxFiles 個檔案（編號為上傳順序，點縮圖可預覽）',
          style: TextStyle(
            fontFamily: 'Space Grotesk',
            fontWeight: FontWeight.bold,
            fontSize: 10,
            color: AppTheme.primary.withValues(alpha: 0.6),
          ),
        ),
        const SizedBox(height: 6),
        // 縮圖列：依順序排列，最後一格是「＋」可再新增
        SizedBox(
          height: 76,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              for (var i = 0; i < _files.length; i++) ...[
                RequirementThumb(
                  file: _files[i],
                  order: i + 1,
                  selected: i == _selected,
                  onTap: () => setState(() => _selected = i),
                  onRemove: () => _removeAttachment(i),
                ),
                const SizedBox(width: 8),
              ],
              if (_files.length < _maxFiles)
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: _pickAttachment,
                  child: Container(
                    width: 76,
                    height: 76,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF2F1ED),
                      border: Border.all(
                        color: AppTheme.primary,
                        width: AppStroke.regular,
                      ),
                    ),
                    child: const Icon(
                      Icons.add,
                      size: 28,
                      color: AppTheme.primary,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: const ObscureAppBar(
        leading: SizedBox.shrink(),
        actions: [SizedBox.shrink()],
      ),
      body: SafeArea(
        // 改成可捲動：鍵盤跳出來時，輸入框會自動捲到看得見的位置
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          padding: const EdgeInsets.fromLTRB(15, 20, 15, 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(width: 7, height: 62, color: AppTheme.accentYellow),
                  const SizedBox(width: 12),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        CustomerSignupText.title,
                        style: TextStyle(
                          fontFamily: 'Space Grotesk',
                          fontWeight: FontWeight.w900,
                          fontSize: 37,
                          height: 0.94,
                          letterSpacing: -1.2,
                        ),
                      ),
                      SizedBox(height: 7),
                      Text(
                        CustomerSignupText.subtitle,
                        style: TextStyle(
                          fontFamily: 'Space Grotesk',
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          letterSpacing: 0,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                decoration: BoxDecoration(
                  color: AppTheme.paper,
                  border: Border.all(
                    color: AppTheme.primary,
                    width: AppStroke.regular,
                  ),
                  boxShadow: const [
                    BoxShadow(
                      color: AppTheme.primary,
                      offset: AppTheme.hardShadowOffset,
                      blurRadius: 0,
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // 點擊後可選擇圖片或 PDF 的上傳區塊
                    _buildUploadArea(),
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 12),
                      height: AppStroke.regular,
                      color: AppTheme.primary.withValues(alpha: 0.15),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: _buildUnderlineField(
                            CustomerSignupText.name,
                            CustomerSignupText.nameHint,
                            _nameController,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildUnderlineField(
                            CustomerSignupText.phone,
                            CustomerSignupText.phoneHint,
                            _phoneController,
                            keyboardType: TextInputType.phone,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    // 專案名稱：與姓名、電話同一種欄位（同高度、同樣式），整列寬度
                    _buildUnderlineField(
                      CustomerSignupText.projectName,
                      CustomerSignupText.projectNameHint,
                      _projectNameController,
                    ),
                    const SizedBox(height: 15),
                    const Text(
                      CustomerSignupText.requirement,
                      style: TextStyle(
                        fontFamily: 'Space Grotesk',
                        fontWeight: FontWeight.bold,
                        fontSize: 11,
                        letterSpacing: 0,
                      ),
                    ),
                    const SizedBox(height: 4),
                    // 需求文字框：預設 3 行高，內容變多會自動長高（最多 6 行再捲動）
                    TextField(
                      controller: _requirementController,
                      keyboardType: TextInputType.multiline,
                      textInputAction: TextInputAction.newline,
                      minLines: 3,
                      maxLines: 6,
                      cursorColor: AppTheme.primary,
                      // 明確指定文字顏色，確保打字時看得清楚
                      style: const TextStyle(
                        fontSize: 12,
                        height: 1.3,
                        color: AppTheme.primary,
                        fontFamily: 'Space Grotesk',
                        letterSpacing: 0,
                      ),
                      decoration: InputDecoration(
                        hintText: CustomerSignupText.requirementHint,
                        hintStyle: TextStyle(
                          color: AppTheme.primary.withValues(alpha: 0.3),
                          fontSize: 12,
                        ),
                        filled: false,
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                            color: AppTheme.primary,
                            width: AppStroke.hairline,
                          ),
                          borderRadius: BorderRadius.zero,
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                            color: AppTheme.accentRed,
                            width: AppStroke.regular,
                          ),
                          borderRadius: BorderRadius.zero,
                        ),
                        // 左右維持 5；上下加大到 12，文字不會貼著上緣
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 5,
                          vertical: 12,
                        ),
                        isDense: true,
                      ),
                    ),
                    const SizedBox(height: 10),
                    GestureDetector(
                      onTap: () async {
                        // 先把需求資料存起來，委託詳情頁才讀得到
                        _saveRequirement();
                        await AppTheme.setRole(designer: false);
                        if (!context.mounted) {
                          return;
                        }
                        Navigator.pushReplacementNamed(
                          context,
                          '/discovery_feed',
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 13),
                        decoration: BoxDecoration(
                          color: AppTheme.primary,
                          border: Border.all(
                            color: AppTheme.primary,
                            width: AppStroke.regular,
                          ),
                          boxShadow: const [
                            BoxShadow(
                              color: AppTheme.accentBlue,
                              offset: AppTheme.hardShadowOffset,
                              blurRadius: 0,
                            ),
                          ],
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              CustomerSignupText.start,
                              style: TextStyle(
                                fontFamily: 'Space Grotesk',
                                fontWeight: FontWeight.w900,
                                fontSize: 15,
                                color: AppTheme.paper,
                                letterSpacing: 0,
                              ),
                            ),
                            SizedBox(width: 10),
                            Icon(
                              Icons.arrow_forward,
                              color: AppTheme.paper,
                              size: 20,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUnderlineField(
    String label,
    String hint,
    TextEditingController controller, {
    TextInputType? keyboardType,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Space Grotesk',
            fontWeight: FontWeight.bold,
            fontSize: 11,
            letterSpacing: 0,
          ),
        ),
        const SizedBox(height: 4),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          style: const TextStyle(
            fontSize: 12,
            fontFamily: 'Space Grotesk',
            letterSpacing: 0,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              color: AppTheme.primary.withValues(alpha: 0.3),
              fontSize: 12,
            ),
            enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(
                color: AppTheme.primary,
                width: AppStroke.hairline,
              ),
            ),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(
                color: AppTheme.accentRed,
                width: AppStroke.regular,
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(vertical: 6),
            isDense: true,
          ),
        ),
      ],
    );
  }
}
