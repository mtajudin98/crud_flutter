import 'package:crud_flutter/helper/dbhelper.dart';
import 'package:crud_flutter/pages/customer/customer_form.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class CustomerList extends StatefulWidget {
  const CustomerList({super.key});

  @override
  State<CustomerList> createState() => _CustomerListState();
}

class _CustomerListState extends State<CustomerList> {
  final RefreshController _refreshController =
      RefreshController(initialRefresh: true);
  List<Map> listData = [];

  void refresh() async {
    final _db = await DBHelper.db();

    const sql = 'SELECT * FROM customer';
    listData = (await _db?.rawQuery(sql))!;
    _refreshController.refreshCompleted();
    setState(() {});
  }

  Widget item(Map d) => ListTile(
        onLongPress: () {
          showMenu(
              context: context,
              position: RelativeRect.fromLTRB(
                  100, MediaQuery.of(context).size.height / 2, 100, 0),
              items: [
                const PopupMenuItem(
                  value: 'S',
                  child: Text('Edit Data'),
                )
              ]).then((value) {
            if (value == 'S') {
              Navigator.push(context,
                      MaterialPageRoute(builder: (c) => CustomerForm(data: d)))
                  .then((value) {
                if (value == true) refresh();
              });
            }
          });
        },
        title: Text('${d['nama']}'),
        trailing: Text('${d['gender']}'),
        subtitle: Text('${d['tgl_lahir']}'),
      );

  Widget btnTambah() => ElevatedButton(
        onPressed: () {
          Navigator.push(context,
                  MaterialPageRoute(builder: (c) => const CustomerForm()))
              .then((value) {
            if (value == true) {
              refresh();
            }
          });
        },
        child: const Text('Tambah Customer'),
      );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Data Customer'),
      ),
      floatingActionButton: btnTambah(),
      body: SmartRefresher(
        controller: _refreshController,
        onRefresh: () => refresh(),
        child: ListView(
          children: [for (Map d in listData) item(d)],
        ),
      ),
    );
  }
}
