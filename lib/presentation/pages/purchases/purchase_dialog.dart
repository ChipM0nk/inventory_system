import 'package:edar_app/cubit/purchases/purchase_cubit.dart';
import 'package:edar_app/cubit/purchases/save_purchase_cubit.dart';
import 'package:edar_app/data/model/purchase/purchase.dart';
import 'package:edar_app/presentation/pages/purchases/datagrid/datagrid_export.dart';
import 'package:edar_app/presentation/pages/purchases/datagrid/purchase_item_datagrid.dart';
import 'package:edar_app/presentation/widgets/custom_elevated_action_button.dart';
import 'package:edar_app/presentation/widgets/custom_inline_label.dart';
import 'package:edar_app/presentation/widgets/fields/error_message_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:printing/printing.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' as xlsio;
import 'package:syncfusion_flutter_pdf/pdf.dart' as sfPdf;
import 'package:syncfusion_flutter_datagrid_export/export.dart';
import 'package:file_saver/file_saver.dart';

class PurchaseDialog extends StatelessWidget {
  final Purchase purchase;
  final int? fontSize;
  final bool flgAddPurchase;
  const PurchaseDialog(
      {required this.purchase,
      this.fontSize = 10,
      this.flgAddPurchase = false,
      super.key});

  @override
  Widget build(BuildContext context) {
    var headerContainer = SizedBox(
      width: 1000,
      height: 120,
      child: Container(
        color: Colors.grey[100],
        child: Padding(
          padding: const EdgeInsets.only(top: 15, left: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    CustomInlineLabel(
                        label: "Purchase No: ",
                        value: purchase.supplierInvoiceNo),
                  ]),
                  Row(children: [
                    CustomInlineLabel(
                        label: "Supplier: ",
                        value: purchase.supplier.supplierName),
                    CustomInlineLabel(
                        label: "Batch Code: ", value: purchase.batchCode),
                  ]),
                  Row(children: [
                    CustomInlineLabel(
                        label: "Purchase Date: ", value: purchase.purchaseDate),
                    CustomInlineLabel(
                        width: 600,
                        label: "Remarks: ",
                        value: purchase.remarks),
                  ]),
                ],
              )
            ],
          ),
        ),
      ),
    );
    var stackHeaderRows = <StackedHeaderRow>[
      StackedHeaderRow(cells: [
        StackedHeaderCell(columnNames: [
          'prodcode',
          'Product Name',
          'Product Description',
          'Price',
          'QTY',
          'Total'
        ], child: headerContainer)
      ]),
    ];

    var serviceErrorMessage = StreamBuilder(
      stream: BlocProvider.of<SavePurchaseCubit>(context).errorStream,
      builder: (context, snapshot) {
        return snapshot.hasError
            ? Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: ErrorMessage(
                  snapshot: snapshot,
                  fontSize: 14,
                  height: 20,
                ),
              )
            : const SizedBox();
      },
    );

    return BlocBuilder<SavePurchaseCubit, SavePurchaseState>(
      builder: (context, state) {
        bool isSaving = state is PurchaseSaving;
        bool isVoiding = state is PurchaseVoiding;

        if (state is PurchaseVoided || state is PurchaseSaved) {
          Future.delayed(Duration.zero, () {
            if (state is PurchaseVoided) {
              BlocProvider.of<PurchaseCubit>(context).fetchPurchases();
            }
            Navigator.of(context, rootNavigator: true).pop();
          });
        }

        GlobalKey<SfDataGridState> purchaseSfKey = GlobalKey<SfDataGridState>();

        void exportDataGridToExcel() async {
          final xlsio.Workbook workbook =
              purchaseSfKey.currentState!.exportToExcelWorkbook();
          final List<int> bytes = workbook.saveAsStream();
          // File('DataGrid.xlsx').writeAsBytes(bytes);
          print("Opening print option");
          // uio.File('DataGrid.xlsx').writeAsBytes(bytes);
          // await Printing.layoutPdf(onLayout: (_) => Uint8List.fromList(bytes));
          await FileSaver.instance
              .saveFile("Datagrid.xls", Uint8List.fromList(bytes), "xls");
          workbook.dispose();
          // await xlsio.saveAndLaunchFile(bytes, 'DataGrid.xlsx');
        }

        void exportDataGridToPDF() async {
          final ByteData data =
              await rootBundle.load('/images/report_header.jpg');
          sfPdf.PdfDocument document =
              purchaseSfKey.currentState!.exportToPdfDocument(
            converter: SfDataGridToPdfConverterExt(data),
          );
          final List<int> bytes = document.saveSync();
          document.dispose();
          await Printing.layoutPdf(onLayout: (_) => Uint8List.fromList(bytes));
        }

        return AlertDialog(
          title: const Text("Purchase Details"),
          content: Column(
            children: [
              SizedBox(
                width: 1000,
                height: 500,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    headerContainer,
                    SizedBox(
                      height: 380,
                      child: PurchaseItemDataGrid(
                        purchaseSfKey: purchaseSfKey,
                        purchaseItems: purchase.purchaseItems,
                        summaryTotal: purchase.totalAmount,
                        stackHeaderRows: stackHeaderRows,
                        editable: false,
                      ),
                    ),
                    serviceErrorMessage,
                  ],
                ),
              ),
            ],
          ),
          actionsPadding: const EdgeInsets.only(bottom: 40),
          actions: [
            Center(
              child: SizedBox(
                width: flgAddPurchase ? 170 : 350,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 170,
                      height: 70,
                      child: CustomElevatedActionButton(
                        onPressed: flgAddPurchase
                            ? () {
                                BlocProvider.of<SavePurchaseCubit>(context)
                                    .addPurchase();
                              }
                            : () async {
                                exportDataGridToPDF();
                              },
                        isLoading: isSaving,
                        text: Text(
                          flgAddPurchase ? "SUBMIT" : "PRINT",
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                        icon: const Icon(Icons.save),
                      ),
                    ),
                    if (!flgAddPurchase)
                      SizedBox(
                        width: 170,
                        height: 70,
                        child: CustomElevatedActionButton(
                          color: Colors.red.shade600,
                          onPressed: purchase.trxnStatus == 'FINAL'
                              ? () {
                                  showDialog(
                                      context: context,
                                      builder: (_) {
                                        return BlocProvider.value(
                                          value:
                                              context.read<SavePurchaseCubit>(),
                                          child: AlertDialog(
                                            title: const Text("Void Purchase"),
                                            content: const Text(
                                                "Are you sure you want to void this purchase?"),
                                            actions: [
                                              ElevatedButton(
                                                  child: const Text("Yes"),
                                                  onPressed: () {
                                                    BlocProvider.of<
                                                                SavePurchaseCubit>(
                                                            context)
                                                        .voidPurchase(purchase
                                                            .purchaseId!);
                                                    Navigator.of(context,
                                                            rootNavigator: true)
                                                        .pop();
                                                  }),
                                              ElevatedButton(
                                                  child: const Text("No"),
                                                  onPressed: () {
                                                    Navigator.of(context,
                                                            rootNavigator: true)
                                                        .pop();
                                                  }),
                                            ],
                                          ),
                                        );
                                      });
                                }
                              : null,
                          isLoading: isVoiding,
                          text: const Text(
                            "VOID",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                          icon: const Icon(
                            Icons.close,
                            size: 25,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
