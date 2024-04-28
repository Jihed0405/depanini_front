class ServiceProvider {
    final int id;
  final String firstName;
  final String lastName;
  final String? address;
  late double distance;
  late int stars;
  final String email;
  final String phoneNumber;
  final String bio;
  final String photoUrl;
  late String commentary;
  final int numberOfExperiences;

  ServiceProvider({
      required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phoneNumber,
    required this.bio,
    required this.photoUrl,
    required this.address,
   
    required this.numberOfExperiences,
    
  }){
  
    distance = 2.5; 
commentary= '';
    stars=1;
  }
  factory ServiceProvider.fromJson(Map<String, dynamic> json) {
    return ServiceProvider(
      id: json['id'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      address: json['address'],
      email: json['email'],
      phoneNumber: json['phoneNumber'],
      bio: json['bio'],
      photoUrl: json['photoUrl'],
      numberOfExperiences: json['numberOfExperiences'],
    );
  }
}