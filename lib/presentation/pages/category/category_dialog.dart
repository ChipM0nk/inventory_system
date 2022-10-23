import 'package:edar_app/cubit/categories/categories_cubit.dart';
import 'package:edar_app/data/model/category.dart';
import 'package:edar_app/presentation/widgets/fields/custom_text_field.dart';
import 'package:edar_app/presentation/widgets/fields/error_message_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// ignore: must_be_immutable
class CategoryDialog extends StatelessWidget {
  Category? category;
  CategoryDialog({this.category, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String title = 'Add Category';
    int? categoryId;
    BlocProvider.of<CategoriesCubit>(context).init();
    BlocProvider.of<CategoriesCubit>(context).clearError();

    if (category != null) {
      BlocProvider.of<CategoriesCubit>(context).loadCategory(category!);
      title = 'Update Category';
      categoryId = category!.categoryId;
    }

    var categoryCode = StreamBuilder(
      stream: BlocProvider.of<CategoriesCubit>(context).categoryCodeStream,
      builder: (context, snapshot) {
        return Padding(
          padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
          child: CustomTextField(
              labelText: "Category Code",
              hintText: "BWLS",
              initialValue:
                  category != null ? category!.categoryCode.toString() : null,
              snapshot: snapshot,
              autofocus: true,
              onChanged: (text) {
                BlocProvider.of<CategoriesCubit>(context)
                    .updateCategoryCode(text);
              }),
        );
      },
    );

    var categoryName = StreamBuilder(
      stream: BlocProvider.of<CategoriesCubit>(context).categoryNameStream,
      builder: (context, snapshot) {
        return Padding(
          padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
          child: CustomTextField(
              labelText: "Category Name",
              hintText: "Toilet Bowls",
              initialValue:
                  category != null ? category!.categoryName.toString() : null,
              snapshot: snapshot,
              onChanged: (text) {
                BlocProvider.of<CategoriesCubit>(context)
                    .updateCategoryName(text);
              }),
        );
      },
    );

    var serviceErrorMessage = StreamBuilder(
      stream: BlocProvider.of<CategoriesCubit>(context).errorStream,
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
    return AlertDialog(
      scrollable: true,
      title: Text(title),
      content: BlocBuilder<CategoriesCubit, CategoriesState>(
          builder: (context, state) {
        if (state is CategoryAdded || state is CategoryUpdated) {
          Navigator.of(context, rootNavigator: true).pop();
        }
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                children: [
                  categoryCode,
                  categoryName,
                  serviceErrorMessage,
                ],
              ),
            ],
          ),
        );
      }),
      actions: [
        StreamBuilder(
          stream: BlocProvider.of<CategoriesCubit>(context).buttonValid,
          builder: (context, snapshot) {
            return Padding(
              padding: const EdgeInsets.all(24),
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
                          ? category == null
                              ? () => BlocProvider.of<CategoriesCubit>(context)
                                  .addCategory()
                              : () => BlocProvider.of<CategoriesCubit>(context)
                                  .updateCategory(categoryId!)
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
