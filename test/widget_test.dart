import 'package:flutter_test/flutter_test.dart';
import 'package:cv_flutter_mave_pimbu_bene/main.dart';

void main() {
  testWidgets('Page de connexion affichée au lancement', (WidgetTester tester) async {
    // Construction de l'application
    await tester.pumpWidget(const CvApp());

    // Vérification de la présence des éléments de connexion
    expect(find.text('Bienvenue'), findsOneWidget);
    expect(find.text('Identifiant'), findsOneWidget);
    expect(find.text('Mot de passe'), findsOneWidget);
    expect(find.text('Se connecter'), findsOneWidget);
  });
}
