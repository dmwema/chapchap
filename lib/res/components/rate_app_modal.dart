import 'package:chapchap/res/app_colors.dart';
import 'package:chapchap/res/app_texts.dart';
import 'package:chapchap/utils/rate_app_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RateAppModal extends StatelessWidget {
  const RateAppModal({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      backgroundColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icône d'étoiles
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: AppColors.primaryColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.star_rounded,
                color: AppColors.primaryColor,
                size: 50,
              ),
            ),
            const SizedBox(height: 20),
            
            // Titre
            AppTexts.titleText(
              "Donnez-nous 5 étoiles",
              color: Colors.black,
            ),
            const SizedBox(height: 15),
            
            // Description
            AppTexts.descriptionText(
              "Votre avis nous aide à améliorer l'application ChapChap. Merci de prendre quelques instants pour nous noter !",
            ),
            const SizedBox(height: 25),
            
            // Étoiles visuelles
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                return Icon(
                  Icons.star_rounded,
                  color: AppColors.primaryColor,
                  size: 40,
                );
              }),
            ),
            const SizedBox(height: 30),
            
            // Boutons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Bouton "Plus tard"
                Expanded(
                  child: CupertinoButton(
                    onPressed: () {
                      RateAppService.setRatePromptShown();
                      Navigator.of(context).pop();
                    },
                    color: Colors.grey[200],
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: AppTexts.buttonText(
                      "Plus tard",
                      color: Colors.black87,
                    ),
                  ),
                ),
                const SizedBox(width: 15),
                
                // Bouton "Noter"
                Expanded(
                  child: CupertinoButton(
                    onPressed: () async {
                      Navigator.of(context).pop();
                      // Utiliser openStoreListing() pour les boutons (recommandé par la doc)
                      // car requestReview() ne fonctionne pas de manière fiable via un bouton (quota)
                      await RateAppService.openStoreListing();
                    },
                    color: AppColors.primaryColor,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: AppTexts.buttonText(
                      "Noter",
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
