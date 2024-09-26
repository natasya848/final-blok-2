import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:tokoonline/constans.dart';
import 'package:tokoonline/models/kategori.dart';
import 'dart:async';
import 'dart:convert';
import 'package:tokoonline/models/produk.dart';
import 'package:tokoonline/users/produkdetailpage.dart';

class DepanPage extends StatefulWidget {
  const DepanPage({super.key});

  @override
  State<DepanPage> createState() => _DepanPageState();
}

class _DepanPageState extends State<DepanPage> {
  List<Kategori> kategorilist = [];

  @override
  void initState() {
    super.initState();
    fetchKategori();
  }

  @override
  void dispose() {
    kategorilist.clear();
    super.dispose();
  }

  Future<List<Kategori>> fetchKategori() async {
    List<Kategori> usersList = [];
    var params = "/kategoribyproduk";
    try {
      var jsonResponse = await http.get(Uri.parse(Palette.sUrl + params));
      if (jsonResponse.statusCode == 200) {
        final jsonItems =
            json.decode(jsonResponse.body).cast<Map<String, dynamic>>();
        usersList =
            jsonItems.map<Kategori>((json) => Kategori.fromJson(json)).toList();
      }
      setState(() {
        kategorilist = usersList;
      });
    } catch (e) {
      // Handle exception or show an error message
      print("Error fetching categories: $e");
    }
    return usersList;
  }

  Future<void> _refresh() async {
    await fetchKategori();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              produkbyKategori(),
            ],
          ),
        ),
      ),
    );
  }

  Widget produkbyKategori() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          for (int i = 0; i < kategorilist.length; i++)
            WidgetbyKategori(
              id: kategorilist[i].id,
              kategori: kategorilist[i].nama.toString(),
              warna: i,
            ),
        ],
      ),
    );
  }
}

class WidgetbyKategori extends StatefulWidget {
  final int id;
  final String kategori;
  final int warna;

  const WidgetbyKategori({
    required this.id,
    required this.kategori,
    required this.warna,
    super.key,
  });

  @override
  _WidgetbyKategoriState createState() => _WidgetbyKategoriState();
}

class _WidgetbyKategoriState extends State<WidgetbyKategori> {
  List<Produk> produklist = [];

  Future<List<Produk>> fetchProduk(String id) async {
    List<Produk> usersList = [];
    var params = "/produkbykategori?id=$id";
    try {
      var jsonResponse = await http.get(Uri.parse(Palette.sUrl + params));
      if (jsonResponse.statusCode == 200) {
        final jsonItems =
            json.decode(jsonResponse.body).cast<Map<String, dynamic>>();
        usersList =
            jsonItems.map<Produk>((json) => Produk.fromJson(json)).toList();
        setState(() {
          produklist = usersList;
        });
      }
    } catch (e) {
      // Handle exception or show an error message
      print("Error fetching products: $e");
    }
    return usersList;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20.0),
      padding: const EdgeInsets.only(right: 10.0),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Container(
            margin: const EdgeInsets.only(top: 10.0, bottom: 10.0),
            padding: const EdgeInsets.only(right: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  width: 200.0,
                  padding: const EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(10.0),
                      bottomRight: Radius.circular(10.0),
                    ),
                    color: Palette.colors[widget.warna],
                    boxShadow: [
                      BoxShadow(
                        color: Palette.colors[widget.warna],
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: Text(
                    widget.kategori,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                InkWell(
                  onTap: () {
                    // Navigator.of(context).push(MaterialPageRoute<Null>(
                    //     builder: (BuildContext context) {
                    //   return ProdukPage("kat", widget.id, 0, widget.kategori);
                    // }));
                  },
                  child: const Text('Selengkapnya',
                      style: TextStyle(color: Colors.blue)),
                )
              ],
            ),
          ),
          Container(
            height: 200.0,
            margin: const EdgeInsets.only(bottom: 7.0),
            child: FutureBuilder<List<Produk>>(
              future: fetchProduk(widget.id.toString()),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: snapshot.data?.length ?? 0,
                  itemBuilder: (BuildContext context, int i) => Card(
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute<Null>(
                            builder: (BuildContext context) {
                          return ProdukDetailPage(
                              snapshot.data[i].id,
                              snapshot.data[i].judul,
                              snapshot.data[i].harga,
                              snapshot.data[i].hargax,
                              snapshot.data[i].thumbnail,
                              false);
                        }));
                      },
                      child: SizedBox(
                        width: 135.0,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Image.asset(
                              '/${snapshot.data![i].thumbnail}',
                              height: 110.0,
                              width: 110.0,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 5.0),
                              child: Text(snapshot.data![i].judul),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 5.0, bottom: 5.0),
                              child: Text(snapshot.data![i].harga),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
