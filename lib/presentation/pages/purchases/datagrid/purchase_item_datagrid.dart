import 'package:edar_app/cubit/products/products_cubit.dart';
import 'package:edar_app/cubit/purchases/purchase_cubit.dart';
import 'package:edar_app/data/model/purchase/purchase_item.dart';
import 'package:edar_app/data/model/supplier.dart';
import 'package:edar_app/presentation/pages/purchases/datagrid/purchase_item_grid_datasource.dart';
import 'package:edar_app/presentation/pages/purchases/purchaseform/purchase_add_item_dialog.dart';
import 'package:edar_app/presentation/utils/util.dart';
import 'package:edar_app/presentation/widgets/custom_elevated_button.dart';
import 'package:edar_app/presentation/widgets/custom_sfdatagrid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

/**
 * 
 * At the moment the entire datagrid is recreaed
 */
class PurchaseItemDataGrid extends StatelessWidget {
  final List<PurchaseItem> purchaseItems;
  final double summaryTotal;
  final List<StackedHeaderRow>? stackHeaderRows;
  final Function(PurchaseItem)? deletePurchaseItem;
  final Function(PurchaseItem)? addPurchaseItem;
  final bool editable;

  const PurchaseItemDataGrid({
    required this.purchaseItems,
    this.summaryTotal = 0.00,
    this.stackHeaderRows,
    this.editable = true,
    this.deletePurchaseItem,
    this.addPurchaseItem,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    PurchaseItemGridDataSource purchaseItemGriDataSource =
        PurchaseItemGridDataSource(
            purchaseItems: purchaseItems,
            editable: editable,
            deletePurchaseItem: deletePurchaseItem);

    var footer = Container(
        color: Colors.grey[100],
        child: Padding(
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: Center(
              child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              editable
                  ? SizedBox(
                      width: 100,
                      child: StreamBuilder<Supplier>(
                          stream: BlocProvider.of<PurchaseCubit>(context)
                              .supplierStream,
                          builder: (context, snapshot) {
                            bool enabled = snapshot.hasData;

                            return CustomElevatedButton(
                              onPressed: enabled
                                  ? () {
                                      showDialog(
                                          // barrierDismissible: false,
                                          context: context,
                                          builder: (_) {
                                            return MultiBlocProvider(
                                              providers: [
                                                BlocProvider.value(
                                                    value: context
                                                        .read<ProductsCubit>()),
                                                BlocProvider.value(
                                                    value: context
                                                        .read<PurchaseCubit>()),
                                              ],
                                              child: PurchaseAddItemDialog(
                                                  addPurchaseItem:
                                                      addPurchaseItem!),
                                            );
                                          });
                                    }
                                  : null,
                              child: const Icon(
                                Icons.add_box_outlined,
                                color: Colors.white,
                                size: 25,
                              ),
                            );
                          }),
                    )
                  : const SizedBox(
                      width: 0,
                    ),
              RichText(
                  text: TextSpan(
                      text: 'TOTAL : ',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                      children: [
                    TextSpan(
                        text:
                            'PHP ${Util.convertToCurrency(summaryTotal).toString()}',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.red)),
                  ])),
            ],
          )),
        ));

    return CustomSfDataGrid(
      stackedHeaderRows: stackHeaderRows ?? [],
      stackedHeaderRowHeight: 120,
      footer: footer,
      source: purchaseItemGriDataSource,
      columns: <GridColumn>[
        GridColumn(
            columnName: 'prodcode',
            width: 150,
            label: Container(
                padding: const EdgeInsets.all(5.0),
                height: 20,
                alignment: Alignment.centerLeft,
                child: const Text(
                  'Product Code',
                ))),
        GridColumn(
            columnName: 'prodname',
            width: 200,
            label: Container(
                padding: const EdgeInsets.all(5.0),
                height: 20,
                alignment: Alignment.centerLeft,
                child: const Text(
                  'Product Name',
                ))),
        GridColumn(
            columnName: 'proddesc',
            width: 350,
            label: Container(
                padding: const EdgeInsets.all(5.0),
                height: 20,
                alignment: Alignment.centerLeft,
                child: const Text('Product Desciption'))),
        GridColumn(
            columnName: 'price',
            width: 100,
            label: Container(
                padding: const EdgeInsets.all(5.0),
                height: 20,
                alignment: Alignment.centerRight,
                child: const Text('Price'))),
        GridColumn(
            columnName: 'qty',
            width: 80,
            label: Container(
                padding: const EdgeInsets.all(5.0),
                height: 20,
                alignment: Alignment.centerRight,
                child: const Text('Quantity'))),
        GridColumn(
            columnName: 'total',
            width: 120,
            label: Container(
                padding: const EdgeInsets.all(5.0),
                height: 20,
                alignment: Alignment.centerRight,
                child: const Text('Total'))),
      ],
    );
  }
}
