class EmployeeCheckIn {
  DateTime checkInTime;
  late DateTime _checkOutTime;
  final int employeeId;

  EmployeeCheckIn({required this.employeeId, required this.checkInTime});

  void checkOutTime(DateTime dateTime) {
    _checkOutTime = dateTime;
  }
}
