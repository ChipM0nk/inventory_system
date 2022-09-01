import 'package:edar_app/cubit/categories/categories_cubit.dart';
import 'package:edar_app/cubit/auth_cubit.dart';
import 'package:edar_app/data/model/category.dart';
import 'package:edar_app/presentation/datasource/category_datasource.dart';
import 'package:edar_app/presentation/pages/category/category_dialog.dart';
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
    return SizedBox(
        width: 1500,
        height: 1000,
        child: BlocBuilder<CategoriesCubit, CategoriesState>(
          builder: (context, state) {
            if (state is! CategoriesLoaded) {
              if (state is CategoriesInitial) {
                BlocProvider.of<CategoriesCubit>(context).fetchCategories();
              }
              return const Center(child: CircularProgressIndicator());
            }

            CategoryData categoryData = CategoryData(
                data: state.filteredData ?? state.categories,
                onDeleteClick: _deleteCategory,
                onItemClick: _openUpdateCategoryDialog);
            return Column(children: [
              Row(
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
                  ElevatedButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (_) {
                            searchController.clear();
                            return BlocProvider.value(
                              value: context.read<CategoriesCubit>(),
                              child: CategoryDialog(),
                            );
                          });
                    },
                    child: const Text("Add Category"),
                  ),
                ],
              ),
              Align(
                alignment: Alignment.topLeft,
                child: SizedBox(
                  width: 500,
                  child: CustomPaginatedDataTable(
                      header: const Text("Categories"),
                      dataColumns: dataColumns(categoryData),
                      rowsPerPage: 10,
                      sortAscending: state.sortAscending,
                      sortIndex: state.sortIndex,
                      source: categoryData),
                ),
              ),
            ]);
          },
        ));
  }

  List<DataColumn> dataColumns(CategoryData data) => <DataColumn>[
        DataColumn(
          label: const Text(
            'Category Code',
            style: TextStyle(fontStyle: FontStyle.italic),
          ),
          onSort: (colIdx, asc) {
            BlocProvider.of<CategoriesCubit>(context).sortCategories(
                (category) => category.categoryCode, colIdx, asc);
          },
        ),
        DataColumn(
          label: const Text(
            'Category Name',
            style: TextStyle(fontStyle: FontStyle.italic),
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
    print('deleting category : ${categoryId}');

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
        });
  }

  void _openUpdateCategoryDialog(Category category) {
    print('updating category : ${category.categoryCode}');
    searchController.clear();
    showDialog(
        context: context,
        builder: (_) {
          return BlocProvider.value(
            value: context.read<CategoriesCubit>(),
            child: CategoryDialog(category: category),
          );
        });
  }
}
