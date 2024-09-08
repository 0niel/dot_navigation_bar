import 'package:dot_navigation_bar/dot_navigation_bar.dart';
import 'package:flutter/material.dart';

import 'DotNavigationBarItem.dart';

class Body extends StatelessWidget {
  const Body({
    super.key,
    required this.items,
    required this.currentIndex,
    required this.previousIndex,
    required this.curve,
    required this.duration,
    required this.selectedItemColor,
    required this.theme,
    required this.unselectedItemColor,
    required this.onTap,
    required this.itemPadding,
    required this.dotIndicatorColor,
    required this.enablePaddingAnimation,
    this.splashBorderRadius,
    this.splashColor,
  });

  final List<DotNavigationBarItem> items;
  final int currentIndex;
  final int previousIndex;
  final Curve curve;
  final Duration duration;
  final Color? selectedItemColor;
  final ThemeData theme;
  final Color? unselectedItemColor;
  final Function(int index) onTap;
  final EdgeInsets itemPadding;
  final Color? dotIndicatorColor;
  final bool enablePaddingAnimation;
  final Color? splashColor;
  final double? splashBorderRadius;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        for (final item in items)
          TweenAnimationBuilder<double>(
            tween: Tween(
              end: items.indexOf(item) == currentIndex ? 1.0 : 0.0,
            ),
            curve: curve,
            duration: duration,
            builder: (context, t, _) {
              final _selectedColor = item.selectedColor ?? selectedItemColor ?? theme.primaryColor;

              final _unselectedColor = item.unselectedColor ?? unselectedItemColor ?? theme.iconTheme.color;

              final int itemIndex = items.indexOf(item);
              final bool isMovingForward = currentIndex > previousIndex;
              final bool isCurrentItem = itemIndex == currentIndex;
              final bool isPreviousItem = itemIndex == previousIndex;

              Alignment alignment = Alignment.bottomCenter;
              if (isCurrentItem) {
                alignment = isMovingForward ? Alignment.bottomRight : Alignment.bottomLeft;
              } else if (isPreviousItem) {
                alignment = isMovingForward ? Alignment.bottomLeft : Alignment.bottomRight;
              }

              return Material(
                color: Color.lerp(Colors.transparent, Colors.transparent, t),
                borderRadius: BorderRadius.circular(splashBorderRadius ?? 8),
                clipBehavior: Clip.antiAlias,
                child: InkWell(
                  onTap: () => onTap.call(itemIndex),
                  focusColor: splashColor ?? _selectedColor.withOpacity(0.1),
                  highlightColor: splashColor ?? _selectedColor.withOpacity(0.1),
                  splashColor: splashColor ?? _selectedColor.withOpacity(0.1),
                  hoverColor: splashColor ?? _selectedColor.withOpacity(0.1),
                  child: Stack(
                    alignment: Alignment.center,
                    children: <Widget>[
                      Padding(
                        padding: itemPadding -
                            (enablePaddingAnimation ? EdgeInsets.only(right: itemPadding.right * t) : EdgeInsets.zero),
                        child: Row(
                          children: [
                            IconTheme(
                              data: IconThemeData(
                                color: Color.lerp(_unselectedColor, _selectedColor, t),
                                size: 24,
                              ),
                              child: item.icon,
                            ),
                          ],
                        ),
                      ),
                      ClipRect(
                        child: SizedBox(
                          height: 40,
                          child: Align(
                            alignment: alignment,
                            widthFactor: t,
                            child: Padding(
                              padding: EdgeInsetsDirectional.only(start: itemPadding.right, end: itemPadding.right),
                              child: CircleAvatar(
                                radius: 3.0,
                                backgroundColor: dotIndicatorColor != null ? dotIndicatorColor : _selectedColor,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
      ],
    );
  }
}
