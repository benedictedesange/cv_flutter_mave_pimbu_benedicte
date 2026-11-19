class FamilyMember {
  final String name;
  final String relation;
  final String profession;
  final String imageUrl;
  final String description;
  final String? phone;

  const FamilyMember({
    required this.name,
    required this.relation,
    required this.profession,
    required this.imageUrl,
    required this.description,
    this.phone,
  });
}
