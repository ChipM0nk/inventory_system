import 'package:edar_app/constants/text_field_formats.dart';
import 'package:edar_app/cubit/invoice/save_invoice_cubit.dart';
import 'package:edar_app/cubit/products/products_cubit.dart';
import 'package:edar_app/data/model/invoice/invoice_item.dart';
import 'package:edar_app/presentation/widgets/custom_elevated_button.dart';
import 'package:edar_app/presentation/widgets/fields/custom_text_field.dart';
import 'package:edar_app/presentation/widgets/fields/error_message_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../data/model/product.dart';

class InvoiceAddItemDialog extends StatelessWidget {
  final Function(InvoiceItem) addInvoiceItem;
  final InvoiceItem? invoiceItem;
  const InvoiceAddItemDialog({
    Key? key,
    required this.addInvoiceItem,
    this.invoiceItem,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<SaveInvoiceCubit>(context).initItem();
    BlocProvider.of<ProductsCubit>(context).fetchProducts();
    return AlertDialog(
      scrollable: true,
      title: const Text('Add Item'),
      content: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<SaveInvoiceCubit, SaveInvoiceState>(
          builder: (context, state) {
            final TextEditingController priceController =
                TextEditingController();
            final TextEditingController quantityController =
                TextEditingController();

            // late bool prodSelected = false;

            var productDropdownField = StreamBuilder<Product>(
                stream:
                    BlocProvider.of<SaveInvoiceCubit>(context).productStream,
                builder: (context, snapshot) {
                  // final categoryController = TextEditingController();
                  final currStockController = TextEditingController();

                  currStockController.text = snapshot.hasData
                      ? snapshot.data!.currentStock.toString()
                      : "";
                  var currentStock = Column(
                    children: [
                      CustomTextField(
                        labelText: "Current Stock",
                        controller: currStockController,
                        enabled: false,
                      ),
                    ],
                  );
                  return StreamBuilder<Product>(
                      stream: BlocProvider.of<SaveInvoiceCubit>(context)
                          .productStream,
                      builder: (context, snapshot) {
                        return Column(
                          children: [
                            BlocBuilder<ProductsCubit, ProductsState>(
                              builder: (context, state) {
                                if (state is ProductsLoaded) {
                                  return Autocomplete<String>(
                                    optionsBuilder:
                                        (TextEditingValue textEditingValue) {
                                      if (textEditingValue.text == '') {
                                        BlocProvider.of<SaveInvoiceCubit>(
                                                context)
                                            .updateProduct(null);
                                        return const Iterable<String>.empty();
                                      } else {
                                        List<String> matches = <String>[];
                                        matches.addAll(state.products
                                            .map((e) =>
                                                "${e.productCode} - ${e.productName}")
                                            .toList());

                                        matches.retainWhere((s) {
                                          return s.toLowerCase().contains(
                                              textEditingValue.text
                                                  .toLowerCase());
                                        });
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
                                        snapshot: snapshot,
                                        onFieldSubmitted: (String value) {
                                          onFieldSubmitted();
                                        },
                                      );
                                    },
                                    onSelected: (String productName) {
                                      Product product = state.products
                                          .firstWhere((element) =>
                                              element.productCode ==
                                              productName.split("-")[0].trim());
                                      BlocProvider.of<SaveInvoiceCubit>(context)
                                          .updateProduct(product);

                                      priceController.text =
                                          product.productPrice.toString();
                                      BlocProvider.of<SaveInvoiceCubit>(context)
                                          .updatePrice(
                                              product.productPrice.toString());

                                      BlocProvider.of<SaveInvoiceCubit>(context)
                                          .updateQuantity("1");
                                      quantityController.text = "1";
                                    },
                                  );
                                }
                                return const SizedBox(
                                    width: 100, child: Text("Error"));
                              },
                            ),
                            currentStock,
                          ],
                        );
                      });
                });

            var productPrice = StreamBuilder(
              stream: BlocProvider.of<SaveInvoiceCubit>(context).priceStream,
              builder: (context, snapshot) {
                return Column(
                  children: [
                    CustomTextField(
                      labelText: "Price",
                      hintText: "1299.99",
                      controller: priceController,
                      snapshot: snapshot,
                      inputFormatters: <TextInputFormatter>[
                        TextFieldFormat.amountFormat
                      ],
                      onChanged: (text) {
                        BlocProvider.of<SaveInvoiceCubit>(context)
                            .updatePrice(text);
                      },
                    ),
                  ],
                );
              },
            );

            var quantity = StreamBuilder(
              stream: BlocProvider.of<SaveInvoiceCubit>(context).quantityStream,
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
                          BlocProvider.of<SaveInvoiceCubit>(context)
                              .updateQuantity(text);
                        }),
                  ],
                );
              },
            );

            var totalAmount = StreamBuilder<double>(
              stream: BlocProvider.of<SaveInvoiceCubit>(context)
                  .invoiceItemAmountStream,
              builder: (context, snapshot) {
                final totalAmountController = TextEditingController();
                totalAmountController.text = snapshot.hasData
                    ? snapshot.data!.toStringAsFixed(2)
                    : "0.0";
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
            stream: BlocProvider.of<SaveInvoiceCubit>(context)
                .buttonValidInvoiceItem,
            builder: (context, snapshot) {
              return CustomElevatedButton(
                  onPressed: snapshot.hasData
                      ? () {
                          InvoiceItem invoiceItem =
                              BlocProvider.of<SaveInvoiceCubit>(context)
                                  .getInvoiceItem(null);
                          addInvoiceItem(invoiceItem);
                          Navigator.of(context).pop();
                        }
                      : null,
                  child: const Text("Submit"));
            }),
        // CustomElevatedButton(
        //     child: const Text("Cancel"),
        //     onPressed: () {
        //       Navigator.of(context).pop();
        //     })
      ],
    );
  }
}
