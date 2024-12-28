import 'dart:math';
import 'package:flutter/material.dart';


class CaptchaFormField extends StatefulWidget {

  final int captchaLength;
  final String? labelText;
  final InputDecoration? inputDecoration;
  final Function(String)? onChanged;
  final String? Function(String? input, String generatedCaptcha)? validator;

  const CaptchaFormField({
    Key? key,
    this.captchaLength = 6, // Default length of CAPTCHA
    this.labelText = 'CAPTCHA',
    this.inputDecoration,
    this.onChanged,
    this.validator,
  }) : super(key: key);

  @override
  State<CaptchaFormField> createState() => _CaptchaFormFieldState();
}

class _CaptchaFormFieldState extends State<CaptchaFormField> {
  late String _captcha;
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _generateCaptcha();
  }

  void _generateCaptcha() {
    const characters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
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

  String? _defaultValidator(String? input, String generatedCaptcha) {
    if (input == null || input.isEmpty) {
      return 'CAPTCHA is required';
    }
    if (input != generatedCaptcha) {
      return 'CAPTCHA does not match';
    }
    return null;
  }

  @override
  void dispose() {
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
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Text(
                  _captcha,
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
}
