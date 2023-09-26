import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../../models/skills/skills.dart';

import '../results/widgets/result_item_widget.dart';

class ScrollableWidget extends StatefulWidget {
  final List<dynamic> list;
  final String type;
  final bool scrollable;
  final Color? bgColor;

  const ScrollableWidget(
      {super.key,
      required this.list,
      required this.type,
      this.bgColor,
      this.scrollable = true});

  @override
  State<ScrollableWidget> createState() => _ScrollableWidgetState();
}

class _ScrollableWidgetState extends State<ScrollableWidget> {
  @override
  Widget build(BuildContext context) {
    return ReorderableListView.builder(
      itemBuilder: (context, index) {
        return Container(
          key: Key("$index"),
          color: widget.bgColor ?? AppColors.black9007c,
          child: Column(
            children: [
              ResultItemWidget(
                skill: widget.list[index] as Skills,
                index: index + 1,
                bgColor: widget.bgColor,
              ),
              if (index != widget.list.length - 1)
                SizedBox(
                  height: getVerticalSize(7),
                )
            ],
          ),
        );
      },
      itemCount: widget.list.length,
      physics: const NeverScrollableScrollPhysics(),
      proxyDecorator: (Widget child, int index, Animation<double> animation) {
        return Material(
          color: Colors.transparent,
          child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(getSize(20))),
            child: Container(color: Colors.transparent, child: child),
          ),
        );
      },
      onReorder: (int start, int current) {
        // dragging from top to bottom
        if (widget.scrollable) {
          scrollableFunction(start, current);
        }
      },
    );
  }

  void scrollableFunction(int start, int current) {
    if (start < current) {
      int end = current - 1;
      dynamic startItem = widget.list[start];
      int i = 0;
      int local = start;
      do {
        widget.list[local] = widget.list[++local];
        i++;
      } while (i < end - start);
      widget.list[end] = startItem;
    }
    // dragging from bottom to top
    else if (start > current) {
      dynamic startItem = widget.list[start];
      for (int i = start; i > current; i--) {
        widget.list[i] = widget.list[i - 1];
      }
      widget.list[current] = startItem;
    }
    setState(() {});
  }
}
