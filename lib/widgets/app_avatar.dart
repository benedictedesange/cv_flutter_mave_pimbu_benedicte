import 'package:flutter/material.dart';

/// Widget d'avatar robuste et soigné.
/// Gère le chargement en réseau, les assets locaux, ainsi qu'un affichage
/// de repli élégant (initiales sur fond dégradé) si le réseau est indisponible.
class AppAvatar extends StatelessWidget {
  final String? imageUrl;
  final String? assetPath;
  final String name;
  final double radius;
  final Color? borderColor;
  final double borderWidth;

  const AppAvatar({
    super.key,
    this.imageUrl,
    this.assetPath,
    required this.name,
    this.radius = 32,
    this.borderColor,
    this.borderWidth = 2.0,
  });

  String _getInitials(String fullName) {
    final parts = fullName.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty) return '?';
    if (parts.length == 1) {
      return parts[0].isNotEmpty ? parts[0][0].toUpperCase() : '?';
    }
    return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
  }

  LinearGradient _generateGradient(String seed) {
    final hash = seed.hashCode.abs();
    final hue1 = (hash % 360).toDouble();
    final hue2 = ((hash + 45) % 360).toDouble();

    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        HSLColor.fromAHSL(1.0, hue1, 0.65, 0.50).toColor(),
        HSLColor.fromAHSL(1.0, hue2, 0.70, 0.40).toColor(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final diameter = radius * 2;

    Widget imageContent;

    if (assetPath != null) {
      imageContent = Image.asset(
        assetPath!,
        width: diameter,
        height: diameter,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => _buildInitialsFallback(),
      );
    } else if (imageUrl != null && imageUrl!.isNotEmpty) {
      imageContent = Image.network(
        imageUrl!,
        width: diameter,
        height: diameter,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Center(
            child: SizedBox(
              width: radius * 0.8,
              height: radius * 0.8,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.teal.shade300,
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded /
                        loadingProgress.expectedTotalBytes!
                    : null,
              ),
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          // Si l'image web ne charge pas, on affiche un bel avatar avec les initiales
          return _buildInitialsFallback();
        },
      );
    } else {
      imageContent = _buildInitialsFallback();
    }

    return Container(
      width: diameter,
      height: diameter,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: borderColor != null
            ? Border.all(color: borderColor!, width: borderWidth)
            : null,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ClipOval(child: imageContent),
    );
  }

  Widget _buildInitialsFallback() {
    return Container(
      decoration: BoxDecoration(
        gradient: _generateGradient(name),
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Text(
        _getInitials(name),
        style: TextStyle(
          color: Colors.white,
          fontSize: radius * 0.75,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.0,
        ),
      ),
    );
  }
}
