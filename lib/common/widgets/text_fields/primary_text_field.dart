import 'package:flutter/material.dart';
import 'package:tienda_app/styles/app_colors.dart';
import 'package:tienda_app/styles/text_styles.dart';

class PrimaryTextField extends StatelessWidget {
  final String hintText;
  final String labelText;
  final TextInputType? keyboardType;
  final bool isPassword;
  final TextEditingController controller;
  final IconData? suffixIcon;

  const PrimaryTextField({
    super.key,
    required this.hintText,
    required this.labelText,
    this.keyboardType,
    this.isPassword = false,
    required this.controller,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(12)),
        color: AppColors.neutralColor.withValues(alpha: 0.40),
      ),
      child: TextField(
        controller: controller,
        enabled: true, 
        readOnly: false,
        decoration: InputDecoration(
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          
          hintText: hintText,
          hintStyle: AppTextStyles.textHintStyle,
          labelText: labelText,
          labelStyle: AppTextStyles.textLabelStyle,
          
          suffixIcon: suffixIcon != null 
              ? Icon(suffixIcon, color: AppColors.neutralColor) 
              : null,
        ),
        style: AppTextStyles.textFieldStyle,
        keyboardType: keyboardType,
        obscureText: isPassword,
      ),
    );
  }
}