import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import 'package:todo_app/app/core/utils/extensions.dart';
import 'package:todo_app/app/core/values/colors.dart';
import 'package:todo_app/app/modules/detail/widget/doing_list.dart';
import 'package:todo_app/app/modules/detail/widget/done_list.dart';
import 'package:todo_app/app/modules/home/controller.dart';

class DetailsPage extends StatelessWidget {
  final homeController = Get.find<HomeController>();
  DetailsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var task = homeController.task.value!;
    var color = HexColor.fromHex(task.color);
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: Form(
          key: homeController.formKey,
          child: ListView(
            children: [
              Padding(
                padding: EdgeInsets.all(3.0.wp),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        Get.back();
                        homeController.updateTodos();
                        homeController.changeTask(null);
                        homeController.textEditingController.clear();
                      },
                      icon: const Icon(
                        Icons.arrow_back,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 3.0.wp),
                child: Row(
                  children: [
                    Icon(
                      IconData(
                        task.icon,
                        fontFamily: 'MaterialIcons',
                      ),
                      color: color,
                    ),
                    SizedBox(
                      width: 2.0.wp,
                    ),
                    Text(
                      task.title,
                      style: TextStyle(
                        fontSize: 15.0.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Obx(() {
                var totalTodos = homeController.doingTodos.length +
                    homeController.completedTodos.length;
                return Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.0.wp,
                    vertical: 3.0.wp,
                  ),
                  child: Row(
                    children: [
                      Text(
                        '$totalTodos مهمة',
                        style: TextStyle(
                          fontSize: 12.0.sp,
                          color: Colors.grey,
                        ),
                      ),
                      SizedBox(width: 3.0.wp),
                      Expanded(
                        child: StepProgressIndicator(
                          totalSteps: totalTodos == 0 ? 1 : totalTodos,
                          currentStep: homeController.completedTodos.length,
                          size: 5,
                          padding: 0,
                          selectedGradientColor: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [color.withOpacity(0.5), color],
                          ),
                          unselectedGradientColor: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [Colors.grey[300]!, Colors.grey[300]!],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),
              Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 2.0.wp,
                  horizontal: 5.0.wp,
                ),
                child: TextFormField(
                  controller: homeController.textEditingController,
                  autofocus: true,
                  decoration: InputDecoration(
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey[300]!),
                      ),
                      prefixIcon: Icon(
                        Icons.check_box_outline_blank,
                        color: Colors.grey[300]!,
                      ),
                      suffixIcon: IconButton(
                        onPressed: () {
                          if (homeController.formKey.currentState!.validate()) {
                            var success = homeController.addTodo(
                                homeController.textEditingController.text);
                            if (success) {
                              EasyLoading.showSuccess(
                                  'حسنا، تم اضافة المهمة بنجاح');
                            } else {
                              EasyLoading.showError(
                                  'نأسف، هذه المهمة موجودة بالفعل');
                            }
                            homeController.textEditingController.clear();
                          }
                        },
                        icon: const Icon(
                          Icons.done,
                          color: blue,
                        ),
                      )),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "نأسف، لا يمكن ترك المهمة فارغة";
                    }
                    return null;
                  },
                ),
              ),
              DoingList(),
              DoneList(),
            ],
          ),
        ),
      ),
    );
  }
}
