import 'package:edar_app/cubit/categories/categories_cubit.dart';
import 'package:edar_app/cubit/products/products_cubit.dart';
import 'package:edar_app/cubit/products/save_product_cubit.dart';
import 'package:edar_app/cubit/suppliers/suppliers_cubit.dart';
import 'package:edar_app/data/model/category.dart';
import 'package:edar_app/data/model/product.dart';
import 'package:edar_app/data/model/supplier.dart';
import 'package:edar_app/presentation/widgets/custom_elevated_action_button.dart';
import 'package:edar_app/presentation/widgets/fields/custom_dropdown.dart';
import 'package:edar_app/presentation/widgets/fields/custom_text_field.dart';
import 'package:edar_app/presentation/widgets/fields/error_message_field.dart';
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
    BlocProvider.of<SaveProductCubit>(context).initDialog();
    BlocProvider.of<CategoriesCubit>(context).fetchCategories();
    BlocProvider.of<SuppliersCubit>(context).fetchSuppliers();
    BlocProvider.of<SaveProductCubit>(context).clearError();
    if (product != null) {
      title = 'Update Product';
      BlocProvider.of<SaveProductCubit>(context).loadProducts(product!);
      productId = product!.productId;
    } else {
      BlocProvider.of<SaveProductCubit>(context).updateProductQuantity("0");
    }

    var productCodeField = StreamBuilder(
      stream: BlocProvider.of<SaveProductCubit>(context).productCodeStream,
      builder: (context, snapshot) {
        return CustomTextField(
            labelText: "Product Code",
            hintText: "GM",
            initialValue:
                product != null ? product!.productCode.toString() : null,
            snapshot: snapshot,
            onChanged: (text) {
              BlocProvider.of<SaveProductCubit>(context)
                  .updateProductCode(text);
            });
      },
    );
    var productName = StreamBuilder(
      stream: BlocProvider.of<SaveProductCubit>(context).productNameStream,
      builder: (context, snapshot) {
        return CustomTextField(
            labelText: "Product Name",
            hintText: "GM",
            initialValue:
                product != null ? product!.productName.toString() : null,
            snapshot: snapshot,
            onChanged: (text) {
              BlocProvider.of<SaveProductCubit>(context)
                  .updateProductName(text);
            });
      },
    );
    var productPriceField = StreamBuilder(
      stream: BlocProvider.of<SaveProductCubit>(context).productPriceStream,
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
              BlocProvider.of<SaveProductCubit>(context)
                  .updateProductPrice(text);
            });
      },
    );
    var productQuanity = StreamBuilder(
      stream: BlocProvider.of<SaveProductCubit>(context).productQuantityStream,
      builder: (context, snapshot) {
        return CustomTextField(
            enabled: false,
            labelText: "Product Quantity",
            hintText: "999.99",
            initialValue:
                product != null ? product!.currentStock.toString() : null,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.allow(RegExp("[.0-9]")),
            ],
            snapshot: snapshot,
            onChanged: (text) {
              BlocProvider.of<SaveProductCubit>(context)
                  .updateProductQuantity(text);
            });
      },
    );
    var productUnitField = StreamBuilder(
      stream: BlocProvider.of<SaveProductCubit>(context).productUnitStream,
      builder: (context, snapshot) {
        return Padding(
          padding: const EdgeInsets.only(left: 0, right: 0),
          child: CustomTextField(
              labelText: "Product Unit",
              hintText: "pcs",
              initialValue: product != null ? product!.unit.toString() : null,
              snapshot: snapshot,
              onChanged: (text) {
                BlocProvider.of<SaveProductCubit>(context)
                    .updateProductUnit(text);
              }),
        );
      },
    );
    var categoryField = StreamBuilder<Object>(
        stream:
            BlocProvider.of<SaveProductCubit>(context).productCategoryStream,
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
                      BlocProvider.of<SaveProductCubit>(context)
                          .updateProductCategory(state.categories.first);
                      catSelected = true;
                    }
                    void onChange<Category>(cat) async {
                      await BlocProvider.of<SaveProductCubit>(context)
                          .updateProductCategory(cat);
                    }

                    return CustomDropdown<Category>(
                      labelText: "Category",
                      value: BlocProvider.of<SaveProductCubit>(context)
                          .getCategory(),
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
        stream:
            BlocProvider.of<SaveProductCubit>(context).productSupplierStream,
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
                      BlocProvider.of<SaveProductCubit>(context)
                          .updateProductSupplier(sup);
                    }

                    if (product == null && supSelected == false) {
                      BlocProvider.of<SaveProductCubit>(context)
                          .updateProductSupplier(state.suppliers.first);
                      supSelected = true;
                    }

                    return CustomDropdown<Supplier>(
                      labelText: "Supplier",
                      value: BlocProvider.of<SaveProductCubit>(context)
                          .getSupplier(),
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
      stream:
          BlocProvider.of<SaveProductCubit>(context).productDescriptionStream,
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
              BlocProvider.of<SaveProductCubit>(context)
                  .updateProductDecription(text);
            });
      },
    );

    var serviceErrorMessage = StreamBuilder(
      stream: BlocProvider.of<SaveProductCubit>(context).errorStream,
      builder: (context, snapshot) {
        return Padding(
          padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
          child: ErrorMessage(
            snapshot: snapshot,
            fontSize: 14,
            height: 20,
          ),
        );
      },
    );

    return BlocBuilder<SaveProductCubit, SaveProductState>(
      builder: (context, state) {
        bool isSaving = state is ProductSaving;
        if (state is ProductSaved) {
          BlocProvider.of<ProductsCubit>(context).fetchProducts();
          Navigator.of(context, rootNavigator: true).pop();
        }
        return AlertDialog(
          scrollable: true,
          title: Text(title),
          content: Center(
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
                      supplierField,
                      productUnitField,
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      productQuanity,
                      const SizedBox(width: 200),
                    ],
                  ),
                  Row(
                    children: [serviceErrorMessage],
                  )
                ],
              ),
            ),
          ),
          actions: [
            Center(
              child: SizedBox(
                width: 200,
                child: StreamBuilder(
                  stream:
                      BlocProvider.of<SaveProductCubit>(context).buttonValid,
                  builder: (context, snapshot) {
                    return Padding(
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        children: [
                          Expanded(
                            child: CustomElevatedActionButton(
                              onPressed: snapshot.hasData
                                  ? product == null
                                      ? () => BlocProvider.of<SaveProductCubit>(
                                              context)
                                          .addProduct()
                                      : () => BlocProvider.of<SaveProductCubit>(
                                              context)
                                          .updateProduct(productId!)
                                  : null,
                              text: const Text(
                                "Submit",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              icon: const Icon(Icons.save),
                              isLoading: isSaving,
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
      },
    );
  }
}
