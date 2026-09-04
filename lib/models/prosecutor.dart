class Prosecutor {
  final int? prosecutorID;
  final String fullName;
  final String? nationalCode;
  final String? phone;
  final String? email;
  final String? specialty;
  final String? licenseNumber;

  Prosecutor({
    this.prosecutorID,
    required this.fullName,
    this.nationalCode,
    this.phone,
    this.email,
    this.specialty,
    this.licenseNumber,
  });

  factory Prosecutor.fromMap(Map<String, dynamic> map) {
    return Prosecutor(
      prosecutorID: map['prosecutorID'] ?? map['ProsecutorID'],
      fullName: map['fullName'] ?? map['FullName'] ?? '',
      nationalCode: map['nationalCode'] ?? map['NationalCode'],
      phone: map['phone'] ?? map['Phone'],
      email: map['email'] ?? map['Email'],
      specialty: map['specialty'] ?? map['Specialty'],
      licenseNumber: map['licenseNumber'] ?? map['LicenseNumber'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'ProsecutorID': prosecutorID,
      'FullName': fullName,
      'NationalCode': nationalCode,
      'Phone': phone,
      'Email': email,
      'Specialty': specialty,
      'LicenseNumber': licenseNumber,
    };
  }
}
