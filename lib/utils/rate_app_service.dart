import 'package:shared_preferences/shared_preferences.dart';
import 'package:in_app_review/in_app_review.dart';

class RateAppService {
  static const String _keyHasRated = 'has_rated_app';
  static const String _keyRatePromptShown = 'rate_prompt_shown';
  
  // ID iOS de l'application pour l'App Store
  static const String _iosAppId = '1594008625'; // À remplacer par l'ID réel de l'App Store (trouvable dans App Store Connect)
  
  static final InAppReview _inAppReview = InAppReview.instance;

  /// Vérifie si l'utilisateur a déjà noté l'application
  static Future<bool> hasRatedApp() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyHasRated) ?? false;
  }

  /// Marque que l'utilisateur a noté l'application
  static Future<void> setHasRatedApp() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyHasRated, true);
  }

  /// Vérifie si le prompt de notation a déjà été affiché
  static Future<bool> hasShownRatePrompt() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyRatePromptShown) ?? false;
  }

  /// Marque que le prompt a été affiché
  static Future<void> setRatePromptShown() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyRatePromptShown, true);
  }

  /// Marque qu'un transfert vient d'être effectué
  static Future<void> markTransferCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('transfer_completed', true);
  }

  /// Vérifie si on doit afficher le prompt de notation
  static Future<bool> shouldShowRatePrompt() async {
    if (await hasRatedApp() || await hasShownRatePrompt()) {
      return false;
    }
    
    final prefs = await SharedPreferences.getInstance();
    bool transferCompleted = prefs.getBool('transfer_completed') ?? false;
    
    if (transferCompleted) {
      // Réinitialiser le flag
      await prefs.setBool('transfer_completed', false);
      // Afficher le prompt après le premier transfert
      return true;
    }
    
    return false;
  }

  /// Demande une review in-app de l'application
  /// IMPORTANT: Ne pas appeler depuis un bouton (quota strict)
  /// Utiliser après une expérience utilisateur significative (ex: après un transfert)
  static Future<void> requestReview() async {
    try {
      final isAvailable = await _inAppReview.isAvailable();
      
      if (isAvailable) {
        // Demande une review in-app (dialogue natif)
        // Note: peut ne rien faire si le quota est dépassé
        await _inAppReview.requestReview();
        // On ne marque pas comme "rated" car l'utilisateur peut fermer le dialogue
        // Seul openStoreListing() marque comme "rated" car il ouvre le store
      }
      // Si pas disponible, on ne fait rien (pas de fallback automatique)
      // Le fallback doit être géré par l'appelant (ex: afficher le modal)
    } catch (e) {
      // Erreur silencieuse - le quota peut être dépassé
      rethrow; // Propager l'erreur pour que l'appelant puisse gérer
    }
  }

  /// Ouvre le store listing
  /// À utiliser pour les boutons permanents car non restreint par quota
  /// appStoreId est requis pour iOS/MacOS (trouvable dans App Store Connect)
  static Future<void> openStoreListing() async {
    try {
      await _inAppReview.openStoreListing(
        appStoreId: _iosAppId.isEmpty ? null : _iosAppId,
      );
      // Marquer comme "rated" car l'utilisateur a été redirigé vers le store
      await setHasRatedApp();
    } catch (e) {
      // Erreur lors de l'ouverture du store listing
      rethrow;
    }
  }

  /// Réinitialise les préférences (pour les tests)
  static Future<void> reset() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyHasRated);
    await prefs.remove(_keyRatePromptShown);
    await prefs.remove('transfer_completed');
  }
}
