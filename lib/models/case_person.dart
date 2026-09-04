class CasePerson {
  final int? casePersonID;
  final int? caseID;
  final int? personID;
  final String? role;
  final DateTime? joinDate;
  final String? notes;
  final String? personName;
  final String? caseTitle;
  final String? caseNumber;

  CasePerson({
    this.casePersonID,
    this.caseID,
    this.personID,
    this.role,
    this.joinDate,
    this.notes,
    this.personName,
    this.caseTitle,
    this.caseNumber,
  });

  factory CasePerson.fromMap(Map<String, dynamic> map) {
    return CasePerson(
      casePersonID: map['casePersonID'] ?? map['CasePersonID'],
      caseID: map['caseID'] ?? map['CaseID'],
      personID: map['personID'] ?? map['PersonID'],
      role: map['role'] ?? map['Role'],
      joinDate: map['joinDate'] != null
          ? DateTime.parse(map['joinDate'])
          : (map['JoinDate'] != null ? DateTime.parse(map['JoinDate']) : null),
      notes: map['notes'] ?? map['Notes'],
      personName: map['personName'] ?? map['PersonName'],
      caseTitle: map['caseTitle'] ?? map['CaseTitle'],
      caseNumber: map['caseNumber'] ?? map['CaseNumber'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'CasePersonID': casePersonID,
      'CaseID': caseID,
      'PersonID': personID,
      'Role': role,
      'JoinDate': joinDate?.toIso8601String(),
      'Notes': notes,
    };
  }
}
