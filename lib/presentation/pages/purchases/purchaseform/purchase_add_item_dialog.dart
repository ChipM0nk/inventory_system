import 'package:edar_app/constants/text_field_formats.dart';
import 'package:edar_app/cubit/products/products_cubit.dart';
import 'package:edar_app/cubit/purchases/purchase_cubit.dart';
import 'package:edar_app/data/model/product.dart';
import 'package:edar_app/data/model/purchase/purchase_item.dart';
import 'package:edar_app/data/model/supplier.dart';
import 'package:edar_app/presentation/widgets/custom_elevated_button.dart';
import 'package:edar_app/presentation/widgets/fields/custom_text_field.dart';
import 'package:edar_app/presentation/widgets/fields/error_message_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

class PurchaseAddItemDialog extends StatelessWidget {
  final Function(PurchaseItem) addPurchaseItem;
  final PurchaseItem? purchaseItem;
  const PurchaseAddItemDialog({
    super.key,
    required this.addPurchaseItem,
    this.purchaseItem,
  });

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<PurchaseCubit>(context).initItem();
    BlocProvider.of<ProductsCubit>(context).fetchProducts();
    return AlertDialog(
      scrollable: true,
      title: const Text('Add Item'),
      content: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<PurchaseCubit, PurchaseState>(
          builder: (context, state) {
            print("Building dialog");
            final TextEditingController priceController =
                TextEditingController();
            final TextEditingController quantityController =
                TextEditingController();

            // late bool prodSelected = false;

            var productDropdownField = StreamBuilder<Product>(
                stream: BlocProvider.of<PurchaseCubit>(context).productStream,
                builder: (context, snapshot) {
                  final categoryController = TextEditingController();
                  categoryController.text = snapshot.hasData
                      ? snapshot.data!.category.categoryName
                      : "";

                  var productCategory = Column(
                    children: [
                      CustomTextField(
                        labelText: "Category",
                        controller: categoryController,
                        enabled: false,
                      ),
                    ],
                  );
                  return Column(
                    children: [
                      StreamBuilder<Supplier>(
                          stream: BlocProvider.of<PurchaseCubit>(context)
                              .supplierStream,
                          builder: (context, snapshot) {
                            int supplierId = snapshot.data!.supplierId!;
                            return BlocBuilder<ProductsCubit, ProductsState>(
                              builder: (context, state) {
                                if (state is ProductsLoaded) {
                                  return StreamBuilder<Product>(
                                      stream: BlocProvider.of<PurchaseCubit>(
                                              context)
                                          .productStream,
                                      builder: (context, snapshot) {
                                        return Autocomplete<String>(
                                          optionsBuilder: (TextEditingValue
                                              textEditingValue) {
                                            if (textEditingValue.text == '') {
                                              categoryController.text = "";
                                              BlocProvider.of<PurchaseCubit>(
                                                      context)
                                                  .updateProduct(null);
                                              return const Iterable<
                                                  String>.empty();
                                            } else {
                                              List<String> matches = <String>[];
                                              matches.addAll(state.products
                                                  .where((e) =>
                                                      e.supplier.supplierId ==
                                                      supplierId)
                                                  .map((e) =>
                                                      "${e.productCode} - ${e.productName}")
                                                  .toList());

                                              matches.retainWhere((s) {
                                                return s.toLowerCase().contains(
                                                    textEditingValue.text
                                                        .toLowerCase());
                                              });

                                              if (matches.isEmpty) {
                                                BlocProvider.of<PurchaseCubit>(
                                                        context)
                                                    .updateProduct(null);

                                                BlocProvider.of<PurchaseCubit>(
                                                        context)
                                                    .updateBatchQuantity("0");
                                                quantityController.text = "0";
                                              }
                                              return matches;
                                            }
                                          },
                                          fieldViewBuilder: (context,
                                              textEditingController,
                                              focusNode,
                                              onFieldSubmitted) {
                                            return CustomTextField(
                                              labelText: "Product",
                                              focusNode: focusNode,
                                              hintText: "GM Toilet Bowl",
                                              controller: textEditingController,
                                              autofocus: true,
                                              onFieldSubmitted: (String value) {
                                                onFieldSubmitted();
                                              },
                                              snapshot: snapshot,
                                            );
                                          },
                                          onSelected: (String productName) {
                                            Product product = state.products
                                                .firstWhere((element) =>
                                                    element.productCode ==
                                                    productName
                                                        .split("-")[0]
                                                        .trim());
                                            BlocProvider.of<PurchaseCubit>(
                                                    context)
                                                .updateProduct(product);

                                            BlocProvider.of<PurchaseCubit>(
                                                    context)
                                                .updateBatchQuantity("1");
                                            quantityController.text = "1";
                                          },
                                        );
                                      });
                                }
                                return const SizedBox(
                                    width: 100, child: Text("Error"));
                              },
                            );
                          }),
                      productCategory,
                    ],
                  );
                });

            var productPrice = StreamBuilder(
              stream:
                  BlocProvider.of<PurchaseCubit>(context).purchaseAmountStream,
              builder: (context, snapshot) {
                return Column(
                  children: [
                    CustomTextField(
                      labelText: "Purchase Amount",
                      hintText: "1299.99",
                      controller: priceController,
                      snapshot: snapshot,
                      inputFormatters: <TextInputFormatter>[
                        TextFieldFormat.amountFormat
                      ],
                      onChanged: (text) {
                        BlocProvider.of<PurchaseCubit>(context)
                            .updatePurchaseAmount(text);
                      },
                    ),
                  ],
                );
              },
            );

            var quantity = StreamBuilder(
              stream:
                  BlocProvider.of<PurchaseCubit>(context).batchQuantityStream,
              builder: (context, snapshot) {
                return Column(
                  children: [
                    CustomTextField(
                        labelText: "Quantity",
                        // initialValue: "1",
                        controller: quantityController,
                        snapshot: snapshot,
                        inputFormatters: <TextInputFormatter>[
                          TextFieldFormat.amountFormat
                        ],
                        onChanged: (text) {
                          BlocProvider.of<PurchaseCubit>(context)
                              .updateBatchQuantity(text);
                        }),
                  ],
                );
              },
            );

            var totalAmount = StreamBuilder(
              stream: BlocProvider.of<PurchaseCubit>(context).itemTotalStream,
              builder: (context, snapshot) {
                final totalAmountController = TextEditingController();
                totalAmountController.text =
                    snapshot.hasData ? snapshot.data.toString() : "0.0";
                return Column(
                  children: [
                    CustomTextField(
                      labelText: "Amount",
                      controller: totalAmountController,
                      enabled: false,
                      inputFormatters: <TextInputFormatter>[
                        TextFieldFormat.amountFormat
                      ],
                    ),
                    ErrorMessage(snapshot: snapshot)
                  ],
                );
              },
            );
            return Column(
              children: <Widget>[
                productDropdownField,
                productPrice,
                quantity,
                totalAmount,
              ],
            );
          },
        ),
      ),
      actions: [
        StreamBuilder<bool>(
            stream:
                BlocProvider.of<PurchaseCubit>(context).buttonValidPurchaseItem,
            builder: (context, snapshot) {
              return CustomElevatedButton(
                  onPressed: snapshot.hasData
                      ? () {
                          PurchaseItem purchaseItem =
                              BlocProvider.of<PurchaseCubit>(context)
                                  .getPurchaseItem(null);
                          addPurchaseItem(purchaseItem);
                          Navigator.of(context).pop();
                        }
                      : null,
                  child: const Text("Submit"));
            }),
      ],
    );
  }
}
