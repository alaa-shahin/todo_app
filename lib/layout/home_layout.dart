import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/common_widgets/components.dart';
import 'package:todo_app/cubit/cubit.dart';
import 'package:todo_app/cubit/states.dart';

class HomeLayout extends StatelessWidget {
  TextEditingController titleController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppCubit()..createDatabase(),
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {},
        builder: (context, state) {
          AppCubit cubit = AppCubit.get(context);
          return Scaffold(
            key: scaffoldKey,
            appBar: AppBar(
              title: Text(cubit.appBarTitles[cubit.currentIndex]),
            ),
            body: cubit.screens[cubit.currentIndex],
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                if (cubit.isBottomSheetShow) {
                  validateBottomSheet(context);
                } else {
                  createBottomSheet(context);
                }
              },
              child:
                  cubit.isBottomSheetShow ? Icon(Icons.add) : Icon(Icons.edit),
            ),
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: cubit.currentIndex,
              type: BottomNavigationBarType.fixed,
              onTap: (index) {
                cubit.changeIndex(index);
              },
              items: [
                BottomNavigationBarItem(
                  icon: Icon(Icons.menu),
                  label: 'Tasks',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.done),
                  label: 'Done',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.archive_outlined),
                  label: 'Archive',
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  createBottomSheet(context) {
    scaffoldKey.currentState
        .showBottomSheet(
          (context) => Container(
            color: Colors.white,
            padding: EdgeInsets.all(20.0),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  defaultTextField(
                    label: 'Task Title',
                    validate: (String value) {
                      if (value.isEmpty) {
                        return 'Title must not be Empty';
                      }
                      return null;
                    },
                    controller: titleController,
                    type: TextInputType.text,
                    prefixIcon: Icons.title,
                  ),
                  SizedBox(height: 15.0),
                  defaultTextField(
                    label: 'Task Time',
                    validate: (String value) {
                      if (value.isEmpty) {
                        return 'Time must not be Empty';
                      }
                      return null;
                    },
                    controller: timeController,
                    type: TextInputType.datetime,
                    onTap: () {
                      showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      ).then((value) {
                        timeController.text = value.format(context).toString();
                      });
                    },
                    prefixIcon: Icons.watch_later_outlined,
                  ),
                  SizedBox(height: 15.0),
                  defaultTextField(
                    label: 'Task date',
                    validate: (String value) {
                      if (value.isEmpty) {
                        return 'date must not be Empty';
                      }
                      return null;
                    },
                    controller: dateController,
                    type: TextInputType.datetime,
                    onTap: () {
                      showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime.parse('2021-06-30'),
                      ).then((value) {
                        dateController.text = DateFormat.yMMMd().format(value);
                      });
                    },
                    prefixIcon: Icons.calendar_today,
                  ),
                ],
              ),
            ),
          ),
          elevation: 15.0,
        )
        .closed
        .then((value) {
      AppCubit.get(context).changeBottomSheet(isShow: false);
    });
    AppCubit.get(context).changeBottomSheet(isShow: true);
  }

  void validateBottomSheet(context) {
    if (formKey.currentState.validate()) {
      AppCubit.get(context).insertToDatabase(
        title: titleController.text,
        time: timeController.text,
        date: dateController.text,
      );
      Navigator.pop(context);
    }
  }
}
