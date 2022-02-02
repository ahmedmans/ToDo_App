import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:todo_app/app/core/utils/extensions.dart';
import 'package:todo_app/app/core/values/colors.dart';
import 'package:todo_app/app/modules/home/controller.dart';

class AddDialog extends StatelessWidget {
  final homeController = Get.find<HomeController>();
  AddDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: Form(
          key: homeController.formKey,
          child: ListView(
            children: [
              Padding(
                padding: EdgeInsets.all(2.0.wp),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () {
                        Get.back();
                        homeController.textEditingController.clear();
                        homeController.changeTask(null);
                      },
                      icon: const Icon(Icons.close),
                    ),
                    TextButton(
                      style: ButtonStyle(
                        overlayColor:
                            MaterialStateProperty.all(Colors.transparent),
                      ),
                      onPressed: () {
                        if (homeController.formKey.currentState!.validate()) {
                          if (homeController.task.value == null) {
                            EasyLoading.showError('من فضلك حدد نوع المهمة');
                          } else {
                            var sucsses = homeController.updateTask(
                              homeController.task.value!,
                              homeController.textEditingController.text,
                            );

                            if (sucsses) {
                              EasyLoading.showSuccess(
                                  'حسنا، تم اضافة المهمة بنجاح');
                              Get.back();
                              homeController.changeTask(null);
                            } else {
                              EasyLoading.showError(
                                  'نأسف، هذه المهمة موجودة بالفعل');
                              homeController.textEditingController.clear();
                            }
                          }
                        }
                      },
                      child: Text(
                        'تم',
                        style: TextStyle(
                          fontSize: 14.0.sp,
                          fontWeight: FontWeight.bold,
                          color: blue,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 5.0.wp),
                child: Text(
                  'مهمة جديدة',
                  style: TextStyle(
                    fontSize: 20.0.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 5.0.wp),
                child: TextFormField(
                  controller: homeController.textEditingController,
                  decoration: InputDecoration(
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey[400]!),
                    ),
                  ),
                  autofocus: true,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'نأسف، لا يمكن ترك المهمة فارغة';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                    top: 5.0.wp, left: 5.0.wp, right: 5.0.wp, bottom: 2.0.wp),
                child: Text(
                  'إضافة الى',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 16.0.sp,
                  ),
                ),
              ),
              ...homeController.tasksList
                  .map((element) => Obx(
                        () => InkWell(
                          onTap: () => homeController.changeTask(element),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 3.0.wp, horizontal: 3.0.wp),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      IconData(
                                        element.icon,
                                        fontFamily: 'MaterialIcons',
                                      ),
                                      color: HexColor.fromHex(element.color),
                                    ),
                                    SizedBox(
                                      width: 3.0.wp,
                                    ),
                                    Text(
                                      element.title,
                                      style: TextStyle(
                                        fontSize: 12.0.sp,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                if (homeController.task.value == element)
                                  const Icon(
                                    Icons.check,
                                    color: Colors.blue,
                                  )
                              ],
                            ),
                          ),
                        ),
                      ))
                  .toList()
            ],
          ),
        ),
      ),
    );
  }
}
