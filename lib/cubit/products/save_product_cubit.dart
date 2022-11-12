// ignore_for_file: must_be_immutable

import 'package:bloc/bloc.dart';
import 'package:edar_app/common/mixins/error_message_mixin.dart';
import 'package:edar_app/common/mixins/mixin_validations.dart';
import 'package:edar_app/cubit/products/products_field_mixin.dart';
import 'package:edar_app/data/model/product.dart';
import 'package:edar_app/data/repository/product_repository.dart';
import 'package:flutter/material.dart';

part 'save_product_state.dart';

class SaveProductCubit extends Cubit<SaveProductState>
    with ValidationMixin, ProductsFieldMixin, ErrorMessageMixin {
  final ProductRepository productRepository = ProductRepository();

  SaveProductCubit() : super(SaveProductInitial());

  initDialog() {
    init();
    clearError();
    emit(SaveProductInitial());
  }

  void addProduct() {
    emit(ProductSaving());

    Map<String, dynamic> productObj = getProduct(null).toJson();

    productRepository.addProduct(productObj).then((isAdded) {
      if (isAdded) {
        emit(ProductSaved());
      } else {
        updateError(null, null);
        emit(ProductSavingError());
      }
    }).onError(
      (error, stackTrace) {
        emit(ProductSavingError());
        updateError('$error', stackTrace);
      },
    );
  }

  void updateProduct(int productId) {
    emit(ProductSaving());

    Map<String, dynamic> productObj = getProduct(productId).toJson();

    productRepository.udpateProduct(productObj, productId!).then((isUpdated) {
      if (isUpdated) {
        emit(ProductSaved());
      } else {
        updateError(null, null);
        emit(ProductSavingError());
      }
    }).onError(
      (error, stackTrace) {
        emit(ProductSavingError());
        updateError('$error', stackTrace);
      },
    );
  }

  loadProducts(Product product) {
    updateProductCode(product.productCode);
    updateProductName(product.productName);
    updateProductDecription(product.productDescription);
    updateProductPrice(product.productPrice.toString());
    updateProductQuantity(product.currentStock.toString());
    updateProductUnit(product.unit);
    updateProductSupplier(product.supplier);
    updateProductCategory(product.category);
  }
}
