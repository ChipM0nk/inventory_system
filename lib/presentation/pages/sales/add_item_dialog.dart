import 'package:edar_app/cubit/invoice/invoice_cubit.dart';
import 'package:edar_app/cubit/products/products_cubit.dart';
import 'package:edar_app/data/model/invoice_item.dart';
import 'package:edar_app/presentation/widgets/fields/custom_dropdown.dart';
import 'package:edar_app/presentation/widgets/fields/custom_text_field.dart';
import 'package:edar_app/presentation/widgets/fields/error_message_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/model/invoice_item_model.dart';
import '../../../data/model/product.dart';

class AddItemDialog extends StatelessWidget {
  final Function(InvoiceItemModel) addInvoiceItem;
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
            final FocusNode categoryFocusNode = FocusNode();
            final TextEditingController priceController =
                TextEditingController();
            final TextEditingController quantityController =
                TextEditingController();
            final TextEditingController categoryController =
                TextEditingController();
            final TextEditingController totalAmountController =
                TextEditingController();

            late bool prodSelected = false;
            void onChange<Product>(prod) {
              BlocProvider.of<InvoiceCubit>(context).updateProduct(prod);

              priceController.text = prod.productPrice.toString();
              BlocProvider.of<InvoiceCubit>(context)
                  .updatePrice(prod.productPrice.toString());

              categoryController.text = prod.category.categoryName.toString();
              // BlocProvider.of<InvoiceCubit>(context)
              //     .updateca(prod.category.categoryName);

              BlocProvider.of<InvoiceCubit>(context).updateQuantity("1");
              quantityController.text = "1";

              totalAmountController.text =
                  double.parse(priceController.text).toString();
              BlocProvider.of<InvoiceCubit>(context)
                  .updateAmount(double.parse(priceController.text).toString());

              categoryFocusNode.requestFocus();
            }

            var productDropdownField = StreamBuilder<Product>(
                stream: BlocProvider.of<InvoiceCubit>(context).productStream,
                builder: (context, snapshot) {
                  return StreamBuilder<Object>(
                      stream:
                          BlocProvider.of<InvoiceCubit>(context).priceStream,
                      builder: (context, snapshot) {
                        return Column(
                          children: [
                            BlocBuilder<ProductsCubit, ProductsState>(
                              builder: (context, state) {
                                if (state is ProductsLoaded) {
                                  List<DropdownMenuItem<Product>>
                                      dropDownItems = state.products
                                          .map((e) => DropdownMenuItem<Product>(
                                                value: e,
                                                child: Text(
                                                  e.productName,
                                                  style: const TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.w900),
                                                ),
                                              ))
                                          .toList();

                                  if (invoiceItem == null &&
                                      prodSelected == false) {
                                    onChange<Product>(state.products.first);
                                    prodSelected = true;
                                  }

                                  return CustomDropdown<Product>(
                                    labelText: "Product",
                                    value:
                                        BlocProvider.of<InvoiceCubit>(context)
                                            .getProduct(),
                                    items: dropDownItems,
                                    context: context,
                                    onChanged: onChange,
                                  );
                                }
                                return const SizedBox(
                                    width: 100, child: Text("Error"));
                              },
                            ),
                          ],
                        );
                      });
                });

            var productCategory = Column(
              children: [
                CustomTextField(
                  labelText: "Category",
                  controller: categoryController,
                  enabled: false,
                  focusNode: categoryFocusNode,
                ),
                const Padding(
                    padding: EdgeInsets.all(5.0), child: SizedBox(width: 200)),
              ],
            );

            var productPrice = StreamBuilder(
              stream: BlocProvider.of<InvoiceCubit>(context).priceStream,
              builder: (context, snapshot) {
                return Column(
                  children: [
                    CustomTextField(
                        labelText: "Price",
                        hintText: "1299.99",
                        controller: priceController,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.allow(RegExp("[.0-9]")),
                          // TextInputFormatter.withFunction((oldValue, newValue) {
                          //   String newText = NumberFormat("###.0#")
                          //       .format(double.parse(oldValue.text));
                          //   print("newVal :${newText}");
                          //   return TextEditingValue(text: newText);
                          //   // return newValue;
                          // })
                        ],
                        onChanged: (text) {
                          BlocProvider.of<InvoiceCubit>(context)
                              .updatePrice(text);
                          totalAmountController.text = (double.parse(text) *
                                  double.parse(quantityController.text))
                              .toStringAsFixed(2);
                        }),
                    ErrorMessage(snapshot: snapshot)
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
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.allow(RegExp("[.0-9]")),
                        ],
                        onChanged: (text) {
                          BlocProvider.of<InvoiceCubit>(context)
                              .updateQuantity(text);
                          totalAmountController.text = (double.parse(text) *
                                  double.parse(priceController.text))
                              .toStringAsFixed(2);
                        }),
                    ErrorMessage(snapshot: snapshot)
                  ],
                );
              },
            );

            var totalAmount = StreamBuilder(
              stream: BlocProvider.of<InvoiceCubit>(context).amountStream,
              builder: (context, snapshot) {
                return Column(
                  children: [
                    CustomTextField(
                        labelText: "Amount",
                        controller: totalAmountController,
                        enabled: false,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.allow(RegExp("[.0-9]")),
                        ],
                        onChanged: (text) {
                          BlocProvider.of<InvoiceCubit>(context)
                              .updateAmount(text);
                        }),
                    ErrorMessage(snapshot: snapshot)
                  ],
                );
              },
            );
            return Column(
              children: <Widget>[
                productDropdownField,
                productCategory,
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
                          BlocProvider.of<InvoiceCubit>(context)
                              .addInvoiceItem(invoiceItem);
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
