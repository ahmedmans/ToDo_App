import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_app/app/core/utils/extensions.dart';
import 'package:todo_app/app/core/values/colors.dart';
import 'package:todo_app/app/modules/home/controller.dart';

class DoneList extends StatelessWidget {
  final homeController = Get.find<HomeController>();
  DoneList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() => homeController.completedTodos.isNotEmpty
        ? Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 5.0.wp,
              vertical: 3.0.wp,
            ),
            child: ListView(
              shrinkWrap: true,
              physics: const ClampingScrollPhysics(),
              children: [
                Text(
                  'المهام المكتملة (${homeController.completedTodos.length})',
                  style: TextStyle(
                    fontSize: 16.0.sp,
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                ...homeController.completedTodos.map(
                  (element) => Dismissible(
                    key: ObjectKey(element),
                    direction: DismissDirection.endToStart,
                    onDismissed: (_) => homeController.deletDoneTodo(element),
                    background: Container(
                      color: Colors.red.withOpacity(0.8),
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: EdgeInsets.only(left: 5.0.wp),
                        child: const Icon(
                          Icons.delete,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: 2.0.wp,
                        horizontal: 3.0.wp,
                      ),
                      child: Row(
                        children: [
                          const SizedBox(
                            width: 20.0,
                            height: 20.0,
                            child: Icon(
                              Icons.done,
                              color: blue,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 3.0.wp,
                            ),
                            child: Text(
                              element['title'],
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 14.0.sp,
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          )
        : Container());
  }
}
