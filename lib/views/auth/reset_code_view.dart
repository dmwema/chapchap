import 'dart:async';
import 'package:chapchap/l10n/app_localizations.dart';
import 'package:chapchap/res/components/auth_container.dart';
import 'package:chapchap/res/components/rounded_button.dart';
import 'package:chapchap/utils/routes/routes_name.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ResetCodeView extends StatefulWidget {
  @override
  State<ResetCodeView> createState() => _ResetCodeViewState();
}

class _ResetCodeViewState extends State<ResetCodeView> {
  final List<TextEditingController> _codeControllers = List.generate(
    5,
        (index) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(
    5,
        (index) => FocusNode(),
  );

  int _countdown = 0;
  Timer? _timer;
  bool _isResendEnabled = true;

  @override
  void dispose() {
    _timer?.cancel();
    for (var controller in _codeControllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void _startCountdown() {
    setState(() {
      _countdown = 30;
      _isResendEnabled = false;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_countdown > 0) {
          _countdown--;
        } else {
          _isResendEnabled = true;
          timer.cancel();
        }
      });
    });
  }

  void _resendCode() {
    if (_isResendEnabled) {
      // TODO: Implement actual resend logic here
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Code renvoyé avec succès'),
          backgroundColor: Colors.green,
        ),
      );
      _startCountdown();
    }
  }

  void _verifyCode() {
    String code = _codeControllers.map((c) => c.text).join();
    if (code.length == 5) {
      Navigator.pushNamed(
        context,
        RoutesName.newPasswords,
        arguments: code,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Veuillez entrer le code complet'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return Scaffold(
      body: AuthContainer(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.lock_reset,
                  size: 50,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              const SizedBox(height: 30),

              Text(
                localizations.translate("resetPasswordTitle"),
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),

              SizedBox(
                width: 300,
                child: Text(
                  localizations.translate("resetEmailMessage"),
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black.withOpacity(.6),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 40),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) {
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 5),
                    width: 50,
                    height: 60,
                    child: TextFormField(
                      controller: _codeControllers[index],
                      focusNode: _focusNodes[index],
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: Colors.grey.shade300,
                            width: 2,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: Colors.grey.shade300,
                            width: 2,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: Theme.of(context).primaryColor,
                            width: 2,
                          ),
                        ),
                        contentPadding: EdgeInsets.zero,
                      ),
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(1),
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      onChanged: (value) {
                        if (value.length == 1 && index < 4) {
                          _focusNodes[index + 1].requestFocus();
                        } else if (value.isEmpty && index > 0) {
                          _focusNodes[index - 1].requestFocus();
                        }
                      },
                    ),
                  );
                }),
              ),
              const SizedBox(height: 40),

              TextButton.icon(
                onPressed: _isResendEnabled ? _resendCode : null,
                icon: Icon(
                  Icons.refresh,
                  color: _isResendEnabled
                      ? Theme.of(context).primaryColor
                      : Colors.grey,
                ),
                label: Text(
                  _isResendEnabled
                      ? 'Renvoyer le code'
                      : 'Renvoyer le code ($_countdown s)',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: _isResendEnabled
                        ? Theme.of(context).primaryColor
                        : Colors.grey,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              const Divider(),
              const SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.info_outline,
                    size: 18,
                    color: Colors.blue,
                  ),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      localizations.translate("checkMailboxMessage"),
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),

              RoundedButton(
                title: localizations.translate("verify"),
                loading: false,
                onPress: _verifyCode,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
