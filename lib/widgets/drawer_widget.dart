import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class DrawerWidget extends StatelessWidget {
  const DrawerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: Colors.blue),
            child: Text(
              "Lifeline App",
              style: TextStyle(color: Colors.white, fontSize: 22),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.medical_information),
            title: const Text("Medicines"),
            onTap: () => Navigator.pushNamed(context, "/medicines"),
          ),
          ListTile(
            leading: const Icon(Icons.event_note),
            title: const Text("Appointments"),
            onTap: () => Navigator.pushNamed(context, "/appointments"),
          ),
          ListTile(
            leading: const Icon(Icons.health_and_safety),
            title: const Text("Health Records"),
            onTap: () => Navigator.pushNamed(context, "/healthRecords"),
          ),
          ListTile(
            leading: const Icon(Icons.report),
            title: const Text("Reports"),
            onTap: () => Navigator.pushNamed(context, "/reports"),
          ),
          ListTile(
            leading: const Icon(Icons.bloodtype),
            title: const Text("Blood Requests"),
            onTap: () => Navigator.pushNamed(context, "/bloodRequests"),
          ),
          ListTile(
            leading: const Icon(Icons.emergency),
            title: const Text("Emergencies"),
            onTap: () => Navigator.pushNamed(context, "/emergencies"),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text("Logout"),
            onTap: () async {
              await AuthService.logout();
              Navigator.pushReplacementNamed(context, "/login");
            },
          ),
        ],
      ),
    );
  }
}
