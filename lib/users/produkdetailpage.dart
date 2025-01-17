import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:tokoonline/helper/dbhelper.dart';
import 'package:tokoonline/models/cabang.dart';
import 'package:http/http.dart' as http;
import 'package:tokoonline/constans.dart';
import 'dart:async';
import 'dart:convert';

import 'package:tokoonline/models/keranjang.dart';

class ProdukDetailPage extends StatefulWidget {
  final Widget child;
  final int id;
  final String judul;
  final String harga;
  final String hargax;
  final String thumbnail;
  final bool valstok;

  const ProdukDetailPage(this.id, this.judul, this.harga, this.hargax,
      this.thumbnail, this.valstok,
      {Key key, this.child})
      : super(key: key);

  @override
  _ProdukDetailPageState createState() => _ProdukDetailPageState();
}

class _ProdukDetailPageState extends State<ProdukDetailPage> {
  List<Cabang> cabanglist = [];
  String _valcabang;
  bool instok = false;
  String userid;
  DbHelper dbHelper = DbHelper();

  @override
  void initState() {
    super.initState();
    fetchCabang();
    if (widget.valstok == true) {
      instok = widget.valstok;
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<List<Cabang>> fetchCabang() async {
    List<Cabang> usersList;
    var params = "/cabang";
    try {
      var jsonResponse = await http.get(Palette.sUrl + params);
      if (jsonResponse.statusCode == 200) {
        final jsonItems =
            json.decode(jsonResponse.body).cast<Map<String, dynamic>>();

        usersList = jsonItems.map<Cabang>((json) {
          return Cabang.fromJson(json);
        }).toList();
        setState(() {
          cabanglist = usersList;
        });
      }
    } catch (e) {}
    return usersList;
  }

  _cekProdukCabang(String idproduk, String idcabang) async {
    var params = "/cekprodukbycabang?idproduk=$idproduk&idcabang=$idcabang";
    try {
      var res = await http.get(Palette.sUrl + params);
      if (res.statusCode == 200) {
        if (res.body == "OK") {
          setState(() {
            instok = true;
          });
        } else {
          setState(() {
            instok = false;
          });
        }
      }
    } catch (e) {
      setState(() {
        instok = false;
      });
    }
  }

  saveKeranjang(Keranjang keranjang) async {
    Database db = await dbHelper.database;
    var batch = db.batch();
    db.execute(
        'insert into keranjang(idproduk,judul,harga,hargax,thumbnail,jumlah,userid,idcabang) values(?,?,?,?,?,?,?,?)',
        [
          keranjang.idproduk,
          keranjang.judul,
          keranjang.harga,
          keranjang.hargax,
          keranjang.thumbnail,
          keranjang.jumlah,
          keranjang.userid,
          keranjang.idcabang
        ]);
    await batch.commit();
    Navigator.of(context).pushNamedAndRemoveUntil(
        '/keranjangusers', (Route<dynamic> route) => false);
  }

  Widget _body() {
    return SizedBox(
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            width: double.infinity,
            child: Image.network("${Palette.sUrl}/${widget.thumbnail}",
                fit: BoxFit.fitWidth),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 5.0),
            child: Text(widget.judul),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
            child: Text(widget.harga),
          ),
          Container(
            margin: const EdgeInsets.all(10),
            child: DropdownButtonFormField(
              decoration: InputDecoration(
                  contentPadding:
                      const EdgeInsets.only(top: 10, left: 12.0, bottom: 10),
                  border: OutlineInputBorder(
                    borderRadius: const BorderRadius.all(
                      Radius.circular(5.0),
                    ),
                    borderSide: const BorderSide(
                      color: Colors.black,
                      width: 1.0,
                    ),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    borderSide: BorderSide(color: Colors.black, width: 1.0),
                  ),
                  fillColor: Colors.black,
                  filled: false),
              hint: const Text("Pilih Cabang"),
              value: _valcabang,
              items: cabanglist.map((item) {
                return DropdownMenuItem(
                  value: item.id.toString(),
                  child: Text(item.nama.toString()),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _valcabang = value;
                  _cekProdukCabang(widget.id.toString(), _valcabang);
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transaksi'),
      ),
      body: Stack(
        children: <Widget>[
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                _body(),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.transparent,
        elevation: 0,
        child: Container(
          child: Row(
            children: [
              Padding(
                  padding: EdgeInsets.only(right: 20.0),
                  child: GestureDetector(
                    onTap: () {},
                    child: Container(
                      child: Icon(
                        Icons.favorite_border,
                        size: 40.0,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        boxShadow: [
                          BoxShadow(color: Colors.grey[500], spreadRadius: 1),
                        ],
                      ),
                    ),
                  )),
              Padding(
                  padding: EdgeInsets.only(right: 20.0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushNamedAndRemoveUntil(
                          '/keranjangusers', (Route<dynamic> route) => false);
                    },
                    child: Container(
                      child: Icon(
                        Icons.shopping_cart,
                        size: 40.0,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        boxShadow: [
                          BoxShadow(color: Colors.grey[500], spreadRadius: 1),
                        ],
                      ),
                    ),
                  )),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    if (instok == true) {
                      Keranjang _keranjangku = Keranjang(
                          idproduk: widget.id,
                          judul: widget.judul,
                          harga: widget.harga,
                          hargax: widget.hargax,
                          thumbnail: widget.thumbnail,
                          jumlah: 1,
                          userid: userid,
                          idcabang: _valcabang);
                      saveKeranjang(_keranjangku);
                    }
                  },
                  child: Container(
                    height: 40.0,
                    child: Center(
                      child: Text('Beli Sekarang',
                          style: TextStyle(color: Colors.white)),
                    ),
                    decoration: BoxDecoration(
                      color: instok == true ? Colors.blue : Colors.grey,
                      borderRadius: BorderRadius.circular(5),
                      boxShadow: [
                        BoxShadow(
                            color: instok == true ? Colors.blue : Colors.grey,
                            spreadRadius: 1),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          height: 60.0,
          padding:
              EdgeInsets.only(left: 10.0, right: 10.0, top: 2.0, bottom: 2.0),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            boxShadow: [
              BoxShadow(color: Colors.grey[100], spreadRadius: 1),
            ],
          ),
        ),
      ),
    );
  }
}
