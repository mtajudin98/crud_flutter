import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../helper/dbhelper.dart';

class CustomerForm extends StatefulWidget {
  const CustomerForm({super.key});

  @override
  State<CustomerForm> createState() => _CustomerFormState();
}

class _CustomerFormState extends State<CustomerForm> {
  late TextEditingController txtID, txtNama, txtTgllhr;
  String gender = '', tgllhr = '';

  _CustomerFormState() {
    txtID = TextEditingController();
    txtNama = TextEditingController();
    txtTgllhr = TextEditingController();

    lastID().then((value) {
      txtID.text = '${value + 1}';
    });
  }

  Widget txtInputID() => TextFormField(
      controller: txtID,
      readOnly: true,
      decoration: const InputDecoration(labelText: 'ID Customer'));
  Widget txtInputNama() => TextFormField(
      controller: txtNama,
      decoration: const InputDecoration(labelText: 'Nama Customer'));
  Widget dropDownGender() => DropdownButtonFormField(
        decoration: const InputDecoration(labelText: 'Jenis Kelamin'),
        isExpanded: true,
        value: gender,
        onChanged: (g) {
          gender = '$g';
        },
        items: const [
          DropdownMenuItem(value: '', child: Text('Pilih Gender')),
          DropdownMenuItem(value: 'L', child: Text('Laki-laki')),
          DropdownMenuItem(value: 'P', child: Text('Perempuan'))
        ],
      );
  DateTime initTgllhr() {
    try {
      return DateFormat('yyyy-mm-dd').parse(txtTgllhr.value.text);
    } catch (e) {
      return DateTime.now();
    }
  }

  Widget txtInputTgllhr() => TextFormField(
        readOnly: true,
        decoration: const InputDecoration(labelText: 'Tanggal Lahir'),
        controller: txtTgllhr,
        onTap: () async {
          final tgl = await showDatePicker(
              context: context,
              initialDate: initTgllhr(),
              firstDate: DateTime(1900),
              lastDate: DateTime.now());
          if (tgl != null) {
            txtTgllhr.text = DateFormat('yyyy-mm-dd').format(tgl);
          }
        },
      );

  Widget aksiSimpan() => TextButton(
        onPressed: () {
          simpanData().then((h) {
            var pesan = h == true ? 'Sukses simpan' : 'Gagal simpan';
            showDialog(
                context: context,
                builder: (bc) => AlertDialog(
                      title: const Text('Simpan Customer'),
                      content: Text(pesan),
                      actions: [
                        TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text('Oke...'))
                      ],
                    )).then((value) => Navigator.pop(context, h));
          });
        },
        child: const Text('Simpan', style: TextStyle(color: Colors.white)),
      );
  Future<int> lastID() async {
    try {
      final _db = await DBHelper.db();
      const query = 'SELECT MAX(id) as id FROM customer';
      final ls = (await _db?.rawQuery(query))!;
      if (ls.isNotEmpty) {
        return int.tryParse('${ls[0]['id']}') ?? 0;
      }
    } catch (e) {
      print('error lastid $e');
    }
    return 0;
  }

  Future<bool> simpanData() async {
    try {
      final _db = await DBHelper.db();
      var data = {
        'id': txtID.value.text,
        'nama': txtNama.value.text,
        'gender': gender,
        'tgl_lahir': txtTgllhr.value.text,
      };
      final id = await _db?.insert('customer', data);
      return id! > 0;
      // ignore: empty_catches
    } catch (e) {}
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Form Customer'),
        actions: [aksiSimpan()],
      ),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(children: [
          txtInputID(),
          txtInputNama(),
          dropDownGender(),
          txtInputTgllhr()
        ]),
      ),
    );
  }
}
