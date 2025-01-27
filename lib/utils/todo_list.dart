import 'package:flutter/material.dart';

class TodoList extends StatelessWidget {
  const TodoList({
    super.key,
    required this.taskName,
    required this.taskCompleted,
    this.onChanged,
    this.deleteFunction,
  });

  final String taskName;
  final bool taskCompleted;
  final Function(bool?)? onChanged;
  final Function(BuildContext)? deleteFunction;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Dismissible(
        key: ValueKey(taskName),
        direction:
            DismissDirection.endToStart, // Hanya bisa swipe dari kanan ke kiri
        background: Container(
          decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: const [
              Padding(
                padding: EdgeInsets.only(right: 20),
                child: Icon(
                  Icons.delete,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
        onDismissed: (direction) {
          if (deleteFunction != null) {
            deleteFunction!(context);
          }
        },
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.deepPurple,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Row(
            children: [
              Checkbox(
                value: taskCompleted,
                onChanged: onChanged,
                checkColor: Colors.black,
                activeColor: Colors.white,
                side: const BorderSide(color: Colors.white),
              ),
              Text(
                taskName,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  decoration: (taskCompleted)
                      ? TextDecoration.lineThrough
                      : TextDecoration.none,
                  decorationColor: Colors.white,
                  decorationThickness: 2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
