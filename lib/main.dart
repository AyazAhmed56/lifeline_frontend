import 'package:flutter/material.dart';

// Import all screens
import 'screens/auth/login_screen.dart';
import 'screens/auth/register_screen.dart';
import 'screens/home_screen.dart';
import 'screens/profile_screen.dart';

// Features
import './screens/blood_requests/blood_request_add_screen.dart';
import './screens/blood_requests/blood_request_detail_screen.dart';
import './screens/blood_requests/blood_requests_list_screen.dart';

import './screens/health_records/health_records_screen.dart';
import 'screens/health_records/add_health_record_screen.dart';
import 'screens/health_records/health_record_detail_screen.dart';

import 'screens/emergencies/emergency_list_screen.dart';
import 'screens/emergencies/add_emergency_screen.dart';
import './screens/emergencies/emergency_detail_screen.dart';

import './screens/medicines/add_medicine_screen.dart';
import './screens/medicines/medicine_detail_screen.dart';
import './screens/medicines/medicines_screen.dart';

import './screens/reports/add_report_screen.dart';
import './screens/reports/report_detail_screen.dart';
import './screens/reports/reports_screen.dart';

import './screens/appointments/add_appointment_screen.dart';
import './screens/appointments/appointment_detail_screen.dart';
import './screens/appointments/appointments_screen.dart';

// AI
import 'screens/ai/ai_chat_screen.dart';
import 'screens/ai/doctor_suggestion_screen.dart';
import 'screens/ai/timeline_analysis_screen.dart';

import './utils/constants.dart';

void main() {
  runApp(const LifelineApp());
}

class LifelineApp extends StatelessWidget {
  const LifelineApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Lifeline",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: ApiConstants.primaryColor,
        scaffoldBackgroundColor: Colors.grey[100],
        appBarTheme: const AppBarTheme(
          backgroundColor: ApiConstants.primaryColor,
          foregroundColor: Colors.white,
          elevation: 2,
        ),
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(),
        ),
      ),
      initialRoute: "/login",
      routes: {
        // Auth
        "/login": (context) => const LoginScreen(),
        "/register": (context) => const RegisterScreen(),
        "/home": (context) => const HomeScreen(),
        "/profile": (context) => const ProfileScreen(),

        // Blood Requests
        "/blood_requests": (context) => const BloodRequestsListScreen(),
        "/add_blood_request": (context) => const BloodRequestAddScreen(),
        "/blood_request_detail": (context) {
          final args =
              ModalRoute.of(context)!.settings.arguments
                  as Map<String, dynamic>;
          return BloodRequestDetailScreen(request: args);
        },

        // Health Records
        "/health_records": (context) => const HealthRecordsPage(),
        "/add_health_record": (context) => const AddHealthRecordPage(),
        "/health_record_detail": (context) {
          final args =
              ModalRoute.of(context)!.settings.arguments
                  as Map<String, dynamic>;
          return HealthRecordDetailPage(record: args);
        },

        // Emergencies
        "/emergencies": (context) => const EmergencyListScreen(),
        "/add_emergency": (context) => const EmergencyAddScreen(),
        "/emergency_detail": (context) {
          final args =
              ModalRoute.of(context)!.settings.arguments
                  as Map<dynamic, dynamic>;
          return EmergencyDetailScreen(emergency: args);
        },

        // Medicines
        "/medicines": (context) => const MedicinesScreen(),
        "/add_medicine": (context) => const AddMedicineScreen(),
        "/medicine_detail": (context) {
          final args =
              ModalRoute.of(context)!.settings.arguments
                  as Map<dynamic, dynamic>;
          return MedicineDetailScreen(medicine: args);
        },

        // Reports
        "/reports": (context) => ReportsScreen(),
        "/add_report": (context) => AddReportScreen(),
        "/report_detail": (context) {
          final args =
              ModalRoute.of(context)!.settings.arguments
                  as Map<dynamic, dynamic>;
          return ReportDetailScreen(report: args);
        },

        // Appointments
        "/appointments": (context) => const AppointmentsScreen(),
        "/add_appointment": (context) => const AddAppointmentScreen(),
        "/appointment_detail": (context) {
          final args =
              ModalRoute.of(context)!.settings.arguments
                  as Map<dynamic, dynamic>;
          return AppointmentDetailScreen(appointment: args);
        },

        // AI
        "/ai_chat": (context) => const AIChatScreen(),
        "/doctor_suggestion": (context) => const DoctorSuggestionScreen(),
        "/timeline_analysis": (context) => const TimelineAnalysisScreen(),
      },
    );
  }
}
