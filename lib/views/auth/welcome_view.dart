import 'dart:io';

import 'package:mardona/common/common_widgets.dart';
import 'package:mardona/res/app_colors.dart';
import 'package:mardona/res/app_texts.dart';
import 'package:mardona/res/components/rounded_button.dart';
import 'package:mardona/res/components/slider.dart';
import 'package:mardona/view_model/services/notifications_service.dart';
import 'package:mardona/views/auth/login_view.dart';
import 'package:mardona/views/auth/register_view.dart';
import 'package:mardona/views/exchange_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class WelcomeView extends StatefulWidget {
  final String? message;
  const WelcomeView({Key? key, this.message}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _WelcomeViewState();
}

class _WelcomeViewState extends State<WelcomeView> {
  int _currentPage = 0;
  bool is_last = false;

  Color dots_color = AppColors.primaryColor;

  PageController _controller = PageController();

  final List<Widget> _pages = [
    SliderPage(title: "Envoyez de l’argent vers plus de 15 destinations !", description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nullam congue feugiat erat in porttitor. In gravida justo non est elementum, ac malesuada nisi iaculis.", image: "assets/1.png"),
    SliderPage(title: "Gagnez 5\$ de rabais avec le Black Friday !", description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nullam congue feugiat erat in porttitor. In gravida justo non est elementum, ac malesuada nisi iaculis.", image: "assets/2.png"),
    SliderPage(title: "Vos transferts du Tchad vers le Canada !", description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nullam congue feugiat erat in porttitor. In gravida justo non est elementum, ac malesuada nisi iaculis.", image: "assets/3.png", text_color: Colors.white,),
  ];

  _onChanged(int index) {
    setState(() {
      _currentPage = index;
      if (index == _pages.length - 1) {
        is_last = true;
      } else {
        is_last = false;
      }
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(
        context: context,
        backArrow: false,
        empty: true,
      ),
      backgroundColor: AppColors.bgColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
          child: Stack(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List<Widget>.generate(_pages.length, (int index) {
                        return Container(
                          height: 10,
                          width: (index == _currentPage) ? 80: 10,
                          margin: const EdgeInsets.symmetric(horizontal: 2, vertical: 20),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: (index == _currentPage) ? dots_color: AppColors.accentColor
                          ),
                        );
                      }
                      ),
                    ),
                    Expanded(
                      child: PageView.builder(
                        scrollDirection: Axis.horizontal,
                        controller: _controller,
                        itemCount: _pages.length,
                        onPageChanged:_onChanged,
                        itemBuilder: (context, int index) {
                          return _pages[index];
                        },
                      ),
                    ),
                  ],
                )
              ),
              Positioned(
                bottom: 0,
                child: SizedBox(
                  width: MediaQuery.of(context).size.width - 40,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      RoundedButton(
                        title: "Faire une estimation",
                        onPress: () {
                          // Navigator.push(
                          //   context,
                          //   CupertinoPageRoute(
                          //     builder: (context) => ExchangeView(public: true,),
                          //   ),
                          // );
                        }
                      ),
                      const SizedBox(height: 10,),
                      Row(
                        children: [
                          SizedBox(
                            width: (MediaQuery.of(context).size.width - 40 - 10) / 2,
                            child: RoundedButton(
                                title: "Connexion",
                                outlined: true,
                                onPress: () {
                                  Navigator.push(
                                    context,
                                    CupertinoPageRoute(
                                      builder: (context) => LoginView(),
                                    ),
                                  );
                                }
                            ),
                          ), const SizedBox(width: 10,),
                          SizedBox(
                            width: (MediaQuery.of(context).size.width - 40 - 10) / 2,
                            child: RoundedButton(
                                title: "Inscription",
                                outlined: true,
                                onPress: () {
                                  Navigator.push(
                                    context,
                                    CupertinoPageRoute(
                                      builder: (context) => RegisterView(),
                                    ),
                                  );
                                }
                            ),
                          )
                        ],
                      )

                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),

    );
  }
  _WelcomeViewState createState() => _WelcomeViewState();
}