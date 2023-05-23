import 'package:flutter/material.dart';

enum AppButtonType{
  outlined, filled, duoTone;
}
enum AppButtonSize{
  small,
  normal,
  large;
}

class AppButton extends StatelessWidget{
  final double? height;
  final double? width;
  final String? label;
  final IconData? icon;
  final Color? color;
  final BorderRadius? borderRadius;
  final VoidCallback? onPressed;
  final VoidCallback? onLongPress;
  final AppButtonType? type;
  final AppButtonSize? size;
  final double? iconSize;
  final TextStyle? labelStyle;
  final bool? isFullWidth;
  const AppButton({
    super.key,
    this.label,
    this.icon,
    this.color,
    this.onPressed,
    this.onLongPress,
    this.height,
    this.width,
    this.borderRadius,
    this.type = AppButtonType.filled,
    this.size = AppButtonSize.normal,
    this.iconSize,
    this.labelStyle,
    this.isFullWidth,
  });
  @override
  Widget build(BuildContext context) {
    bool isDarkMode = MediaQuery.of(context).platformBrightness == Brightness.dark;
    Color fallBackColor = color ?? (isDarkMode ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.primary);
    Color typoColor = Colors.transparent;
    Color backgroundColor = Colors.transparent;
    Color borderColor = Colors.transparent;
    Color splashColor = Colors.transparent;
    double borderWidth = 0;
    //for  filled button
    if(type == AppButtonType.filled){
      typoColor = Colors.white;
      backgroundColor = color ?? Theme.of(context).colorScheme.primary;
      borderColor = Colors.transparent;
      splashColor = Colors.white.withAlpha(100);
    }

    //for duoTone
    if(type == AppButtonType.duoTone){
      typoColor = fallBackColor;
      backgroundColor = (fallBackColor).withAlpha(40);
      borderColor = fallBackColor.withAlpha(10);
      splashColor = (fallBackColor).withAlpha(100);
      borderWidth = 1.5;
    }

    //for outlined button
    if(type == AppButtonType.outlined){
      typoColor = fallBackColor;
      backgroundColor = Colors.transparent;
      borderColor = fallBackColor;
      splashColor = (fallBackColor).withAlpha(20);
      borderWidth = 1.5;
    }



    //for size
    double dimension = 0;

    switch(size){
      case AppButtonSize.small: dimension = 30 ; break;
      case AppButtonSize.normal: dimension = 40 ; break;
      case AppButtonSize.large: dimension = 55 ;break;
      default: break;
    }
    dimension = height ?? dimension;


    double paddingStart = dimension*0.6;
    double paddingEnd = dimension*0.6;

    if(icon != null){
      paddingStart = dimension*0.5;
    }
    EdgeInsets padding = EdgeInsets.only(left: paddingStart, right: paddingEnd);
    if(width != null){
      padding = EdgeInsets.zero;
    }

    return
      ConstrainedBox(
          constraints:  BoxConstraints(
              minWidth: isFullWidth?? false ? double.infinity : width??dimension,
              minHeight: dimension,
              maxWidth: width ?? double.infinity
          ),
          child:  IntrinsicWidth(
              child:MaterialButton(
                color: backgroundColor,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                disabledColor: backgroundColor.withAlpha(50),
                onPressed: onPressed,
                onLongPress: onLongPress,
                minWidth: dimension,
                padding: padding,
                height: dimension,
                elevation: 0,
                focusElevation: 0,
                highlightElevation: 0,
                hoverElevation: 0,
                shape:  RoundedRectangleBorder(
                    borderRadius: borderRadius ?? BorderRadius.circular(dimension * 0.35),
                    side: BorderSide(
                        width: borderWidth,
                        color: borderColor
                    )
                ),
                splashColor: splashColor,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    icon != null ? Icon(icon, color: typoColor, size: iconSize ?? (dimension - (dimension*(55/100))),) : const SizedBox(),
                    icon != null && label!= null ? SizedBox(width: dimension*0.3,) : const SizedBox(),
                    label!= null ?Text(label??"" ,style: TextStyle(color: typoColor).merge(labelStyle),): const SizedBox()
                  ],
                ),
              )
          )
      );
  }
}