import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tienda_app/styles/app_colors.dart';
import 'package:tienda_app/styles/text_styles.dart';

class BottomNavigatorTab extends StatelessWidget {
  final String title;
  final String iconPath;
  final bool isSelected;
  final VoidCallback? onTap;
  const BottomNavigatorTab({super.key,
    required this.title,
    required this.iconPath,
    this.isSelected = false,
    this.onTap
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        spacing: 4,
        children: [
          SvgPicture.asset(
              iconPath,
            colorFilter: ColorFilter.mode(isSelected ? AppColors.backgroundColor : AppColors.secondaryColor, BlendMode.srcIn),
          ),
          Text(
            title,
            style: AppTextStyles.textDescriptionStyle.copyWith(
              color: isSelected ? AppColors.backgroundColor : AppColors.secondaryColor
            )
          )
        ],
      ),
    );
  }
}
