import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class AppTextField extends StatelessWidget {
  final String hint;
  final IconData? icon;
  final Widget? suffix;
  final VoidCallback? onTap;
  final bool readOnly;

  const AppTextField({
    super.key,
    required this.hint,
    this.icon,
    this.suffix,
    this.onTap,
    this.readOnly = true,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      readOnly: readOnly,
      onTap: onTap,
      decoration: appInputDecoration(hint: hint, icon: icon, suffix: suffix),
    );
  }
}
