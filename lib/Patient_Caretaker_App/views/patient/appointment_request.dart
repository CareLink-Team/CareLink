import 'package:flutter/material.dart';

class AppointmentRequest extends StatefulWidget {
  const AppointmentRequest({super.key});

  @override
  State<AppointmentRequest> createState() => _AppointmentRequestState();
}

class _AppointmentRequestState extends State<AppointmentRequest> {
  final _formKey = GlobalKey<FormState>();
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  final TextEditingController _doctorController = TextEditingController();

  // Sample upcoming appointments
  final List<Map<String, String>> _appointments = [
    {'date': '2025-12-15', 'time': '10:00 AM', 'doctor': 'Dr. Ahmed'},
    {'date': '2025-12-20', 'time': '02:00 PM', 'doctor': 'Dr. Sara'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Request Appointment')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔹 Form Heading
            const Text(
              'Request New Appointment',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            Form(
              key: _formKey,
              child: Column(
                children: [
                  // 👨‍⚕️ Doctor Name
                  TextFormField(
                    controller: _doctorController,
                    decoration: const InputDecoration(
                      labelText: 'Doctor Name',
                      prefixIcon: Icon(Icons.person, color: Color(0xFF1976D2)),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Enter doctor name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),

                  // 📅 Select Date
                  InkWell(
                    onTap: () async {
                      DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(const Duration(days: 365)),
                      );
                      if (picked != null) {
                        setState(() {
                          _selectedDate = picked;
                        });
                      }
                    },
                    child: InputDecorator(
                      decoration: const InputDecoration(
                        labelText: 'Select Date',
                        prefixIcon: Icon(
                          Icons.calendar_today,
                          color: Color(0xFF1976D2),
                        ),
                      ),
                      child: Text(
                        _selectedDate != null
                            ? '${_selectedDate!.year}-${_selectedDate!.month.toString().padLeft(2, '0')}-${_selectedDate!.day.toString().padLeft(2, '0')}'
                            : 'Tap to select date',
                        style: TextStyle(
                          color: _selectedDate != null
                              ? Colors.black
                              : Colors.grey[600],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // ⏰ Select Time
                  InkWell(
                    onTap: () async {
                      TimeOfDay? picked = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      );
                      if (picked != null) {
                        setState(() {
                          _selectedTime = picked;
                        });
                      }
                    },
                    child: InputDecorator(
                      decoration: const InputDecoration(
                        labelText: 'Select Time',
                        prefixIcon: Icon(
                          Icons.access_time,
                          color: Color(0xFF1976D2),
                        ),
                      ),
                      child: Text(
                        _selectedTime != null
                            ? _selectedTime!.format(context)
                            : 'Tap to select time',
                        style: TextStyle(
                          color: _selectedTime != null
                              ? Colors.black
                              : Colors.grey[600],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // 🔘 Submit Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate() &&
                            _selectedDate != null &&
                            _selectedTime != null) {
                          // Placeholder: Add appointment logic
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Appointment requested!'),
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Please complete all fields'),
                            ),
                          );
                        }
                      },
                      child: const Text('Request Appointment'),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // 🔹 Upcoming Appointments
            const Text(
              'Upcoming Appointments',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            _appointments.isEmpty
                ? const Text(
                    'No upcoming appointments.',
                    style: TextStyle(color: Colors.grey),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _appointments.length,
                    itemBuilder: (context, index) {
                      final appt = _appointments[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: ListTile(
                          leading: const Icon(
                            Icons.calendar_today,
                            color: Color(0xFF1976D2),
                          ),
                          title: Text('${appt['date']} at ${appt['time']}'),
                          subtitle: Text('Doctor: ${appt['doctor']}'),
                        ),
                      );
                    },
                  ),
          ],
        ),
      ),
    );
  }
}
