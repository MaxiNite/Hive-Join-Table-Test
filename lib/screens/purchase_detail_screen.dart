import 'package:flutter/material.dart';
import 'package:hive_join_table_test/database/database.dart';
import 'package:hive_join_table_test/utils/username_picker.dart';
import 'package:provider/provider.dart';
// import 'package:intl/intl.dart'; FOR DATE FORMAT
import 'package:drift/drift.dart' as dr;
import 'package:number_inc_dec/number_inc_dec.dart';

class PurchaseDetailScreen extends StatefulWidget {
  final String title;
  final PurchaseCompanion purchaseCompanion;

  const PurchaseDetailScreen(
      {super.key, required this.title, required this.purchaseCompanion});

  @override
  State<PurchaseDetailScreen> createState() => _PurchaseDetailScreenState();
}

class _PurchaseDetailScreenState extends State<PurchaseDetailScreen> {
  late AppDatabase appDatabase;
  late TextEditingController quantityController;
  late String userController;

  @override
  void initState() {
    // userController = TextEditingController();
    quantityController = TextEditingController();
    quantityController.text = widget.purchaseCompanion.quantity.value;
    userController = widget.purchaseCompanion.user.value;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    appDatabase = Provider.of<AppDatabase>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _getPurchaseDetailAppbar(),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Column(
          children: [
            NumberInputWithIncrementDecrement(controller: quantityController),
            const SizedBox(height: 30),
            UsernamePicker(
              username: userController,
              onChange: (selectedUsername) {
                userController = selectedUsername;
                setState(() {});
              },
            ),
          ],
        ),
      ),
    );
  }

  _getPurchaseDetailAppbar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: const Icon(
          Icons.chevron_left_outlined,
          color: Colors.black,
        ),
      ),
      title: Text(
        widget.title,
        style: const TextStyle(color: Colors.black),
      ),
      actions: [
        IconButton(
          onPressed: () {
            _saveToDb();
          },
          icon: const Icon(
            Icons.save,
            color: Colors.black,
          ),
        ),
        IconButton(
          onPressed: () {
            _deletePurchaseFromDb();
          },
          icon: const Icon(
            Icons.delete,
            color: Colors.black,
          ),
        ),
      ],
    );
  }

  void _saveToDb() {
    if (widget.purchaseCompanion.id.present) {
      appDatabase
          .updatePurchase(
            PurchaseData(
              id: widget.purchaseCompanion.id.value,
              quantity: widget.purchaseCompanion.quantity.value,
              user: widget.purchaseCompanion.user.value,
            ),
          )
          .then((value) => Navigator.pop(context));
    } else {
      appDatabase
          .insertPurchases(
            PurchaseCompanion(
              quantity: dr.Value(quantityController.text),
              user: dr.Value(userController),
            ),
          )
          .then((value) => Navigator.pop(context));
    }
  }

  void _deletePurchaseFromDb() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Purchase?'),
          content: const Text('Do you really want to delete this purchase?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);

                appDatabase
                    .deletePurchases(
                      PurchaseData(
                        id: widget.purchaseCompanion.id.value,
                        quantity: widget.purchaseCompanion.quantity.value,
                        user: widget.purchaseCompanion.user.value,
                      ),
                    )
                    .then((value) => Navigator.pop(context));
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}
