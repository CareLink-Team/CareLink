import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HealthList extends StatefulWidget {
  final String patientId;

  const HealthList({super.key, required this.patientId});

  @override
  State<HealthList> createState() => _HealthListState();
}

class _HealthListState extends State<HealthList> {
  bool _loading = true;
  List<Map<String, dynamic>> _records = [];

  @override
  void initState() {
    super.initState();
    _fetchHealthRecords();
  }

  Future<void> _fetchHealthRecords() async {
    final supabase = Supabase.instance.client;

    try {
      final response = await supabase
          .from('health_data')
          .select()
          .eq('patient_id', widget.patientId)
          .order('date_time', ascending: false);

      setState(() {
        _records = List<Map<String, dynamic>>.from(response);
        _loading = false;
      });
    } catch (e) {
      setState(() => _loading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching records: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Health Records')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _records.isEmpty
              ? const Center(
                  child: Text(
                    'No health records found.',
                    style: TextStyle(color: Colors.grey),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _records.length,
                  itemBuilder: (context, index) {
                    final record = _records[index];
                    final date = DateTime.parse(record['date_time']).toLocal();
                    final bloodPressure =
                        '${record['blood_pressure_systolic']} / ${record['blood_pressure_diastolic']}';

                    final symptoms = (record['symptoms'] as String?)
                            ?.split(',')
                            .map((e) => e.trim())
                            .toList() ??
                        [];

                    return Card(
                      margin: const EdgeInsets.only(bottom: 16),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Date: ${date.toString().split(' ')[0]}',
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Blood Pressure'),
                                Text(
                                  bloodPressure,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Symptoms'),
                                Text(
                                  symptoms.join(', '),
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            if (record['remarks'] != null &&
                                record['remarks'].toString().isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Text(
                                  'Remarks: ${record['remarks']}',
                                  style: const TextStyle(
                                      fontStyle: FontStyle.italic),
                                ),
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
