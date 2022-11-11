import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'edit_categories_state.dart';

class EditCategoriesCubit extends Cubit<EditCategoriesState> {
  EditCategoriesCubit() : super(EditCategoriesInitial());
}
