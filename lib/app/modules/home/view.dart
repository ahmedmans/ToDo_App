import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:todo_app/app/core/values/colors.dart';
import 'package:todo_app/app/data/models/task.dart';
import 'package:todo_app/app/modules/home/controller.dart';
import 'package:todo_app/app/core/utils/extensions.dart';
import 'package:todo_app/app/modules/home/widget/add_card.dart';
import 'package:todo_app/app/modules/home/widget/add_dialog.dart';
import 'package:todo_app/app/modules/home/widget/task_card.dart';
import 'package:todo_app/app/modules/report/report.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        () => IndexedStack(index: controller.tabIndex.value, children: [
          SafeArea(
            child: ListView(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 4.0.wp,
                  ),
                  child: Text(
                    "قائمة المهمام",
                    style: TextStyle(
                      fontSize: 25.0.sp,
                    ),
                  ),
                ),
                SizedBox(
                  height: 1.0.hp,
                ),
                Obx(
                  () => GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const ClampingScrollPhysics(),
                    children: [
                      ...controller.tasksList
                          .map(
                            (element) => LongPressDraggable(
                              data: element,
                              onDragStarted: () =>
                                  controller.changeDeliting(true),
                              onDraggableCanceled: (_, __) =>
                                  controller.changeDeliting(false),
                              onDragEnd: (_) =>
                                  controller.changeDeliting(false),
                              feedback: Opacity(
                                opacity: 0.8,
                                child: TaskCard(task: element),
                              ),
                              child: TaskCard(task: element),
                            ),
                          )
                          .toList(),
                      AddCard(),
                    ],
                  ),
                ),
              ],
            ),
          ),
          ReportPage(),
        ]),
      ),
      floatingActionButton: DragTarget<Task>(
        builder: (_, __, ___) {
          return Obx(
            () => FloatingActionButton(
              backgroundColor: controller.deleting.value ? Colors.red : blue,
              onPressed: () {
                if (controller.tasksList.isNotEmpty) {
                  Get.to(AddDialog(), transition: Transition.downToUp);
                } else {
                  EasyLoading.showInfo('برجاء انشاء نوع المهمة اولا');
                }
              },
              child: Icon(
                controller.deleting.value ? Icons.delete_forever : Icons.add,
              ),
            ),
          );
        },
        onAccept: (Task task) {
          controller.deleteTask(task);
          EasyLoading.showSuccess('تم الحذف بنجاح');
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: Theme(
        data: ThemeData(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent),
        child: Obx(
          () => BottomNavigationBar(
            onTap: (int index) => controller.changeTabIndex(index),
            currentIndex: controller.tabIndex.value,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            items: [
              BottomNavigationBarItem(
                  icon: Padding(
                    padding: EdgeInsets.only(left: 15.0.wp),
                    child: Image.asset(
                      'assets/image/home.png',
                      width: 10.0.wp,
                    ),
                  ),
                  label: 'الصفحة الرئيسية'),
              BottomNavigationBarItem(
                  icon: Padding(
                    padding: EdgeInsets.only(right: 15.0.wp),
                    child: Image.asset(
                      'assets/image/report.png',
                      width: 10.0.wp,
                    ),
                  ),
                  label: 'تقرير'),
            ],
          ),
        ),
      ),
    );
  }
}
