class User {
  final int id;
  final String firstName;
  final String lastName;
  final String email;
  final String phoneNumber;
  final String address;
  final String photoUrl;

  User(
      {required this.id,
      required this.firstName,
      required this.lastName,
      required this.email,
      required this.phoneNumber,
      required this.address,
      required this.photoUrl}) {
    
  }
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        id: json['id'],
        firstName: json['firstName'],
        lastName: json['lastName'],
        email: json['email'],
        phoneNumber: json['phoneNumber'],
        address: json['address'],
        photoUrl:json['photoUrl']
        );
        
  }
}
