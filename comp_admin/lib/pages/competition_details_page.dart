import 'package:flutter/material.dart';
import 'dart:async';  // For Timer

class CompetitionDetailsPage extends StatefulWidget {
  final dynamic competition; // Expect competition object passed from HomePage

  const CompetitionDetailsPage({super.key, required this.competition});

  @override
  _CompetitionDetailsPageState createState() => _CompetitionDetailsPageState();
}

class _CompetitionDetailsPageState extends State<CompetitionDetailsPage> {
  bool _isButtonVisible = true;  // Button visibility flag
  bool _isInterest = true;  // Flag to toggle between "Show Interest" and "Get Approval"

  @override
  void initState() {
    super.initState();

    // Toggle the button visibility every 500 milliseconds (half a second)
    Timer.periodic(const Duration(milliseconds: 500), (timer) {
      setState(() {
        _isButtonVisible = !_isButtonVisible;  // Toggle visibility
      });
    });
  }

  void _toggleButtonAction() {
    setState(() {
      if (_isInterest) {
        // Logic when "Show Interest" is clicked
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Interest has been shown.')),
        );
      } else {
        // Logic when "Get Approval" is clicked
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Approval request sent.')),
        );
      }

      // Toggle the button state after action
      _isInterest = !_isInterest;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.competition['name'] ?? 'Competition Details',
          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.competition['name'] ?? 'No Title Available',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Date: ${widget.competition['date'] ?? 'No Date Available'}',
              style: const TextStyle(fontSize: 16, color: Colors.black54),
            ),
            const SizedBox(height: 16),
            Text(
              'Details:',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              widget.competition['details'] ?? 'No Details Available',
              style: const TextStyle(fontSize: 16, color: Colors.black87),
            ),
            const SizedBox(height: 16),
            Text(
              'Category: ${widget.competition['category'] ?? 'N/A'}',
              style: const TextStyle(fontSize: 16, color: Colors.black87),
            ),
            const SizedBox(height: 16),
            Text(
              'Level: ${widget.competition['level'] ?? 'N/A'}',
              style: const TextStyle(fontSize: 16, color: Colors.black87),
            ),
            const SizedBox(height: 32),

            // Single Button with Blinking Effect
            Visibility(
              visible: _isButtonVisible,  // Controls visibility
              child: ElevatedButton(
                onPressed: _toggleButtonAction, // Toggle between actions
                style: ElevatedButton.styleFrom(
                  backgroundColor: _isInterest ? Colors.deepPurple : Colors.purpleAccent,
                  padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 30),
                ),
                child: Text(
                  'Show Interest and Get Approval',  // Static button text
                  style: const TextStyle(fontSize: 16, color: Colors.white),
                ),

              ),
            ),
          ],
        ),
      ),
    );
  }
}
