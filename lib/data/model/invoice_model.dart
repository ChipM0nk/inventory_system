import 'invoice_item_model.dart';

class InvoiceModel {
  String? invoiceNo;
  String? customerName;
  String? customerAddress;
  String? contactNumber;
  String? salesPerson;
  String? poNumber;
  String? purchaseDate;
  String? paymentType;
  String? paymentTerms;
  String? tinNo;
  String? dueDate;
  List<InvoiceItemModel>? invoiceItems;

  get getInvoiceNo => invoiceNo;

  set setInvoiceNo(invoiceNo) => this.invoiceNo = invoiceNo;

  get getCustomerName => customerName;

  set setCustomerName(customerName) => this.customerName = customerName;

  get getCustomerAddress => this.customerAddress;

  set setCustomerAddress(customerAddress) =>
      this.customerAddress = customerAddress;

  get getContactNumber => this.contactNumber;

  set setContactNumber(contactNumber) => this.contactNumber = contactNumber;

  get getSalesPerson => this.salesPerson;

  set setSalesPerson(salesPerson) => this.salesPerson = salesPerson;

  get getPoNumber => this.poNumber;

  set setPoNumber(poNumber) => this.poNumber = poNumber;

  get getPurchaseDate => this.purchaseDate;

  set setPurchaseDate(purchaseDate) => this.purchaseDate = purchaseDate;

  get getPaymentType => this.paymentType;

  set setPaymentType(paymentType) => this.paymentType = paymentType;

  get getPaymentTerms => this.paymentTerms;

  set setPaymentTerms(paymentTerms) => this.paymentTerms = paymentTerms;

  get getTinNo => this.tinNo;

  set setTinNo(tinNo) => this.tinNo = tinNo;

  get getDueDate => this.dueDate;

  set setDueDate(dueDate) => this.dueDate = dueDate;

  List<InvoiceItemModel>? get getInvoiceItems => this.invoiceItems;

  set setInvoiceItems(List<InvoiceItemModel>? invoiceItems) =>
      this.invoiceItems = invoiceItems;
}
