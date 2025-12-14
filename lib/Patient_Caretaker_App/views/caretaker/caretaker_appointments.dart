import 'package:flutter/material.dart';

class CaretakerAppointments extends StatefulWidget {
  const CaretakerAppointments({super.key});

  @override
  State<CaretakerAppointments> createState() => _CaretakerAppointmentsState();
}

class _CaretakerAppointmentsState extends State<CaretakerAppointments> {
  // Initial appointment requests
  final List<Map<String, String>> _requests = [
    {'patient': 'Ali Raza', 'date': '2025-12-15', 'time': '10:00 AM'},
    {'patient': 'Sara Ahmed', 'date': '2025-12-20', 'time': '02:00 PM'},
  ];

  final List<Map<String, String>> _approved = [];
  final List<Map<String, String>> _rejected = [];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F7FA),
        appBar: AppBar(
          title: const Text('Manage Appointments'),
          backgroundColor: const Color(0xFF1976D2),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Requests'),
              Tab(text: 'Approved'),
              Tab(text: 'Rejected'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildList(_requests, showActions: true),
            _buildList(_approved, showActions: false),
            _buildList(_rejected, showActions: false),
          ],
        ),
      ),
    );
  }

  // 🔹 Build appointment list
  Widget _buildList(List<Map<String, String>> list, {required bool showActions}) {
    if (list.isEmpty) {
      return const Center(
        child: Text(
          'No appointments here.',
          style: TextStyle(color: Colors.grey),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: list.length,
      itemBuilder: (context, index) {
        final appt = list[index];
        return Card(
          elevation: 2,
          margin: const EdgeInsets.only(bottom: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: ListTile(
            leading: const Icon(Icons.calendar_today, color: Color(0xFF1976D2)),
            title: Text(appt['patient']!),
            subtitle: Text('${appt['date']} at ${appt['time']}'),
            trailing: showActions
                ? Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.check_circle, color: Colors.green),
                        onPressed: () {
                          setState(() {
                            _approved.add(appt);
                            _requests.removeAt(index);
                          });
                        },
                        tooltip: 'Approve',
                      ),
                      IconButton(
                        icon: const Icon(Icons.cancel, color: Colors.red),
                        onPressed: () {
                          setState(() {
                            _rejected.add(appt);
                            _requests.removeAt(index);
                          });
                        },
                        tooltip: 'Reject',
                      ),
                    ],
                  )
                : Icon(
                    showActions ? Icons.hourglass_top : 
                    (list == _approved ? Icons.check_circle : Icons.cancel),
                    color: list == _approved ? Colors.green : Colors.red,
                  ),
          ),
        );
      },
    );
  }
}
