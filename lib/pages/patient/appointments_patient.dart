import 'package:flutter/material.dart';

class AppointmentsPatientPage extends StatefulWidget {
  const AppointmentsPatientPage({Key? key}) : super(key: key);

  @override
  State<AppointmentsPatientPage> createState() => _AppointmentsPatientPageState();
}

class _AppointmentsPatientPageState extends State<AppointmentsPatientPage> {
  final List<Map<String, String>> _appointments = [
    {'date': '2025-10-12', 'time': '10:30 AM', 'doctor': 'Dr. Ahmed Khalid'},
    {'date': '2025-10-20', 'time': '02:00 PM', 'doctor': 'Dr. Lina Al-Majali'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: Colors.teal.shade600,
        title: const Text(
          'My Appointments',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal.shade600,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                _showAddAppointmentDialog(context);
              },
              icon:  Icon(Icons.add,color: Colors.black,),
              label:  Text(
                'Book New Appointment',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold,color: Colors.black),
              ),
            ),
             SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: _appointments.length,
                itemBuilder: (context, index) {
                  final appt = _appointments[index];
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 3,
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.teal.shade100,
                        child: Icon(Icons.calendar_today, color: Colors.teal.shade700),
                      ),
                      title: Text(
                        appt['doctor']!,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text('${appt['date']} • ${appt['time']}'),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                        onPressed: () {
                          setState(() {
                            _appointments.removeAt(index);
                          });
                        },
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

  void _showAddAppointmentDialog(BuildContext context) {
    final TextEditingController _doctor = TextEditingController();
    final TextEditingController _date = TextEditingController();
    final TextEditingController _time = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title:  Text('New Appointment'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _doctor,
              decoration:  InputDecoration(
                labelText: 'Doctor Name',
                prefixIcon: Icon(Icons.person_outline),
              ),
            ),
            TextField(
              controller: _date,
              decoration:  InputDecoration(
                labelText: 'Date (YYYY-MM-DD)',
                prefixIcon: Icon(Icons.date_range_outlined),
              ),
            ),
            TextField(
              controller: _time,
              decoration: const InputDecoration(
                labelText: 'Time (e.g. 10:30 AM)',
                prefixIcon: Icon(Icons.access_time),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.teal.shade600,
            ),
            onPressed: () {
              if (_doctor.text.isNotEmpty && _date.text.isNotEmpty && _time.text.isNotEmpty) {
                setState(() {
                  _appointments.add({
                    'doctor': _doctor.text,
                    'date': _date.text,
                    'time': _time.text,
                  });
                });
                Navigator.pop(context);
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}
