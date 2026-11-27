import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/app_text.dart';
import '../../core/app_theme.dart';
import '../../core/neo_button.dart';

class DailyPlannerScreen extends StatefulWidget {
  const DailyPlannerScreen({super.key});

  @override
  State<DailyPlannerScreen> createState() => _DailyPlannerScreenState();
}

class _DailyPlannerScreenState extends State<DailyPlannerScreen> {
  final List<String> _headers = PlannerText.headers;
  late List<List<TextEditingController>> _taskControllersByCategory;
  late List<List<bool>> _checkedStatesByCategory;
  late List<List<FocusNode>> _taskFocusNodesByCategory;
  late List<int> _categoryDisplayOrder;
  bool _isFocusMode = true;

  @override
  void initState() {
    super.initState();
    _categoryDisplayOrder = [0, 1, 2, 3, 4];
    _taskControllersByCategory = [
      [
        for (final task in PlannerText.sampleTasks[0])
          SpacedTextEditingController(text: task),
      ],
      [
        for (final task in PlannerText.sampleTasks[1])
          SpacedTextEditingController(text: task),
      ],
      [
        for (final task in PlannerText.sampleTasks[2])
          SpacedTextEditingController(text: task),
      ],
      [
        for (final task in PlannerText.sampleTasks[3])
          SpacedTextEditingController(text: task),
      ],
      [
        for (final task in PlannerText.sampleTasks[4])
          SpacedTextEditingController(text: task),
      ],
    ];
    _checkedStatesByCategory = [
      [false, false],
      [false, false, false],
      [false, false, false],
      [false, false, false],
      [false, false, false],
    ];
    _taskFocusNodesByCategory = List.generate(
      _headers.length,
      (catIdx) => List.generate(
        _taskControllersByCategory[catIdx].length,
        (taskIdx) => _createFocusNode(catIdx, taskIdx),
      ),
    );
  }

  FocusNode _createFocusNode(int categoryIndex, int taskIndex) {
    final node = FocusNode();
    node.onKeyEvent = (node, event) {
      if (event is KeyDownEvent &&
          event.logicalKey == LogicalKeyboardKey.backspace) {
        final controller = _taskControllersByCategory[categoryIndex][taskIndex];
        if (controller.selection.baseOffset == 0) {
          _removeTaskRow(categoryIndex: categoryIndex, taskIndex: taskIndex);
          return KeyEventResult.handled;
        }
      }
      return KeyEventResult.ignored;
    };
    return node;
  }

  @override
  void dispose() {
    for (final category in _taskControllersByCategory) {
      for (final controller in category) {
        controller.dispose();
      }
    }
    for (final category in _taskFocusNodesByCategory) {
      for (final node in category) {
        node.dispose();
      }
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!AppTheme.isDesigner) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacementNamed(context, '/discovery_feed');
      });
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final now = DateTime.now();
    final weekdays = ['MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT', 'SUN'];
    final months = [
      'JAN',
      'FEB',
      'MAR',
      'APR',
      'MAY',
      'JUN',
      'JUL',
      'AUG',
      'SEP',
      'OCT',
      'NOV',
      'DEC',
    ];

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: const ObscureAppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(15, 25, 15, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SpacedText(
                '${now.month}/${now.day} ${weekdays[now.weekday - 1]}',
                style: const TextStyle(
                  fontFamily: 'Space Grotesk',
                  fontWeight: FontWeight.w900,
                  fontSize: 56,
                  height: 0.94,
                  letterSpacing: -2,
                ),
              ),
              const SizedBox(height: 12),
              SpacedText(
                '${now.year} ${months[now.month - 1]}',
                style: const TextStyle(
                  fontFamily: 'Space Grotesk',
                  fontWeight: FontWeight.w800,
                  fontSize: 12,
                  letterSpacing: 0.5,
                  height: 0.94,
                ),
              ),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: () => setState(() => _isFocusMode = !_isFocusMode),
                child: Container(
                  width: double.infinity,
                  decoration: NeoBoxDecoration(
                    color: _isFocusMode ? AppTheme.primary : AppTheme.surface,
                  ),
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 14,
                  ),
                  child: SpacedText(
                    _isFocusMode ? PlannerText.focusOn : PlannerText.focusOff,
                    style: TextStyle(
                      color: _isFocusMode ? Colors.white : AppTheme.primary,
                      fontFamily: 'Space Grotesk',
                      fontWeight: FontWeight.w900,
                      fontSize: 13,
                      letterSpacing: 0,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 6),
              const Divider(color: AppTheme.primary, thickness: 2),
              const SizedBox(height: 10),
              ..._categoryDisplayOrder.map((catIndex) {
                final isLast = catIndex == _categoryDisplayOrder.last;
                return Column(
                  children: [
                    _buildCategorizedSection(catIndex),
                    if (!isLast) const SizedBox(height: 10),
                  ],
                );
              }),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
      bottomNavigationBar: ObscureNavBar(
        pageContext: context,
        activeRoute: '/daily_planner',
      ),
    );
  }

  Widget _buildCategorizedSection(int index) {
    switch (index) {
      case 0:
        return _buildCategoryItem(
          0,
          headerColor: Colors.white,
          boxColor: AppTheme.accentRed,
          textColor: Colors.white,
        );
      case 1:
        return _buildCategoryItem(1, boxColor: AppTheme.accentYellow);
      case 2:
        return _buildCategoryItem(
          2,
          boxColor: AppTheme.accentBlue,
          headerColor: Colors.white,
          textColor: Colors.white,
        );
      case 3:
        return _buildCategoryItem(3, boxColor: AppTheme.surface);
      case 4:
        return _buildCategoryItem(
          4,
          boxColor: AppTheme.primary,
          headerColor: Colors.white,
          textColor: Colors.white,
        );
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildCategoryItem(
    int index, {
    Color? headerColor,
    Color? boxColor,
    Color? textColor,
  }) {
    return Container(
      decoration: NeoBoxDecoration(color: boxColor ?? AppTheme.surface),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SpacedText(
            _headers[index],
            style: TextStyle(
              fontFamily: 'Space Grotesk',
              fontWeight: FontWeight.w900,
              fontSize: 15,
              color: headerColor ?? AppTheme.primary,
              letterSpacing: 0,
            ),
          ),
          const SizedBox(height: 8),
          Column(
            children: List.generate(_taskControllersByCategory[index].length, (
              taskIndex,
            ) {
              final isChecked = _checkedStatesByCategory[index][taskIndex];
              final isLastItem =
                  taskIndex == _taskControllersByCategory[index].length - 1;
              final displayTextColor = textColor ?? AppTheme.primary;

              return Padding(
                padding: const EdgeInsets.only(bottom: 7),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    if (!isLastItem) ...[
                      NeoButton(
                        onTap: () => _toggleChecked(index, taskIndex),
                        color: isChecked ? AppTheme.accentYellow : Colors.white,
                        depth: 3,
                        borderWidth: AppStroke.regular,
                        child: Container(
                          width: 18,
                          height: 18,
                          alignment: Alignment.center,
                          child: isChecked
                              ? const Icon(
                                  Icons.check,
                                  size: 12,
                                  color: AppTheme.primary,
                                )
                              : null,
                        ),
                      ),
                      const SizedBox(width: 10),
                    ] else ...[
                      const SizedBox(width: 8),
                    ],
                    Expanded(
                      child: TextField(
                        focusNode: _taskFocusNodesByCategory[index][taskIndex],
                        controller:
                            _taskControllersByCategory[index][taskIndex],
                        minLines: 1,
                        maxLines: 1,
                        textInputAction: TextInputAction.done,
                        style: TextStyle(
                          fontFamily: 'Space Grotesk',
                          fontWeight: FontWeight.w800,
                          fontSize: 12,
                          color: isChecked
                              ? displayTextColor.withValues(alpha: 0.5)
                              : displayTextColor,
                          decoration: isChecked
                              ? TextDecoration.lineThrough
                              : null,
                          letterSpacing: 0,
                        ),
                        decoration: InputDecoration(
                          hintText: isLastItem ? PlannerText.add : null,
                          hintStyle: TextStyle(letterSpacing: kSmallChineseLetterSpacing,
                            color: displayTextColor.withValues(alpha: 0.4),
                            fontSize: 12,
                          ),
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                        ),
                        onChanged: (_) => _updateCategoryOrdering(),
                        onSubmitted: (_) => _addTaskRow(categoryIndex: index),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  void _toggleChecked(int categoryIndex, int taskIndex) {
    setState(() {
      final isChecked = !_checkedStatesByCategory[categoryIndex][taskIndex];
      _checkedStatesByCategory[categoryIndex][taskIndex] = isChecked;
      if (isChecked) {
        final controller = _taskControllersByCategory[categoryIndex].removeAt(
          taskIndex,
        );
        final checked = _checkedStatesByCategory[categoryIndex].removeAt(
          taskIndex,
        );
        final focus = _taskFocusNodesByCategory[categoryIndex].removeAt(
          taskIndex,
        );
        final lastBlankIndex = _taskControllersByCategory[categoryIndex]
            .indexWhere((controller) => controller.text.isEmpty);
        final insertIndex = lastBlankIndex == -1
            ? _taskControllersByCategory[categoryIndex].length
            : lastBlankIndex;
        _taskControllersByCategory[categoryIndex].insert(
          insertIndex,
          controller,
        );
        _checkedStatesByCategory[categoryIndex].insert(insertIndex, checked);
        _taskFocusNodesByCategory[categoryIndex].insert(insertIndex, focus);
      }
    });
    _updateCategoryOrdering();
  }

  void _addTaskRow({required int categoryIndex}) {
    setState(() {
      _taskControllersByCategory[categoryIndex].add(
        SpacedTextEditingController(text: ''),
      );
      _checkedStatesByCategory[categoryIndex].add(false);
      _taskFocusNodesByCategory[categoryIndex].add(
        _createFocusNode(
          categoryIndex,
          _taskControllersByCategory[categoryIndex].length - 1,
        ),
      );
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final newIndex = _taskControllersByCategory[categoryIndex].length - 1;
      if (newIndex >= 0 &&
          newIndex < _taskFocusNodesByCategory[categoryIndex].length) {
        _taskFocusNodesByCategory[categoryIndex][newIndex].requestFocus();
      }
    });
    _updateCategoryOrdering();
  }

  void _removeTaskRow({required int categoryIndex, required int taskIndex}) {
    if (_taskControllersByCategory[categoryIndex].length <= 1) {
      setState(() {
        _taskControllersByCategory[categoryIndex][0].clear();
        _checkedStatesByCategory[categoryIndex][0] = false;
      });
      _updateCategoryOrdering();
      return;
    }

    final removedController =
        _taskControllersByCategory[categoryIndex][taskIndex];
    final removedFocusNode =
        _taskFocusNodesByCategory[categoryIndex][taskIndex];
    setState(() {
      _taskControllersByCategory[categoryIndex].removeAt(taskIndex);
      _checkedStatesByCategory[categoryIndex].removeAt(taskIndex);
      _taskFocusNodesByCategory[categoryIndex].removeAt(taskIndex);
      removedController.dispose();
      removedFocusNode.dispose();
    });
    _updateCategoryOrdering();
  }

  void _updateCategoryOrdering() {
    setState(() {
      final active = <int>[];
      final empty = <int>[];
      for (var i = 0; i < _headers.length; i++) {
        final hasText = _taskControllersByCategory[i].any(
          (controller) => controller.text.trim().isNotEmpty,
        );
        if (hasText) {
          active.add(i);
        } else {
          empty.add(i);
        }
      }
      _categoryDisplayOrder = [...active, ...empty];
    });
  }
}
