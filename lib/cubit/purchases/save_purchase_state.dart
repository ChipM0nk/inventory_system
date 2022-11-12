part of 'save_purchase_cubit.dart';

@immutable
abstract class SavePurchaseState {}

class SavePurchaseInitial extends SavePurchaseState {}

class PurchaseSaving extends SavePurchaseState {}

class PurchaseSaved extends SavePurchaseState {}

class PurchaseSavingError extends SavePurchaseState {}

class PurchaseVoiding extends SavePurchaseState {}

class PurchaseVoided extends SavePurchaseState {}

class PurchaseVoidingError extends SavePurchaseState {}
