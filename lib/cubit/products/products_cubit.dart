import 'package:edar_app/cubit/products/products_field_mixin.dart';
import 'package:edar_app/data/model/product.dart';
import 'package:edar_app/data/repository/product_repository.dart';
import 'package:edar_app/common/mixins/error_message_mixin.dart';
import 'package:edar_app/common/mixins/mixin_validations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'products_state.dart';

class ProductsCubit extends Cubit<ProductsState> with ErrorMessageMixin {
  final ProductRepository productRepository = ProductRepository();

  ProductsCubit() : super(ProductsInitial());

  void fetchProducts() {
    print("Fetch products");

    productRepository
        .fetchAll()
        .then((products) => {
              print("Loading Products.."),
              emit(ProductsLoaded(
                products: products,
                sortIndex: null,
                sortAscending: true,
              )),
            })
        .onError((error, stackTrace) => updateError('$error', stackTrace));
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

  void deleteProduct(int productId) {
    productRepository.deleteProduct(productId).then((isDeleted) {
      if (isDeleted) {
        emit(ProductDeleted());
        fetchProducts();
      } else {
        updateError(null, null);
      }
    }).onError(
      (error, stackTrace) {
        print("Error message : ${error}");
        updateError('$error', stackTrace);
      },
    );
  }

  void searchProduct(String searchText) {
    final currentState = state;
    if (currentState is ProductsLoaded) {
      final data = currentState.products;
      if (searchText.isEmpty) {
        emit(ProductsLoaded(products: data, sortAscending: false));
      } else {
        final filteredData = data
            .where((cat) =>
                cat.productName.toLowerCase().contains(
                      searchText.toLowerCase(),
                    ) ||
                cat.productCode.toLowerCase().contains(
                      searchText.toLowerCase(),
                    ))
            .toList();
        emit(ProductsLoaded(
          filteredData: filteredData,
          products: data,
          sortAscending: true,
        ));
      }
    }
  }

  void selectedProduct(Product? product) {
    final currentState = state;
    if (currentState is ProductsLoaded) {
      final products = currentState.products;
      emit(ProductsLoaded(
        products: products,
        sortAscending: true,
        selectedProduct:
            products.firstWhere((prod) => prod.productId == product!.productId),
      ));
    }
  }
}
