import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CaretakerAppointments extends StatefulWidget {
  final String caretakerId;

  const CaretakerAppointments({
    super.key,
    required this.caretakerId,
  });

  @override
  State<CaretakerAppointments> createState() => _CaretakerAppointmentsState();
}

class _CaretakerAppointmentsState extends State<CaretakerAppointments> {
  final supabase = Supabase.instance.client;

  bool _loading = false;
  bool _submitting = false;

  String? _doctorId;
  String? _patientId;

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _purposeController = TextEditingController();
  DateTime? _selectedDate;

  List<Map<String, dynamic>> _pending = [];
  List<Map<String, dynamic>> _approved = [];
  List<Map<String, dynamic>> _rejected = [];

  @override
  void initState() {
    super.initState();
    _fetchAssignment();
    _fetchAppointments();
  }

  // Fetch doctor_id and patient_id assigned to caretaker
  Future<void> _fetchAssignment() async {
    try {
      final res = await supabase
          .from('caretaker_profiles')
          .select('doctor_id, patient_id')
          .eq('caretaker_id', widget.caretakerId)
          .single();

      setState(() {
        _doctorId = res['doctor_id'];
        _patientId = res['patient_id'];
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Assignment error: $e')),
      );
    }
  }

  // Fetch caretaker appointments
  Future<void> _fetchAppointments() async {
    setState(() => _loading = true);
    try {
      final res = await supabase
          .from('appointments')
          .select()
          .eq('caretaker_id', widget.caretakerId)
          .order('date_time', ascending: true);

      final list = List<Map<String, dynamic>>.from(res);

      setState(() {
        _pending = list.where((a) => a['status'] == 'pending').toList();
        _approved = list.where((a) => a['status'] == 'confirmed').toList();
        _rejected = list.where((a) => a['status'] == 'cancelled').toList();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Fetch error: $e')),
      );
    } finally {
      setState(() => _loading = false);
    }
  }

  // Submit appointment
  Future<void> _submitAppointment() async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a date')),
      );
      return;
    }

    if (_doctorId == null || _patientId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Doctor or patient not assigned')),
      );
      return;
    }

    final dateTime = DateTime(
      _selectedDate!.year,
      _selectedDate!.month,
      _selectedDate!.day,
    ).toIso8601String();

    setState(() => _submitting = true);

    try {
      await supabase.from('appointments').insert({
        'doctor_id': _doctorId,
        'caretaker_id': widget.caretakerId,
        'patient_id': _patientId,
        'date_time': dateTime,
        'purpose': _purposeController.text,
        'status': 'pending',
      });

      _purposeController.clear();
      _selectedDate = null;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Appointment requested')),
      );

      await _fetchAppointments();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Submit error: $e')),
      );
    } finally {
      setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Appointments'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Request'),
              Tab(text: 'Approved'),
              Tab(text: 'Rejected'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildRequestForm(),
            _buildList(_approved),
            _buildList(_rejected),
          ],
        ),
      ),
    );
  }

  Widget _buildRequestForm() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              controller: _purposeController,
              decoration: const InputDecoration(
                labelText: 'Purpose',
                prefixIcon: Icon(Icons.notes),
              ),
              validator: (v) =>
                  v == null || v.isEmpty ? 'Purpose required' : null,
            ),
            const SizedBox(height: 16),
            InkWell(
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 365)),
                );
                if (picked != null) {
                  setState(() => _selectedDate = picked);
                }
              },
              child: InputDecorator(
                decoration: const InputDecoration(
                  labelText: 'Select Date',
                  prefixIcon: Icon(Icons.calendar_today),
                ),
                child: Text(
                  _selectedDate == null
                      ? 'Tap to select'
                      : _selectedDate!.toLocal().toString().split(' ')[0],
                ),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _submitting ? null : _submitAppointment,
                child: _submitting
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Request Appointment'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildList(List<Map<String, dynamic>> list) {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (list.isEmpty) {
      return const Center(child: Text('No appointments'));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: list.length,
      itemBuilder: (context, index) {
        final appt = list[index];
        final date = DateTime.parse(appt['date_time'])
            .toLocal()
            .toString()
            .split(' ')[0];

        return Card(
          child: ListTile(
            leading: const Icon(Icons.event),
            title: Text(appt['purpose'] ?? ''),
            subtitle: Text(date),
            trailing: Text(
              appt['status'],
              style: TextStyle(
                color: appt['status'] == 'confirmed'
                    ? Colors.green
                    : appt['status'] == 'cancelled'
                        ? Colors.red
                        : Colors.orange,
              ),
            ),
          ),
        );
      },
    );
  }
}
