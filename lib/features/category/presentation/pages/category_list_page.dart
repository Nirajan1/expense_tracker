import 'package:expense_tracker/core/app_card_layout.dart';
import 'package:expense_tracker/core/app_top_container.dart';
import 'package:expense_tracker/features/category/domain_layer/entity/category_entity.dart';
import 'package:expense_tracker/features/category/presentation/bloc/category_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CategoryListPageView extends StatelessWidget {
  const CategoryListPageView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            AppTopContainer(title: 'Category List'),
            BlocBuilder<CategoryBloc, CategoryState>(
              builder: (context, state) {
                if (state is CategoryLoadingState) {
                  return CircularProgressIndicator();
                } else if (state is CategoryLoadedState) {
                  if (state.categoryEntity.isEmpty) {
                    return Text(
                      'No Category available',
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    );
                  }
                  return ListView.builder(
                    itemCount: state.categoryEntity.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (BuildContext context, int index) {
                      return _buildCard(context, state.categoryEntity[index]);
                    },
                  );
                } else if (state is CategoryErrorState) {
                  return Text(state.errorMessage.toString());
                } else {
                  return Text('No Category found');
                }
              },
            )
          ],
        ),
      ),
    );
  }
}

Widget _buildCard(BuildContext context, CategoryEntity categoryEntity) {
  return Padding(
    padding: const EdgeInsets.only(left: 16.0, right: 16, bottom: 10),
    child: AppCardLayoutView(
      marginBottom: 10,
      child: ListTile(
        title: Row(
          children: [
            Text("Name : "),
            Text(categoryEntity.name),
          ],
        ),
        subtitle: Row(
          children: [
            Text('Slug : '),
            Text(categoryEntity.slug),
          ],
        ),
      ),
    ),
  );
}
