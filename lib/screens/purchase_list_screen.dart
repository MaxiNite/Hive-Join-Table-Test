import 'package:flutter/material.dart';
import 'package:hive_join_table_test/database/database.dart';
import 'package:drift/drift.dart' as dr;
import 'package:hive_join_table_test/screens/purchase_detail_screen.dart';
import 'package:provider/provider.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class PurchaseListScreen extends StatefulWidget {
  const PurchaseListScreen({super.key});

  @override
  State<PurchaseListScreen> createState() => _PurchaseListScreenState();
}

class _PurchaseListScreenState extends State<PurchaseListScreen> {
  late AppDatabase database;
  int axisCount = 2;

  @override
  Widget build(BuildContext context) {
    database = Provider.of<AppDatabase>(context);

    return Scaffold(
      appBar: _getPurchaseListAppBar(),
      body: FutureBuilder<List<PurchaseData>>(
        future: _getPurchasesFromDB(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<PurchaseData>? purchaseList = snapshot.data;
            if (purchaseList != null) {
              if (purchaseList.isEmpty) {
                return Center(
                  child: Text(
                    'No Purchase found, add new ones',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                );
              } else {
                return purchaseListUI(purchaseList);
              }
            }
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                snapshot.error.toString(),
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            );
          }
          return Center(
            child: Text(
              'Click on add burron to add a new purchase',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _navigateToPurchaseDetail(
            'Add Purchase',
            const PurchaseCompanion(
              quantity: dr.Value(''),
              user: dr.Value(''),
            ),
          );
        },
        shape: const CircleBorder(
          side: BorderSide(color: Colors.black, width: 2),
        ),
        backgroundColor: Colors.white,
        child: const Icon(
          Icons.add,
          color: Colors.black,
        ),
      ),
    );
  }

  Future<List<PurchaseData>> _getPurchasesFromDB() async {
    return await database.getPurchasesList();
  }

  Widget purchaseListUI(List<PurchaseData> purchaseList) {
    return StaggeredGridView.countBuilder(
      itemCount: purchaseList.length,
      crossAxisCount: 4,
      itemBuilder: (context, index) {
        PurchaseData purchaseData = purchaseList[index];
        return InkWell(
          onTap: () {
            _navigateToPurchaseDetail(
                'Edit Purchase',
                PurchaseCompanion(
                  id: dr.Value(purchaseData.id),
                  quantity: dr.Value(purchaseData.quantity),
                  user: dr.Value(purchaseData.user),
                ));
          },
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 10),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              border: Border.all(color: Colors.black),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'ID: ${purchaseData.id}',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        'QUANTITY: ${purchaseData.quantity}',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        'USER: ${purchaseData.user}',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
      staggeredTileBuilder: (index) => StaggeredTile.fit(axisCount),
      mainAxisSpacing: 8,
      crossAxisSpacing: 4,
    );
  }

  _navigateToPurchaseDetail(
      String title, PurchaseCompanion purchaseCompanion) async {
    var res = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PurchaseDetailScreen(
          title: title,
          purchaseCompanion: purchaseCompanion,
        ),
      ),
    );

    if (res != null && res == true) {
      setState(() {});
    }
  }

  _getPurchaseListAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      centerTitle: true,
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
      title: const Text(
        'Purchase',
        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
      ),
      actions: [
        IconButton(
          onPressed: () {
            if (axisCount == 2) {
              axisCount = 4;
            } else {
              axisCount = 2;
            }
            setState(() {});
          },
          icon: Icon(
            axisCount == 4 ? Icons.grid_view : Icons.list,
            color: Colors.black,
          ),
        ),
      ],
    );
  }
}
