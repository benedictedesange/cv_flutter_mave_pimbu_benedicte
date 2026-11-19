import 'package:flutter/material.dart';
import '../widgets/app_avatar.dart';

/// Page d'accueil présentant le Curriculum Vitae complet de MAVE PIMBU BENEDICTE.
/// Conçue avec une interface moderne, chaleureuse et professionnelle.
class CvScreen extends StatelessWidget {
  const CvScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FA),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            // En-tête avec bannière dégradée et photo de profil réelle
            _buildProfileHeader(context),

            // Corps du CV organisé par thématiques
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. Formation académique
                  _buildSectionCard(
                    title: 'Formation Académique',
                    icon: Icons.school_rounded,
                    accentColor: const Color(0xFF1565C0), // Bleu académique
                    child: _buildEducationContent(),
                  ),

                  const SizedBox(height: 16),

                  // 2. Expériences & Projets réalisés
                  _buildSectionCard(
                    title: 'Expériences & Projets',
                    icon: Icons.workspace_premium_rounded,
                    accentColor: Colors.teal.shade700,
                    child: _buildExperiencesContent(),
                  ),

                  const SizedBox(height: 16),

                  // 3. Compétences techniques
                  _buildSectionCard(
                    title: 'Compétences Techniques',
                    icon: Icons.terminal_rounded,
                    accentColor: const Color(0xFF5E35B1), // Violet tech
                    child: _buildSkillsContent(),
                  ),

                  const SizedBox(height: 16),

                  // 4. Compétences linguistiques
                  _buildSectionCard(
                    title: 'Compétences Linguistiques',
                    icon: Icons.translate_rounded,
                    accentColor: const Color(0xFFD84315), // Orange chaleureux
                    child: _buildLanguagesContent(),
                  ),

                  const SizedBox(height: 16),

                  // 5. Centres d'intérêt
                  _buildSectionCard(
                    title: 'Centres d\'Intérêt & Loisirs',
                    icon: Icons.auto_awesome_rounded,
                    accentColor: const Color(0xFFC2185B), // Rose passion
                    child: _buildInterestsContent(),
                  ),

                  const SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Bannière d'en-tête présentant la photo réelle, le nom et le titre
  Widget _buildProfileHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.teal.shade900,
            Colors.teal.shade700,
            Colors.teal.shade600,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.teal.shade900.withValues(alpha: 0.25),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
      child: Column(
        children: [
          // Photo de profil réelle de Bénédicte
          const AppAvatar(
            assetPath: 'assets/images/profile.jpg',
            name: 'MAVE PIMBU BENEDICTE',
            radius: 64,
            borderColor: Colors.white,
            borderWidth: 4,
          ),
          const SizedBox(height: 16),

          // Nom complet
          const Text(
            'MAVE PIMBU BENEDICTE',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: 1.1,
            ),
          ),
          const SizedBox(height: 8),

          // Badge profil : Étudiante
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.18),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white.withValues(alpha: 0.35)),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.school, size: 16, color: Colors.white),
                SizedBox(width: 8),
                Text(
                  'ÉTUDIANTE',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    letterSpacing: 1.6,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Carte générique pour structurer chaque section du CV
  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    required Color accentColor,
    required Widget child,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: accentColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: accentColor, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16.5,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E293B),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }

  /// Bloc Formation
  Widget _buildEducationContent() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: const Color(0xFFE3F2FD),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(
            Icons.school_outlined,
            color: Color(0xFF1565C0),
            size: 24,
          ),
        ),
        const SizedBox(width: 14),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'LICENCE EN RÉSEAU SYSTÈME ET TÉLÉCOMMUNICATION',
                style: TextStyle(
                  fontSize: 14.5,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0F172A),
                ),
              ),
              SizedBox(height: 4),
              Text(
                'Formation supérieure approfondie • Architecture réseaux, télécommunications, protocoles et administration système.',
                style: TextStyle(
                  fontSize: 13,
                  color: Color(0xFF475569),
                  height: 1.35,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Bloc Expériences et Projets
  Widget _buildExperiencesContent() {
    return Column(
      children: [
        _buildExperienceTile(
          icon: Icons.business_center_rounded,
          iconColor: Colors.teal.shade700,
          title: 'Stage chez Global Technology',
          subtitle: 'Immersion professionnelle en Télécoms & Systèmes',
          description:
              'Participation active à la maintenance des infrastructures réseaux, au diagnostic technique et au suivi des équipements télécoms.',
          tag: 'Stage',
          tagColor: Colors.teal,
        ),
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 12),
          child: Divider(height: 1, color: Color(0xFFE2E8F0)),
        ),
        _buildExperienceTile(
          icon: Icons.local_hospital_rounded,
          iconColor: const Color(0xFF4338CA),
          title: 'Application de Gestion d\'un Hôpital',
          subtitle: 'Projet de conception & développement logiciel',
          description:
              'Développement d\'une solution facilitant la gestion des patients, le suivi des rendez-vous médicaux et la centralisation des dossiers hospitaliers.',
          tag: 'Projet',
          tagColor: const Color(0xFF4338CA),
        ),
      ],
    );
  }

  Widget _buildExperienceTile({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required String description,
    required String tag,
    required Color tagColor,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: iconColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: iconColor, size: 22),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: const TextStyle(
                        fontSize: 14.5,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: tagColor.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      tag,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: tagColor,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w600,
                  color: tagColor,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: const TextStyle(
                  fontSize: 12.5,
                  color: Color(0xFF475569),
                  height: 1.35,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Bloc Compétences Techniques avec badges visuels
  Widget _buildSkillsContent() {
    final skills = [
      {'name': 'Développeur FLUTTER', 'icon': Icons.flutter_dash, 'color': Colors.teal},
      {'name': 'Développement Web', 'icon': Icons.language_rounded, 'color': Colors.blue},
      {'name': 'Réseaux & Protocoles', 'icon': Icons.hub_rounded, 'color': Colors.indigo},
      {'name': 'Systèmes Télécoms', 'icon': Icons.cell_tower_rounded, 'color': Colors.deepOrange},
      {'name': 'Dart & Algorithmique', 'icon': Icons.code_rounded, 'color': Colors.purple},
    ];

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: skills.map((skill) {
        final color = skill['color'] as Color;
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: color.withValues(alpha: 0.3)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(skill['icon'] as IconData, size: 16, color: color),
              const SizedBox(width: 8),
              Text(
                skill['name'] as String,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  /// Bloc Langues
  Widget _buildLanguagesContent() {
    return Column(
      children: [
        _buildLanguageProgress(
          language: 'Français',
          description: 'Langue officielle & d\'enseignement',
          percentage: 0.95,
        ),
        const SizedBox(height: 12),
        _buildLanguageProgress(
          language: 'Lingala',
          description: 'Langue nationale & courante',
          percentage: 0.90,
        ),
        const SizedBox(height: 12),
        _buildLanguageProgress(
          language: 'Swahili',
          description: 'Langue nationale & communication',
          percentage: 0.80,
        ),
      ],
    );
  }

  Widget _buildLanguageProgress({
    required String language,
    required String description,
    required double percentage,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              language,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: Color(0xFF0F172A),
              ),
            ),
            Text(
              description,
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFF64748B),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: LinearProgressIndicator(
            value: percentage,
            minHeight: 7,
            backgroundColor: const Color(0xFFE2E8F0),
            valueColor: AlwaysStoppedAnimation<Color>(Colors.teal.shade600),
          ),
        ),
      ],
    );
  }

  /// Bloc Centres d'intérêt
  Widget _buildInterestsContent() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildHobbyColumn(
          icon: Icons.sports_esports_rounded,
          title: 'Jeux',
          subtitle: 'Logique & Réflexion',
          color: const Color(0xFF4F46E5),
        ),
        _buildHobbyColumn(
          icon: Icons.manage_search_rounded,
          title: 'Les Recherches',
          subtitle: 'Veille & Nouvelles Tech',
          color: Colors.teal.shade700,
        ),
        _buildHobbyColumn(
          icon: Icons.auto_stories_rounded,
          title: 'Lire',
          subtitle: 'Livres & Ouvrages',
          color: const Color(0xFFC026D3),
        ),
      ],
    );
  }

  Widget _buildHobbyColumn({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
  }) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 26),
        ),
        const SizedBox(height: 8),
        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 13.5,
            color: Color(0xFF0F172A),
          ),
        ),
        Text(
          subtitle,
          style: const TextStyle(
            fontSize: 11,
            color: Color(0xFF64748B),
          ),
        ),
      ],
    );
  }
}
