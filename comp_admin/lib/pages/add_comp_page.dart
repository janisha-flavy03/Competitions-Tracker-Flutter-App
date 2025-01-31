import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../controller/home_controller.dart';
import '../widgets/drop_down_btn.dart';

class AddCompPage extends StatelessWidget {
  const AddCompPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(builder: (ctrl) {
      return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Add Competition',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.deepPurple, Colors.purpleAccent],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          elevation: 10,
        ),
        body: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  elevation: 6,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        const Text(
                          'Add New Competition',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.deepPurple,
                          ),
                        ),
                        const SizedBox(height: 20),
                        // Competition Name
                        TextField(
                          controller: ctrl.competitionNameCtrl,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            label: const Text('Competition Name'),
                            hintText: 'Enter Competition Name',
                          ),
                        ),
                        const SizedBox(height: 15),
                        // Competition Details
                        TextField(
                          controller: ctrl.competitionDetailsCtrl,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            label: const Text('Details (Optional)'),
                            hintText: 'Enter Competition Details',
                          ),
                          maxLines: 4,
                        ),
                        const SizedBox(height: 15),
                        // Image URL
                        TextField(
                          controller: ctrl.competitionImgCtrl,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            label: const Text('Image URL'),
                            hintText: 'Enter Image URL',
                          ),
                        ),
                        const SizedBox(height: 15),
                        // Date Picker
                        TextField(
                          controller: ctrl.competitionDateCtrl,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            label: const Text('Date (yyyy-MM-dd)'),
                            hintText: 'Select Date',
                          ),
                          onTap: () async {
                            FocusScope.of(context).requestFocus(FocusNode());
                            DateTime? selectedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(1900),
                              lastDate: DateTime(2100),
                            );
                            if (selectedDate != null) {
                              ctrl.competitionDateCtrl.text =
                                  DateFormat('yyyy-MM-dd').format(selectedDate);
                            }
                          },
                        ),
                        const SizedBox(height: 15),
                        // Competition Place
                        TextField(
                          controller: ctrl.competitionPlaceCtrl,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            label: const Text('Place (Optional)'),
                            hintText: 'Enter Place',
                          ),
                        ),
                        const SizedBox(height: 15),
                        // Category and Level Dropdowns
                        Row(
                          children: [
                            Expanded(
                              child: DropDownBtn(
                                items: ['Technical', 'Non-Technical', 'Both'],
                                selectedItemText: ctrl.category,
                                onSelected: (value) {
                                  ctrl.category = value ?? 'Category';
                                  ctrl.update();
                                },
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: DropDownBtn(
                                items: [
                                  'Intra-college',
                                  'Inter-college',
                                  'Intra-Department',
                                  'Inter-Department',
                                  'National Level',
                                  'International Level',
                                  'Others'
                                ],
                                selectedItemText: ctrl.level,
                                onSelected: (value) {
                                  ctrl.level = value ?? 'Level';
                                  ctrl.update();
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 15),
                        // Registration Fee
                        const Text(
                          'Registration Fee? (Optional)',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        DropDownBtn(
                          items: ['Yes', 'No'],
                          selectedItemText: ctrl.fee.toString(),
                          onSelected: (value) {
                            ctrl.fee = (value ?? 'No').toLowerCase() == 'yes';
                            ctrl.update();
                          },
                        ),
                        const SizedBox(height: 20),
                        // Add Competition Button
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.deepPurple,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 30, vertical: 15),
                          ),
                          onPressed: () {
                            if (ctrl.competitionNameCtrl.text.trim().isEmpty) {
                              Get.snackbar(
                                'Missing Fields',
                                'Competition Name is required.',
                                snackPosition: SnackPosition.TOP,
                                backgroundColor: Colors.red,
                                colorText: Colors.white,
                              );
                              return;
                            }
                            if (ctrl.competitionImgCtrl.text.trim().isEmpty) {
                              Get.snackbar(
                                'Missing Fields',
                                'Image URL is required.',
                                snackPosition: SnackPosition.TOP,
                                backgroundColor: Colors.red,
                                colorText: Colors.white,
                              );
                              return;
                            }
                            ctrl.addCompetition();
                          },
                          child: const Text(
                            'Add Competition',
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}