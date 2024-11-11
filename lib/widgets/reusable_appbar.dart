import 'package:flutter/material.dart';
import 'package:shopease/constants/color_const.dart';

class ReusableAppBar extends StatelessWidget {
  final IconData leadingIcon;
  final IconData actionIcons;
  final Color? backgroundColor;
  final bool isHome;
  final void Function()? onActionTap;
  final void Function()? onLeadingTap;
  const ReusableAppBar({
    super.key,
    required this.leadingIcon,
    required this.actionIcons,
    this.onActionTap,
    this.onLeadingTap,
    required this.isHome, this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: GestureDetector(
        onTap: onLeadingTap ??
            (isHome == true
                ? null
                : () {
                    Navigator.pop(context);
                  }),
        child: Icon(
          leadingIcon,
          color: primaryTextColor,
        ),
      ),
      scrolledUnderElevation: 0,
      elevation: 0,
      backgroundColor: backgroundColor ?? transparent,
      actions: [
        IconButton(
          onPressed: onActionTap,
          icon: Icon(
            actionIcons,
            color: primaryTextColor,
          ),
        ),
      ],
    );
  }
}
