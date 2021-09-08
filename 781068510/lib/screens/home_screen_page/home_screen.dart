import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes/database/shared_preferences_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../cubit/home_screen/home_cubit.dart';
import '../../cubit/themes/theme_cubit.dart';
import '../../models/note_model.dart';

import '../../routes/routes.dart' as route;
import 'list_view_build.dart';

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeCubit = context.read<ThemeCubit>();
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (cubitContext, state) {
        return Scaffold(
          appBar: AppBar(
            elevation: 0.0,
            leading: IconButton(
              onPressed: () => print('menu'),
              icon: const Icon(Icons.menu),
            ),
            title: const Text(
              ('title'),
            ),
            centerTitle: true,
            actions: <Widget>[
              IconButton(
                  // onPressed:() async {
                  //   var num = ThemePreferences.getIntFromSharedPrefs();
                  //   await num == 0 ? ThemePreferences.setTheme(1) : ThemePreferences.setTheme(0);
                  //   themeCubit..changeTheme;
                  //   },
                onPressed: themeCubit.changeTheme,
                  icon: const Icon(Icons.invert_colors)),
            ],
          ),
          body: buildPages(state),
          floatingActionButton: buildFloatingActionButton(context),
          bottomNavigationBar: buildBottomNavigationBar(cubitContext, state),
        );
      },
    );
  }

  Widget buildBottomNavigationBar(BuildContext context, HomeState state) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      elevation: 0.0,
      currentIndex: state.selectedIndex,
      items: [
        const BottomNavigationBarItem(
          icon: Icon(Icons.class_),
          label: 'Home',
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.assignment),
          label: 'Daily',
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.access_time),
          label: 'Timeline',
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.explore),
          label: 'Explore',
        ),
      ],
      onTap: (index) {
        context.read<HomeCubit>().setNavBarItem(index);
      },
    );
  }

  Widget buildFloatingActionButton(BuildContext context) {
    return FloatingActionButton(
      child: const Icon(
        Icons.add,
      ),
      onPressed: () async {
        final page = await Navigator.of(context).pushNamed(route.addNotePage);
        if (page is PageCategoryInfo) {
          context.read<HomeCubit>().addPage(page);
        }
      },
    );
  }

  Widget buildPages(HomeState state) {
    switch (state.selectedIndex) {
      case 0:
        return homePage();
      case 1:
        return daily();
      case 2:
        return timeline();
      case 3:
        return explore();
      default:
        return Container();
    }
  }

  Widget homePage() {
    return Column(
      children: <Widget>[
        //buildSearchContainer(),
        Flexible(child: BuildListView())
      ],
    );
  }

  Widget buildSearchContainer() {
    return Container(
      height: 65,
      child: Center(
        child: Expanded(
          child: Container(
            margin: const EdgeInsets.all(10),
            height: 60,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.black12,
                borderRadius: BorderRadius.all(
                  Radius.circular(15),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.only(left: 15),
                    child: const Icon(Icons.search),
                  ),
                  Expanded(
                    child: TextFormField(
                      style: const TextStyle(color: Colors.black, fontSize: 16),
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(borderSide: BorderSide.none),
                        hintText: 'Search',
                        contentPadding: EdgeInsets.only(left: 10),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget daily() => Container();

  Widget timeline() => Container();

  Widget explore() => Container();
}
