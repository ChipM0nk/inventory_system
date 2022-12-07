import 'package:edar_app/constants/text_field_formats.dart';
import 'package:edar_app/cubit/purchases/purchase_cubit.dart';
import 'package:edar_app/cubit/purchases/save_purchase_cubit.dart';
import 'package:edar_app/cubit/suppliers/suppliers_cubit.dart';
import 'package:edar_app/data/model/purchase/purchase.dart';
import 'package:edar_app/data/model/purchase/purchase_item.dart';
import 'package:edar_app/data/model/supplier.dart';
import 'package:edar_app/presentation/pages/purchases/datagrid/purchase_item_datagrid.dart';
import 'package:edar_app/presentation/pages/purchases/purchase_dialog.dart';

import 'package:edar_app/presentation/widgets/custom_elevated_button.dart';
import 'package:edar_app/presentation/widgets/fields/custom_date_picker.dart';
import 'package:edar_app/routing/route_names.dart';
import 'package:edar_app/services/navigation_service.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../../locator.dart';
import '../../../widgets/fields/custom_text_field.dart';

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
    BlocProvider.of<SavePurchaseCubit>(context).init();
    BlocProvider.of<SuppliersCubit>(context).fetchSuppliers();
    super.initState();
  }

  void _addItem(PurchaseItem purchaseItem) {
    BlocProvider.of<SavePurchaseCubit>(context).addPurchaseItem(purchaseItem);
  }

  void _deleteItem(PurchaseItem purchaseItem) {
    BlocProvider.of<SavePurchaseCubit>(context)
        .removePurchaseItem(purchaseItem);
  }

  @override
  Widget build(BuildContext context) {
    var purchaseNo = StreamBuilder<String>(
        stream:
            BlocProvider.of<SavePurchaseCubit>(context).supplierInvoiceStream,
        builder: (context, snapshot) {
          return CustomTextField(
              snapshot: snapshot,
              onChanged: (text) {
                BlocProvider.of<SavePurchaseCubit>(context)
                    .updatePurchaseNo(text);
              },
              labelText: 'Supplier Invoice No');
        });
    // var batchCode = StreamBuilder<String>(
    //     stream: BlocProvider.of<SavePurchaseCubit>(context).batchCodeStream,
    //     builder: (context, snapshot) {
    //       return CustomTextField(
    //           snapshot: snapshot,
    //           hintText: "2022-09-12", //TODO review
    //           inputFormatters: [
    //             TextFieldFormat.bacthCodeFormat,
    //           ],
    //           onChanged: (text) {
    //             BlocProvider.of<SavePurchaseCubit>(context)
    //                 .updateBatchCode(text);
    //           },
    //           labelText: 'Batch Code');
    //     });

    var purchaseDate = CustomDatePicker(
      labelText: "Purchase Date",
      onChanged: (dateTime) {
        BlocProvider.of<SavePurchaseCubit>(context)
            .updatePurchaseDate(dateTime);
      },
      dateFormat: dateFormat,
    );

    var remarks = CustomTextField(
      width: 465,
      labelText: "Remarks",
      onChanged: (remarks) {
        BlocProvider.of<SavePurchaseCubit>(context).updateRemarks(remarks);
      },
    );

    var supplierFinderField = StreamBuilder<Object>(
        stream: BlocProvider.of<SavePurchaseCubit>(context).supplierStream,
        builder: (context, snapshot) {
          return BlocBuilder<SuppliersCubit, SuppliersState>(
            builder: (context, state) {
              if (state is SuppliersLoaded) {
                return Autocomplete<String>(
                  optionsBuilder: (TextEditingValue textEditingValue) {
                    if (textEditingValue.text == '') {
                      BlocProvider.of<SavePurchaseCubit>(context)
                          .updateSupplier(null);
                      return const Iterable<String>.empty();
                    } else {
                      List<String> matches = <String>[];
                      matches.addAll(
                          state.suppliers.map((e) => e.supplierName).toList());

                      matches.retainWhere((s) {
                        return s
                            .toLowerCase()
                            .contains(textEditingValue.text.toLowerCase());
                      });
                      if (matches.isEmpty) {
                        BlocProvider.of<SavePurchaseCubit>(context)
                            .updateSupplier(null);
                      }
                      return matches;
                    }
                  },
                  fieldViewBuilder: (context, textEditingController, focusNode,
                      onFieldSubmitted) {
                    return CustomTextField(
                      labelText: "Supplier",
                      focusNode: focusNode,
                      controller: textEditingController,
                      onFieldSubmitted: (String value) {
                        onFieldSubmitted();
                      },
                      snapshot: snapshot,
                    );
                  },
                  onSelected: (String supplierName) {
                    Supplier supplier = state.suppliers.firstWhere(
                        (element) => element.supplierName == supplierName);
                    BlocProvider.of<SavePurchaseCubit>(context)
                        .updateSupplier(supplier);
                  },
                );
              }
              return const SizedBox(width: 100, child: Text("Error"));
            },
          );
        });

    return BlocBuilder<SavePurchaseCubit, SavePurchaseState>(
      builder: (context, state) {
        if (state is PurchaseSaved) {
          Future.delayed(Duration.zero, () {
            setState(() {
              locator<NavigationService>().navigateTo(PurchaseFormRoute);
              BlocProvider.of<SavePurchaseCubit>(context).reset();
            });
          });
        }

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
                      children: [
                        supplierFinderField,
                        purchaseNo,
                        purchaseDate,
                        const SizedBox(width: 200),
                      ],
                    ),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //   crossAxisAlignment: CrossAxisAlignment.start,
                    //   children: [
                    //     batchCode,
                    //     purchaseDate,
                    //     const SizedBox(width: 200),
                    //     const SizedBox(width: 200),
                    //   ],
                    // ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        remarks,
                      ],
                    ),
                  ],
                ),
                StreamBuilder<List<PurchaseItem>>(
                    stream: BlocProvider.of<SavePurchaseCubit>(context)
                        .purchaseItemsStream,
                    builder: (context, snapshot) {
                      return SizedBox(
                        width: 1000,
                        height: 350,
                        child: Column(
                          children: [
                            PurchaseItemDataGrid(
                              purchaseSfKey: GlobalKey<SfDataGridState>(),
                              purchaseItems:
                                  BlocProvider.of<SavePurchaseCubit>(context)
                                      .getPurchaseItems(),
                              summaryTotal:
                                  BlocProvider.of<SavePurchaseCubit>(context)
                                      .getTotal(), //TO Update
                              editable: true,
                              addPurchaseItem: _addItem,
                              deletePurchaseItem: _deleteItem,
                            ),
                          ],
                        ),
                      );
                    }),
                Row(
                  children: [
                    StreamBuilder<bool>(
                        stream: BlocProvider.of<SavePurchaseCubit>(context)
                            .saveButtonValid,
                        builder: (context, snapshot) {
                          return SizedBox(
                            height: 50,
                            width: 150,
                            child: CustomElevatedButton(
                              onPressed: snapshot.hasData
                                  ? () {
                                      _openPurchaseDialog();
                                    }
                                  : null,
                              child: const Text("REVIEW"),
                            ),
                          );
                        }),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }

  void _openPurchaseDialog() {
    Purchase purchase =
        BlocProvider.of<SavePurchaseCubit>(context).getPurchase(null);
    BlocProvider.of<SavePurchaseCubit>(context).clearError();
    showDialog(
        context: context,
        builder: (_) {
          return MultiBlocProvider(
            providers: [
              BlocProvider.value(value: context.read<PurchaseCubit>()),
              BlocProvider.value(value: context.read<SavePurchaseCubit>()),
            ],
            child: PurchaseDialog(
              purchase: purchase,
              flgAddPurchase: true,
            ),
          );
        });
  }
}
