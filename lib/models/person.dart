class Person {
  final int? personID;
  final String fullName;
  final String nationalCode;
  final String? phone;
  final String? address;
  final String? personType;

  Person({
    this.personID,
    required this.fullName,
    required this.nationalCode,
    this.phone,
    this.address,
    this.personType,
  });

  factory Person.fromMap(Map<String, dynamic> map) {
    return Person(
      personID: map['personID'] ?? map['PersonID'],
      fullName: map['fullName'] ?? map['FullName'] ?? '',
      nationalCode: map['nationalCode'] ?? map['NationalCode'] ?? '',
      phone: map['phone'] ?? map['Phone'],
      address: map['address'] ?? map['Address'],
      personType: map['personType'] ?? map['PersonType'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'PersonID': personID,
      'FullName': fullName,
      'NationalCode': nationalCode,
      'Phone': phone,
      'Address': address,
      'PersonType': personType,
    };
  }
}
