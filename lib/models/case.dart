class Case {
  final int? caseID;
  final String caseNumber;
  final String caseTitle;
  final int? courtID;
  final String? courtName;
  final int? prosecutorID;
  final String? prosecutorName;
  final String? caseType;
  final DateTime? registerDate;
  final String? caseStatus;
  final String? description;

  Case({
    this.caseID,
    required this.caseNumber,
    required this.caseTitle,
    this.courtID,
    this.courtName,
    this.prosecutorID,
    this.prosecutorName,
    this.caseType,
    this.registerDate,
    this.caseStatus,
    this.description,
  });

  factory Case.fromMap(Map<String, dynamic> map) {
    return Case(
      caseID: map['caseID'] ?? map['CaseID'],
      caseNumber: map['caseNumber'] ?? map['CaseNumber'] ?? '',
      caseTitle: map['caseTitle'] ?? map['CaseTitle'] ?? '',
      courtID: map['courtID'] ?? map['CourtID'],
      courtName: map['courtName'] ?? map['CourtName'],
      prosecutorID: map['prosecutorID'] ?? map['ProsecutorID'],
      prosecutorName: map['prosecutorName'] ?? map['ProsecutorName'],
      caseType: map['caseType'] ?? map['CaseType'],
      registerDate: map['registerDate'] != null
          ? DateTime.parse(map['registerDate'])
          : (map['RegisterDate'] != null ? DateTime.parse(map['RegisterDate']) : null),
      caseStatus: map['caseStatus'] ?? map['CaseStatus'],
      description: map['description'] ?? map['Description'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'CaseID': caseID,
      'CaseNumber': caseNumber,
      'CaseTitle': caseTitle,
      'CourtID': courtID,
      'ProsecutorID': prosecutorID,
      'CaseType': caseType,
      'RegisterDate': registerDate?.toIso8601String(),
      'CaseStatus': caseStatus,
      'Description': description,
    };
  }
}
