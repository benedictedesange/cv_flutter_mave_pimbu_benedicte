import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import '../widgets/app_avatar.dart';

/// Écran des coordonnées professionnelles de MAVE PIMBU BENEDICTE.
/// Permet de déclencher directement un appel téléphonique, d'envoyer un email,
/// d'ouvrir une discussion WhatsApp ou de consulter ses profils LinkedIn & GitHub.
class ContactScreen extends StatelessWidget {
  const ContactScreen({super.key});

  final String _email = 'issambadesange1@gmail.com';
  final String _phone = '0823791714';
  final String _phoneInternational = '+243823791714';
  final String _linkedin = 'https://www.linkedin.com/in/mave-pimbu-benedicte';
  final String _github = 'https://github.com/mave-pimbu-benedicte';
  final String _whatsapp = 'https://wa.me/243823791714';

  /// Lance l'application Téléphone par défaut
  Future<void> _makePhoneCall(BuildContext context, String phoneNumber) async {
    final Uri launchUri = Uri(scheme: 'tel', path: phoneNumber);
    try {
      final launched = await launchUrl(launchUri, mode: LaunchMode.externalApplication);
      if (!launched && context.mounted) {
        _handleLaunchError(context, 'Impossible de composer le numéro', phoneNumber);
      }
    } catch (_) {
      if (context.mounted) {
        _handleLaunchError(context, 'Erreur lors de l\'ouverture de l\'application d\'appel', phoneNumber);
      }
    }
  }

  /// Ouvre le client de messagerie pré-rempli
  Future<void> _sendEmail(BuildContext context, String email) async {
    final Uri launchUri = Uri(
      scheme: 'mailto',
      path: email,
      queryParameters: {
        'subject': 'Prise de contact - MAVE PIMBU BENEDICTE (CV Mobile)',
        'body': 'Bonjour Bénédicte,\n\nJe vous contacte suite à la consultation de votre application mobile.',
      },
    );
    try {
      final launched = await launchUrl(launchUri, mode: LaunchMode.externalApplication);
      if (!launched && context.mounted) {
        _handleLaunchError(context, 'Impossible d\'ouvrir l\'application email', email);
      }
    } catch (_) {
      if (context.mounted) {
        _handleLaunchError(context, 'Aucun client de messagerie configuré', email);
      }
    }
  }

  /// Ouvre un lien web (LinkedIn, GitHub, WhatsApp)
  Future<void> _openWebUrl(BuildContext context, String urlString) async {
    final Uri uri = Uri.parse(urlString);
    try {
      final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
      if (!launched && context.mounted) {
        _handleLaunchError(context, 'Impossible d\'ouvrir le lien web', urlString);
      }
    } catch (_) {
      if (context.mounted) {
        _handleLaunchError(context, 'Erreur lors de l\'accès au navigateur', urlString);
      }
    }
  }

  /// Gestionnaire d'erreur convivial avec copie automatique dans le presse-papiers
  void _handleLaunchError(BuildContext context, String message, String copyValue) {
    Clipboard.setData(ClipboardData(text: copyValue));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$message. La valeur ($copyValue) a été copiée.'),
        backgroundColor: Colors.teal.shade800,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  /// Copie manuelle avec confirmation
  void _copyToClipboard(BuildContext context, String text, String label) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$label copié dans le presse-papiers !'),
        backgroundColor: Colors.teal.shade800,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FA),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            // Bannière d'en-tête
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 28),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.teal.shade900, Colors.teal.shade700],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(32),
                  bottomRight: Radius.circular(32),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.teal.shade900.withValues(alpha: 0.2),
                    blurRadius: 14,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: const Column(
                children: [
                  AppAvatar(
                    assetPath: 'assets/images/profile.jpg',
                    name: 'MAVE PIMBU BENEDICTE',
                    radius: 40,
                    borderColor: Colors.white,
                    borderWidth: 3,
                  ),
                  SizedBox(height: 12),
                  Text(
                    'Entrons en Contact',
                    style: TextStyle(
                      fontSize: 21,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'À l\'écoute pour stages, collaborations et projets technologiques',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12.5,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),

            // Cartes de contacts
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4, vertical: 6),
                    child: Text(
                      'Touchez une carte pour interagir directement :',
                      style: TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF64748B),
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),

                  // 1. E-mail
                  _buildInteractiveCard(
                    context: context,
                    icon: Icons.alternate_email_rounded,
                    iconColor: const Color(0xFFDC2626),
                    iconBgColor: const Color(0xFFFEE2E2),
                    title: 'Adresse E-mail',
                    subtitle: _email,
                    actionText: 'Envoyer un e-mail',
                    actionIcon: Icons.send_rounded,
                    onTap: () => _sendEmail(context, _email),
                    onCopy: () => _copyToClipboard(context, _email, 'E-mail'),
                  ),

                  const SizedBox(height: 12),

                  // 2. Appel téléphonique
                  _buildInteractiveCard(
                    context: context,
                    icon: Icons.phone_forwarded_rounded,
                    iconColor: const Color(0xFF16A34A),
                    iconBgColor: const Color(0xFFDCFCE7),
                    title: 'Numéro de Téléphone',
                    subtitle: '$_phone (ou $_phoneInternational)',
                    actionText: 'Lancer l\'appel direct',
                    actionIcon: Icons.call_rounded,
                    onTap: () => _makePhoneCall(context, _phone),
                    onCopy: () => _copyToClipboard(context, _phone, 'Numéro'),
                  ),

                  const SizedBox(height: 12),

                  // 3. WhatsApp
                  _buildInteractiveCard(
                    context: context,
                    icon: Icons.chat_rounded,
                    iconColor: const Color(0xFF15803D),
                    iconBgColor: const Color(0xFFD1FAE5),
                    title: 'WhatsApp',
                    subtitle: 'Message direct au $_phone',
                    actionText: 'Discuter sur WhatsApp',
                    actionIcon: Icons.open_in_new_rounded,
                    onTap: () => _openWebUrl(context, _whatsapp),
                    onCopy: () => _copyToClipboard(context, _phone, 'WhatsApp'),
                  ),

                  const SizedBox(height: 12),

                  // 4. LinkedIn
                  _buildInteractiveCard(
                    context: context,
                    icon: Icons.business_center_rounded,
                    iconColor: const Color(0xFF0284C7),
                    iconBgColor: const Color(0xFFE0F2FE),
                    title: 'Profil LinkedIn',
                    subtitle: 'MAVE PIMBU BENEDICTE',
                    actionText: 'Consulter le profil professionnel',
                    actionIcon: Icons.open_in_new_rounded,
                    onTap: () => _openWebUrl(context, _linkedin),
                    onCopy: () => _copyToClipboard(context, _linkedin, 'Lien LinkedIn'),
                  ),

                  const SizedBox(height: 12),

                  // 5. GitHub
                  _buildInteractiveCard(
                    context: context,
                    icon: Icons.code_rounded,
                    iconColor: const Color(0xFF0F172A),
                    iconBgColor: const Color(0xFFF1F5F9),
                    title: 'Dépôts GitHub',
                    subtitle: 'Projets Flutter, Web & Réseaux',
                    actionText: 'Explorer mes repositories',
                    actionIcon: Icons.open_in_new_rounded,
                    onTap: () => _openWebUrl(context, _github),
                    onCopy: () => _copyToClipboard(context, _github, 'Lien GitHub'),
                  ),

                  const SizedBox(height: 18),

                  // Encart Localisation
                  Container(
                    padding: const EdgeInsets.all(16),
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
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.teal.shade50,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            Icons.location_on_rounded,
                            color: Colors.teal.shade800,
                            size: 26,
                          ),
                        ),
                        const SizedBox(width: 14),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Localisation',
                                style: TextStyle(
                                  fontSize: 14.5,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF0F172A),
                                ),
                              ),
                              SizedBox(height: 2),
                              Text(
                                'Kinshasa, République Démocratique du Congo',
                                style: TextStyle(
                                  fontSize: 12.5,
                                  color: Color(0xFF64748B),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
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

  Widget _buildInteractiveCard({
    required BuildContext context,
    required IconData icon,
    required Color iconColor,
    required Color iconBgColor,
    required String title,
    required String subtitle,
    required String actionText,
    required IconData actionIcon,
    required VoidCallback onTap,
    required VoidCallback onCopy,
  }) {
    return Container(
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
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: iconBgColor,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(icon, color: iconColor, size: 24),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 14.5,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0F172A),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: const TextStyle(
                          fontSize: 12.5,
                          color: Color(0xFF475569),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Text(
                            actionText,
                            style: TextStyle(
                              fontSize: 11.5,
                              fontWeight: FontWeight.w600,
                              color: Colors.teal.shade800,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Icon(actionIcon, size: 13, color: Colors.teal.shade800),
                        ],
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.copy_rounded, size: 18),
                  color: Colors.grey.shade500,
                  tooltip: 'Copier',
                  onPressed: onCopy,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
