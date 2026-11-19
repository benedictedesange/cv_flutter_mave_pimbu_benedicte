import 'package:flutter/material.dart';
import '../models/family_member.dart';
import '../widgets/app_avatar.dart';

/// Écran présentant avec tendresse et bienveillance les membres de la famille
/// de MAVE PIMBU BENEDICTE.
class FamilyScreen extends StatefulWidget {
  const FamilyScreen({super.key});

  @override
  State<FamilyScreen> createState() => _FamilyScreenState();
}

class _FamilyScreenState extends State<FamilyScreen> {
  // Liste des membres avec données réalistes, humaines et photos fiables
  final List<FamilyMember> _familyMembers = const [
    FamilyMember(
      name: 'Jean-Pierre Pimbu',
      relation: 'Père',
      profession: 'Ingénieur Télécoms & Réseaux',
      imageUrl: 'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?auto=format&fit=crop&w=400&q=80',
      description:
          'Pilier de la famille et passionné d\'ingénierie. C\'est lui qui m\'a transmis le goût des télécommunications, la rigueur et l\'ambition d\'excellence.',
      phone: '+243 810 000 001',
    ),
    FamilyMember(
      name: 'Marie-Claire Mave',
      relation: 'Mère',
      profession: 'Médecin Pédiatre',
      imageUrl: 'https://images.unsplash.com/photo-1544005313-94ddf0286df2?auto=format&fit=crop&w=400&q=80',
      description:
          'Un cœur plein d\'amour et de générosité. Toujours disponible pour encourager, soigner et inspirer toute la famille au quotidien.',
      phone: '+243 810 000 002',
    ),
    FamilyMember(
      name: 'David Pimbu',
      relation: 'Grand Frère',
      profession: 'Développeur Full-Stack',
      imageUrl: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?auto=format&fit=crop&w=400&q=80',
      description:
          'Le grand frère développeur et complice technique. Mon premier mentor en programmation qui m\'a encouragée à explorer Flutter et le Web.',
      phone: '+243 810 000 003',
    ),
    FamilyMember(
      name: 'Sarah Pimbu',
      relation: 'Petite Sœur',
      profession: 'Étudiante en Pharmacie',
      imageUrl: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=400&q=80',
      description:
          'Le rayon de soleil de la maison. Studieuse, pleine d\'énergie et de joie communicative, passionnée par le domaine médical.',
      phone: '+243 810 000 004',
    ),
    FamilyMember(
      name: 'Alain Mave',
      relation: 'Oncle',
      profession: 'Directeur des Ressources Humaines',
      imageUrl: 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?auto=format&fit=crop&w=400&q=80',
      description:
          'Le sage conseiller de la famille. Expert en relations professionnelles et leadership, toujours prêt à guider mes choix de carrière.',
      phone: '+243 810 000 005',
    ),
    FamilyMember(
      name: 'Esther Pimbu',
      relation: 'Tante',
      profession: 'Juriste d\'Entreprise',
      imageUrl: 'https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?auto=format&fit=crop&w=400&q=80',
      description:
          'Passionnée par le droit et la justice. Elle m\'enseigne la persévérance et le sens de l\'éthique dans le monde professionnel.',
      phone: '+243 810 000 006',
    ),
  ];

  Color _getRelationColor(String relation) {
    switch (relation.toLowerCase()) {
      case 'père':
        return const Color(0xFF1E3A8A); // Bleu profond
      case 'mère':
        return const Color(0xFFDB2777); // Rose fuchsia
      case 'grand frère':
        return const Color(0xFF0D9488); // Teal
      case 'petite sœur':
        return const Color(0xFFD97706); // Ambre chaud
      case 'oncle':
        return const Color(0xFF6D28D9); // Violet
      case 'tante':
        return const Color(0xFFBE185D); // Rubis
      default:
        return Colors.blueGrey;
    }
  }

  void _showMemberDetails(BuildContext context, FamilyMember member) {
    final relationColor = _getRelationColor(member.relation);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(28),
            topRight: Radius.circular(28),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Petite barre de drag
            Container(
              width: 44,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const SizedBox(height: 20),

            // Avatar du membre
            AppAvatar(
              imageUrl: member.imageUrl,
              name: member.name,
              radius: 46,
              borderColor: relationColor,
              borderWidth: 3,
            ),
            const SizedBox(height: 14),

            // Nom du membre
            Text(
              member.name,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0F172A),
              ),
            ),
            const SizedBox(height: 6),

            // Badge lien de parenté
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
              decoration: BoxDecoration(
                color: relationColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                member.relation,
                style: TextStyle(
                  color: relationColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ),
            const SizedBox(height: 18),

            // Profession
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.teal.shade50,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(Icons.work_outline_rounded,
                    color: Colors.teal.shade800, size: 22),
              ),
              title: const Text(
                'Profession',
                style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
              ),
              subtitle: Text(
                member.profession,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                  color: Color(0xFF0F172A),
                ),
              ),
            ),

            // Description personnelle
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFFEFF6FF),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.favorite_outline_rounded,
                    color: Color(0xFF2563EB), size: 22),
              ),
              title: const Text(
                'Rôle & Liens dans la famille',
                style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
              ),
              subtitle: Text(
                member.description,
                style: const TextStyle(
                  fontSize: 13.5,
                  height: 1.4,
                  color: Color(0xFF334155),
                ),
              ),
            ),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal.shade800,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Fermer',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FA),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // Bannière d'introduction chaleureuse
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.fromLTRB(16, 16, 16, 10),
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.teal.shade900, Colors.teal.shade700],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.teal.shade900.withValues(alpha: 0.2),
                    blurRadius: 12,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: const Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.white24,
                    radius: 26,
                    child: Icon(
                      Icons.diversity_1_rounded,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                  SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Mon Cercle Familial',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 3),
                        Text(
                          'Découvrez les personnes qui m\'inspirent, me soutiennent et partagent mon quotidien.',
                          style: TextStyle(
                            fontSize: 12.5,
                            color: Colors.white70,
                            height: 1.3,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Liste des membres
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final member = _familyMembers[index];
                  final relationColor = _getRelationColor(member.relation);

                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.04),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(16),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(16),
                        onTap: () => _showMemberDetails(context, member),
                        child: Padding(
                          padding: const EdgeInsets.all(14.0),
                          child: Row(
                            children: [
                              // Avatar fiable (avec photo internet ou initiales stylées si hors-ligne)
                              AppAvatar(
                                imageUrl: member.imageUrl,
                                name: member.name,
                                radius: 32,
                                borderColor: relationColor.withValues(alpha: 0.4),
                                borderWidth: 2.5,
                              ),
                              const SizedBox(width: 14),

                              // Informations textuelles
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      member.name,
                                      style: const TextStyle(
                                        fontSize: 15.5,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF0F172A),
                                      ),
                                    ),
                                    const SizedBox(height: 3),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: relationColor.withValues(alpha: 0.12),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Text(
                                        member.relation,
                                        style: TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold,
                                          color: relationColor,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.work_outline_rounded,
                                          size: 14,
                                          color: Colors.grey.shade600,
                                        ),
                                        const SizedBox(width: 4),
                                        Expanded(
                                          child: Text(
                                            member.profession,
                                            style: TextStyle(
                                              fontSize: 12.5,
                                              color: Colors.grey.shade700,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),

                              // Indicateur d'action
                              Icon(
                                Icons.chevron_right_rounded,
                                color: Colors.grey.shade400,
                                size: 24,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
                childCount: _familyMembers.length,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
