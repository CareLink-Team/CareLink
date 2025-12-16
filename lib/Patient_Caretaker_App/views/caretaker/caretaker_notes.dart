import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CaretakerNotes extends StatefulWidget {
  final String caretakerId; // Pass the logged-in caretaker ID

  const CaretakerNotes({super.key, required this.caretakerId});

  @override
  State<CaretakerNotes> createState() => _CaretakerNotesState();
}

class _CaretakerNotesState extends State<CaretakerNotes> {
  final TextEditingController _noteController = TextEditingController();
  final supabase = Supabase.instance.client;

  List<Map<String, dynamic>> _patients = [];
  String? _selectedPatient;

  List<Map<String, dynamic>> _notes = [];
  bool _loadingPatients = true;
  bool _loadingNotes = true;

  @override
  void initState() {
    super.initState();
    _fetchPatients();
    _fetchNotes();
  }

  Future<void> _fetchPatients() async {
    try {
      final response = await supabase
    .from('patients') // your patients table
    .select('user_id, full_name:doctor_profiles(full_name)') // join full_name from doctor_profiles
    .eq('caretaker_id', widget.caretakerId);


      setState(() {
        _patients = List<Map<String, dynamic>>.from(response);
        _loadingPatients = false;
      });
    } catch (e) {
      setState(() => _loadingPatients = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error fetching patients: $e')));
    }
  }

  Future<void> _fetchNotes() async {
    try {
      final response = await supabase
          .from('caretaker_notes')
          .select('id, patient_id, note, created_at, patients!inner(full_name)')
          .eq('caretaker_id', widget.caretakerId)
          .order('created_at', ascending: false);

      setState(() {
        _notes = List<Map<String, dynamic>>.from(response);
        _loadingNotes = false;
      });
    } catch (e) {
      setState(() => _loadingNotes = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error fetching notes: $e')));
    }
  }

  Future<void> _saveNote() async {
    if (_selectedPatient == null || _noteController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select patient and write note')),
      );
      return;
    }

    try {
      final note = _noteController.text.trim();
      await supabase.from('caretaker_notes').insert({
        'caretaker_id': widget.caretakerId,
        'patient_id': _selectedPatient,
        'note': note,
        'created_at': DateTime.now().toIso8601String(),
      });

      _noteController.clear();
      _fetchNotes(); // refresh notes
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error saving note: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text('Patient Notes'),
        backgroundColor: const Color(0xFF1976D2),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Select Patient',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            _loadingPatients
                ? const CircularProgressIndicator()
                : DropdownButtonFormField<String>(
                    value: _selectedPatient,
                    hint: const Text('Choose patient'),
                    items: _patients.map<DropdownMenuItem<String>>((
                      dynamic patient,
                    ) {
                      final mapPatient = Map<String, dynamic>.from(patient);
                      return DropdownMenuItem<String>(
                        value: mapPatient['user_id'] as String?,
                        child: Text(mapPatient['full_name'] ?? ''),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() => _selectedPatient = value);
                    },
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.person, color: Color(0xFF1976D2)),
                    ),
                  ),

            const SizedBox(height: 16),
            TextField(
              controller: _noteController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Write Note',
                alignLabelWithHint: true,
                prefixIcon: Icon(Icons.note_add, color: Color(0xFF1976D2)),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1976D2),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                onPressed: _saveNote,
                child: const Text('Save Note'),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Patient Notes',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _loadingNotes
                ? const Center(child: CircularProgressIndicator())
                : Expanded(
                    child: _notes.isEmpty
                        ? const Center(
                            child: Text(
                              'No notes available',
                              style: TextStyle(color: Colors.grey),
                            ),
                          )
                        : ListView.builder(
                            itemCount: _notes.length,
                            itemBuilder: (context, index) {
                              final note = _notes[index];
                              final patientName =
                                  note['patients']['full_name'] ?? 'Unknown';
                              final date = note['created_at'].toString().split(
                                ' ',
                              )[0];
                              return Card(
                                elevation: 2,
                                margin: const EdgeInsets.only(bottom: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: ListTile(
                                  leading: const Icon(
                                    Icons.note,
                                    color: Color(0xFF1976D2),
                                  ),
                                  title: Text(note['note'] ?? ''),
                                  subtitle: Text('$patientName • $date'),
                                ),
                              );
                            },
                          ),
                  ),
          ],
        ),
      ),
    );
  }
}
