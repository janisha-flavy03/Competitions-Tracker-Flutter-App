import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../controller/home_controller.dart';
import 'add_comp_page.dart';
import 'competition_details_page.dart';
import 'interested_students_page.dart'; // Import the page for showing interested students

class HomePage extends StatelessWidget {
  final String role; // Role passed from login page

  const HomePage({super.key, required this.role});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(builder: (ctrl) {
      return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Competitions',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
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
          elevation: 10.0,
        ),
        body: ctrl.competition.isEmpty
            ? _noCompetitionsView()
            : _competitionListView(ctrl),
        floatingActionButton: role == "admin" ? _adminFloatingButton() : null,
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        persistentFooterButtons: role == "admin" ? _adminFooterButtons(ctrl) : [],
      );
    });
  }

  Widget _noCompetitionsView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(Icons.event_busy, size: 80, color: Colors.grey),
          SizedBox(height: 16),
          Text(
            'No competitions available!',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Add a competition to get started.',
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _competitionListView(HomeController ctrl) {
    return ListView.builder(
      itemCount: ctrl.competition.length,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      itemBuilder: (context, index) {
        var competition = ctrl.competition[ctrl.competition.length - 1 - index];

        String title = competition.name ?? 'No Title Available';
        String date = competition.date != null && competition.date is DateTime
            ? DateFormat('yyyy-MM-dd').format(competition.date!)
            : 'Invalid Date';

        return Card(
          elevation: 4,
          margin: const EdgeInsets.symmetric(vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.all(16),
            leading: CircleAvatar(
              backgroundColor: Colors.deepPurple,
              child: const Icon(Icons.event, color: Colors.white),
            ),
            title: Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            subtitle: Text(
              date,
              style: const TextStyle(fontSize: 14, color: Colors.black54),
            ),
            onTap: () {
              Get.to(() => CompetitionDetailsPage(
                competition: {
                  'id': competition.id,
                  'name': competition.name,
                  'date': competition.date != null
                      ? DateFormat('yyyy-MM-dd').format(competition.date!)
                      : null,
                  'details': competition.details,
                  'category': competition.category,
                  'level': competition.level,
                },
              ));
            },
            trailing: role == "admin" ? _deleteIconButton(competition, ctrl) : null,
          ),
        );
      },
    );
  }

  Widget _deleteIconButton(competition, HomeController ctrl) {
    return IconButton(
      icon: const Icon(Icons.delete, color: Colors.red),
      onPressed: () {
        _showDeleteConfirmationDialog(competition, ctrl);
      },
    );
  }

  void _showDeleteConfirmationDialog(competition, HomeController ctrl) {
    Get.dialog(
      AlertDialog(
        title: const Text(
          'Confirm Deletion',
          style: TextStyle(color: Colors.red),
        ),
        content: const Text(
          'Are you sure you want to delete this competition?',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Get.back();
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (competition.id != null) {
                ctrl.deleteCompetition(competition.id!);
                Get.back();
              }
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  Widget _adminFloatingButton() {
    return FloatingActionButton(
      onPressed: () {
        // Navigate to Add Competition Page
        Get.to(() => const AddCompPage());
      },
      backgroundColor: Colors.deepPurple,
      child: const Icon(Icons.add, color: Colors.white),
    );
  }


  List<Widget> _adminFooterButtons(HomeController ctrl) {
    return [
      IconButton(
        icon: const Icon(Icons.emoji_events),
        onPressed: () {
          // Navigate to InterestedStudentsPage with students list
          Get.to(() => InterestedStudentsPage(
            interestedStudents: ctrl.students.toList().map((student) {
              return {
                "name": student.name,
                "id": student.id,
              };
            }).toList(), // Convert RxList to List<Map<String, String>>
          ));
        },
      ),
    ];
  }
}
