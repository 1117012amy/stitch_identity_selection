import 'package:flutter/material.dart';
import '../../core/app_text.dart';
import '../../core/app_theme.dart';
import 'chat_room_screen.dart';

class MessageInboxScreen extends StatelessWidget {
  const MessageInboxScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const ObscureAppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Search Bar
              Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppTheme.surface,
                        border: Border.all(color: AppTheme.primary, width: 1.5),
                        boxShadow: const [
                          BoxShadow(
                            color: AppTheme.primary,
                            offset: AppTheme.hardShadowOffset,
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.search,
                            color: AppTheme.primary,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextField(
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: AppTheme.isDesigner
                                    ? MessageText.designerSearchHint
                                    : MessageText.customerSearchHint,
                                hintStyle: const TextStyle(letterSpacing: kSmallChineseLetterSpacing,
                                  fontFamily: 'Space Grotesk',
                                  fontSize: 12,
                                ),
                                isDense: true,
                                contentPadding: EdgeInsets.zero,
                              ),
                              style: const TextStyle(
                                fontFamily: 'Space Grotesk',
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: AppTheme.accentYellow,
                      border: Border.all(color: AppTheme.primary, width: 1.5),
                      boxShadow: const [
                        BoxShadow(
                          color: AppTheme.primary,
                          offset: AppTheme.hardShadowOffset,
                        ),
                      ],
                    ),
                    child: IconButton(
                      icon: const Icon(
                        Icons.filter_list,
                        color: AppTheme.primary,
                        size: 20,
                      ),
                      onPressed: () {},
                      padding: const EdgeInsets.all(8),
                      constraints: const BoxConstraints(),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Messages
              if (AppTheme.isDesigner) ...[
                _buildMessageItem(
                  context,
                  name: MessageText.designerMessages[0].name,
                  time: MessageText.designerMessages[0].time,
                  subject: MessageText.designerMessages[0].subject,
                  message: MessageText.designerMessages[0].message,
                  isActive: true,
                  unreadCount: 2,
                ),
                const SizedBox(height: 10),
                _buildMessageItem(
                  context,
                  name: MessageText.designerMessages[1].name,
                  time: MessageText.designerMessages[1].time,
                  subject: MessageText.designerMessages[1].subject,
                  message: MessageText.designerMessages[1].message,
                ),
                const SizedBox(height: 10),
                _buildMessageItem(
                  context,
                  name: MessageText.designerMessages[2].name,
                  time: MessageText.designerMessages[2].time,
                  subject: MessageText.designerMessages[2].subject,
                  message: MessageText.designerMessages[2].message,
                ),
                const SizedBox(height: 10),
                _buildMessageItemSystem(context),
              ] else ...[
                _buildMessageItem(
                  context,
                  name: MessageText.customerMessages[0].name,
                  time: MessageText.customerMessages[0].time,
                  subject: MessageText.customerMessages[0].subject,
                  message: MessageText.customerMessages[0].message,
                  isActive: true,
                  unreadCount: 1,
                ),
                const SizedBox(height: 10),
                _buildMessageItemSystem(context),
              ],
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
      floatingActionButton: AppTheme.isDesigner
          ? FloatingActionButton(
              onPressed: () {},
              backgroundColor: AppTheme.accentRed,
              foregroundColor: Colors.white,
              mini: true,
              shape: const RoundedRectangleBorder(
                side: BorderSide(color: AppTheme.primary, width: 1.5),
                borderRadius: BorderRadius.zero,
              ),
              child: const Icon(Icons.edit, size: 22),
            )
          : null,
      bottomNavigationBar: ObscureNavBar(
        pageContext: context,
        activeRoute: '/message_inbox',
      ),
    );
  }

  Widget _buildMessageItem(
    BuildContext context, {
    required String name,
    required String time,
    required String subject,
    required String message,
    bool isActive = false,
    int unreadCount = 0,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                ChatRoomScreen(contactName: name, contactStatus: 'Online'),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: AppTheme.surface,
          border: Border.all(
            color: AppTheme.primary,
            width: isActive ? 2.5 : 1.5,
          ),
          boxShadow: isActive
              ? const [
                  BoxShadow(
                    color: AppTheme.primary,
                    offset: AppTheme.hardShadowOffset,
                  ),
                ]
              : null,
        ),
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    border: Border.all(color: AppTheme.primary, width: 1.5),
                    color: Colors.grey.shade300,
                  ),
                  child: const Icon(
                    Icons.person,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
                if (unreadCount > 0)
                  Positioned(
                    bottom: -3,
                    right: -3,
                    child: Container(
                      width: 18,
                      height: 18,
                      decoration: BoxDecoration(
                        color: AppTheme.accentYellow,
                        border: Border.all(color: AppTheme.primary, width: 1.0),
                      ),
                      alignment: Alignment.center,
                      child: SpacedText(
                        '$unreadCount',
                        style: const TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 9,
                          letterSpacing: 0,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: SpacedText(
                          name,
                          style: const TextStyle(
                            fontFamily: 'Space Grotesk',
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                            letterSpacing: 0,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      SpacedText(
                        time,
                        style: TextStyle(
                          fontFamily: 'Space Grotesk',
                          fontWeight: FontWeight.bold,
                          fontSize: 10,
                          color: AppTheme.primary.withValues(
                            alpha: isActive ? 1.0 : 0.5,
                          ),
                          letterSpacing: 0,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  SpacedText(
                    subject,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 11,
                      color: isActive ? AppTheme.accentRed : AppTheme.primary,
                      letterSpacing: 0,
                    ),
                  ),
                  const SizedBox(height: 2),
                  SpacedText(
                    message,
                    style: TextStyle(
                      fontSize: 11,
                      color: AppTheme.primary.withValues(
                        alpha: isActive ? 1.0 : 0.6,
                      ),
                      letterSpacing: 0,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 4),
            Icon(
              Icons.chevron_right,
              color: AppTheme.primary.withValues(alpha: isActive ? 1.0 : 0.3),
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageItemSystem(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const ChatRoomScreen(
              contactName: 'SYSTEM',
              contactStatus: 'Automated Message',
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: AppTheme.surface,
          border: Border.all(color: AppTheme.primary, width: 1.0),
        ),
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppTheme.accentBlue,
                border: Border.all(color: AppTheme.primary, width: 1.5),
              ),
              child: const Icon(
                Icons.corporate_fare,
                color: Colors.white,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Expanded(
                        child: SpacedText(
                          MessageText.systemName,
                          style: TextStyle(
                            fontFamily: 'Space Grotesk',
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                            letterSpacing: 0,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      SpacedText(
                        MessageText.systemTime,
                        style: TextStyle(
                          fontFamily: 'Space Grotesk',
                          fontWeight: FontWeight.bold,
                          fontSize: 10,
                          color: AppTheme.primary.withValues(alpha: 0.5),
                          letterSpacing: 0,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  const SpacedText(
                    MessageText.systemSubject,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 11,
                      letterSpacing: 0,
                    ),
                  ),
                  const SizedBox(height: 2),
                  SpacedText(
                    MessageText.systemMessage,
                    style: TextStyle(
                      fontSize: 11,
                      color: AppTheme.primary.withValues(alpha: 0.6),
                      letterSpacing: 0,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 4),
            Icon(
              Icons.chevron_right,
              color: AppTheme.primary.withValues(alpha: 0.3),
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
