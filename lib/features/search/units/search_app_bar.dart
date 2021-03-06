part of '../view.dart';

class _SearchAppBar extends StatelessWidget with PreferredSizeWidget {
  const _SearchAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = SearchCubit.of(context);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: Form(
          key: cubit.formKey,
          child: TextFormField(
            // controller: cubit.searchController,
            decoration:
                const InputDecoration(labelText: 'Search for a user...'),
            onSaved: (s) => cubit.text = s!,
          ),
        ),
        actions: [
          IconButton(
            onPressed: cubit.getSearchedlUser,
            icon: const Icon(
              Icons.search_outlined,
            ),
          )
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size(double.infinity, 50);
}
