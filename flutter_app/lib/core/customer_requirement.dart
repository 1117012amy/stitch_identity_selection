import 'dart:convert';
import 'dart:typed_data';

// 與 app_theme.dart 相同的條件匯入：依平台自動挑選 Web / 手機 / 桌面的儲存實作
import 'project_storage_stub.dart'
    if (dart.library.html) 'project_storage_web.dart'
    if (dart.library.io) 'project_storage_io.dart';

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

  factory RequirementFile.fromJson(Map<String, dynamic> json) {
    return RequirementFile(
      bytes: base64Decode(json['bytesBase64'] as String? ?? ''),
      name: json['name'] as String? ?? '',
      sizeText: json['sizeText'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'bytesBase64': base64Encode(bytes),
    'name': name,
    'sizeText': sizeText,
  };
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

  factory CustomerRequirement.fromJson(Map<String, dynamic> json) {
    return CustomerRequirement(
      projectName: json['projectName'] as String? ?? '',
      name: json['name'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      description: json['description'] as String? ?? '',
      files:
          (json['files'] as List?)
              ?.whereType<Map<String, dynamic>>()
              .map(RequirementFile.fromJson)
              .toList() ??
          const [],
    );
  }

  Map<String, dynamic> toJson() => {
    'projectName': projectName,
    'name': name,
    'phone': phone,
    'description': description,
    'files': files.map((file) => file.toJson()).toList(),
  };

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
    // 同步寫入本機儲存，重新整理 / 重開 App 後資料仍在
    ProjectStorage.saveCustomerRequirement(requirement.toJson());
  }

  /// App 啟動（或下拉重新整理）時載入上次存的客戶需求
  static Future<void> load() async {
    final json = await ProjectStorage.loadCustomerRequirement();
    if (json != null) {
      try {
        current = CustomerRequirement.fromJson(json);
      } catch (_) {
        // 存檔格式不對時當作沒有資料，不讓 App 打不開
        current = const CustomerRequirement();
      }
    }
  }
}
