import 'product.dart';
import 'category.dart';

class InvoiceItemModel {
  late Product product;
  double? unitPrice;
  double? sellPrice;
  double? quantity;

  get getProduct => product;

  set setProduct(product) => this.product = product;
  Category? category;

  get getCcategory => category;

  set setCcategory(ccategory) => this.category = category;

  get getUnitPrice => unitPrice;

  set setUnitPrice(unitPrice) => this.unitPrice = unitPrice;

  get getSellPrice => sellPrice;

  set setSellPrice(sellPrice) => this.sellPrice = sellPrice;

  get getQuantity => quantity;

  set setQuantity(quantity) => this.quantity = quantity;
}
