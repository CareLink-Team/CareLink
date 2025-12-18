import 'package:flutter/material.dart';
import '../../../services/appointment_service.dart';

class AppointmentTab extends StatelessWidget {
  final String patientId;

  AppointmentTab({super.key, required this.patientId});

  final AppointmentService service = AppointmentService();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: service.getAppointmentsForPatient(patientId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(
            child: Text(
              snapshot.error.toString(),
              style: const TextStyle(color: Colors.red),
            ),
          );
        }

        final appointments = snapshot.data ?? [];

        if (appointments.isEmpty) {
          return const Center(child: Text('No appointments found'));
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: appointments.length,
          itemBuilder: (context, index) {
            final data = appointments[index];

            final caretakerName =
                data['caretaker_profiles']?['user_profiles']?['full_name'] ??
                'No caretaker';

            final dateTime = DateTime.parse(data['date_time']);

            // Use animated card here
            return AnimatedAppointmentCard(
              index: index,
              title: data['purpose'] ?? 'Appointment',
              caretakerName: caretakerName,
              status: data['status'] ?? 'Pending',
              date: "${dateTime.day}/${dateTime.month}/${dateTime.year}",
            );
          },
        );
      },
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
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _fadeAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    // Delay animation based on index for staggered effect
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
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            title: Text(
              widget.title,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Caretaker: ${widget.caretakerName}'),
                const SizedBox(height: 4),
                Text('Status: ${widget.status}'),
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