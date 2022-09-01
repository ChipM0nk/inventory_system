import 'package:edar_app/cubit/products/products_field_mixin.dart';
import 'package:edar_app/data/model/product.dart';
import 'package:edar_app/data/repository/product_repository.dart';
import 'package:edar_app/utils/mixin_validations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'products_state.dart';

class ProductsCubit extends Cubit<ProductsState>
    with ValidationMixin, ProductsFieldMixin {
  final ProductRepository productRepository;

  ProductsCubit({required this.productRepository}) : super(ProductsInitial());

  void fetchProducts() {
    print("Fetch products");

    productRepository.fetchAll().then((products) => {
          emit(ProductsLoaded(
            products: products,
            sortIndex: null,
            sortAscending: true,
          )),
        });
  }

  void sortProducts<T>(
      Comparable<T> Function(Product) getField, int sortIndex, bool ascending) {
    print("Sorting products");
    final currentState = state;
    if (currentState is ProductsLoaded) {
      final products = currentState.products;
      final filteredData = currentState.filteredData;

      final data = filteredData ?? products;
      data.sort((a, b) {
        final aValue = getField(a);
        final bValue = getField(b);
        return ascending
            ? Comparable.compare(aValue, bValue)
            : Comparable.compare(bValue, aValue);
      });
      emit(ProductsLoaded(
          filteredData: data,
          products: products,
          sortIndex: sortIndex,
          sortAscending: ascending));
    }
  }

  void addProduct() {
    emit(AddingProduct());

    Map<String, dynamic> productObj = getProduct(null).toJson();

    print("Add suppplier :::: ${productObj}");
    productRepository.addProduct(productObj).then((isAdded) {
      if (isAdded) {
        // fetchProducts();
        emit(ProductAdded());
        fetchProducts();
      } else {
        emit(ProductStateError());
      }
    });
  }

  void updateProduct(int productId) {
    emit(UpdatingProduct());

    Map<String, dynamic> productObj = getProduct(productId).toJson();
    print("Update ::: ${productObj}");

    productRepository.udpateProduct(productObj, productId!).then((isUpdated) {
      if (isUpdated) {
        // fetchProducts();
        emit(ProductUpdated());
        fetchProducts();
      } else {
        emit(ProductStateError());
      }
    });
  }

  void deleteProduct(int productId) {
    emit(DeletingProduct());

    productRepository.deleteProduct(productId).then((isDeleted) {
      if (isDeleted) {
        emit(ProductDeleted());
        fetchProducts();
      } else {
        emit(ProductStateError());
      }
    });
  }

  void searchProduct(String searchText) {
    final currentState = state;
    if (currentState is ProductsLoaded) {
      final data = currentState.products;
      if (searchText.isEmpty) {
        emit(ProductsLoaded(products: data, sortAscending: false));
      } else {
        final filteredData =
            data.where((cat) => cat.productName.contains(searchText)).toList();
        emit(ProductsLoaded(
            filteredData: filteredData, products: data, sortAscending: true));
      }
    }
  }

  loadProducts(Product product) {
    updateProductName(product.productName);
    updateProductDecription(product.productDescription);
    updateProductPrice(product.productPrice.toString());
    updateProductQuantity(product.productQuantity.toString());
    updateProductUnit(product.productUnit);
    updateProductSupplier(product.supplier);
    updateProductCategory(product.category);
  }
}
