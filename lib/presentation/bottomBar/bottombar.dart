// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:route_to_market/presentation/activities/activities_page.dart';
import 'package:route_to_market/presentation/customers/customers_page.dart';

class BottomBar extends StatefulWidget {
  const BottomBar({super.key});

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  List _pages = [];
  int _selectedPageIndex = 0;

  @override
  void initState() {
    _pages = [
      {'page': CustomersPage(), 'title': "Customers"},
      {'page': ActivitiesPage(), 'title': "Activities"},
    ];
    super.initState();
  }

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_pages[_selectedPageIndex]['title'])),
      body: _pages[_selectedPageIndex]['page'],
      bottomNavigationBar: BottomNavigationBar(
        onTap: _selectPage,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        unselectedItemColor: Colors.black,
        unselectedFontSize: 12,
        selectedItemColor: Theme.of(context).primaryColor,
        currentIndex: _selectedPageIndex,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.group), label: 'Customers'),
          BottomNavigationBarItem(
            icon: Icon(Icons.folder_copy_rounded),
            label: 'Activities',
          ),
        ],
      ),
    );
  }
}
