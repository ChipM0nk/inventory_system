import 'package:edar_app/cubit/invoice/invoice_cubit.dart';
import 'package:edar_app/cubit/products/products_cubit.dart';
import 'package:edar_app/data/model/invoice/invoice_item.dart';
import 'package:edar_app/presentation/widgets/fields/custom_text_field.dart';
import 'package:edar_app/presentation/widgets/fields/error_message_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/model/product.dart';

class AddItemDialog extends StatelessWidget {
  final Function(InvoiceItem) addInvoiceItem;
  final InvoiceItem? invoiceItem;
  const AddItemDialog({
    Key? key,
    required this.addInvoiceItem,
    this.invoiceItem,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<InvoiceCubit>(context).itemInit();
    BlocProvider.of<ProductsCubit>(context).fetchProducts();
    return AlertDialog(
      scrollable: true,
      title: const Text('Add Item'),
      content: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<InvoiceCubit, InvoiceState>(
          builder: (context, state) {
            final TextEditingController priceController =
                TextEditingController();
            final TextEditingController quantityController =
                TextEditingController();

            late bool prodSelected = false;

            // void onChange<Product>(prod) {
            //   BlocProvider.of<InvoiceCubit>(context).updateProduct(prod);

            //   priceController.text = prod.productPrice.toString();
            //   BlocProvider.of<InvoiceCubit>(context)
            //       .updatePrice(prod.productPrice.toString());

            //   BlocProvider.of<InvoiceCubit>(context).updateQuantity("1");
            //   quantityController.text = "1";
            // }

            var productDropdownField = StreamBuilder<Product>(
                stream: BlocProvider.of<InvoiceCubit>(context).productStream,
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
                  return StreamBuilder<Object>(
                      stream:
                          BlocProvider.of<InvoiceCubit>(context).priceStream,
                      builder: (context, snapshot) {
                        return Column(
                          children: [
                            BlocBuilder<ProductsCubit, ProductsState>(
                              builder: (context, state) {
                                if (state is ProductsLoaded) {
                                  // if (invoiceItem == null &&
                                  //     prodSelected == false) {
                                  //   onChange<Product>(state.products.first);
                                  //   prodSelected = true;
                                  // }

                                  return Autocomplete<String>(
                                    optionsBuilder:
                                        (TextEditingValue textEditingValue) {
                                      if (textEditingValue.text == '') {
                                        return const Iterable<String>.empty();
                                      } else {
                                        List<String> matches = <String>[];
                                        matches.addAll(state.products
                                            .map((e) => e.productName)
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
                                        onFieldSubmitted: (String value) {
                                          onFieldSubmitted();
                                          print(
                                              'You just typed a new entry  $value');
                                        },
                                      );
                                    },
                                    onSelected: (String productName) {
                                      Product product = state.products
                                          .firstWhere((element) =>
                                              element.productName ==
                                              productName);
                                      BlocProvider.of<InvoiceCubit>(context)
                                          .updateProduct(product);

                                      priceController.text =
                                          product.productPrice.toString();
                                      BlocProvider.of<InvoiceCubit>(context)
                                          .updatePrice(
                                              product.productPrice.toString());

                                      BlocProvider.of<InvoiceCubit>(context)
                                          .updateQuantity("1");
                                      quantityController.text = "1";
                                    },
                                  );
                                }
                                return const SizedBox(
                                    width: 100, child: Text("Error"));
                              },
                            ),
                            productCategory,
                          ],
                        );
                      });
                });

            var productPrice = StreamBuilder(
              stream: BlocProvider.of<InvoiceCubit>(context).priceStream,
              builder: (context, snapshot) {
                return Column(
                  children: [
                    CustomTextField(
                      labelText: "Price",
                      hintText: "1299.99",
                      controller: priceController,
                      snapshot: snapshot,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.allow(RegExp("[.0-9]")),
                      ],
                      onChanged: (text) {
                        BlocProvider.of<InvoiceCubit>(context)
                            .updatePrice(text);
                      },
                    ),
                  ],
                );
              },
            );

            var quantity = StreamBuilder(
              stream: BlocProvider.of<InvoiceCubit>(context).quantityStream,
              builder: (context, snapshot) {
                return Column(
                  children: [
                    CustomTextField(
                        labelText: "Quantity",
                        // initialValue: "1",
                        controller: quantityController,
                        snapshot: snapshot,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.allow(RegExp("[.0-9]")),
                        ],
                        onChanged: (text) {
                          BlocProvider.of<InvoiceCubit>(context)
                              .updateQuantity(text);
                        }),
                  ],
                );
              },
            );

            var totalAmount = StreamBuilder(
              stream: BlocProvider.of<InvoiceCubit>(context)
                  .invoiceItemAmountStream,
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
                        FilteringTextInputFormatter.allow(RegExp("[.0-9]")),
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
                BlocProvider.of<InvoiceCubit>(context).buttonValidInvoiceItem,
            builder: (context, snapshot) {
              return ElevatedButton(
                  child: const Text("Submit"),
                  onPressed: snapshot.hasData
                      ? () {
                          InvoiceItem invoiceItem =
                              BlocProvider.of<InvoiceCubit>(context)
                                  .getInvoiceItem(null);
                          addInvoiceItem(invoiceItem);
                          Navigator.of(context).pop();
                        }
                      : null);
            }),
        ElevatedButton(
            child: const Text("Cancel"),
            onPressed: () {
              Navigator.of(context).pop();
            })
      ],
    );
  }
}
