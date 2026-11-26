import 'dart:typed_data';

// ============================================================
// CustomerRequirement：客戶在「需求上傳介面」（customer_signup_screen）
// 填寫的內容。送出後存在這裡，View Orders（委託詳情頁）會讀取，
// 讓專案名稱、稱呼、電話、需求文字、圖片 / PDF 都同步顯示在版面對應的位置。
// ============================================================

/// 客戶上傳的單一檔案（圖片或 PDF）。檔案順序 = 上傳順序。
class RequirementFile {
  const RequirementFile({
    required this.bytes,
    required this.name,
    required this.sizeText,
  });

  final Uint8List bytes;
  final String name;
  final String sizeText;

  bool get isPdf => name.toLowerCase().endsWith('.pdf');
}

class CustomerRequirement {
  const CustomerRequirement({
    this.projectName = '',
    this.name = '',
    this.phone = '',
    this.description = '',
    this.files = const [],
  });

  /// 專案名稱（客戶自己命名，對應 View Orders 的 COMMISSION BRIEF 標題）
  final String projectName;

  /// 稱呼（對應 View Orders 的 CLIENT DOSSIER 區塊）
  final String name;

  /// 聯絡電話（對應 View Orders 的 DIRECT LINE 區塊）
  final String phone;

  /// 需求文字敘述（對應 View Orders 的 COMMISSION BRIEF 區塊）
  final String description;

  /// 上傳的圖片 / PDF（依上傳順序，對應 View Orders 的附件區）
  final List<RequirementFile> files;

  bool get hasFile => files.isNotEmpty;

  /// 客戶有填任何東西才算「有需求資料」
  bool get isEmpty =>
      projectName.trim().isEmpty &&
      name.trim().isEmpty &&
      phone.trim().isEmpty &&
      description.trim().isEmpty &&
      !hasFile;
}

/// 全 App 共用的「最新一份客戶需求」。
/// customer_signup_screen 寫入，view_orders_screen 讀取。
class CustomerRequirementStore {
  static CustomerRequirement current = const CustomerRequirement();

  static void save(CustomerRequirement requirement) {
    current = requirement;
  }
}
