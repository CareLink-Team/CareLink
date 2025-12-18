import 'package:flutter/material.dart';
import '../../../core/theme/theme.dart';
import '../../../services/appointment_service.dart';

class DoctorAppointmentsScreen extends StatefulWidget {
  const DoctorAppointmentsScreen({super.key});

  @override
  State<DoctorAppointmentsScreen> createState() =>
      _DoctorAppointmentsScreenState();
}

class _DoctorAppointmentsScreenState extends State<DoctorAppointmentsScreen> {
  final AppointmentService service = AppointmentService();

  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();

  List<Map<String, dynamic>> _appointments = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadAppointments();
  }

  Future<void> _loadAppointments() async {
    try {
      final data = await service.getPendingAppointments();
      setState(() {
        _appointments = data;
        _loading = false;
      });
    } catch (e) {
      setState(() => _loading = false);
    }
  }

  // ===============================
  // UI
  // ===============================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightBlue,
      appBar: AppBar(
        backgroundColor: AppTheme.primaryBlue,
        title: const Text('Pending Appointments'),
        centerTitle: true,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _appointments.isEmpty
          ? const Center(child: Text('No pending appointments'))
          : AnimatedList(
              key: _listKey,
              padding: const EdgeInsets.all(16),
              initialItemCount: _appointments.length,
              itemBuilder: (context, index, animation) {
                final a = _appointments[index];

                final patientName =
                    a['patient_profiles']?['user_profiles']?['full_name'] ??
                    'Unknown Patient';

                final caretakerName =
                    a['caretaker_profiles']?['user_profiles']?['full_name'] ??
                    'No caretaker';

                final requestedDate = DateTime.parse(a['date_time']).toLocal();

                return SizeTransition(
                  sizeFactor: animation,
                  child: FadeTransition(
                    opacity: animation,
                    child: _appointmentCard(
                      a,
                      index,
                      patientName,
                      caretakerName,
                      requestedDate,
                    ),
                  ),
                );
              },
            ),
    );
  }

  // ===============================
  // Appointment Card
  // ===============================
  Widget _appointmentCard(
    Map<String, dynamic> a,
    int index,
    String patientName,
    String caretakerName,
    DateTime requestedDate,
  ) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.only(bottom: 14),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: ListTile(
        title: Text(
          patientName,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 6),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Caretaker: $caretakerName'),
              Text('Purpose: ${a['purpose']}'),
              Text('Requested Date: ${requestedDate.toString().split(' ')[0]}'),
              Text(
                'Status: ${a['status']}',
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
        trailing: PopupMenuButton<String>(
          itemBuilder: (_) => const [
            PopupMenuItem(value: 'approve', child: Text('Approve')),
            PopupMenuItem(value: 'reject', child: Text('Reject')),
          ],
          onSelected: (value) {
            if (value == 'approve') {
              _showApproveDialog(
                context,
                a['appointment_id'],
                requestedDate,
                index,
              );
            } else {
              _rejectWithAnimation(a['appointment_id'], index);
            }
          },
        ),
      ),
    );
  }

  // ===============================
  // Reject with animation
  // ===============================
  Future<void> _rejectWithAnimation(String appointmentId, int index) async {
    final removedItem = _appointments[index];

    // First animate removal
    _appointments.removeAt(index);
    _listKey.currentState?.removeItem(
      index,
      (context, animation) => FadeTransition(
        opacity: animation,
        child: SizeTransition(
          sizeFactor: animation,
          child: Card(
            margin: const EdgeInsets.only(bottom: 14),
            child: ListTile(
              title: Text(
                removedItem['patient_profiles']?['user_profiles']?['full_name'] ??
                    '',
              ),
            ),
          ),
        ),
      ),
      duration: const Duration(milliseconds: 350),
    );

    // Then update DB
    await service.rejectAppointment(appointmentId);
  }

  // ===============================
  // Approve dialog + animation
  // ===============================
  Future<void> _showApproveDialog(
    BuildContext context,
    String appointmentId,
    DateTime requestedDate,
    int index,
  ) async {
    DateTime selectedDate = requestedDate;
    TimeOfDay? selectedTime;

    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Approve Appointment'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.calendar_today),
              title: Text(selectedDate.toString().split(' ')[0]),
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: selectedDate,
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 365)),
                );
                if (picked != null) selectedDate = picked;
              },
            ),
            ListTile(
              leading: const Icon(Icons.access_time),
              title: Text(
                selectedTime == null
                    ? 'Select Time'
                    : selectedTime!.format(context),
              ),
              onTap: () async {
                final picked = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                );
                if (picked != null) selectedTime = picked;
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            child: const Text('Cancel'),
            onPressed: () => Navigator.pop(context),
          ),
          ElevatedButton(
            child: const Text('Approve'),
            onPressed: () async {
              if (selectedTime == null) return;

              final finalDateTime = DateTime(
                selectedDate.year,
                selectedDate.month,
                selectedDate.day,
                selectedTime!.hour,
                selectedTime!.minute,
              );

              await service.approveAppointment(
                appointmentId: appointmentId,
                finalDateTime: finalDateTime,
              );

              Navigator.pop(context);

              final removed = _appointments.removeAt(index);
              _listKey.currentState?.removeItem(
                index,
                (context, animation) => FadeTransition(
                  opacity: animation,
                  child: SizeTransition(
                    sizeFactor: animation,
                    child: Container(),
                  ),
                ),
                duration: const Duration(milliseconds: 400),
              );
            },
          ),
        ],
      ),
    );
  }
}
