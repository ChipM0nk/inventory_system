import 'package:edar_app/cubit/categories/add_categories_cubit.dart';
import 'package:edar_app/cubit/categories/categories_cubit.dart';
import 'package:edar_app/data/model/category.dart';
import 'package:edar_app/presentation/widgets/custom_elevated_action_button.dart';
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

    if (category != null) {
      BlocProvider.of<SaveCategoriesCubit>(context).loadCategory(category!);
      title = 'Update Category';
      categoryId = category!.categoryId;
    }

    var categoryCode = StreamBuilder(
      stream: BlocProvider.of<SaveCategoriesCubit>(context).categoryCodeStream,
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
                BlocProvider.of<SaveCategoriesCubit>(context)
                    .updateCategoryCode(text);
              }),
        );
      },
    );

    var categoryName = StreamBuilder(
      stream: BlocProvider.of<SaveCategoriesCubit>(context).categoryNameStream,
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
                BlocProvider.of<SaveCategoriesCubit>(context)
                    .updateCategoryName(text);
              }),
        );
      },
    );

    var serviceErrorMessage = StreamBuilder(
      stream: BlocProvider.of<SaveCategoriesCubit>(context).errorStream,
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
    return BlocBuilder<SaveCategoriesCubit, SaveCategoriesState>(
      builder: (context, state) {
        bool isSaving = false;
        if (state is CategorySaving || state is CategoryUpdating) {
          isSaving = true;
        }
        if (state is CategorySaved || state is CategoryUpdated) {
          BlocProvider.of<CategoriesCubit>(context).fetchCategories();
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
                    categoryCode,
                    categoryName,
                    serviceErrorMessage,
                  ],
                ),
              ],
            ),
          ),
          actions: [
            StreamBuilder(
              stream: BlocProvider.of<SaveCategoriesCubit>(context).buttonValid,
              builder: (context, snapshot) {
                return Padding(
                  padding: const EdgeInsets.all(24),
                  child: Row(
                    children: [
                      Expanded(
                        child: CustomElevatedActionButton(
                          onPressed: snapshot.hasData
                              ? category == null
                                  ? () => BlocProvider.of<SaveCategoriesCubit>(
                                          context)
                                      .addCategory()
                                  : () => BlocProvider.of<SaveCategoriesCubit>(
                                          context)
                                      .updateCategory(categoryId!)
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
