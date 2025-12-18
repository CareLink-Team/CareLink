import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CaretakerAppointments extends StatefulWidget {
  final String caretakerId;

  const CaretakerAppointments({super.key, required this.caretakerId});

  @override
  State<CaretakerAppointments> createState() => _CaretakerAppointmentsState();
}

class _CaretakerAppointmentsState extends State<CaretakerAppointments> {
  final supabase = Supabase.instance.client;

  bool _loading = true;
  List<Map<String, dynamic>> _requests = [];
  List<Map<String, dynamic>> _approved = [];
  List<Map<String, dynamic>> _rejected = [];

  @override
  void initState() {
    super.initState();
    _fetchAppointments();
  }

  Future<void> _fetchAppointments() async {
    setState(() => _loading = true);

    try {
      // Fetch all appointments for this caretaker
      final appointments = await supabase
          .from('appointments')
          .select('''
      appointment_id,
      date_time,
      status,
      purpose,
      patient_profiles (
        patient_id,
        user_profiles (
          full_name
        )
      )
    ''')
          .eq('caretaker_id', widget.caretakerId)
          .order('date_time');

      final List<Map<String, dynamic>> all = List<Map<String, dynamic>>.from(
        appointments,
      );

      setState(() {
        _requests = all.where((a) => a['status'] == 'pending').toList();
        _approved = all.where((a) => a['status'] == 'confirmed').toList();
        _rejected = all.where((a) => a['status'] == 'cancelled').toList();
        _loading = false;
      });
    } catch (e) {
      setState(() => _loading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching appointments: $e')),
      );
    }
  }

  Future<void> _updateStatus(String appointmentId, String status) async {
    try {
      await supabase
          .from('appointments')
          .update({'status': status})
          .eq('appointment_id', appointmentId);

      // Refresh after update
      _fetchAppointments();
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error updating appointment: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

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

  Widget _buildList(
    List<Map<String, dynamic>> list, {
    required bool showActions,
  }) {
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
        final patientName =
            appt['patient_profiles']?['user_profiles']?['full_name'] ??
            'Unknown';
        final dateTime = DateTime.parse(appt['date_time']).toLocal();
        final date = dateTime.toString().split(' ')[0];
        final time =
            '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';

        return Card(
          elevation: 2,
          margin: const EdgeInsets.only(bottom: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            leading: const Icon(Icons.calendar_today, color: Color(0xFF1976D2)),
            title: Text(patientName),
            subtitle: Text('$date at $time'),
            trailing: showActions
                ? Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.check_circle,
                          color: Colors.green,
                        ),
                        onPressed: () =>
                            _updateStatus(appt['appointment_id'], 'confirmed'),
                        tooltip: 'Approve',
                      ),
                      IconButton(
                        icon: const Icon(Icons.cancel, color: Colors.red),
                        onPressed: () =>
                            _updateStatus(appt['appointment_id'], 'cancelled'),
                        tooltip: 'Reject',
                      ),
                    ],
                  )
                : Icon(
                    list == _approved ? Icons.check_circle : Icons.cancel,
                    color: list == _approved ? Colors.green : Colors.red,
                  ),
          ),
        );
      },
    );
  }
}
