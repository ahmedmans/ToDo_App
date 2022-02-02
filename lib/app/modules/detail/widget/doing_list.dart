import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_app/app/core/utils/extensions.dart';
import 'package:todo_app/app/core/values/colors.dart';
import 'package:todo_app/app/modules/home/controller.dart';

class DoingList extends StatelessWidget {
  final homeController = Get.find<HomeController>();
  DoingList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => homeController.doingTodos.isEmpty &&
              homeController.completedTodos.isEmpty
          ? Column(
              children: [
                Image.asset(
                  'assets/image/task.png',
                  fit: BoxFit.cover,
                  width: 65.0.wp,
                ),
                Text(
                  'أضف ما تود القيام به',
                  style: TextStyle(
                    fontSize: 20.0.sp,
                    fontWeight: FontWeight.bold,
                    color: blue,
                  ),
                )
              ],
            )
          : ListView(
              shrinkWrap: true,
              physics: const ClampingScrollPhysics(),
              children: [
                ...homeController.doingTodos
                    .map(
                      (element) => Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 3.0.wp,
                          horizontal: 9.0.wp,
                        ),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 20,
                              height: 20,
                              child: Checkbox(
                                fillColor: MaterialStateProperty.resolveWith(
                                    (states) => Colors.grey),
                                value: element['done'],
                                onChanged: (value) {
                                  homeController.doneTodo(element['title']);
                                },
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 3.0.wp),
                              child: Text(
                                element['title'],
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 14.0.sp,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                    .toList(),
                if (homeController.doingTodos.isNotEmpty)
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5.0.wp),
                    child: const Divider(
                      thickness: 2.0,
                    ),
                  ),
              ],
            ),
    );
  }
}
