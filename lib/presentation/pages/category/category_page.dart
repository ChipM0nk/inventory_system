import 'package:edar_app/cubit/categories/add_categories_cubit.dart';
import 'package:edar_app/cubit/categories/categories_cubit.dart';
import 'package:edar_app/cubit/categories/edit_categories_cubit.dart';
import 'package:edar_app/data/model/category.dart';
import 'package:edar_app/presentation/datasource/category_datasource.dart';
import 'package:edar_app/presentation/pages/category/category_dialog.dart';
import 'package:edar_app/presentation/widgets/custom_elevated_button.dart';
import 'package:edar_app/presentation/widgets/custom_paginated_datatable.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage({Key? key}) : super(key: key);

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  final searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 55),
          SizedBox(
            width: 500,
            child: Row(
              children: [
                SizedBox(
                  height: 20,
                  width: 350,
                  child: TextField(
                      controller: searchController,
                      decoration: const InputDecoration(
                        hintText: 'Search',
                      ),
                      onChanged: (value) => {
                            BlocProvider.of<CategoriesCubit>(context)
                                .searchCategory(value),
                          }),
                ),
                const SizedBox(
                  width: 30,
                ),
                CustomElevatedButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (_) {
                          searchController.clear();
                          BlocProvider.of<SaveCategoriesCubit>(context)
                              .initDialog();
                          return MultiBlocProvider(
                            providers: [
                              BlocProvider.value(
                                  value: context.read<CategoriesCubit>()),
                              BlocProvider.value(
                                  value: context.read<SaveCategoriesCubit>()),
                              BlocProvider.value(
                                  value: context.read<EditCategoriesCubit>()),
                            ],
                            child: CategoryDialog(),
                          );
                        });
                  },
                  child: const Text("Add Category"),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: SizedBox(
              width: 500,
              child: BlocBuilder<CategoriesCubit, CategoriesState>(
                  builder: (context, state) {
                if (state is! CategoriesLoaded) {
                  BlocProvider.of<CategoriesCubit>(context).fetchCategories();
                }

                if (state is CategoriesLoaded) {
                  CategoryData categoryData = CategoryData(
                      data: state.filteredData ?? state.categories,
                      onDeleteClick: _deleteCategory,
                      onItemClick: _openUpdateCategoryDialog);

                  return CustomPaginatedDataTable(
                      header: const Text("Categories"),
                      dataColumns: dataColumns(categoryData),
                      rowsPerPage: 10,
                      sortAscending: state.sortAscending,
                      sortIndex: state.sortIndex,
                      source: categoryData);
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              }),
            ),
          ),
        ]);
  }

  List<DataColumn> dataColumns(CategoryData data) => <DataColumn>[
        DataColumn(
          label: const Text(
            'Category Code',
            style: TextStyle(
                fontStyle: FontStyle.italic, fontWeight: FontWeight.bold),
          ),
          onSort: (colIdx, asc) {
            BlocProvider.of<CategoriesCubit>(context).sortCategories(
                (category) => category.categoryCode, colIdx, asc);
          },
        ),
        DataColumn(
          label: const Text(
            'Category Name',
            style: TextStyle(
                fontStyle: FontStyle.italic, fontWeight: FontWeight.bold),
          ),
          onSort: (colIdx, asc) {
            BlocProvider.of<CategoriesCubit>(context).sortCategories(
                (category) => category.categoryName, colIdx, asc);
          },
        ),
        const DataColumn(
          label: Text(''),
        ),
      ];

  void _deleteCategory(int categoryId) {
    searchController.clear();
    showDialog(
      context: context,
      builder: (_) {
        return BlocProvider.value(
          value: context.read<CategoriesCubit>(),
          child: AlertDialog(
            title: Text("Delete"),
            content: BlocListener<CategoriesCubit, CategoriesState>(
              listener: (context, state) {
                if (state is CategoryDeleted) {
                  Navigator.of(context, rootNavigator: true).pop();
                }
              },
              child: Text("Are you sure you want to delete this item?"),
            ),
            actions: [
              ElevatedButton(
                  child: Text("Yes"),
                  onPressed: () {
                    BlocProvider.of<CategoriesCubit>(context)
                        .deleteCategory(categoryId);
                  }),
              ElevatedButton(
                  child: Text("No"),
                  onPressed: () {
                    Navigator.of(context, rootNavigator: true).pop();
                  }),
            ],
          ),
        );
      },
    );
  }

  void _openUpdateCategoryDialog(Category category) {
    print('updating category : ${category.categoryCode}');
    searchController.clear();
    BlocProvider.of<SaveCategoriesCubit>(context).initDialog();
    showDialog(
        context: context,
        builder: (_) {
          return MultiBlocProvider(
            providers: [
              BlocProvider.value(value: context.read<CategoriesCubit>()),
              BlocProvider.value(value: context.read<SaveCategoriesCubit>()),
              BlocProvider.value(value: context.read<EditCategoriesCubit>()),
            ],
            child: CategoryDialog(category: category),
          );
        });
  }
}
