import 'package:flutter/material.dart';
import 'package:tokoonline/constans.dart';
import 'package:tokoonline/users/depanpage.dart';
import 'package:tokoonline/users/kategori.dart';

class Beranda extends StatefulWidget {
  const Beranda({super.key});

  @override
  State<Beranda> createState() => _BerandaState();
}

class _BerandaState extends State<Beranda> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _activeTabIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(setActiveTabIndex);
  }

  @override
  void dispose() {
    _tabController.removeListener(setActiveTabIndex);
    _tabController.dispose();
    super.dispose();
  }

  void setActiveTabIndex() {
    setState(() {
      _activeTabIndex = _tabController.index;
    });
  }

  @override
  Widget build(BuildContext context) {
    var appBar2 = AppBar(
      backgroundColor: Palette.bg1,
      title: TextField(
        onTap: () {},
        readOnly: true,
        style: const TextStyle(fontSize: 15),
        decoration: InputDecoration(
            hintText: 'Search',
            prefixIcon: const Icon(Icons.search, color: Palette.orange),
            contentPadding: const EdgeInsets.symmetric(vertical: 10.0),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.white),
            ),
            fillColor: const Color(0xfff3f3f4),
            filled: true),
      ),
      bottom: TabBar(
        controller: _tabController,
        indicatorColor: Palette.orange,
        unselectedLabelColor: Colors.grey,
        labelPadding: const EdgeInsets.all(0),
        tabs: const [
          Tab(text: 'Beranda'),
          Tab(text: 'Kategori'),
        ],
      ),
    );
    var appBar = appBar2;
    return Scaffold(
        appBar: appBar,
        body: TabBarView(
          physics: const NeverScrollableScrollPhysics(),
          controller: _tabController,
          children: const [
            DepanPage(),
            KategoriPage(),
          ],
        ));
  }
}

@override
Widget build(BuildContext context) {
  // TODO: implement build
  throw UnimplementedError();
}
