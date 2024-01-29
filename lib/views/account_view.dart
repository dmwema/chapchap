import 'package:chapchap/common/common_widgets.dart';
import 'package:chapchap/data/response/status.dart';
import 'package:chapchap/model/pays_destination_model.dart';
import 'package:chapchap/model/pays_model.dart';
import 'package:chapchap/model/user_model.dart';
import 'package:chapchap/res/app_colors.dart';
import 'package:chapchap/res/components/hide_keyboard_container.dart';
import 'package:chapchap/res/components/profile_menu.dart';
import 'package:chapchap/utils/routes/routes_name.dart';
import 'package:chapchap/utils/utils.dart';
import 'package:chapchap/view_model/auth_view_model.dart';
import 'package:chapchap/view_model/demandes_view_model.dart';
import 'package:chapchap/view_model/services/local_auth_service.dart';
import 'package:chapchap/view_model/user_view_model.dart';
import 'package:chapchap/views/auth/login_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccountView extends StatefulWidget {
  const AccountView({Key? key}) : super(key: key);

  @override
  State<AccountView> createState() => _AccountViewState();
}

class _AccountViewState extends State<AccountView> {
  DemandesViewModel demandesViewModel = DemandesViewModel();
  PaysModel selectedFrom = PaysModel();
  UserModel? user;
  Destination? selectedTo;
  PaysDestinationModel? paysDestinationModel;
  List destinationsList = [];
  AuthViewModel authViewModel = AuthViewModel();
  bool changed = false;
  SharedPreferences? preferences;
  bool localAuthEnabled = false;

  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _toController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadPr();
    setState(() {
      AuthViewModel().getLocalAuth().then((value) {
        setState(() {
          localAuthEnabled = value;
        });
      });
    });
    demandesViewModel.paysActifs([], context);
  }

  Future loadPr() async {
    setState(() async {
      preferences = await SharedPreferences.getInstance();
    });
  }

  void insert(content, TextEditingController controller) {
    if (content.runtimeType.toString() == "double"){
      if (controller == _toController) {
        content = double.parse(content.toStringAsFixed(2));
      } else {
        content = double.parse(content.toStringAsFixed(2));
      }
      controller.value = TextEditingValue(
        text: content.toString(),
        selection: TextSelection.collapsed(offset: content.toString().length),
      );
    } else {
      _amountController.clear();
      _toController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    UserViewModel().getUser().then((value) {
      setState(() {
        user = value;
      });
    });
    return HideKeyBordContainer(
      child: Scaffold(
        backgroundColor: AppColors.formFieldColor,
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              commonAppBar(
                context: context,
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text("Mon compte", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.black), textAlign: TextAlign.left,),
              ),
              Expanded(
                child: ChangeNotifierProvider<DemandesViewModel>(
                    create: (BuildContext context) => demandesViewModel,
                    child: Consumer<DemandesViewModel>(
                        builder: (context, value, _){
                          switch (value.paysActifList.status) {
                            case Status.LOADING:
                              return SizedBox(
                                height: MediaQuery.of(context).size.height - 200,
                                child: const Center(
                                  child: CupertinoActivityIndicator(color: Colors.black,),
                                ),
                              );
                            case Status.ERROR:
                              return Center(
                                child: Text(value.paysActifList.message.toString()),
                              );
                            default:
                              List paysActifsList = value.paysActifList.data!;
                              for (var element in paysActifsList) {
                                PaysModel pays = PaysModel.fromJson(element);
                                if (user != null && selectedFrom.idPays == null && (pays.idPays.toString() == user!.idPays.toString())) {
                                  selectedFrom = pays;
                                }
                              }
                              return SingleChildScrollView(
                                child: Padding(
                                  padding: const EdgeInsets.all(20),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      ProfileMenu(
                                        title: "informations personnelles",
                                        icon: Icons.notes,
                                        noIcon: true,
                                        onTap: () {
                                          Navigator.pushNamed(context, RoutesName.profile);
                                        },
                                      ),
                                      ProfileMenu(
                                        title: "Pays de résidence",
                                        icon: CupertinoIcons.map,
                                        suffix: Image.asset("packages/country_icons/icons/flags/png/${selectedFrom.codePays}.png", width: 20, height: 15, fit: BoxFit.contain),
                                        noIcon: true,
                                        onTap: () {
                                          showModalBottomSheet(
                                            context: context,
                                            builder: (context) {
                                              return Container(
                                                  padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
                                                  child: Column(
                                                    mainAxisSize: MainAxisSize.min,
                                                    children: [
                                                      const Text("Séléctionnez le pays", style: TextStyle(
                                                          fontWeight: FontWeight.w600
                                                      ),),
                                                      const SizedBox(height: 20,),
                                                      Expanded(child: ListView.builder(
                                                        itemCount: paysActifsList.length,
                                                        itemBuilder: (context, index) {
                                                          PaysModel current = PaysModel.fromJson(paysActifsList[index]);
                                                          return InkWell(
                                                              onTap: () {
                                                                setState(() {
                                                                  selectedFrom = current;
                                                                  changed = true;
                                                                  if (!demandesViewModel.loading) {
                                                                    Map data = {
                                                                      'idPays': selectedFrom.idPays,
                                                                      'adresse': user!.adresse
                                                                    };
                                                                    demandesViewModel.uClient(data, context, false);
                                                                  }
                                                                });
                                                                Navigator.pop(context);
                                                              },
                                                              child: Container(
                                                                padding: const EdgeInsets.all(10),
                                                                decoration: BoxDecoration(
                                                                    border: Border.all(width: 1, color: Colors.black.withOpacity(.1))
                                                                ),
                                                                child: Row(
                                                                  children: [
                                                                    Image.asset("packages/country_icons/icons/flags/png/${current.codePays}.png", width: 20, height: 20, fit: BoxFit.contain,),
                                                                    const SizedBox(width: 20,),
                                                                    Text(current.paysNom.toString(), style: const TextStyle(
                                                                        fontSize: 14,
                                                                        fontWeight: FontWeight.bold
                                                                    ),)
                                                                  ],
                                                                ),
                                                              )
                                                          );
                                                        },
                                                      ))
                                                    ],
                                                  )
                                              );
                                            },
                                            shape: const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.vertical(
                                                top: Radius.circular(20),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                      ProfileMenu(
                                        title: "Mon historique",
                                        icon: Icons.history_rounded,
                                        noIcon: true,
                                        onTap: () {
                                          Navigator.pushNamed(context, RoutesName.history);
                                        },
                                      ),
                                      ProfileMenu(
                                        title: "Mes factures",
                                        icon: CupertinoIcons.doc_text,
                                        noIcon: true,
                                        onTap: () {
                                          Navigator.pushNamed(context, RoutesName.invoices);
                                        },
                                      ),
                                      ProfileMenu(
                                        title: "Coupons rabais & Parrainage",
                                        icon: CupertinoIcons.gift,
                                        noIcon: true,
                                        onTap: () {
                                          Navigator.pushNamed(context, RoutesName.couponView);
                                        },
                                      ),
                                      if (user!.soldeParrainage != null && user!.soldeParrainage.toString() != 'null')
                                      ProfileMenu(
                                        title: "Recompense",
                                        icon: CupertinoIcons.gift,
                                        noIcon: true,
                                        onTap: () {
                                          Navigator.pushNamed(context, RoutesName.recompenseView);
                                        },
                                      ),
                                      ProfileMenu(
                                        title: "Nous joindre",
                                        icon: Icons.phone_outlined,
                                        noIcon: true,
                                        onTap: () {
                                          Navigator.pushNamed(context, RoutesName.contactView);
                                        },
                                      ),
                                      const Divider(),
                                      const SizedBox(height: 10,),
                                      ProfileMenu(
                                        title: "Verrouillage biométrique",
                                        icon: Icons.fingerprint,
                                        noIcon: true,
                                        padding: false,
                                        suffix: CupertinoSwitch(
                                          activeColor: AppColors.primaryColor,
                                          value: localAuthEnabled,
                                          onChanged: (value) {
                                            LocalAuthService.canAuthenticate().then((value2) {
                                              if (value2) {
                                                LocalAuthService.authenticate().then((value3) {
                                                  if (value3) {
                                                    authViewModel.setLocalAuth(value).then((res) {
                                                      setState(() {
                                                        localAuthEnabled = value;
                                                      });
                                                    });
                                                  }
                                                });
                                              } else {
                                                Utils.flushBarErrorMessage("Votre téléphone ne supprote pas cette fonctionnalité", context);
                                              }
                                            });
                                          },
                                        ),
                                        onTap: () {
                                        },
                                      ),
                                      const SizedBox(height: 10,),
                                      GestureDetector(
                                        onTap: () {
                                          UserViewModel().remove().then((value) {
                                            if (value) {
                                              Navigator.pushAndRemoveUntil(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) => LoginView(),
                                                ),
                                                    (route) => false,
                                              );
                                            }
                                          });
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                              color: AppColors.formFieldBorderColor,
                                              borderRadius: BorderRadius.circular(5)
                                          ),
                                          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                                          child: const Center(
                                            child: Text(
                                              "Se deconnecter",
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.black54,
                                                  fontWeight: FontWeight.w600
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 30,),
                                    ],
                                  ),
                                ),
                              );
                          }
                        })
                ),
              ),
            ],
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton(
            backgroundColor: AppColors.primaryColor,
            child: const Icon(CupertinoIcons.arrow_up_right), onPressed: () {
          Navigator.pushNamed(context, RoutesName.send);
        }
        ),
        bottomNavigationBar: BottomAppBar(
            shape: const CircularNotchedRectangle(),
            child: SizedBox(
              height: 66,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(child: const Icon(CupertinoIcons.square_grid_2x2,), onTap: () {
                        Navigator.pushNamed(context, RoutesName.home);
                      }),
                      const SizedBox(height: 5), // The dummy child
                      const Text("Accueil", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 10,),)
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(child: const Icon(CupertinoIcons.person_2), onTap: () {
                        Navigator.pushNamed(context, RoutesName.recipeints);
                      }),
                      const SizedBox(height: 5), // The dummy child
                      const Text("Bénéficiaires", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 10,),)
                    ],
                  ),
                  const SizedBox(width: 40),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(child: const Icon(CupertinoIcons.arrow_right_arrow_left_circle,), onTap: () {
                        Navigator.pushNamed(context, RoutesName.exchange);
                      }),
                      const SizedBox(height: 5), // The dummy child
                      const Flexible(child: Text("Change",  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 10),))
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(child: Icon(CupertinoIcons.person_fill, color: AppColors.primaryColor,), onTap: () {
                        // Navigator.pushNamed(context, RoutesName.accountView);
                      }),
                      const SizedBox(height: 5), // The dummy child
                      Text("Mon compte", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 10, color: AppColors.primaryColor,),)
                    ],
                  ),
                ],
              ),
            )
        ),
      ),
    );
  }
}