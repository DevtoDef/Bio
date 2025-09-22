// Giới hạn chiều ngang “khung nội dung”
import 'package:flutter/material.dart';

const double kContentMaxWidth = 640;

/// Căn giữa và giới hạn bề ngang cho mọi khối nội dung
Widget centerWidget(Widget child) {
  return Center(
    child: ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: kContentMaxWidth),
      child: child,
    ),
  );
}
