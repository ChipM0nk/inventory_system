import 'package:edar_app/cubit/suppliers/save_suppliers_cubit.dart';
import 'package:edar_app/cubit/suppliers/suppliers_cubit.dart';
import 'package:edar_app/data/model/supplier.dart';
import 'package:edar_app/presentation/widgets/custom_elevated_action_button.dart';
import 'package:edar_app/presentation/widgets/fields/error_message_field.dart';
import 'package:edar_app/presentation/widgets/fields/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// ignore: must_be_immutable
class SupplierDialog extends StatelessWidget {
  Supplier? supplier;
  SupplierDialog({this.supplier, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String title = 'Add Supplier';
    int? supplierId;
    BlocProvider.of<SaveSuppliersCubit>(context).initDialog();

    if (supplier != null) {
      BlocProvider.of<SaveSuppliersCubit>(context).loadSuppliers(supplier!);
      title = 'Update Supplier';
      supplierId = supplier!.supplierId;
    }

    var supplierNameField = StreamBuilder(
      stream: BlocProvider.of<SaveSuppliersCubit>(context).supplierNameStream,
      builder: (context, snapshot) {
        return CustomTextField(
            labelText: "Supplier Name",
            hintText: "GM",
            autofocus: true,
            width: 300,
            initialValue:
                supplier != null ? supplier!.supplierName.toString() : null,
            snapshot: snapshot,
            onChanged: (text) {
              BlocProvider.of<SaveSuppliersCubit>(context)
                  .updateSupplierName(text);
            });
      },
    );

    var supplierContactField = StreamBuilder(
      stream:
          BlocProvider.of<SaveSuppliersCubit>(context).supplierContactNumStream,
      builder: (context, snapshot) {
        return CustomTextField(
            labelText: "Contact Number",
            hintText: "09219999999",
            textInputType: TextInputType.number,
            width: 300,
            initialValue: supplier != null
                ? supplier!.supplierContactNumber.toString()
                : null,
            snapshot: snapshot,
            onChanged: (text) {
              BlocProvider.of<SaveSuppliersCubit>(context)
                  .updateSupplierContactNumber(text);
            });
      },
    );
    var supplierEmailAddField = StreamBuilder(
      stream:
          BlocProvider.of<SaveSuppliersCubit>(context).supplierEmailAddStream,
      builder: (context, snapshot) {
        return CustomTextField(
            labelText: "Email Address",
            hintText: "gm@gmail.com",
            width: 300,
            initialValue:
                supplier != null ? supplier!.supplierEmailAdd.toString() : null,
            snapshot: snapshot,
            onChanged: (text) {
              BlocProvider.of<SaveSuppliersCubit>(context)
                  .updateSupplierEmailAddress(text);
            });
      },
    );

    var supplierAddressField = StreamBuilder(
      stream:
          BlocProvider.of<SaveSuppliersCubit>(context).supplierAddressStream,
      builder: (context, snapshot) {
        return CustomTextField(
            labelText: "Supplier Address",
            hintText: "Sto Tomas",
            textInputType: TextInputType.multiline,
            width: 300,
            minLines: 6,
            height: 80,
            initialValue:
                supplier != null ? supplier!.supplierAddress.toString() : null,
            snapshot: snapshot,
            onChanged: (text) {
              BlocProvider.of<SaveSuppliersCubit>(context)
                  .updateSupplierAddress(text);
            });
      },
    );

    var serviceErrorMessage = StreamBuilder(
      stream: BlocProvider.of<SaveSuppliersCubit>(context).errorStream,
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

    return BlocBuilder<SaveSuppliersCubit, SaveSuppliersState>(
      builder: (context, state) {
        bool isSaving = state is SupplierSaving;

        if (state is SupplierSaved) {
          BlocProvider.of<SuppliersCubit>(context).fetchSuppliers();
          Navigator.of(context, rootNavigator: true).pop();
        }
        return AlertDialog(
          scrollable: true,
          title: Text(title),
          content: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  children: [
                    supplierNameField,
                    supplierEmailAddField,
                    supplierContactField,
                    supplierAddressField,
                    serviceErrorMessage,
                  ],
                ),
              ],
            ),
          ),
          actions: [
            StreamBuilder(
              stream: BlocProvider.of<SaveSuppliersCubit>(context).buttonValid,
              builder: (context, snapshot) {
                return Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    children: [
                      Expanded(
                        child: CustomElevatedActionButton(
                          onPressed: snapshot.hasData
                              ? supplier == null
                                  ? () => BlocProvider.of<SaveSuppliersCubit>(
                                          context)
                                      .addSupplier()
                                  : () => BlocProvider.of<SaveSuppliersCubit>(
                                          context)
                                      .updateSupplier(supplierId!)
                              : null,
                          isLoading: isSaving,
                          text: const Text(
                            "Submit",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          icon: const Icon(Icons.save),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }
}
