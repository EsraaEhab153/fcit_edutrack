import 'package:fci_edutrack/screens/home_screen/profiles/doctor_profile_screen.dart';
import 'package:fci_edutrack/screens/home_screen/profiles/student_profile_screen.dart';

class RBAC {
  static final Map<String, List<String>> _permissions = {
    "admin": ["manage_users", "grade_assignments", "view_assignments"],
    "doctor": ["grade_assignments", "view_assignments"],
    "student": ["view_assignments"],
  };

  static final Map<String, String> _roleRoutes = {
    "admin": "/adminProfile",
    "doctor": DoctorProfileScreen.routeName,
    "student": StudentProfileScreen.routeName,
  };

  static bool hasPermission(String role, String permission) {
    return _permissions[role]?.contains(permission) ?? false;
  }

  static String? getProfileRoute(String role) {
    return _roleRoutes[role.toLowerCase()];
  }
}
