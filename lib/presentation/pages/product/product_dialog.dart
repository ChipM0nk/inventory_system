import 'package:edar_app/cubit/categories/categories_cubit.dart';
import 'package:edar_app/cubit/products/products_cubit.dart';
import 'package:edar_app/cubit/suppliers/suppliers_cubit.dart';
import 'package:edar_app/data/model/category.dart';
import 'package:edar_app/data/model/product.dart';
import 'package:edar_app/data/model/supplier.dart';
import 'package:edar_app/presentation/widgets/fields/custom_dropdown.dart';
import 'package:edar_app/presentation/widgets/fields/custom_text_field.dart';
import 'package:edar_app/presentation/widgets/fields/error_text.dart';
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
            child: Container(
              width: 600,
              child: Column(
                children: [
                  Row(
                    children: [
                      SizedBox(
                        width: 300,
                        child: StreamBuilder(
                          stream: BlocProvider.of<ProductsCubit>(context)
                              .productCodeStream,
                          builder: (context, snapshot) {
                            return Padding(
                              padding: const EdgeInsets.only(
                                  left: 24, right: 24, top: 24),
                              child: Column(
                                children: [
                                  CustomTextField(
                                      labelText: "Enter Product Code",
                                      context: context,
                                      hintText: "GM",
                                      initialValue: product != null
                                          ? product!.productCode.toString()
                                          : null,
                                      onChanged: (text) {
                                        BlocProvider.of<ProductsCubit>(context)
                                            .updateProductCode(text);
                                        return text;
                                      }),
                                  snapshot.hasError
                                      ? ErrorText(
                                          errorText: snapshot.error.toString())
                                      : const SizedBox(
                                          height: 29,
                                        )
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 300,
                        child: StreamBuilder(
                          stream: BlocProvider.of<ProductsCubit>(context)
                              .productNameStream,
                          builder: (context, snapshot) {
                            return Padding(
                              padding: const EdgeInsets.only(
                                  left: 24, right: 24, top: 24),
                              child: Column(
                                children: [
                                  CustomTextField(
                                      labelText: "Enter Product Name",
                                      context: context,
                                      hintText: "GM",
                                      initialValue: product != null
                                          ? product!.productName.toString()
                                          : null,
                                      onChanged: (text) {
                                        BlocProvider.of<ProductsCubit>(context)
                                            .updateProductName(text);
                                        return text;
                                      }),
                                  snapshot.hasError
                                      ? ErrorText(
                                          errorText: snapshot.error.toString())
                                      : const SizedBox(
                                          height: 29,
                                        )
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                      SizedBox(
                        width: 300,
                        child: StreamBuilder(
                          stream: BlocProvider.of<ProductsCubit>(context)
                              .productPriceStream,
                          builder: (context, snapshot) {
                            return Padding(
                              padding: const EdgeInsets.only(
                                  left: 24, right: 24, top: 24),
                              child: Column(
                                children: [
                                  CustomTextField(
                                      labelText: "Enter Product Price",
                                      context: context,
                                      hintText: "09219999999",
                                      initialValue: product != null
                                          ? product!.productPrice.toString()
                                          : null,
                                      onChanged: (text) {
                                        BlocProvider.of<ProductsCubit>(context)
                                            .updateProductPrice(text);
                                        return text;
                                      }),
                                  snapshot.hasError
                                      ? ErrorText(
                                          errorText: snapshot.error.toString())
                                      : const SizedBox(
                                          height: 29,
                                        )
                                ],
                              ),
                            );
                          },
                        ),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: 300,
                        child: StreamBuilder(
                          stream: BlocProvider.of<ProductsCubit>(context)
                              .productQuantityStream,
                          builder: (context, snapshot) {
                            return Padding(
                              padding: const EdgeInsets.only(
                                  left: 24, right: 24, top: 24),
                              child: Column(
                                children: [
                                  CustomTextField(
                                      labelText: "Enter Product Quantity",
                                      context: context,
                                      hintText: "09219999999",
                                      initialValue: product != null
                                          ? product!.productQuantity.toString()
                                          : null,
                                      onChanged: (text) {
                                        BlocProvider.of<ProductsCubit>(context)
                                            .updateProductQuantity(text);
                                        return text;
                                      }),
                                  snapshot.hasError
                                      ? ErrorText(
                                          errorText: snapshot.error.toString())
                                      : const SizedBox(
                                          height: 29,
                                        )
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                      SizedBox(
                        width: 300,
                        child: StreamBuilder(
                          stream: BlocProvider.of<ProductsCubit>(context)
                              .productUnitStream,
                          builder: (context, snapshot) {
                            return Padding(
                              padding: const EdgeInsets.only(
                                  left: 24, right: 24, top: 24),
                              child: Column(
                                children: [
                                  CustomTextField(
                                      labelText: "Enter Product Unit",
                                      context: context,
                                      hintText: "09219999999",
                                      initialValue: product != null
                                          ? product!.productUnit.toString()
                                          : null,
                                      onChanged: (text) {
                                        BlocProvider.of<ProductsCubit>(context)
                                            .updateProductUnit(text);
                                        return text;
                                      }),
                                  snapshot.hasError
                                      ? ErrorText(
                                          errorText: snapshot.error.toString())
                                      : const SizedBox(
                                          height: 29,
                                        )
                                ],
                              ),
                            );
                          },
                        ),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: 300,
                        child: StreamBuilder(
                          stream: BlocProvider.of<ProductsCubit>(context)
                              .productCategoryStream,
                          builder: (context, snapshot) {
                            return Padding(
                              padding: const EdgeInsets.only(
                                  left: 24, right: 24, top: 24),
                              child: Column(
                                children: [
                                  BlocBuilder<CategoriesCubit, CategoriesState>(
                                    builder: (context, state) {
                                      if (state is CategoriesLoaded) {
                                        var selectedValue = null;
                                        if (product != null &&
                                            state.selectedCategory == null) {
                                          print("Yey product!");
                                          BlocProvider.of<CategoriesCubit>(
                                                  context)
                                              .selectCategory(
                                                  product!.category);
                                        }
                                        List<DropdownMenuItem<Category>>
                                            dropDownItems = state.categories
                                                .map((e) =>
                                                    DropdownMenuItem<Category>(
                                                      value: e,
                                                      child:
                                                          Text(e.categoryName),
                                                    ))
                                                .toList();

                                        void onChange<Category>(cat) {
                                          BlocProvider.of<CategoriesCubit>(
                                                  context)
                                              .selectCategory(cat);
                                          BlocProvider.of<ProductsCubit>(
                                                  context)
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
                                  snapshot.hasError
                                      ? ErrorText(
                                          errorText: snapshot.error.toString())
                                      : const SizedBox(
                                          height: 29,
                                        )
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                      SizedBox(
                        width: 300,
                        child: StreamBuilder(
                          stream: BlocProvider.of<ProductsCubit>(context)
                              .productSupplierStream,
                          builder: (context, snapshot) {
                            return Padding(
                              padding: const EdgeInsets.only(
                                  left: 24, right: 24, top: 24),
                              child: Column(
                                children: [
                                  BlocBuilder<SuppliersCubit, SuppliersState>(
                                    builder: (context, state) {
                                      if (state is SuppliersLoaded) {
                                        if (product != null &&
                                            state.selectedSupplier == null) {
                                          print("Yey!");
                                          BlocProvider.of<SuppliersCubit>(
                                                  context)
                                              .selectSupplier(
                                                  product!.supplier);
                                        }
                                        List<DropdownMenuItem<Supplier>>
                                            dropDownItems = state.suppliers
                                                .map((e) =>
                                                    DropdownMenuItem<Supplier>(
                                                      value: e,
                                                      child:
                                                          Text(e.supplierName),
                                                    ))
                                                .toList();

                                        void onChange<Supplier>(sup) {
                                          BlocProvider.of<SuppliersCubit>(
                                                  context)
                                              .selectSupplier(sup);
                                          BlocProvider.of<ProductsCubit>(
                                                  context)
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
                                  snapshot.hasError
                                      ? ErrorText(
                                          errorText: snapshot.error.toString())
                                      : const SizedBox(
                                          height: 29,
                                        )
                                ],
                              ),
                            );
                          },
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    width: 1000,
                    child: StreamBuilder(
                      stream: BlocProvider.of<ProductsCubit>(context)
                          .productDescriptionStream,
                      builder: (context, snapshot) {
                        return Padding(
                          padding: const EdgeInsets.only(
                              left: 24, right: 24, top: 24),
                          child: Column(
                            children: [
                              CustomTextField(
                                  labelText: "Enter Product Description",
                                  context: context,
                                  hintText: "Sto Tomas",
                                  initialValue: product != null
                                      ? product!.productDescription.toString()
                                      : null,
                                  onChanged: (text) {
                                    BlocProvider.of<ProductsCubit>(context)
                                        .updateProductDecription(text);
                                    return text;
                                  }),
                              snapshot.hasError
                                  ? ErrorText(
                                      errorText: snapshot.error.toString())
                                  : const SizedBox(
                                      height: 29,
                                    )
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          )),
      actions: [
        StreamBuilder(
          stream: BlocProvider.of<ProductsCubit>(context).buttonValid,
          builder: (context, snapshot) {
            return Padding(
              padding: const EdgeInsets.all(24),
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
                              ? () => BlocProvider.of<ProductsCubit>(context)
                                  .addProduct()
                              : () => BlocProvider.of<ProductsCubit>(context)
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
      ],
    );
  }
}
