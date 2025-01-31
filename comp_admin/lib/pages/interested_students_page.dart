import 'package:flutter/material.dart';

class InterestedStudentsPage extends StatelessWidget {
  final List<Map<String, String>> interestedStudents;

  const InterestedStudentsPage({super.key, required this.interestedStudents});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Interested Students'),
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
      ),
      body: interestedStudents.isEmpty
          ? _noInterestView()
          : _studentsListView(),
    );
  }

  Widget _noInterestView() {
    return const Center(
      child: Text(
        'No students have shown interest yet.',
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _studentsListView() {
    return ListView.builder(
      itemCount: interestedStudents.length,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      itemBuilder: (context, index) {
        var student = interestedStudents[index];
        String name = student['name'] ?? 'No Name Available';
        String regNo = student['regNo'] ?? 'No Registration Number';

        return _studentCard(name, regNo);
      },
    );
  }

  Widget _studentCard(String name, String regNo) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        title: Text(
          name,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        subtitle: Text(
          regNo,
          style: const TextStyle(fontSize: 14, color: Colors.black54),
        ),
      ),
    );
  }
}
