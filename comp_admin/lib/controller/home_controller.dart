import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../competition/competition.dart';
import '../student/student.dart';  // Assuming you have a Student model

class HomeController extends GetxController {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  late CollectionReference competitionCollection;
  late CollectionReference studentCollection;

  // Controllers for text fields
  TextEditingController competitionNameCtrl = TextEditingController();
  TextEditingController competitionDetailsCtrl = TextEditingController();
  TextEditingController competitionImgCtrl = TextEditingController();
  TextEditingController competitionDateCtrl = TextEditingController();
  TextEditingController competitionPlaceCtrl = TextEditingController();

  // Default values
  String category = 'Category';
  String level = 'Level';
  bool fee = true;

  // List to store competitions and students
  RxList<Competition> competition = <Competition>[].obs;
  RxList<Student> students = <Student>[].obs; // List to hold student data

  @override
  Future<void> onInit() async {
    competitionCollection = firestore.collection('competition');
    studentCollection = firestore.collection('students');  // Firestore collection for students
    await fetchCompetitions();
    await fetchStudents();  // Fetch students on initialization
    super.onInit();
  }

  // Add a new competition
  Future<void> addCompetition() async {
    try {
      // Validate required fields: Competition Name and Image URL
      if (competitionNameCtrl.text.isEmpty || competitionImgCtrl.text.isEmpty) {
        Get.snackbar(
          'Invalid Input',
          'Competition Name and Image URL are required!',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.orange,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );
        return;
      }

      // Parse date string to DateTime
      final competitionDate = DateTime.tryParse(competitionDateCtrl.text.trim());
      if (competitionDate == null) {
        Get.snackbar(
          'Invalid Input',
          'Please enter a valid date for the competition.',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.orange,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );
        return;
      }

      // Create Firestore document
      DocumentReference doc = competitionCollection.doc();

      // Construct Competition object
      Competition competitionData = Competition(
        id: doc.id,
        name: competitionNameCtrl.text.trim(),
        category: category,
        details: competitionDetailsCtrl.text.trim(),
        date: competitionDate, // Store as DateTime object
        level: level,
        image: competitionImgCtrl.text.trim(),
        fee: fee,
      );

      // Convert DateTime to Timestamp for Firestore
      final competitionJson = competitionData.toJson();
      competitionJson['date'] = Timestamp.fromDate(competitionDate); // Ensure date is saved as Timestamp

      // Save to Firestore
      await doc.set(competitionJson);

      // Success notification
      Get.snackbar(
        'Success',
        'Competition added successfully!',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );

      // Reset form fields
      setValuesDefault();
      await fetchCompetitions();  // Refresh competitions after adding
    } catch (e) {
      // Error notification
      Get.snackbar(
        'Error',
        'Failed to add competition: ${_formatError(e)}',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );

      if (kDebugMode) {
        print('Error adding competition: $e');
      }
    }
  }

  // Fetch all competitions
  Future<void> fetchCompetitions() async {
    try {
      // Retrieve all documents from Firestore
      QuerySnapshot competitionSnapshot = await competitionCollection.get();

      if (competitionSnapshot.docs.isEmpty) {
        competition.clear();
        update(); // Update UI when no competitions are found
        return;
      }

      // Parse documents
      final List<Competition> retrievedCompetitions = competitionSnapshot.docs
          .map((doc) {
        var competitionData = doc.data() as Map<String, dynamic>;

        // Convert Timestamp to DateTime for the 'date' field
        if (competitionData['date'] is Timestamp) {
          competitionData['date'] = (competitionData['date'] as Timestamp).toDate();
        }

        // Convert DateTime to String if required for UI
        String formattedDate = DateFormat('yyyy-MM-dd').format(competitionData['date']);

        // Update the competitionData with the formatted date (optional, if needed for display)
        competitionData['date'] = formattedDate;

        return Competition.fromJson(competitionData);
      }).toList();

      // Update competition list
      competition.clear();
      competition.assignAll(retrievedCompetitions);
      update(); // Update UI when competitions are fetched
    } catch (e) {
      // Error notification
      Get.snackbar(
        'Error',
        'Failed to fetch competitions: ${_formatError(e)}',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );

      if (kDebugMode) {
        print('Error fetching competitions: $e');
      }
    }
  }

  // Fetch students' data
  Future<void> fetchStudents() async {
    try {
      // Retrieve all documents from Firestore for students
      QuerySnapshot studentSnapshot = await studentCollection.get();

      if (studentSnapshot.docs.isEmpty) {
        students.clear();
        update(); // Update UI when no students are found
        return;
      }

      // Parse documents to create student objects
      final List<Student> retrievedStudents = studentSnapshot.docs
          .map((doc) {
        var studentData = doc.data() as Map<String, dynamic>;
        return Student.fromJson(studentData);
      }).toList();

      // Update students list
      students.clear();
      students.assignAll(retrievedStudents);
      update(); // Update UI after fetching students
    } catch (e) {
      // Error notification
      Get.snackbar(
        'Error',
        'Failed to fetch students: ${_formatError(e)}',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
    }
  }

  // Add student interest in a competition
  Future<void> showInterestInCompetition(String studentId, String competitionId) async {
    try {
      // Get reference to student document
      DocumentReference studentDoc = studentCollection.doc(studentId);

      // Update student's interest in the competition
      await studentDoc.update({
        'interestedCompetitions': FieldValue.arrayUnion([competitionId])
      });

      // Success notification
      Get.snackbar(
        'Success',
        'Student has shown interest in the competition!',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );

      update(); // Update UI after showing interest
    } catch (e) {
      // Error notification
      Get.snackbar(
        'Error',
        'Failed to update interest: ${_formatError(e)}',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
    }
  }

  // Delete a competition
  Future<void> deleteCompetition(String competitionId) async {
    try {
      // Get reference to competition document
      DocumentReference competitionDoc = competitionCollection.doc(competitionId);

      // Delete competition document
      await competitionDoc.delete();

      // Success notification
      Get.snackbar(
        'Success',
        'Competition deleted successfully!',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );

      await fetchCompetitions();  // Refresh competitions after deleting
    } catch (e) {
      // Error notification
      Get.snackbar(
        'Error',
        'Failed to delete competition: ${_formatError(e)}',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );

      if (kDebugMode) {
        print('Error deleting competition: $e');
      }
    }
  }

  // Reset the form fields to default values
  void setValuesDefault() {
    competitionNameCtrl.clear();
    competitionDateCtrl.clear();
    competitionDetailsCtrl.clear();
    competitionImgCtrl.clear();
    competitionPlaceCtrl.clear();

    category = 'Category';
    level = 'Level';
    fee = fee;
    update(); // Update the UI after resetting values
  }

  // Format the error message
  String _formatError(dynamic error) {
    if (error is FirebaseException) {
      return error.message ?? 'Unknown Firebase error';
    }
    return error.toString();
  }

  List<Map<String, dynamic>> getStudentsAsMap() {
    return students.map((student) {
      return {
        'name': student.name,
        'registrationNumber': student.registrationNumber,
        // Add other fields as necessary
      };
    }).toList();
  }

  // Get competition by ID (if needed)
  getCompetitionById(String competitionId) async {
    try {
      DocumentSnapshot doc = await competitionCollection.doc(competitionId).get();
      if (doc.exists) {
        var competitionData = doc.data() as Map<String, dynamic>;
        // Handle competition data here
        return Competition.fromJson(competitionData);
      } else {
        Get.snackbar(
          'Error',
          'Competition not found!',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to fetch competition: ${_formatError(e)}',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
    }
  }
}
