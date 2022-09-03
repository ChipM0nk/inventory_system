import 'package:edar_app/cubit/suppliers/suppliers_cubit.dart';
import 'package:edar_app/data/model/supplier.dart';
import 'package:edar_app/presentation/widgets/fields/custom_text_field.dart';
import 'package:edar_app/presentation/widgets/fields/error_message_field.dart';
import 'package:edar_app/presentation/widgets/fields/error_text.dart';
import 'package:edar_app/presentation/widgets/fields/form_field.dart';
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
    BlocProvider.of<SuppliersCubit>(context).init();

    if (supplier != null) {
      BlocProvider.of<SuppliersCubit>(context).loadSuppliers(supplier!);
      title = 'Update Supplier';
      supplierId = supplier!.supplierId;
    }

    var supplierNameField = StreamBuilder(
      stream: BlocProvider.of<SuppliersCubit>(context).supplierNameStream,
      builder: (context, snapshot) {
        return Padding(
          padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
          child: Column(
            children: [
              CustomTextFormField(
                  labelText: "Supplier Name",
                  hintText: "GM",
                  initialValue: supplier != null
                      ? supplier!.supplierName.toString()
                      : null,
                  onChanged: (text) {
                    BlocProvider.of<SuppliersCubit>(context)
                        .updateSupplierName(text);
                  }),
              ErrorMessage(snapshot: snapshot)
            ],
          ),
        );
      },
    );
    var supplierAddressField = StreamBuilder(
      stream: BlocProvider.of<SuppliersCubit>(context).supplierAddressStream,
      builder: (context, snapshot) {
        return Padding(
          padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
          child: Column(
            children: [
              CustomTextFormField(
                  labelText: "Supplier Address",
                  hintText: "Sto Tomas",
                  initialValue: supplier != null
                      ? supplier!.supplierAddress.toString()
                      : null,
                  onChanged: (text) {
                    BlocProvider.of<SuppliersCubit>(context)
                        .updateSupplierAddress(text);
                  }),
              ErrorMessage(snapshot: snapshot)
            ],
          ),
        );
      },
    );
    var supplierContactField = StreamBuilder(
      stream: BlocProvider.of<SuppliersCubit>(context).supplierContactNumStream,
      builder: (context, snapshot) {
        return Padding(
          padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
          child: Column(
            children: [
              CustomTextFormField(
                  labelText: "Supplier Contact Number",
                  hintText: "09219999999",
                  initialValue: supplier != null
                      ? supplier!.supplierContactNumber.toString()
                      : null,
                  onChanged: (text) {
                    BlocProvider.of<SuppliersCubit>(context)
                        .updateSupplierContactNumber(text);
                  }),
              ErrorMessage(snapshot: snapshot)
            ],
          ),
        );
      },
    );

    return AlertDialog(
      scrollable: true,
      title: Text(title),
      content: BlocListener<SuppliersCubit, SuppliersState>(
          listener: (context, state) {
            if (state is SupplierAdded || state is SupplierUpdated) {
              Navigator.of(context, rootNavigator: true).pop();
            }
          },
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  children: [
                    supplierNameField,
                    supplierAddressField,
                    supplierContactField
                  ],
                ),
              ],
            ),
          )),
      actions: [
        StreamBuilder(
          stream: BlocProvider.of<SuppliersCubit>(context).buttonValid,
          builder: (context, snapshot) {
            return Padding(
              padding: const EdgeInsets.all(10),
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
                          ? supplier == null
                              ? () => BlocProvider.of<SuppliersCubit>(context)
                                  .addSupplier()
                              : () => BlocProvider.of<SuppliersCubit>(context)
                                  .updateSupplier(supplierId!)
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
