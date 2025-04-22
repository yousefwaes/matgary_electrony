import 'package:dot_navigation_bar/dot_navigation_bar.dart';
import 'package:flutter/material.dart';

import '../../../../core/AppTheme.dart';

enum _SelectedTab { home, favorite, cart, reports }

class Bottomnavigation extends StatefulWidget {
  @override
  _BottomnavigationState createState() => _BottomnavigationState();
}

class _BottomnavigationState extends State<Bottomnavigation> {
  _SelectedTab _selectedTab = _SelectedTab.home; // القيمة الافتراضية

  void _handleIndexChanged(int index) {
    setState(() {

      _selectedTab = _SelectedTab.values[index];
    });

    // التنقل إلى الصفحة المناسبة
    switch (_selectedTab) {
      case _SelectedTab.home:
        Navigator.pushReplacementNamed(context, '/home');
        break;
      case _SelectedTab.favorite:
        Navigator.pushReplacementNamed(context, '/favorite');
        break;
      case _SelectedTab.cart:
        Navigator.pushReplacementNamed(context, '/cart');
        break;
      case _SelectedTab.reports:
        Navigator.pushReplacementNamed(context, '/orders');
        break;
      // TODO: Handle this case.

    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 125, // ارتفاع شريط التنقل
      decoration: BoxDecoration(
        color: Colors.transparent, // جعل الخلفية شفافة
        borderRadius: BorderRadius.vertical(top: Radius.circular(100)), // الزوايا المنحنية
        boxShadow: [
          BoxShadow(
            color: Colors.black26, // ظل خفيف
            blurRadius: 50,
            offset: Offset(0, -2), // موضع الظل
          ),
        ],
      ),
      child: ClipRRect(
        // استخدام ClipRRect لتجنب أي تجاوزات
        borderRadius: BorderRadius.vertical(top: Radius.circular(100)), // الزوايا المنحنية
        child: DotNavigationBar(
          currentIndex: _SelectedTab.values.indexOf(_selectedTab),
          onTap: _handleIndexChanged,
          dotIndicatorColor: primaryColor.withOpacity(0.2),
          unselectedItemColor: Colors.grey[600],
          splashColor: primaryColor.withOpacity(0.1),
          // الزوايا المنحنية
          borderRadius: 20,
          // العناصر
          items: [
            DotNavigationBarItem(
              icon: Icon(Icons.home),
              selectedColor: primaryColor,
            ),
            DotNavigationBarItem(
              icon: Icon(Icons.favorite_border),
              selectedColor: primaryColor,
            ),
            DotNavigationBarItem(
              icon: Icon(Icons.shopping_cart),
              selectedColor: primaryColor,
            ),
            DotNavigationBarItem(
              icon: Icon(Icons.assessment),
              selectedColor: primaryColor,
            ),
          ],
        ),
      ),
    );
  }
}