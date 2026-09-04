class Court {
  final int? courtID;
  final String courtName;
  final String? courtType;
  final String? address;
  final String? phone;

  Court({
    this.courtID,
    required this.courtName,
    this.courtType,
    this.address,
    this.phone,
  });

  factory Court.fromMap(Map<String, dynamic> map) {
    return Court(
      courtID: map['courtID'] ?? map['CourtID'],
      courtName: map['courtName'] ?? map['CourtName'] ?? '',
      courtType: map['courtType'] ?? map['CourtType'],
      address: map['address'] ?? map['Address'],
      phone: map['phone'] ?? map['Phone'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'CourtID': courtID,
      'CourtName': courtName,
      'CourtType': courtType,
      'Address': address,
      'Phone': phone,
    };
  }
}
