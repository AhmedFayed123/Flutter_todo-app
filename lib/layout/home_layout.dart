import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/shared/cubit/states.dart';
import '../shared/component/component.dart';
import '../shared/cubit/cubit.dart';

class HomeLayout extends StatelessWidget {
  var titleController = TextEditingController();
  var timeController = TextEditingController();
  var dateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AppCubit()..createDatabase(),
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (BuildContext context, AppStates state) {},
        builder: (BuildContext context, AppStates state) {
          AppCubit cubit = AppCubit.get(context);

          return Scaffold(
            appBar: AppBar(
              title: Text(
                cubit.titles[cubit.currentIndex],
              ),
            ),
            body: ConditionalBuilder(
              condition: state is! AppGetDatabaseLoadingState,
              builder: (context) => cubit.screens[cubit.currentIndex],
              fallback: (context) => Center(child: CircularProgressIndicator()),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: ()
          {
            showModalBottomSheet(
              context: context,
              builder: (BuildContext context) {
                   return Container(
                      color: Colors.white,
                      padding: EdgeInsets.all(
                        20.0,
                      ),
                      child: Column(
                          children: [
                            defaultTextInput(
                              fromController: titleController,
                              keyboardType:TextInputType.text,
                              hint: 'Task Title',
                              prefixIcon: Icons.title,
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            defaultTextInput(
                              fromController: timeController,
                              keyboardType:TextInputType.datetime,
                              hint: 'Task Date',
                              prefixIcon: Icons.watch_later_outlined,
                              onTap: () {
                                showTimePicker(
                                  context: context,
                                  initialTime: TimeOfDay.now(),
                                ).then((value) {
                                  timeController.text =
                                      value!.format(context).toString();
                                  print(value.format(context));
                                });
                              },
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            defaultTextInput(
                              fromController: titleController,
                              keyboardType:TextInputType.text,
                              hint: 'Task Date',
                              prefixIcon: Icons.title,
                              onTap: (){
                                showDatePicker(
                                    context: context,
                                    initialDate:  DateTime.now(),
                                    firstDate: DateTime.now(),
                                    lastDate: DateTime.parse('2025-05-03'),
                                    ).then((value) {
                                    dateController.text =
                                    DateFormat.yMMMd().format(value!);
                                    }
                                );
                                },
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            TextButton(
                                onPressed:(){
                                  cubit.insertToDatabase(
                                    title: titleController.text,
                                    time: timeController.text,
                                    date: dateController.text,
                                  );
                                },
                                child: Text('ADD'))
                          ],
                        ),
                    );
              },
            );
              },
              child: Icon(
                Icons.add,
              ),
            ),
            bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              currentIndex: cubit.currentIndex,
              onTap: (index) {
                cubit.changeIndex(index);
              },
              items: [
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.menu,
                  ),
                  label: 'Tasks',
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.check_circle_outline,
                  ),
                  label: 'Done',
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.archive_outlined,
                  ),
                  label: 'Archived',
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}