import 'package:edar_app/cubit/categories/categories_cubit.dart';
import 'package:edar_app/cubit/products/products_cubit.dart';
import 'package:edar_app/cubit/suppliers/suppliers_cubit.dart';
import 'package:edar_app/data/model/category.dart';
import 'package:edar_app/data/model/product.dart';
import 'package:edar_app/data/model/supplier.dart';
import 'package:edar_app/presentation/widgets/fields/custom_dropdown.dart';
import 'package:edar_app/presentation/widgets/fields/error_message_field.dart';
import 'package:edar_app/presentation/widgets/fields/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// ignore: must_be_immutable
class ProductDialog extends StatelessWidget {
  Product? product;
  ProductDialog({this.product, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String title = 'Add Product';
    int? productId;
    late bool catSelected = false;
    late bool supSelected = false;
    BlocProvider.of<ProductsCubit>(context).init();
    BlocProvider.of<CategoriesCubit>(context).fetchCategories();
    BlocProvider.of<SuppliersCubit>(context).fetchSuppliers();
    if (product != null) {
      title = 'Update Product';
      BlocProvider.of<ProductsCubit>(context).loadProducts(product!);
      productId = product!.productId;
    } else {}

    var productCodeField = StreamBuilder(
      stream: BlocProvider.of<ProductsCubit>(context).productCodeStream,
      builder: (context, snapshot) {
        return CustomTextField(
            labelText: "Product Code",
            hintText: "GM",
            initialValue:
                product != null ? product!.productCode.toString() : null,
            snapshot: snapshot,
            onChanged: (text) {
              BlocProvider.of<ProductsCubit>(context).updateProductCode(text);
            });
      },
    );
    var productName = StreamBuilder(
      stream: BlocProvider.of<ProductsCubit>(context).productNameStream,
      builder: (context, snapshot) {
        return CustomTextField(
            labelText: "Product Name",
            hintText: "GM",
            initialValue:
                product != null ? product!.productName.toString() : null,
            snapshot: snapshot,
            onChanged: (text) {
              BlocProvider.of<ProductsCubit>(context).updateProductName(text);
            });
      },
    );
    var productPriceField = StreamBuilder(
      stream: BlocProvider.of<ProductsCubit>(context).productPriceStream,
      builder: (context, snapshot) {
        return CustomTextField(
            labelText: "Product Price",
            hintText: "999.99",
            initialValue:
                product != null ? product!.productPrice.toString() : null,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.allow(RegExp("[.0-9]")),
            ],
            snapshot: snapshot,
            onChanged: (text) {
              BlocProvider.of<ProductsCubit>(context).updateProductPrice(text);
            });
      },
    );
    var productQuanity = StreamBuilder(
      stream: BlocProvider.of<ProductsCubit>(context).productQuantityStream,
      builder: (context, snapshot) {
        return CustomTextField(
            labelText: "Product Quantity",
            hintText: "999.99",
            initialValue:
                product != null ? product!.productQuantity.toString() : null,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.allow(RegExp("[.0-9]")),
            ],
            snapshot: snapshot,
            onChanged: (text) {
              BlocProvider.of<ProductsCubit>(context)
                  .updateProductQuantity(text);
            });
      },
    );
    var productUnitField = StreamBuilder(
      stream: BlocProvider.of<ProductsCubit>(context).productUnitStream,
      builder: (context, snapshot) {
        return Padding(
          padding: const EdgeInsets.only(left: 0, right: 0),
          child: CustomTextField(
              labelText: "Product Unit",
              hintText: "09219999999",
              initialValue:
                  product != null ? product!.productUnit.toString() : null,
              snapshot: snapshot,
              onChanged: (text) {
                BlocProvider.of<ProductsCubit>(context).updateProductUnit(text);
              }),
        );
      },
    );
    var categoryField = StreamBuilder<Object>(
        stream: BlocProvider.of<ProductsCubit>(context).productCategoryStream,
        builder: (context, snapshot) {
          return Column(
            children: [
              BlocBuilder<CategoriesCubit, CategoriesState>(
                builder: (context, state) {
                  if (state is CategoriesLoaded) {
                    List<DropdownMenuItem<Category>> dropDownItems =
                        state.categories
                            .map((e) => DropdownMenuItem<Category>(
                                  value: e,
                                  child: Text(e.categoryName),
                                ))
                            .toList();

                    if (product == null && catSelected == false) {
                      BlocProvider.of<ProductsCubit>(context)
                          .updateProductCategory(state.categories.first);
                      catSelected = true;
                    }
                    void onChange<Category>(cat) async {
                      await BlocProvider.of<ProductsCubit>(context)
                          .updateProductCategory(cat);
                    }

                    return CustomDropdown<Category>(
                      labelText: "Category",
                      value:
                          BlocProvider.of<ProductsCubit>(context).getCategory(),
                      items: dropDownItems,
                      context: context,
                      onChanged: onChange,
                    );
                  }
                  return const SizedBox(
                    width: 16, //todo: handle
                  );
                },
              ),
            ],
          );
        });
    //   },
    // );
    //TODO Change this and avoid setting selectedSupplier object.
    //see sales_form.dart Payment Term
    var supplierField = StreamBuilder<Supplier>(
        stream: BlocProvider.of<ProductsCubit>(context).productSupplierStream,
        builder: (context, snapshot) {
          return Column(
            children: [
              BlocBuilder<SuppliersCubit, SuppliersState>(
                builder: (context, state) {
                  if (state is SuppliersLoaded) {
                    List<DropdownMenuItem<Supplier>> dropDownItems =
                        state.suppliers
                            .map((e) => DropdownMenuItem<Supplier>(
                                  value: e,
                                  child: Text(e.supplierName),
                                ))
                            .toList();

                    void onChange<Supplier>(sup) {
                      BlocProvider.of<ProductsCubit>(context)
                          .updateProductSupplier(sup);
                    }

                    if (product == null && supSelected == false) {
                      BlocProvider.of<ProductsCubit>(context)
                          .updateProductSupplier(state.suppliers.first);
                      supSelected = true;
                    }

                    return CustomDropdown<Supplier>(
                      labelText: "Supplier",
                      value:
                          BlocProvider.of<ProductsCubit>(context).getSupplier(),
                      items: dropDownItems,
                      context: context,
                      onChanged: onChange,
                    );
                  }
                  return const SizedBox(width: 16); //todo handle
                },
              ),
            ],
          );
        });

    var productDescriptionField = StreamBuilder(
      stream: BlocProvider.of<ProductsCubit>(context).productDescriptionStream,
      builder: (context, snapshot) {
        return CustomTextField(
            labelText: "Product Description",
            hintText: "Sto Tomas",
            width: 440,
            height: 60,
            minLines: 3,
            initialValue:
                product != null ? product!.productDescription.toString() : null,
            snapshot: snapshot,
            onChanged: (text) {
              BlocProvider.of<ProductsCubit>(context)
                  .updateProductDecription(text);
            });
      },
    );
    return AlertDialog(
      scrollable: true,
      title: Text(title),
      content: BlocListener<ProductsCubit, ProductsState>(
          listener: (context, state) {
            if (state is ProductAdded || state is ProductUpdated) {
              Navigator.of(context, rootNavigator: true).pop();
            }
          },
          child: Center(
            child: SizedBox(
              width: 450,
              child: Column(
                children: [
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        productCodeField,
                        productName,
                      ]),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [productDescriptionField],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      categoryField,
                      productPriceField,
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      productQuanity,
                      productUnitField,
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      supplierField,
                      const SizedBox(width: 200),
                    ],
                  ),
                ],
              ),
            ),
          )),
      actions: [
        Center(
          child: SizedBox(
            width: 200,
            child: StreamBuilder(
              stream: BlocProvider.of<ProductsCubit>(context).buttonValid,
              builder: (context, snapshot) {
                return Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF08B578),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                          onPressed: snapshot.hasData
                              ? product == null
                                  ? () =>
                                      BlocProvider.of<ProductsCubit>(context)
                                          .addProduct()
                                  : () =>
                                      BlocProvider.of<ProductsCubit>(context)
                                          .updateProduct(productId!)
                              : null,
                          child: const Text(
                            "Submit",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
