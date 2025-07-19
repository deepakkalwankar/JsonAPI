class User {
  final int id;
  final String name;
  final String email;
  final String phone;
  final String website;
  final String street;
  final String suite;
  final String city;
  final String zipcode;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.website,
    required this.street,
    required this.suite,
    required this.city,
    required this.zipcode,
  });

  factory User.fromJson(Map<String, dynamic> json) {
  final addr = json['address'] ?? {};
  return User(
    id: json['id'] ?? 0,
    name: json['name'] ?? '',
    email: json['email'] ?? '',
    phone: json['phone'] ?? '',
    website: json['website'] ?? '',
    street: addr['street'] ?? '',
    suite: addr['suite'] ?? '',
    city: addr['city'] ?? '',
    zipcode: addr['zipcode'] ?? '',
  );
}


  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'email': email,
    'phone': phone,
    'website': website,
    'address': {
      'street': street,
      'suite': suite,
      'city': city,
      'zipcode': zipcode,
    },
  };
}
