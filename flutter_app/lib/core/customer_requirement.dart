import 'dart:typed_data';

// ============================================================
// CustomerRequirement：客戶在「需求上傳介面」（customer_signup_screen）
// 填寫的內容。送出後存在這裡，View Orders（委託詳情頁）會讀取，
// 讓稱呼、電話、需求文字、圖片 / PDF 都同步顯示在版面上對應的位置。
// ============================================================
class CustomerRequirement {
  const CustomerRequirement({
    this.name = '',
    this.phone = '',
    this.description = '',
    this.fileBytes,
    this.fileName,
    this.fileSizeText,
  });

  /// 稱呼（對應 View Orders 的 CLIENT DOSSIER 區塊）
  final String name;

  /// 聯絡電話（對應 View Orders 的 DIRECT LINE 區塊）
  final String phone;

  /// 需求文字敘述（對應 View Orders 的 COMMISSION BRIEF 區塊）
  final String description;

  /// 上傳的圖片或 PDF 內容（對應 View Orders 的 VISUAL REF / ATTACHED FILE）
  final Uint8List? fileBytes;
  final String? fileName;
  final String? fileSizeText;

  bool get hasFile => fileBytes != null && (fileName ?? '').isNotEmpty;

  bool get isPdf => (fileName ?? '').toLowerCase().endsWith('.pdf');

  /// 客戶有填任何東西才算「有需求資料」
  bool get isEmpty =>
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
