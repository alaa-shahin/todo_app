import 'package:flutter/material.dart';
import 'package:todo_app/cubit/cubit.dart';

Widget defaultTextField({
  @required TextEditingController controller,
  @required TextInputType type,
  @required Function validate,
  @required IconData prefixIcon,
  @required String label,
  Function onSubmit,
  Function onTap,
  Function onChange,
}) {
  return TextFormField(
    controller: controller,
    validator: validate,
    keyboardType: type,
    onChanged: onChange,
    onFieldSubmitted: onSubmit,
    onTap: onTap,
    decoration: InputDecoration(
      labelText: label,
      prefixIcon: Icon(prefixIcon),
      border: OutlineInputBorder(),
    ),
  );
}

Widget buildTaskItem(Map tasks, BuildContext context) {
  return Dismissible(
    onDismissed: (direction) {
      AppCubit.get(context).deleteDatabase(id: tasks['id']);
    },
    key: Key('Delete'),
    child: Padding(
      padding: EdgeInsets.all(20.0),
      child: Row(
        children: [
          CircleAvatar(
            radius: 40.0,
            child: Text(tasks['time']),
          ),
          SizedBox(width: 15.0),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tasks['title'],
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                  ),
                ),
                Text(
                  tasks['date'],
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 15.0),
          IconButton(
            onPressed: () {
              AppCubit.get(context)
                  .updateDatabase(status: 'done', id: tasks['id']);
            },
            icon: Icon(Icons.done, color: Colors.green),
          ),
          IconButton(
            onPressed: () {
              AppCubit.get(context)
                  .updateDatabase(status: 'archive', id: tasks['id']);
            },
            icon: Icon(Icons.archive, color: Colors.black54),
          ),
        ],
      ),
    ),
  );
}

Widget tasksBuilder(List<Map> tasks, String state) {
  return tasks.length == 0
      ? Center(
          child: Text(
            "You Don't Have Any $state Tasks",
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        )
      : ListView.separated(
          itemBuilder: (context, index) => buildTaskItem(tasks[index], context),
          separatorBuilder: (context, index) => Container(),
          itemCount: tasks.length,
        );
}
