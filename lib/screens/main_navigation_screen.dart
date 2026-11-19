import 'package:flutter/material.dart';
import 'cv_screen.dart';
import 'family_screen.dart';
import 'contact_screen.dart';
import 'login_screen.dart';
import '../widgets/app_avatar.dart';

/// Écran principal gérant la navigation fluide entre les différentes sections :
/// - Mon CV (Accueil)
/// - Ma Famille
/// - Mes Coordonnées
/// L'utilisateur peut naviguer soit via la BottomNavigationBar, soit via le Drawer latéral.
class MainNavigationScreen extends StatefulWidget {
  final int initialIndex;
  const MainNavigationScreen({super.key, this.initialIndex = 0});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  late int _currentIndex;

  final List<Widget> _pages = const [
    CvScreen(),
    FamilyScreen(),
    ContactScreen(),
  ];

  final List<String> _titles = const [
    'Curriculum Vitae',
    'Ma Famille',
    'Mes Coordonnées',
  ];

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  void _onTabSelected(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.logout_rounded, color: Colors.red),
            SizedBox(width: 10),
            Text('Déconnexion'),
          ],
        ),
        content: const Text(
          'Voulez-vous vraiment vous déconnecter et retourner à la page de connexion ?',
          style: TextStyle(fontSize: 14, color: Color(0xFF334155)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade700,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text('Se déconnecter'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _titles[_currentIndex],
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
        backgroundColor: Colors.teal.shade800,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_rounded),
            tooltip: 'Se déconnecter',
            onPressed: _showLogoutDialog,
          ),
        ],
      ),

      // Tiroir de navigation latéral (Drawer)
      drawer: Drawer(
        child: Column(
          children: [
            // En-tête personnalisé avec la photo réelle de Bénédicte
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(20, 48, 20, 24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.teal.shade900, Colors.teal.shade700],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppAvatar(
                    assetPath: 'assets/images/profile.jpg',
                    name: 'MAVE PIMBU BENEDICTE',
                    radius: 36,
                    borderColor: Colors.white,
                    borderWidth: 2.5,
                  ),
                  SizedBox(height: 12),
                  Text(
                    'MAVE PIMBU BENEDICTE',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    'issambadesange1@gmail.com',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 12.5,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Licence Réseau Système & Télécoms',
                    style: TextStyle(
                      color: Colors.white60,
                      fontSize: 11.5,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),

            // Liens du menu
            const SizedBox(height: 10),
            _buildDrawerTile(
              index: 0,
              icon: Icons.badge_outlined,
              selectedIcon: Icons.badge_rounded,
              title: 'Mon CV (Accueil)',
            ),
            _buildDrawerTile(
              index: 1,
              icon: Icons.diversity_1_outlined,
              selectedIcon: Icons.diversity_1_rounded,
              title: 'Ma Famille',
            ),
            _buildDrawerTile(
              index: 2,
              icon: Icons.contact_mail_outlined,
              selectedIcon: Icons.contact_mail_rounded,
              title: 'Mes Coordonnées',
            ),

            const Divider(height: 24),
            const Spacer(),

            // Bouton de déconnexion dans le Drawer
            ListTile(
              leading: const Icon(Icons.logout_rounded, color: Colors.red),
              title: const Text(
                'Déconnexion',
                style: TextStyle(color: Colors.red, fontWeight: FontWeight.w600),
              ),
              onTap: () {
                Navigator.pop(context);
                _showLogoutDialog();
              },
            ),
            const SizedBox(height: 14),
          ],
        ),
      ),

      // Corps de l'application conservant l'état de chaque onglet
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),

      // Barre de navigation inférieure moderne (Material 3)
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: _onTabSelected,
        indicatorColor: Colors.teal.shade100,
        backgroundColor: Colors.white,
        elevation: 8,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.badge_outlined),
            selectedIcon: Icon(Icons.badge_rounded, color: Colors.teal),
            label: 'CV & Accueil',
          ),
          NavigationDestination(
            icon: Icon(Icons.diversity_1_outlined),
            selectedIcon: Icon(Icons.diversity_1_rounded, color: Colors.teal),
            label: 'Famille',
          ),
          NavigationDestination(
            icon: Icon(Icons.contact_phone_outlined),
            selectedIcon: Icon(Icons.contact_phone_rounded, color: Colors.teal),
            label: 'Contact',
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerTile({
    required int index,
    required IconData icon,
    required IconData selectedIcon,
    required String title,
  }) {
    final isSelected = _currentIndex == index;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
      child: ListTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        leading: Icon(
          isSelected ? selectedIcon : icon,
          color: isSelected ? Colors.teal.shade800 : Colors.grey.shade700,
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            color: isSelected ? Colors.teal.shade900 : Colors.black87,
          ),
        ),
        selected: isSelected,
        selectedTileColor: Colors.teal.shade50,
        onTap: () {
          _onTabSelected(index);
          Navigator.pop(context); // Fermer le drawer
        },
      ),
    );
  }
}
