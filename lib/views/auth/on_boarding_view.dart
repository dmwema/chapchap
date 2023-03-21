import 'package:chapchap/res/app_colors.dart';
import 'package:chapchap/res/components/slider.dart';
import 'package:chapchap/utils/routes/routes_name.dart';
import 'package:flutter/material.dart';

class OnBoardingView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => OnBoardingViewState();
}

class OnBoardingViewState extends State<OnBoardingView> {
  int _currentPage = 0;
  bool is_last = false;

  PageController _controller = PageController();

  final List<Widget> _pages = [
    SliderPage(title: "Envoyez de l'argent en un clin d'œil", description: "Avec Chapchap, vous pouvez transférer de l'argent à vos proches en quelques clics. Plus besoin de faire la queue dans une agence bancaire ou de passer par des intermédiaires coûteux.", image: "assets/1.gif"),
    SliderPage(title: "Sécurité et fiabilité garanties", description: "Nous prenons la sécurité de vos transactions très au sérieux. Toutes les données sont cryptées et nous utilisons les dernières technologies pour protéger vos données.", image: "assets/2.gif"),
    SliderPage(title: "Commencez la belle aventure !", description: "Nous sommes ravis de vous accueillir dans notre communauté. Avec Chapchap, vous pouvez envoyer de l'argent à vos proches en toute sécurité et à des tarifs avantageux. Commencez dès maintenant !", image: "assets/3.gif", text_color: Colors.white,),
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
  Widget build(BuildContext context) {
    Color dots_color = AppColors.primaryColor;
    return Scaffold(
        body: Container(
          decoration: const BoxDecoration(
              color: Colors.white,
          ),
          child: Stack(
            children: <Widget>[
              PageView.builder(
                scrollDirection: Axis.horizontal,
                controller: _controller,
                itemCount: _pages.length,
                onPageChanged:_onChanged,
                itemBuilder: (context, int index) {
                  return _pages[index];
                },
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List<Widget>.generate(_pages.length, (int index) {
                      return Container(
                        height: 10,
                        width: (index == _currentPage) ? 30: 10,
                        margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 30),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: (index == _currentPage) ? dots_color: dots_color.withOpacity(0.5)
                        ),
                      );
                    }
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      if (!is_last) {
                        _controller.nextPage(
                            duration: Duration(milliseconds: 800),
                            curve: Curves.easeInOutQuint
                        );
                      } else {
                        // go Home
                        Navigator.pushNamed(context, RoutesName.login);
                      }
                    },
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 300),
                      height: 60,
                      alignment: Alignment.center,
                      width: _currentPage != (_pages.length - 1) ? 70 : 160,
                      decoration: BoxDecoration(
                        color: AppColors.primaryColor,
                        borderRadius: BorderRadius.circular(35),
                      ),
                      child: (_currentPage == (_pages.length - 1)?
                      const Text(
                        "Commencer", style:
                      TextStyle(
                          color: Colors.white,
                          fontSize: 20
                      ),
                      ):
                      const Icon(Icons.chevron_right_rounded, size: 30, color: Colors.white,)
                      )
                      ,),
                  ),
                  const SizedBox(
                    height: 40,
                  )
                ],
              )

            ],
          ),
        )
    );
  }
}