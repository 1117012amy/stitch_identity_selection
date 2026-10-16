import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../core/app_text.dart';
import '../../core/app_theme.dart';

class ChatRoomScreen extends StatefulWidget {
  final String contactName;
  final String contactStatus;

  const ChatRoomScreen({
    super.key,
    this.contactName = ChatText.defaultContactName,
    this.contactStatus = ChatText.defaultStatus,
  });

  @override
  State<ChatRoomScreen> createState() => _ChatRoomScreenState();
}

class ChatMessageItem {
  final String id;
  final String text;
  final String time;
  final bool isUser;
  final bool isRead;
  final bool isImage;
  final bool isDocument;
  final bool isBrief;
  final Uint8List? fileBytes;
  final String? fileName;
  final String? fileSizeStr;

  const ChatMessageItem({
    required this.id,
    required this.text,
    required this.time,
    required this.isUser,
    this.isRead = false,
    this.isImage = false,
    this.isDocument = false,
    this.isBrief = false,
    this.fileBytes,
    this.fileName,
    this.fileSizeStr,
  });
}

class _ChatRoomScreenState extends State<ChatRoomScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  late List<ChatMessageItem> _messages;
  bool _showEmojiPicker = false;

  @override
  void initState() {
    super.initState();
    _messages = [
      const ChatMessageItem(
        id: '1',
        text: ChatText.receivedMessage,
        time: '09:41 AM',
        isUser: false,
      ),
      const ChatMessageItem(
        id: '2',
        text: ChatText.sentMessage,
        time: '09:43 AM',
        isUser: true,
        isRead: true,
      ),
      const ChatMessageItem(
        id: '3',
        text: ChatText.receivedImageMessage,
        time: '09:45 AM',
        isUser: false,
        isImage: true,
      ),
      const ChatMessageItem(
        id: '4',
        text: ChatText.sentBrief,
        time: '09:46 AM',
        isUser: true,
        isBrief: true,
      ),
    ];
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    final now = DateTime.now();
    final timeStr = _formatTime(now);

    setState(() {
      _messages.add(
        ChatMessageItem(
          id: now.millisecondsSinceEpoch.toString(),
          text: text,
          time: timeStr,
          isUser: true,
          isRead: false,
        ),
      );
    });

    _messageController.clear();
    _scrollToBottom();
  }

  void _insertEmoji(String emoji) {
    final text = _messageController.text;
    final selection = _messageController.selection;
    if (selection.start >= 0) {
      final newText = text.replaceRange(selection.start, selection.end, emoji);
      _messageController.value = TextEditingValue(
        text: newText,
        selection: TextSelection.collapsed(
          offset: selection.start + emoji.length,
        ),
      );
    } else {
      _messageController.text += emoji;
    }
  }

  void _showAttachmentOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          margin: const EdgeInsets.all(12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppTheme.surface,
            border: Border.all(color: AppTheme.primary, width: 2.0),
            boxShadow: const [
              BoxShadow(
                color: AppTheme.primary,
                offset: Offset(4, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    '從本機上傳檔案 (REAL FILE UPLOAD)',
                    style: TextStyle(
                      fontFamily: 'Space Grotesk',
                      fontWeight: FontWeight.w900,
                      fontSize: 13,
                      letterSpacing: 0.25,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.close, size: 20),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              _buildAttachmentTile(
                icon: Icons.photo_library,
                title: '📷 上傳手機 / 電腦圖片檔案 (Upload Photo/Image)',
                color: AppTheme.accentYellow,
                onTap: () {
                  Navigator.pop(context);
                  _pickImageFile();
                },
              ),
              const SizedBox(height: 10),
              _buildAttachmentTile(
                icon: Icons.picture_as_pdf,
                title: '📄 上傳本機 PDF / 文件檔案 (Upload PDF/Doc File)',
                color: AppTheme.accentRed,
                textColor: Colors.white,
                onTap: () {
                  Navigator.pop(context);
                  _pickPdfFile();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAttachmentTile({
    required IconData icon,
    required String title,
    required Color color,
    Color textColor = AppTheme.primary,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: color,
          border: Border.all(color: AppTheme.primary, width: 1.5),
          boxShadow: const [
            BoxShadow(
              color: AppTheme.primary,
              offset: Offset(2.5, 2.5),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, color: textColor, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontFamily: 'Space Grotesk',
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  color: textColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickImageFile() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image =
          await picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        final bytes = await image.readAsBytes();
        final name = image.name;
        final sizeKb = (bytes.length / 1024).toStringAsFixed(1);
        final now = DateTime.now();

        setState(() {
          _messages.add(
            ChatMessageItem(
              id: now.millisecondsSinceEpoch.toString(),
              text: name,
              time: _formatTime(now),
              isUser: true,
              isImage: true,
              fileBytes: bytes,
              fileName: name,
              fileSizeStr: '$sizeKb KB',
            ),
          );
        });
        _scrollToBottom();
      }
    } catch (e) {
      debugPrint('Image pick error: $e');
    }
  }

  Future<void> _pickPdfFile() async {
    try {
      final files = await FilePicker.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx', 'txt'],
      );
      if (files.isNotEmpty) {
        final file = files.first;
        final name = file.name;
        final bytes = await file.readAsBytes();
        final sizeBytes = await file.length();
        final sizeKb = (sizeBytes / 1024).toStringAsFixed(1);
        final now = DateTime.now();

        setState(() {
          _messages.add(
            ChatMessageItem(
              id: now.millisecondsSinceEpoch.toString(),
              text: name,
              time: _formatTime(now),
              isUser: true,
              isDocument: true,
              fileBytes: bytes,
              fileName: name,
              fileSizeStr: '$sizeKb KB',
            ),
          );
        });
        _scrollToBottom();
      }
    } catch (e) {
      debugPrint('PDF pick error: $e');
    }
  }

  String _formatTime(DateTime time) {
    final hour =
        time.hour > 12 ? time.hour - 12 : (time.hour == 0 ? 12 : time.hour);
    final period = time.hour >= 12 ? 'PM' : 'AM';
    final minute = time.minute.toString().padLeft(2, '0');
    final formattedHour = hour.toString().padLeft(2, '0');
    return '$formattedHour:$minute $period';
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _showEmojiPickerModal() {
    final emojis = [
      '😊',
      '😂',
      '😍',
      '👍',
      '❤️',
      '🔥',
      '✨',
      '🎉',
      '🎨',
      '📐',
      '💼',
      '🚀',
      '🙌',
      '💯',
      '👏',
      '😎',
    ];
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          margin: const EdgeInsets.all(12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppTheme.surface,
            border: Border.all(color: AppTheme.primary, width: 2.0),
            boxShadow: const [
              BoxShadow(
                color: AppTheme.primary,
                offset: Offset(4, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    '選擇表情符號 (EMOJIS)',
                    style: TextStyle(
                      fontFamily: 'Space Grotesk',
                      fontWeight: FontWeight.w900,
                      fontSize: 13,
                      letterSpacing: 0.25,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.close, size: 20),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 8,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemCount: emojis.length,
                itemBuilder: (context, index) {
                  final emoji = emojis[index];
                  return GestureDetector(
                    onTap: () {
                      _insertEmoji(emoji);
                      Navigator.pop(context);
                    },
                    child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: AppTheme.primary, width: 1.5),
                        boxShadow: const [
                          BoxShadow(
                            color: AppTheme.primary,
                            offset: Offset(2.0, 2.0),
                          ),
                        ],
                      ),
                      child: Text(
                        emoji,
                        style: const TextStyle(fontSize: 18),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildEmojiPicker() {
    final emojis = ['😊', '👍', '❤️', '🔥', '✨', '🎨', '📐', '💼', '🎉', '🙌'];
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: const BoxDecoration(
        color: AppTheme.surface,
        border: Border(
          top: BorderSide(color: AppTheme.primary, width: 1.5),
        ),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: emojis.map((emoji) {
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: GestureDetector(
                onTap: () => _insertEmoji(emoji),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: AppTheme.primary, width: 1.5),
                    boxShadow: const [
                      BoxShadow(
                        color: AppTheme.primary,
                        offset: Offset(2.0, 2.0),
                      ),
                    ],
                  ),
                  child: Text(
                    emoji,
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.surface,
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(context),
            Expanded(
              child: Stack(
                children: [
                  _buildBackgroundDecorations(),
                  ListView(
                    controller: _scrollController,
                    padding: const EdgeInsets.fromLTRB(15, 16, 15, 100),
                    children: [
                      _buildDateHeader(_dateLabel(DateTime.now())),
                      const SizedBox(height: 16),
                      for (final msg in _messages) ...[
                        if (msg.isDocument)
                          _buildDocumentMessage(
                            fileName: msg.fileName ?? msg.text,
                            fileSize: msg.fileSizeStr ?? 'Document',
                            time: msg.time,
                            isUser: msg.isUser,
                          )
                        else if (msg.isImage && msg.fileBytes != null)
                          _buildMessageWithRealImage(
                            bytes: msg.fileBytes!,
                            fileName: msg.fileName ?? 'Uploaded Image',
                            time: msg.time,
                            isUser: msg.isUser,
                          )
                        else if (msg.isImage)
                          _buildReceivedMessageWithImage(
                            message: msg.text,
                            time: msg.time,
                          )
                        else if (msg.isBrief)
                          _buildSentMessageBrief(
                            message: msg.text,
                            time: msg.time,
                          )
                        else if (msg.isUser)
                          _buildSentMessage(
                            message: msg.text,
                            time: msg.time,
                            isRead: msg.isRead,
                          )
                        else
                          _buildReceivedMessage(
                            message: msg.text,
                            time: msg.time,
                          ),
                        const SizedBox(height: 16),
                      ],
                      _buildTypingIndicator(),
                    ],
                  ),
                ],
              ),
            ),
            if (_showEmojiPicker) _buildEmojiPicker(),
            _buildBottomBar(),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Container(
      height: AppTheme.appBarHeight + AppTheme.appBarDividerHeight,
      padding: const EdgeInsets.only(left: 12, right: 16),
      decoration: const BoxDecoration(
        color: AppTheme.surface,
        border: Border(
          bottom: BorderSide(
            color: AppTheme.primary,
            width: AppTheme.appBarDividerHeight,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: 48,
                height: 48,
                child: IconButton(
                  padding: EdgeInsets.zero,
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  icon: const Icon(
                    Icons.arrow_back,
                    color: AppTheme.primary,
                    size: 22,
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              const SizedBox(width: 2),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: AppTheme.primary,
                            width: 1.5,
                          ),
                          color: Colors.grey[300],
                        ),
                        child: const Icon(
                          Icons.person,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                      Positioned(
                        bottom: -2,
                        right: -2,
                        child: Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: Colors.greenAccent,
                            border: Border.all(
                              color: AppTheme.primary,
                              width: 1.25,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 9),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.contactName.toUpperCase(),
                        style: const TextStyle(
                          fontFamily: 'Space Grotesk',
                          fontWeight: FontWeight.w900,
                          fontSize: 13,
                          letterSpacing: 0,
                          height: 1.03,
                        ),
                      ),
                      const SizedBox(height: 1),
                      Text(
                        widget.contactStatus.toUpperCase(),
                        style: TextStyle(
                          fontFamily: 'Space Grotesk',
                          fontWeight: FontWeight.bold,
                          fontSize: 9,
                          letterSpacing: 0.25,
                          color: AppTheme.primary.withValues(alpha: 0.6),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: 36,
                height: 36,
                child: IconButton(
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  icon: const Icon(
                    Icons.videocam,
                    color: AppTheme.primary,
                    size: 22,
                  ),
                  onPressed: () {},
                ),
              ),
              SizedBox(
                width: 36,
                height: 36,
                child: IconButton(
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  icon: const Icon(
                    Icons.more_vert,
                    color: AppTheme.primary,
                    size: 22,
                  ),
                  onPressed: () {},
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDateHeader(String text) {
    return Center(
      child: Transform.rotate(
        angle: -0.05,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          decoration: BoxDecoration(
            color: AppTheme.primary,
            border: Border.all(color: AppTheme.primary, width: 1.5),
          ),
          child: Text(
            text,
            style: const TextStyle(
              fontFamily: 'Space Grotesk',
              fontWeight: FontWeight.bold,
              fontSize: 11,
              color: Colors.white,
              letterSpacing: 0.25,
            ),
          ),
        ),
      ),
    );
  }

  String _dateLabel(DateTime date) {
    final today = _dateOnly(DateTime.now());
    final target = _dateOnly(date);
    final difference = today.difference(target).inDays;

    if (difference == 0) {
      return ChatText.today;
    }
    if (difference == 1) {
      return '昨天';
    }
    return '${target.month}/${target.day}';
  }

  DateTime _dateOnly(DateTime date) =>
      DateTime(date.year, date.month, date.day);

  BoxDecoration _messageBubbleDecoration(Color color) {
    return BoxDecoration(
      color: color,
      border: Border.all(color: AppTheme.primary, width: 1.5),
      boxShadow: const [
        BoxShadow(
          color: AppTheme.primary,
          offset: AppTheme.hardShadowOffset,
          blurRadius: 0,
          spreadRadius: 0,
        ),
      ],
    );
  }

  Widget _buildReceivedMessage({
    required String message,
    required String time,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LayoutBuilder(
          builder: (context, constraints) {
            return ConstrainedBox(
              constraints: BoxConstraints(maxWidth: constraints.maxWidth * 0.8),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: _messageBubbleDecoration(Colors.white),
                child: Text(
                  message,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    height: 1.28,
                    letterSpacing: 0,
                  ),
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 6),
        Padding(
          padding: const EdgeInsets.only(left: 4),
          child: Text(
            time,
            style: TextStyle(
              fontFamily: 'Space Grotesk',
              fontWeight: FontWeight.bold,
              fontSize: 10,
              letterSpacing: 0.25,
              color: AppTheme.primary.withValues(alpha: 0.5),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSentMessage({
    required String message,
    required String time,
    bool isRead = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        LayoutBuilder(
          builder: (context, constraints) {
            return ConstrainedBox(
              constraints: BoxConstraints(maxWidth: constraints.maxWidth * 0.8),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: _messageBubbleDecoration(AppTheme.neutralLight),
                child: Text(
                  message,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    height: 1.28,
                    letterSpacing: 0,
                  ),
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 6),
        Padding(
          padding: const EdgeInsets.only(right: 4),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                time,
                style: TextStyle(
                  fontFamily: 'Space Grotesk',
                  fontWeight: FontWeight.bold,
                  fontSize: 10,
                  letterSpacing: 0.25,
                  color: AppTheme.primary.withValues(alpha: 0.5),
                ),
              ),
              if (isRead) ...[
                const SizedBox(width: 4),
                const Icon(
                  Icons.done_all,
                  size: 14,
                  color: AppTheme.accentBlue,
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDocumentMessage({
    required String fileName,
    required String fileSize,
    required String time,
    required bool isUser,
  }) {
    final bubbleColor = isUser ? AppTheme.neutralLight : Colors.white;
    return Column(
      crossAxisAlignment:
          isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        LayoutBuilder(
          builder: (context, constraints) {
            return ConstrainedBox(
              constraints:
                  BoxConstraints(maxWidth: constraints.maxWidth * 0.8),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: _messageBubbleDecoration(bubbleColor),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppTheme.accentRed,
                        border: Border.all(color: AppTheme.primary, width: 1.5),
                      ),
                      child: const Icon(
                        Icons.picture_as_pdf,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            fileName,
                            style: const TextStyle(
                              fontFamily: 'Space Grotesk',
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            fileSize,
                            style: TextStyle(
                              fontFamily: 'Space Grotesk',
                              fontSize: 10,
                              color: AppTheme.primary.withValues(alpha: 0.6),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.primary,
                        border: Border.all(color: AppTheme.primary, width: 1.0),
                      ),
                      child: const Text(
                        'PDF',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 9,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 6),
        Padding(
          padding: EdgeInsets.only(left: isUser ? 0 : 4, right: isUser ? 4 : 0),
          child: Text(
            time,
            style: TextStyle(
              fontFamily: 'Space Grotesk',
              fontWeight: FontWeight.bold,
              fontSize: 10,
              letterSpacing: 0.25,
              color: AppTheme.primary.withValues(alpha: 0.5),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMessageWithRealImage({
    required Uint8List bytes,
    required String fileName,
    required String time,
    required bool isUser,
  }) {
    return Column(
      crossAxisAlignment:
          isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        LayoutBuilder(
          builder: (context, constraints) {
            return ConstrainedBox(
              constraints:
                  BoxConstraints(maxWidth: constraints.maxWidth * 0.8),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: _messageBubbleDecoration(
                  isUser ? AppTheme.neutralLight : Colors.white,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      height: constraints.maxWidth * 0.55,
                      decoration: BoxDecoration(
                        border: Border.all(color: AppTheme.primary, width: 1.5),
                      ),
                      child: Image.memory(
                        bytes,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            const Center(
                          child: Icon(Icons.broken_image, size: 36),
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Text(
                        fileName,
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 6),
        Padding(
          padding: EdgeInsets.only(left: isUser ? 0 : 4, right: isUser ? 4 : 0),
          child: Text(
            time,
            style: TextStyle(
              fontFamily: 'Space Grotesk',
              fontWeight: FontWeight.bold,
              fontSize: 10,
              letterSpacing: 0.25,
              color: AppTheme.primary.withValues(alpha: 0.5),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildReceivedMessageWithImage({
    required String message,
    required String time,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LayoutBuilder(
          builder: (context, constraints) {
            return ConstrainedBox(
              constraints: BoxConstraints(maxWidth: constraints.maxWidth * 0.8),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: _messageBubbleDecoration(Colors.white),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      height: constraints.maxWidth * 0.5,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        border: Border.all(color: AppTheme.primary, width: 1.5),
                      ),
                      child: const Center(
                        child: Icon(Icons.image, size: 36, color: Colors.grey),
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: const BoxDecoration(
                        border: Border(
                          top: BorderSide(color: AppTheme.primary, width: 1.5),
                        ),
                      ),
                      child: Text(
                        message,
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          height: 1.28,
                          letterSpacing: 0,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 6),
        Padding(
          padding: const EdgeInsets.only(left: 4),
          child: Text(
            time,
            style: TextStyle(
              fontFamily: 'Space Grotesk',
              fontWeight: FontWeight.bold,
              fontSize: 10,
              letterSpacing: 0.25,
              color: AppTheme.primary.withValues(alpha: 0.5),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSentMessageBrief({
    required String message,
    required String time,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        LayoutBuilder(
          builder: (context, constraints) {
            return ConstrainedBox(
              constraints: BoxConstraints(maxWidth: constraints.maxWidth * 0.8),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: _messageBubbleDecoration(AppTheme.accentBlue),
                child: Text(
                  message,
                  style: const TextStyle(
                    fontFamily: 'Space Grotesk',
                    fontSize: 13,
                    color: Colors.white,
                    letterSpacing: 0,
                  ),
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 6),
        Padding(
          padding: const EdgeInsets.only(right: 4),
          child: Text(
            time,
            style: TextStyle(
              fontFamily: 'Space Grotesk',
              fontWeight: FontWeight.bold,
              fontSize: 10,
              letterSpacing: 0.25,
              color: AppTheme.primary.withValues(alpha: 0.5),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTypingIndicator() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          decoration: BoxDecoration(
            color: AppTheme.accentYellow,
            border: Border.all(color: AppTheme.primary, width: 1.5),
            boxShadow: const [
              BoxShadow(
                color: AppTheme.primary,
                offset: AppTheme.hardShadowOffset,
                blurRadius: 0,
                spreadRadius: 0,
              ),
            ],
          ),
          child: const _BouncingWhiteSquares(),
        ),
        const SizedBox(width: 10),
        const Text(
          '輸入中',
          style: TextStyle(
            fontFamily: 'Space Grotesk',
            fontWeight: FontWeight.w900,
            fontSize: 11,
            letterSpacing: 0.2,
            color: AppTheme.primary,
          ),
        ),
      ],
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 10),
      decoration: const BoxDecoration(
        color: AppTheme.surface,
        border: Border(top: BorderSide(color: AppTheme.primary, width: 1.5)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: AppTheme.primary, width: 1.5),
              boxShadow: const [
                BoxShadow(
                  color: AppTheme.primary,
                  offset: Offset(2.5, 2.5),
                ),
              ],
            ),
            child: IconButton(
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              icon: const Icon(Icons.add, size: 20, color: AppTheme.primary),
              onPressed: _showAttachmentOptions,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Container(
              height: 38,
              padding: const EdgeInsets.symmetric(horizontal: 6),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: AppTheme.primary, width: 1.5),
                boxShadow: const [
                  BoxShadow(
                    color: AppTheme.primary,
                    offset: Offset(2.5, 2.5),
                  ),
                ],
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      onSubmitted: (_) => _sendMessage(),
                      textInputAction: TextInputAction.send,
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                        color: AppTheme.primary,
                      ),
                      maxLines: 4,
                      minLines: 1,
                      decoration: InputDecoration(
                        hintText: ChatText.inputHint,
                        hintStyle: TextStyle(
                          fontFamily: 'Space Grotesk',
                          fontWeight: FontWeight.w500,
                          fontSize: 12,
                          letterSpacing: 0.25,
                          color: AppTheme.primary.withValues(alpha: 0.4),
                        ),
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 4,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: AppTheme.primary,
              border: Border.all(color: AppTheme.primary, width: 1.5),
              boxShadow: const [
                BoxShadow(
                  color: AppTheme.primary,
                  offset: Offset(2.5, 2.5),
                ),
              ],
            ),
            child: IconButton(
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              icon: const Icon(Icons.send, size: 18, color: Colors.white),
              onPressed: _sendMessage,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackgroundDecorations() {
    return Positioned.fill(
      child: Opacity(
        opacity: 0.1,
        child: Stack(
          children: [
            Positioned(
              top: 100,
              left: 20,
              child: Transform.rotate(
                angle: 0.2,
                child: Container(
                  width: 140,
                  height: 140,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    border: Border.all(color: AppTheme.primary, width: 1.5),
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 150,
              right: -50,
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  color: AppTheme.accentYellow,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppTheme.primary, width: 1.5),
                ),
              ),
            ),
            Positioned(
              top: 300,
              right: 50,
              child: Transform.rotate(
                angle: -0.5,
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: AppTheme.accentBlue,
                    border: Border.all(color: AppTheme.primary, width: 1.5),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BouncingWhiteSquares extends StatefulWidget {
  const _BouncingWhiteSquares();

  @override
  State<_BouncingWhiteSquares> createState() => _BouncingWhiteSquaresState();
}

class _BouncingWhiteSquaresState extends State<_BouncingWhiteSquares>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(3, (index) {
            final double step = index * 0.2;
            final double animVal = (_controller.value - step) % 1.0;
            final double bounce =
                animVal < 0.4 ? -3.5 * (1.0 - (animVal / 0.4 - 0.5).abs() * 2) : 0.0;

            return Padding(
              padding: EdgeInsets.only(right: index < 2 ? 4.0 : 0.0),
              child: Transform.translate(
                offset: Offset(0, bounce.clamp(-3.5, 0.0)),
                child: Container(
                  width: 7,
                  height: 7,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: AppTheme.primary, width: 1.0),
                  ),
                ),
              ),
            );
          }),
        );
      },
    );
  }
}

