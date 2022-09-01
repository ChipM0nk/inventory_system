import 'package:edar_app/cubit/categories/categories_cubit.dart';
import 'package:edar_app/data/model/category.dart';
import 'package:edar_app/presentation/widgets/fields/custom_text_field.dart';
import 'package:edar_app/presentation/widgets/fields/error_text.dart';
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

    if (category != null) {
      BlocProvider.of<CategoriesCubit>(context).loadCategory(category!);
      title = 'Update Category';
      categoryId = category!.categoryId;
    }

    return AlertDialog(
      scrollable: true,
      title: Text(title),
      content: BlocListener<CategoriesCubit, CategoriesState>(
          listener: (context, state) {
            if (state is CategoryAdded || state is CategoryUpdated) {
              Navigator.of(context, rootNavigator: true).pop();
            }
          },
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  children: [
                    StreamBuilder(
                      stream: BlocProvider.of<CategoriesCubit>(context)
                          .categoryCodeStream,
                      builder: (context, snapshot) {
                        return Padding(
                          padding: const EdgeInsets.only(
                              left: 24, right: 24, top: 24),
                          child: Column(
                            children: [
                              CustomTextField(
                                  labelText: "Enter Category Code",
                                  context: context,
                                  hintText: "BWLS",
                                  initialValue: category != null
                                      ? category!.categoryCode.toString()
                                      : null,
                                  onChanged: (text) {
                                    BlocProvider.of<CategoriesCubit>(context)
                                        .updateCategoryCode(text);
                                    return text;
                                  }),
                              snapshot.hasError
                                  ? ErrorText(
                                      errorText: snapshot.error.toString())
                                  : const SizedBox(
                                      height: 29,
                                    )
                            ],
                          ),
                        );
                      },
                    ),
                    StreamBuilder(
                      stream: BlocProvider.of<CategoriesCubit>(context)
                          .categoryNameStream,
                      builder: (context, snapshot) {
                        return Padding(
                          padding: const EdgeInsets.only(
                              left: 24, right: 24, top: 24),
                          child: Column(
                            children: [
                              CustomTextField(
                                  labelText: "Enter Category Name",
                                  context: context,
                                  hintText: "Toilet Bowls",
                                  initialValue: category != null
                                      ? category!.categoryName.toString()
                                      : null,
                                  onChanged: (text) {
                                    BlocProvider.of<CategoriesCubit>(context)
                                        .updateCategoryName(text);
                                    return text;
                                  }),
                              snapshot.hasError
                                  ? ErrorText(
                                      errorText: snapshot.error.toString())
                                  : const SizedBox(
                                      height: 29,
                                    )
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          )),
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
