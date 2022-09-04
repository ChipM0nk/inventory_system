import 'package:edar_app/cubit/categories/categories_cubit.dart';
import 'package:edar_app/cubit/products/products_cubit.dart';
import 'package:edar_app/cubit/suppliers/suppliers_cubit.dart';
import 'package:edar_app/data/model/category.dart';
import 'package:edar_app/data/model/product.dart';
import 'package:edar_app/data/model/supplier.dart';
import 'package:edar_app/presentation/widgets/fields/custom_dropdown.dart';
import 'package:edar_app/presentation/widgets/fields/custom_text_field.dart';
import 'package:edar_app/presentation/widgets/fields/error_message_field.dart';
import 'package:edar_app/presentation/widgets/fields/form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// ignore: must_be_immutable
class ProductDialog extends StatelessWidget {
  Product? product;
  ProductDialog({this.product, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String title = 'Add Product';
    int? productId;
    BlocProvider.of<ProductsCubit>(context).init();
    BlocProvider.of<CategoriesCubit>(context).fetchCategories();
    BlocProvider.of<SuppliersCubit>(context).fetchSuppliers();
    if (product != null) {
      title = 'Update Product';
      BlocProvider.of<ProductsCubit>(context).loadProducts(product!);
      productId = product!.productId;
    }

    var productCodeField = StreamBuilder(
      stream: BlocProvider.of<ProductsCubit>(context).productCodeStream,
      builder: (context, snapshot) {
        return Column(
          children: [
            CustomTextFormField(
                labelText: "Product Code",
                hintText: "GM",
                initialValue:
                    product != null ? product!.productCode.toString() : null,
                onChanged: (text) {
                  BlocProvider.of<ProductsCubit>(context)
                      .updateProductCode(text);
                }),
            ErrorMessage(snapshot: snapshot)
          ],
        );
      },
    );
    var productName = StreamBuilder(
      stream: BlocProvider.of<ProductsCubit>(context).productNameStream,
      builder: (context, snapshot) {
        return Column(
          children: [
            CustomTextFormField(
                labelText: "Product Name",
                hintText: "GM",
                initialValue:
                    product != null ? product!.productName.toString() : null,
                onChanged: (text) {
                  BlocProvider.of<ProductsCubit>(context)
                      .updateProductName(text);
                }),
            ErrorMessage(snapshot: snapshot)
          ],
        );
      },
    );
    var productPriceField = StreamBuilder(
      stream: BlocProvider.of<ProductsCubit>(context).productPriceStream,
      builder: (context, snapshot) {
        return Column(
          children: [
            CustomTextFormField(
                labelText: "Product Price",
                hintText: "09219999999",
                initialValue:
                    product != null ? product!.productPrice.toString() : null,
                onChanged: (text) {
                  BlocProvider.of<ProductsCubit>(context)
                      .updateProductPrice(text);
                }),
            ErrorMessage(snapshot: snapshot)
          ],
        );
      },
    );
    var productQuanity = StreamBuilder(
      stream: BlocProvider.of<ProductsCubit>(context).productQuantityStream,
      builder: (context, snapshot) {
        return Column(
          children: [
            CustomTextFormField(
                labelText: "Product Quantity",
                hintText: "09219999999",
                initialValue: product != null
                    ? product!.productQuantity.toString()
                    : null,
                onChanged: (text) {
                  BlocProvider.of<ProductsCubit>(context)
                      .updateProductQuantity(text);
                }),
            ErrorMessage(snapshot: snapshot)
          ],
        );
      },
    );
    var productUnitField = StreamBuilder(
      stream: BlocProvider.of<ProductsCubit>(context).productUnitStream,
      builder: (context, snapshot) {
        return Padding(
          padding: const EdgeInsets.only(left: 0, right: 0),
          child: Column(
            children: [
              CustomTextFormField(
                  labelText: "Product Unit",
                  hintText: "09219999999",
                  initialValue:
                      product != null ? product!.productUnit.toString() : null,
                  onChanged: (text) {
                    BlocProvider.of<ProductsCubit>(context)
                        .updateProductUnit(text);
                  }),
              ErrorMessage(snapshot: snapshot)
            ],
          ),
        );
      },
    );
    var categoryField = StreamBuilder(
      stream: BlocProvider.of<ProductsCubit>(context).productCategoryStream,
      builder: (context, snapshot) {
        return Column(
          children: [
            BlocBuilder<CategoriesCubit, CategoriesState>(
              builder: (context, state) {
                if (state is CategoriesLoaded) {
                  if (product != null && state.selectedCategory == null) {
                    BlocProvider.of<CategoriesCubit>(context)
                        .selectCategory(product!.category);
                  }
                  List<DropdownMenuItem<Category>> dropDownItems =
                      state.categories
                          .map((e) => DropdownMenuItem<Category>(
                                value: e,
                                child: Text(e.categoryName),
                              ))
                          .toList();

                  void onChange<Category>(cat) {
                    BlocProvider.of<CategoriesCubit>(context)
                        .selectCategory(cat);
                    BlocProvider.of<ProductsCubit>(context)
                        .updateProductCategory(cat);
                  }

                  return CustomDropdown<Category>(
                    labelText: "Select Category",
                    value: state.selectedCategory,
                    items: dropDownItems,
                    context: context,
                    onChanged: onChange,
                  );
                }
                return const SizedBox(
                  width: 10,
                );
              },
            ),
            ErrorMessage(snapshot: snapshot)
          ],
        );
      },
    );
    var supplierField = StreamBuilder(
      stream: BlocProvider.of<ProductsCubit>(context).productSupplierStream,
      builder: (context, snapshot) {
        return Column(
          children: [
            BlocBuilder<SuppliersCubit, SuppliersState>(
              builder: (context, state) {
                if (state is SuppliersLoaded) {
                  if (product != null && state.selectedSupplier == null) {
                    BlocProvider.of<SuppliersCubit>(context)
                        .selectSupplier(product!.supplier);
                  }
                  List<DropdownMenuItem<Supplier>> dropDownItems =
                      state.suppliers
                          .map((e) => DropdownMenuItem<Supplier>(
                                value: e,
                                child: Text(e.supplierName),
                              ))
                          .toList();

                  void onChange<Supplier>(sup) {
                    BlocProvider.of<SuppliersCubit>(context)
                        .selectSupplier(sup);
                    BlocProvider.of<ProductsCubit>(context)
                        .updateProductSupplier(sup);
                  }

                  return CustomDropdown<Supplier>(
                    labelText: "Select Supplier",
                    value: state.selectedSupplier,
                    items: dropDownItems,
                    context: context,
                    onChanged: onChange,
                  );
                }
                return const SizedBox(
                  width: 10,
                );
              },
            ),
            ErrorMessage(snapshot: snapshot)
          ],
        );
      },
    );
    var productDescriptionField = StreamBuilder(
      stream: BlocProvider.of<ProductsCubit>(context).productDescriptionStream,
      builder: (context, snapshot) {
        return Column(
          children: [
            CustomTextFormField(
                labelText: "Product Description",
                hintText: "Sto Tomas",
                width: 450,
                height: 60,
                minLines: 3,
                initialValue: product != null
                    ? product!.productDescription.toString()
                    : null,
                onChanged: (text) {
                  BlocProvider.of<ProductsCubit>(context)
                      .updateProductDecription(text);
                }),
            ErrorMessage(snapshot: snapshot)
          ],
        );
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
              width: 500,
              child: Column(
                children: [
                  Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        productCodeField,
                        const SizedBox(
                          width: 30,
                        ),
                        productName,
                      ]),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [productDescriptionField],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      productPriceField,
                      const SizedBox(
                        width: 30,
                      ),
                      productQuanity,
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      productUnitField,
                      const SizedBox(
                        width: 30,
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      categoryField,
                      const SizedBox(
                        width: 50,
                      ),
                      supplierField,
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
