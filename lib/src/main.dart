import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

enum CaptchaComplexity { easy, medium, hard }

class CaptchaFormField extends StatefulWidget {
  final int captchaLength;
  final Duration captchaDuration;
  final String? labelText;
  final InputDecoration? inputDecoration;
  final Function(String)? onChanged;
  final String? Function(String? input, String generatedCaptcha)? validator;
  final CaptchaComplexity captchaComplexity;
  final BoxDecoration? captchaBackground;
  final TextStyle? captchaTextStyle;
  final ThemeData? captchaTheme;
  final String? requiredErrorMessage;
  final String? mismatchErrorMessage;

  const CaptchaFormField({
    Key? key,
    this.captchaLength = 6,
    this.captchaDuration = const Duration(minutes: 1),
    this.labelText = 'CAPTCHA',
    this.inputDecoration,
    this.onChanged,
    this.validator,
    this.captchaComplexity = CaptchaComplexity.medium,
    this.captchaBackground,
    this.captchaTextStyle,
    this.captchaTheme,
    this.requiredErrorMessage,
    this.mismatchErrorMessage,
  }) : super(key: key);

  @override
  State<CaptchaFormField> createState() => _CaptchaFormFieldState();
}

class _CaptchaFormFieldState extends State<CaptchaFormField> {
  late String _captcha;
  late TextEditingController _controller;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _generateCaptcha();
    _startTimer();
  }

  void _generateCaptcha() {
    String characters;
    switch (widget.captchaComplexity) {
      case CaptchaComplexity.easy:
        characters = '0123456789';
        break;
      case CaptchaComplexity.medium:
        characters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
        break;
      case CaptchaComplexity.hard:
        characters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#\$%^&*';
        break;
    }
    final random = Random();
    setState(() {
      _captcha = String.fromCharCodes(
        Iterable.generate(
          widget.captchaLength,
              (_) => characters.codeUnitAt(random.nextInt(characters.length)),
        ),
      );
    });
  }

  void _startTimer() {
    _timer = Timer.periodic(widget.captchaDuration, (timer) {
      _generateCaptcha();
    });
  }

  String? _defaultValidator(String? input, String generatedCaptcha) {
    if (input == null || input.isEmpty) {
      return widget.requiredErrorMessage ?? 'CAPTCHA is required';
    }
    if (input != generatedCaptcha) {
      return widget.mismatchErrorMessage ?? 'CAPTCHA does not match';
    }
    return null;
  }

  @override
  void dispose() {
    _timer.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _controller,
      decoration: widget.inputDecoration ??
          InputDecoration(
            labelText: widget.labelText,
            suffix: InkWell(
              borderRadius: BorderRadius.circular(5),
              onTap: _generateCaptcha,
              child: Container(
                decoration: widget.captchaBackground ??
                    BoxDecoration(
                      gradient: LinearGradient(colors: [Colors.white, Colors.grey[300]!]),
                    ),
                padding: const EdgeInsets.all(5.0),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: Text(
                    _captcha,
                    key: ValueKey(_captcha),
                    style: widget.captchaTextStyle ??
                        widget.captchaTheme?.textTheme.bodyText1 ??
                        const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
            border: const OutlineInputBorder(),
          ),
      onChanged: widget.onChanged,
      validator: widget.validator != null
          ? (value) => widget.validator!(value, _captcha)
          : (value) => _defaultValidator(value, _captcha),
    );
  }

  Widget previewCaptcha() {
    return InkWell(
      onTap: _generateCaptcha,
      child: Container(
        decoration: widget.captchaBackground ??
            BoxDecoration(
              gradient: LinearGradient(colors: [Colors.white, Colors.grey[300]!]),
            ),
        padding: const EdgeInsets.all(5.0),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: Text(
            _captcha,
            key: ValueKey(_captcha),
            style: widget.captchaTextStyle ??
                widget.captchaTheme?.textTheme.bodyText1 ??
                const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
