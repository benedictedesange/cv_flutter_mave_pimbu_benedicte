class FamilyMember {
  final int id;
  final String name;
  final String postName;
  final String firstName;
  final String birthPlace;
  final String birthDate;
  final String relation;
  final String? imageUrl;

  FamilyMember({
    required this.id,
    required this.name,
    required this.postName,
    required this.firstName,
    required this.birthPlace,
    required this.birthDate,
    required this.relation,
    this.imageUrl,
  });

  String get fullName => '$name $postName $firstName'.trim();

  factory FamilyMember.fromJson(Map<String, dynamic> json) {
    return FamilyMember(
      id: json['id'] is int
          ? json['id'] as int
          : int.parse(json['id'].toString()),
      name: json['nom']?.toString() ?? '',
      postName: json['postnom']?.toString() ?? '',
      firstName: json['prenom']?.toString() ?? '',
      birthPlace: json['lieu_naissance']?.toString() ?? '',
      birthDate: json['date_naissance']?.toString() ?? '',
      relation: json['parente']?.toString() ?? '',
      imageUrl: json['image_url']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
        'nom': name,
        'postnom': postName,
        'prenom': firstName,
        'lieu_naissance': birthPlace,
        'date_naissance': birthDate,
        'parente': relation,
      };
}
