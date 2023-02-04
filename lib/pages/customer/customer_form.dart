import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
        onPressed: () {},
        child: Text('Simpan', style: TextStyle(color: Colors.white)),
      );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Form Customer'),
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
