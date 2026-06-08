import 'package:chapchap/l10n/app_localizations.dart';
import 'package:chapchap/res/app_colors.dart';
import 'package:chapchap/res/app_texts.dart';
import 'package:chapchap/res/components/slider.dart';
import 'package:chapchap/views/auth/welcome_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class OnBoardingView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => OnBoardingViewState();
}

class OnBoardingViewState extends State<OnBoardingView>
    with TickerProviderStateMixin {

  int _currentPage = 0;
  bool isLast = false;
  bool showFinalText = false;

  bool isVideoReady = false;

  final PageController _controller = PageController();
  VideoPlayerController? _videoController;
  AnimationController? textAnimationController;
  Animation<double>? textScaleAnimation;

  AnimationController? _fadeOutController;

  void _playExitAnimation() async {
    await _fadeOutController!.forward();
    setState(() => showFinalText = true);
    textAnimationController!.forward();
    await Future.delayed(const Duration(milliseconds: 1200));
    Navigator.pushAndRemoveUntil(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 700),
        pageBuilder: (_, __, ___) => WelcomeView(),
        transitionsBuilder: (context, animation, sec, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
          (route) => false,
    );
  }

  @override
  void initState() {
    super.initState();
    _fadeOutController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 700));
    textAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    textScaleAnimation = Tween<double>(begin: 0.6, end: 1.0)
        .animate(CurvedAnimation(parent: textAnimationController!, curve: Curves.easeOutBack));
  }

  @override
  void dispose() {
    _controller.dispose();
    _videoController?.dispose();
    _fadeOutController?.dispose();
    super.dispose();
  }

  Future<void> finishOnboard() async {
    _videoController = VideoPlayerController.asset('assets/videos/open.mp4')
      ..initialize().then((_) {
        setState(() => isVideoReady = true);
        _videoController!.play();

        _videoController!.addListener(() {
          final isFinished = _videoController!.value.position >=
              _videoController!.value.duration;

          if (isFinished) {
            _playExitAnimation();
          }
        });
      });
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    final List<Widget> pages = [
      SliderPage(
        title: localizations.translate("onboardingTitle1"),
        description: localizations.translate("onboardingDesc1"),
        image: "assets/1.gif",
      ),
      SliderPage(
        title: localizations.translate("onboardingTitle2"),
        description: localizations.translate("onboardingDesc2"),
        image: "assets/2.gif",
      ),
      SliderPage(
        title: localizations.translate("onboardingTitle3"),
        description: localizations.translate("onboardingDesc3"),
        image: "assets/3.gif",
        text_color: Colors.white,
      ),
    ];

    void onChanged(int index) {
      setState(() {
        _currentPage = index;
        isLast = index == pages.length - 1;
      });
    }

    return Scaffold(
      body: isVideoReady
          ? Stack(
        alignment: Alignment.center,
        children: [
          FadeTransition(
            opacity: Tween(begin: 1.0, end: 0.0).animate(_fadeOutController!),
            child: Center(
              child: AspectRatio(
                aspectRatio: _videoController!.value.aspectRatio,
                child: VideoPlayer(_videoController!),
              ),
            ),
          ),

          if (showFinalText)
            ScaleTransition(
              scale: textScaleAnimation!,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    "assets/logo_red.png",
                    width: 120,
                    height: 120,
                    fit: BoxFit.contain,
                  ),

                  const SizedBox(height: 20),
                  AppTexts.titleText(
                    "Bienvenue Chez ChapChap!",
                    color: AppColors.primaryColor,
                  ),

                  const SizedBox(height: 10),
                  AppTexts.descriptionText(
                    "La meilleure expérience de transfert d'argent",
                  ),
                ],
              ),
            ),
        ],
      )
          : _buildOnboarding(pages, onChanged, localizations),

    );
  }

  Widget _buildOnboarding(List<Widget> pages, Function(int) onChanged,
      AppLocalizations localizations) {
    return Container(
      decoration: const BoxDecoration(color: Colors.white),
      child: Stack(
        children: [
          PageView.builder(
            controller: _controller,
            itemCount: pages.length,
            onPageChanged: onChanged,
            itemBuilder: (context, index) => pages[index],
          ),

          /// --- Dots ---
          Positioned(
            bottom: 90,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                pages.length,
                    (i) => AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  height: 10,
                  width: i == _currentPage ? 26 : 10,
                  margin:
                  const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: i == _currentPage
                        ? AppColors.primaryColor
                        : AppColors.primaryColor.withOpacity(0.4),
                  ),
                ),
              ),
            ),
          ),

          /// --- Bottom Buttons ---
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                /// Skip
                TextButton(
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      CupertinoPageRoute(builder: (_) => WelcomeView()),
                          (route) => false,
                    );
                  },
                  child:
                  AppTexts.buttonText(localizations.translate("skip")),
                ),

                /// Next / Start
                InkWell(
                  onTap: () {
                    if (!isLast) {
                      _controller.nextPage(
                          duration: const Duration(milliseconds: 600),
                          curve: Curves.easeOut);
                    } else {
                      finishOnboard();
                    }
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 350),
                    height: 50,
                    width: isLast ? 150 : 55,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: isLast
                        ? AppTexts.buttonText(
                      localizations.translate("start"),
                      color: Colors.white,
                    )
                        : const Icon(Icons.chevron_right_rounded,
                        size: 30, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
