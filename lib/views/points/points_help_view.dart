
import 'package:chapchap/common/common_widgets.dart';
import 'package:chapchap/data/response/status.dart';
import 'package:chapchap/model/user_model.dart';
import 'package:chapchap/res/app_colors.dart';
import 'package:chapchap/res/app_texts.dart';
import 'package:chapchap/res/components/hide_keyboard_container.dart';
import 'package:chapchap/res/components/rounded_button.dart';
import 'package:chapchap/utils/routes/routes_name.dart';
import 'package:chapchap/utils/utils.dart';
import 'package:chapchap/view_model/auth_view_model.dart';
import 'package:chapchap/view_model/demandes_view_model.dart';
import 'package:chapchap/view_model/user_view_model.dart';
import 'package:chapchap/view_model/wallet_view_model.dart';
import 'package:chapchap/views/wallet/create_wallet_view.dart';
import 'package:chapchap/views/wallet/recharge_history_view.dart';
import 'package:chapchap/views/wallet/recharge_view.dart';
import 'package:chapchap/views/wallet/transfers_history_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class PointsHelpView extends StatefulWidget {
  const PointsHelpView({Key? key}) : super(key: key);

  @override
  State<PointsHelpView> createState() => _PointsHelpViewSatet();
}

class _PointsHelpViewSatet extends State<PointsHelpView> {
  UserModel? user;

  DemandesViewModel  demandesViewModel = DemandesViewModel();

  @override
  Widget build(BuildContext context) {
    return HideKeyBordContainer(
      child: Scaffold(
        backgroundColor: AppColors.bgColor,
        resizeToAvoidBottomInset: false,
        appBar: CommonAppBar(
          context: context,
          backArrow: true,
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppTexts.bigTitleText("Comment ça marche ?"),
                const SizedBox(height: 20,),
                AppTexts.titleText("1. Faites plus de transferts"),
                const SizedBox(height: 10,),
                AppTexts.descriptionText("Chaque fois que vous effectuez un transfert d'argent, vous accumulez des points. Ces points peuvent être convertis en CAD."),
                const SizedBox(height: 10,),
                AppTexts.descriptionText("Plus vous transférez, plus vous gagnez de points, ce qui vous permet de bénéficier d'un montant supplémentaire lorsque vous les convertissez."),

                const SizedBox(height: 20,),

                AppTexts.titleText("2. Convertissez vos points en CAD"),
                const SizedBox(height: 10,),
                AppTexts.descriptionText("Une fois que vous avez accumulé suffisamment de points, vous pouvez les convertir en CAD. Ce montant sera alors versé dans votre wallet."),
                const SizedBox(height: 10,),
                AppTexts.descriptionText("Vous pourrez ensuite utiliser ces fonds pour effectuer des transferts à vos proches.")
              ],
            ),
          ),
        ),
      ),
    );
  }
}