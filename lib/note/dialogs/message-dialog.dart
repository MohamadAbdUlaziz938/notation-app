import 'package:flutter/material.dart';

showMessageDialog(BuildContext context, String message) {

  return showGeneralDialog(
      context: context,
      pageBuilder: (BuildContext buildContext, Animation<double> animation,
          Animation<double> secondaryAnimation) {
        //final Widget pageChild = Builder(builder: builder);
        return SafeArea(
          top: false,
          child: Builder(builder: (BuildContext context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20
                ),
              ),
              //content: text(message, singleLine: false),
              content: Text(message),
              contentPadding: EdgeInsets.fromLTRB(24, 20, 24, 0),
              actions: [
                RaisedButton(
                  color: Theme.of(context).buttonColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20
                    ),
                  ),
                  child: Text('Continue'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          }),
        );
      },

      barrierDismissible: false,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      //barrierColor: barrierColor ?? Colors.black54,
      //transitionDuration: duration ?? const Duration(milliseconds: 400),
      transitionDuration:  const Duration(milliseconds: 400),
      transitionBuilder: (BuildContext context, Animation<double> animation,
          Animation<double> secondaryAnimation, Widget child) {
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

      }

  );
}