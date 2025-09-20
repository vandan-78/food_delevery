import 'package:flutter/material.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:another_flushbar/flushbar_route.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Utils {
  // Toast Messages with modern styling
  static void toastMessage(String message, {ToastType type = ToastType.info}) {
    Color backgroundColor;
    Color textColor;
    IconData? icon;

    switch (type) {
      case ToastType.success:
        backgroundColor = const Color(0xFF00C853);
        textColor = Colors.white;
        icon = Icons.check_circle;
        break;
      case ToastType.error:
        backgroundColor = const Color(0xFFD50000);
        textColor = Colors.white;
        icon = Icons.error;
        break;
      case ToastType.warning:
        backgroundColor = const Color(0xFFFFAB00);
        textColor = Colors.black;
        icon = Icons.warning;
        break;
      case ToastType.info:
      default:
        backgroundColor = const Color(0xFF2979FF);
        textColor = Colors.white;
        icon = Icons.info;
        break;
    }

    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: backgroundColor,
      textColor: textColor,
      fontSize: 16.0,
      webPosition: "center",
      webBgColor: backgroundColor.value.toRadixString(16).substring(2),
      timeInSecForIosWeb: 2,
    );
  }

  // Flushbar without title
  static void flushbarErrorMessage(String message, BuildContext context,
      {FlushbarType type = FlushbarType.error}) {
    Color backgroundColor;
    Color textColor;
    IconData icon;

    switch (type) {
      case FlushbarType.success:
        backgroundColor = const Color(0xFF00C853);
        textColor = Colors.white;
        icon = Icons.check_circle;
        break;
      case FlushbarType.error:
        backgroundColor = const Color(0xFFD50000);
        textColor = Colors.white;
        icon = Icons.error;
        break;
      case FlushbarType.warning:
        backgroundColor = const Color(0xFFFFAB00);
        textColor = Colors.black;
        icon = Icons.warning;
        break;
      case FlushbarType.info:
      default:
        backgroundColor = const Color(0xFF2979FF);
        textColor = Colors.white;
        icon = Icons.info;
        break;
    }

    showFlushbar(
      context: context,
      flushbar: Flushbar(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        padding: const EdgeInsets.all(15),
        borderRadius: BorderRadius.circular(16),
        backgroundColor: backgroundColor,
        message: message,
        messageColor: textColor,
        duration: const Duration(seconds: 2),
        flushbarStyle: FlushbarStyle.FLOATING,
        icon: Icon(icon, size: 28, color: textColor),
      )..show(context),
    );
  }

  // Gradient Flushbar without title
  static void gradientFlushbar(String message, BuildContext context,
      {FlushbarType type = FlushbarType.info}) {
    List<Color> gradientColors;
    IconData icon;

    switch (type) {
      case FlushbarType.success:
        gradientColors = [const Color(0xFF00C853), const Color(0xFF64DD17)];
        icon = Icons.check_circle;
        break;
      case FlushbarType.error:
        gradientColors = [const Color(0xFFD50000), const Color(0xFFFF5252)];
        icon = Icons.error;
        break;
      case FlushbarType.warning:
        gradientColors = [const Color(0xFFFFAB00), const Color(0xFFFFD600)];
        icon = Icons.warning;
        break;
      case FlushbarType.info:
      default:
        gradientColors = [const Color(0xFF2979FF), const Color(0xFF448AFF)];
        icon = Icons.info;
        break;
    }

    showFlushbar(
      context: context,
      flushbar: Flushbar(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        padding: const EdgeInsets.all(15),
        borderRadius: BorderRadius.circular(16),
        backgroundGradient: LinearGradient(
          colors: gradientColors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        message: message,
        messageColor: Colors.white,
        duration: const Duration(seconds: 2),
        flushbarStyle: FlushbarStyle.FLOATING,
        icon: Icon(icon, size: 28, color: Colors.white),
      )..show(context),
    );
  }

  // Bottom Flushbar without title
  static void bottomSheetFlushbar(String message, BuildContext context,
      {FlushbarType type = FlushbarType.info}) {
    Color backgroundColor;
    IconData icon;

    switch (type) {
      case FlushbarType.success:
        backgroundColor = const Color(0xFF00C853);
        icon = Icons.check_circle;
        break;
      case FlushbarType.error:
        backgroundColor = const Color(0xFFD50000);
        icon = Icons.error;
        break;
      case FlushbarType.warning:
        backgroundColor = const Color(0xFFFFAB00);
        icon = Icons.warning;
        break;
      case FlushbarType.info:
      default:
        backgroundColor = const Color(0xFF2979FF);
        icon = Icons.info;
        break;
    }

    showFlushbar(
      context: context,
      flushbar: Flushbar(
        padding: const EdgeInsets.all(20),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        backgroundColor: backgroundColor,
        flushbarPosition: FlushbarPosition.BOTTOM,
        message: message,
        messageColor: Colors.white,
        duration: const Duration(seconds: 4),
        flushbarStyle: FlushbarStyle.FLOATING,
        icon: Icon(icon, size: 28, color: Colors.white),
      )..show(context),
    );
  }

  // Glassmorphism Flushbar without title
  static void glassFlushbar(String message, BuildContext context,
      {FlushbarType type = FlushbarType.info}) {
    Color backgroundColor;
    IconData icon;

    switch (type) {
      case FlushbarType.success:
        backgroundColor = const Color(0x4D00C853);
        icon = Icons.check_circle;
        break;
      case FlushbarType.error:
        backgroundColor = const Color(0x4DD50000);
        icon = Icons.error;
        break;
      case FlushbarType.warning:
        backgroundColor = const Color(0x4DFFAB00);
        icon = Icons.warning;
        break;
      case FlushbarType.info:
      default:
        backgroundColor = const Color(0x4D2979FF);
        icon = Icons.info;
        break;
    }

    showFlushbar(
      context: context,
      flushbar: Flushbar(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        padding: const EdgeInsets.all(15),
        borderRadius: BorderRadius.circular(16),
        backgroundColor: backgroundColor,
        message: message,
        messageColor: Colors.white,
        duration: const Duration(seconds: 4),
        flushbarStyle: FlushbarStyle.FLOATING,
        icon: Icon(icon, size: 28, color: Colors.white),
      )..show(context),
    );
  }

  // Action Flushbar without title
  static void actionFlushbar(String message, BuildContext context,
      String actionText, VoidCallback onActionPressed,
      {FlushbarType type = FlushbarType.info}) {
    Color backgroundColor;
    IconData icon;

    switch (type) {
      case FlushbarType.success:
        backgroundColor = const Color(0xFF00C853);
        icon = Icons.check_circle;
        break;
      case FlushbarType.error:
        backgroundColor = const Color(0xFFD50000);
        icon = Icons.error;
        break;
      case FlushbarType.warning:
        backgroundColor = const Color(0xFFFFAB00);
        icon = Icons.warning;
        break;
      case FlushbarType.info:
      default:
        backgroundColor = const Color(0xFF2979FF);
        icon = Icons.info;
        break;
    }

    showFlushbar(
      context: context,
      flushbar: Flushbar(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        padding: const EdgeInsets.all(15),
        borderRadius: BorderRadius.circular(16),
        backgroundColor: backgroundColor,
        message: message,
        messageColor: Colors.white,
        duration: const Duration(seconds: 5),
        flushbarStyle: FlushbarStyle.FLOATING,
        icon: Icon(icon, size: 28, color: Colors.white),
        mainButton: TextButton(
          onPressed: onActionPressed,
          child: Text(
            actionText,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      )..show(context),
    );
  }
}

enum ToastType { success, error, warning, info }
enum FlushbarType { success, error, warning, info }
