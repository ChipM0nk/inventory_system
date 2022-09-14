import 'package:edar_app/cubit/purchases/purchase_cubit.dart';
import 'package:edar_app/data/model/purchase/purchase_item.dart';

import 'package:edar_app/presentation/pages/purchase/purchase_datatable.dart';
import 'package:edar_app/presentation/widgets/fields/custom_date_picker.dart';
import 'package:edar_app/presentation/widgets/fields/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../widgets/fields/custom_text_field.dart';

class PurchaseForm extends StatefulWidget {
  const PurchaseForm({Key? key}) : super(key: key);

  @override
  State<PurchaseForm> createState() => _PurchaseFormState();
}

class _PurchaseFormState extends State<PurchaseForm> {
  final dateFormat = 'dd-MMM-yy';
  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    BlocProvider.of<PurchaseCubit>(context).init();

    super.initState();
  }

  void _addItem(PurchaseItem purchaseItem) {
    // BlocProvider.of<PurchaseCubit>(context).addPurchaseItem(purchaseItem);
  }

  void _deleteItem(PurchaseItem purchaseItem) {
    // BlocProvider.of<PurchaseCubit>(context).removePurchaseItem(purchaseItem);
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: SizedBox(
        width: 1000,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [],
                ),
              ],
            ),
            PurchaseDatatable(
              deletePurchaseItem: _deleteItem,
              addPurchaseItem: _addItem,
            ),
            Row(
              children: [
                StreamBuilder<bool>(
                    stream:
                        BlocProvider.of<PurchaseCubit>(context).saveButtonValid,
                    builder: (context, snapshot) {
                      return ElevatedButton(
                        onPressed: snapshot.hasData &&
                                BlocProvider.of<PurchaseCubit>(context)
                                    .getPurchaseItems()!
                                    .isNotEmpty
                            ? () {
                                BlocProvider.of<PurchaseCubit>(context)
                                    .addPurchase();
                              }
                            : null,
                        child: const Text("Save"),
                      );
                    }),
              ],
            )
          ],
        ),
      ),
    );
  }
}
