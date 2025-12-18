import 'package:flutter/material.dart';
import '../../../services/appointment_service.dart';

class AppointmentTab extends StatefulWidget {
  final String patientId;

  const AppointmentTab({super.key, required this.patientId});

  @override
  State<AppointmentTab> createState() => _AppointmentTabState();
}

class _AppointmentTabState extends State<AppointmentTab> {
  final AppointmentService service = AppointmentService();
  List<Map<String, dynamic>> appointments = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _loadAppointments();
  }

  Future<void> _loadAppointments() async {
    setState(() => loading = true);
    final data = await service.getAppointmentsForPatient(widget.patientId);
    setState(() {
      appointments = data;
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (appointments.isEmpty) {
      return const Center(child: Text('No appointments found'));
    }

    return RefreshIndicator(
      onRefresh: _loadAppointments,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: appointments.length,
        itemBuilder: (context, index) {
          final data = appointments[index];
          final caretakerName =
              data['caretaker_profiles']?['user_profiles']?['full_name'] ??
              'No caretaker';
          final dateTime = DateTime.parse(data['date_time']);
          final status = data['status'] ?? 'pending';

          return AnimatedAppointmentCard(
            key: ValueKey(
              data['appointment_id'],
            ), // ensures animation works on rebuild
            index: index,
            title: data['purpose'] ?? 'Appointment',
            caretakerName: caretakerName,
            status: status,
            date: "${dateTime.day}/${dateTime.month}/${dateTime.year}",
          );
        },
      ),
    );
  }
}

// --------------------- ANIMATED APPOINTMENT CARD ---------------------

class AnimatedAppointmentCard extends StatefulWidget {
  final int index;
  final String title;
  final String caretakerName;
  final String status;
  final String date;

  const AnimatedAppointmentCard({
    super.key,
    required this.index,
    required this.title,
    required this.caretakerName,
    required this.status,
    required this.date,
  });

  @override
  State<AnimatedAppointmentCard> createState() =>
      _AnimatedAppointmentCardState();
}

class _AnimatedAppointmentCardState extends State<AnimatedAppointmentCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<Offset> _slideAnimation;
  late final Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _fadeAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));

    Future.delayed(Duration(milliseconds: widget.index * 100), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 10,
                offset: Offset(0, 6),
              ),
            ],
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
            title: Text(
              widget.title,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: widget.status == 'cancelled' ? Colors.red : Colors.black,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Caretaker: ${widget.caretakerName}'),
                const SizedBox(height: 4),
                Text(
                  'Status: ${widget.status}',
                  style: TextStyle(
                    fontWeight: widget.status == 'cancelled'
                        ? FontWeight.bold
                        : FontWeight.w500,
                    color: widget.status == 'cancelled'
                        ? Colors.red
                        : Colors.black,
                  ),
                ),
              ],
            ),
            trailing: Text(
              widget.date,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ),
        ),
      ),
    );
  }
}
