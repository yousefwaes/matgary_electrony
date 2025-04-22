import 'package:flutter/material.dart';

import '../../../../core/AppTheme.dart';

AppBar myAppBar(BuildContext context, String title) {
  return AppBar(
    automaticallyImplyLeading: false,
    // leading: IconButton(
    //   icon: Icon(Icons.arrow_back_rounded, color: Colors.white),
    //   onPressed: () {
    //     Navigator.pop(context);
    //   },
    // ),
    backgroundColor: primaryColor,
    title: Center(

      child: Text(
        title,
        style: const TextStyle(
          fontSize: 30,
          fontWeight: FontWeight.bold,
          color: primaryColor1,
        ),
      ),
    ),
    toolbarHeight: 120,
    // يمكنك ضبط هذا الرقم لتحديد الارتفاع المرغوب
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        bottom: Radius.circular(60), // جعل الأركان السفلية منحنية
      ),

    ),

  );
}
