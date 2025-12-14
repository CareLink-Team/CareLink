import 'package:flutter/material.dart';

class CaretakerNotes extends StatefulWidget {
  const CaretakerNotes({super.key});

  @override
  State<CaretakerNotes> createState() => _CaretakerNotesState();
}

class _CaretakerNotesState extends State<CaretakerNotes> {
  final TextEditingController _noteController = TextEditingController();

  // Dummy patient list
  final List<String> _patients = [
    'Ali Raza',
    'Sarah Ahmed',
    'Ayesha Khan',
    'Usman Malik',
  ];

  String? _selectedPatient;

  final List<Map<String, String>> _notes = [
    {
      'patient': 'Ali Raza',
      'note': 'Patient recovering well.',
      'date': '2025-12-10'
    },
  ];

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

            // 🔹 Select Patient
            const Text(
              'Select Patient',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            DropdownButtonFormField<String>(
              value: _selectedPatient,
              hint: const Text('Choose patient'),
              items: _patients.map((patient) {
                return DropdownMenuItem(
                  value: patient,
                  child: Text(patient),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedPatient = value;
                });
              },
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person, color: Color(0xFF1976D2)),
              ),
            ),

            const SizedBox(height: 16),

            // 🔹 Add Note
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
                onPressed: () {
                  if (_selectedPatient == null ||
                      _noteController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please select patient and write note'),
                      ),
                    );
                    return;
                  }

                  setState(() {
                    _notes.add({
                      'patient': _selectedPatient!,
                      'note': _noteController.text,
                      'date':
                          DateTime.now().toString().split(' ')[0],
                    });
                    _noteController.clear();
                  });
                },
                child: const Text('Save Note'),
              ),
            ),

            const SizedBox(height: 24),

            // 🔹 Notes List
            const Text(
              'Patient Notes',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            Expanded(
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
                            title: Text(note['note']!),
                            subtitle: Text(
                              '${note['patient']} • ${note['date']}',
                            ),
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
