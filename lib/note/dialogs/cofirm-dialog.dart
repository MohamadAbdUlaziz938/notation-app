import 'package:flutter/material.dart';
import 'package:note/utils/text.dart';
//import 'package:bedrive/utils/text.dart';
enum DialogTransitionType {
  fade,
  slideFromTop,
  slideFromTopFade,
  slideFromBottom,
  slideFromBottomFade,
  slideFromLeft,
  slideFromLeftFade,
  slideFromRight,
  slideFromRightFade,
  scale,
  fadeScale,
  rotate,
  scaleRotate,
  fadeRotate,
  rotate3D,
  size,
  sizeFade,
  none,
}
Future<bool> showConfirmationDialog(
    BuildContext context,
    {
      @required String title,
      @required String subtitle,
      String cancelText = 'Cancel',
      String confirmText = 'Confirm',
      animationType = DialogTransitionType.fadeScale,
    }
    ) {
  return showGeneralDialog(
      context: context,
      pageBuilder: (BuildContext buildContext, Animation<double> animation,
          Animation<double> secondaryAnimation) {
        //final Widget pageChild = Builder(builder: builder);
        return SafeArea(
          top: false,
          child: Builder(builder: (BuildContext context) {
            return    AlertDialog(

              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20
                ),
              ),

              title: text(title),
              content: text(subtitle, singleLine: false),
              actions: [
                FlatButton(
                  //color: Colors.white,
                  textColor: Theme.of(context).textTheme.bodyText2.color,
                  child: text(confirmText=="Restore"?cancelText:confirmText),
                  onPressed: () {
                    confirmText=="Restore"?Navigator.of(context).pop(null):Navigator.of(context).pop(true);
                  },

                ),
                RaisedButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20
                    ),

                  ),
                  //color: ,
                  color: Theme.of(context).buttonColor,
                  child: text(confirmText=="Restore"?confirmText:cancelText),
                  onPressed: () {
                    confirmText=="Restore"?Navigator.of(context).pop(true):Navigator.of(context).pop(null);
                    //Navigator.of(context).pop(null);
                  },
                ),
              ],
            );
          }),
        );
      },
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      //barrierColor: barrierColor ?? Colors.black54,
      //transitionDuration: duration ?? const Duration(milliseconds: 400),
      transitionDuration:  const Duration(milliseconds: 400),
      transitionBuilder: (BuildContext context, Animation<double> animation,
          Animation<double> secondaryAnimation, Widget child) {
        switch(animationType ){
          case DialogTransitionType.fadeScale:
            return ScaleTransition(
              //transformHitTests: false,
              scale:CurvedAnimation(
                parent: animation,
                curve: Interval(
                  0.5,
                  0.9,
                  curve: Curves.easeInOutBack,
                ),
              ),
              child:FadeTransition(
                opacity: CurvedAnimation(
                  parent: animation,
                  curve: Curves.linear,
                ),
                child: child,
              ),
            );
          case DialogTransitionType.slideFromBottomFade:
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0.0, 1.0),
                end: Offset.zero,
              ).chain(CurveTween(curve: Curves.easeInOutBack)).animate(animation),
              child: FadeTransition(
                opacity: animation,
                child: child,
              ),
            );
          default:
            return FadeTransition(opacity: animation, child: child);
        }

      }

  );
}