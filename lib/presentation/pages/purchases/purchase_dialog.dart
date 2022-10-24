import 'package:edar_app/cubit/purchases/purchase_cubit.dart';
import 'package:edar_app/data/model/purchase/purchase.dart';
import 'package:edar_app/presentation/widgets/fields/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PurchaseDialog extends StatelessWidget {
  final Purchase purchase;
  final int? fontSize;
  final bool flgAddPurchase;
  const PurchaseDialog(
      {super.key,
      required this.purchase,
      this.fontSize,
      this.flgAddPurchase = false});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PurchaseCubit, PurchaseState>(
      builder: (context, state) {
        if (state is PurchaseAdded) {
          Navigator.of(context, rootNavigator: true).pop();
        }
        return AlertDialog(
          title: const Text("Invoice Details"),
          content: SizedBox(
              width: 1000,
              height: 800,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomTextField(
                          initialValue: purchase.supplier.supplierName,
                          labelText: "Supplier Name",
                          enabled: false,
                        ),
                        CustomTextField(
                          initialValue: purchase.purchaseNo,
                          labelText: "Purchase No",
                          enabled: false,
                        ),
                        const SizedBox(width: 200),
                        const SizedBox(width: 200),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomTextField(
                          initialValue: purchase.supplier.supplierName,
                          labelText: "Batch Code",
                          enabled: false,
                        ),
                        CustomTextField(
                          initialValue: purchase.purchaseNo,
                          labelText: "Purchase Date",
                          enabled: false,
                        ),
                        const SizedBox(width: 200),
                        const SizedBox(width: 200),
                      ],
                    ),
                  ])),
        );
      },
    );
  }
}
