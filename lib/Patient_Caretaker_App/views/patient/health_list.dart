import 'package:flutter/material.dart';

class HealthList extends StatelessWidget {
  const HealthList({super.key});

  // Sample Data (replace with backend data later)
  final List<Map<String, dynamic>> _records = const [
    {
      'date': '2025-12-01',
      'bloodPressure': '120 / 80',
      'heartRate': 75,
      'temperature': 36.7,
      'symptoms': ['Fever', 'Cough'],
    },
    {
      'date': '2025-12-05',
      'bloodPressure': '130 / 85',
      'heartRate': 80,
      'temperature': 37.2,
      'symptoms': ['Fatigue'],
    },
    {
      'date': '2025-12-10',
      'bloodPressure': '118 / 78',
      'heartRate': 72,
      'temperature': 36.5,
      'symptoms': [],
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Health Records')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: _records.isEmpty
            ? const Center(
                child: Text(
                  'No health records found.',
                  style: TextStyle(color: Colors.grey),
                ),
              )
            : ListView.builder(
                itemCount: _records.length,
                itemBuilder: (context, index) {
                  final record = _records[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 16),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Date: ${record['date']}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Blood Pressure'),
                                  Text(
                                    record['bloodPressure'],
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Heart Rate'),
                                  Text(
                                    '${record['heartRate']} bpm',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Temperature'),
                                  Text(
                                    '${record['temperature']} °C',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Symptoms'),
                                  Text(
                                    (record['symptoms'] as List<dynamic>?)
                                            ?.map((e) => e.toString())
                                            .join(', ') ??
                                        '',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
