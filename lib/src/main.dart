import 'dart:math';
import 'package:flutter/material.dart';

/// A widget that provides a CAPTCHA form field for user input.
///
/// This widget generates a CAPTCHA string for validation and includes
/// options for customization such as label text, input decoration, and validation logic.
class CaptchaFormField extends StatefulWidget {
  /// The length of the generated CAPTCHA.
  ///
  /// Defaults to 6 characters.
  final int captchaLength;

  /// The label text displayed above the input field.
  ///
  /// Defaults to "CAPTCHA".
  final String? labelText;

  /// Custom decoration for the input field.
  ///
  /// Overrides the default decoration if provided.
  final InputDecoration? inputDecoration;

  /// A callback triggered when the input value changes.
  final Function(String)? onChanged;

  /// A validator function to check the input against the generated CAPTCHA.
  ///
  /// Defaults to a function that checks if the input matches the CAPTCHA.
  final String? Function(String? input, String generatedCaptcha)? validator;

  /// The background color of the CAPTCHA text.
  final Color? captchaBackground;

  /// The text style of the CAPTCHA.
  final TextStyle? captchaTextStyle;

  /// The complexity level of the CAPTCHA (e.g., Simple, Medium, Complex).
  ///
  /// Defaults to `CaptchaComplexity.medium`.
  final CaptchaComplexity complexity;

  /// Creates a CAPTCHA form field.
  const CaptchaFormField({
    Key? key,
    this.captchaLength = 6,
    this.labelText = 'CAPTCHA',
    this.inputDecoration,
    this.onChanged,
    this.validator,
    this.captchaBackground,
    this.captchaTextStyle,
    this.complexity = CaptchaComplexity.medium,
  }) : super(key: key);

  @override
  State<CaptchaFormField> createState() => _CaptchaFormFieldState();
}

/// Defines the complexity levels of the CAPTCHA.
enum CaptchaComplexity {
  /// Simple CAPTCHA with only uppercase letters.
  simple,

  /// Medium CAPTCHA with both uppercase letters and numbers.
  medium,

  /// Complex CAPTCHA with uppercase letters, numbers, and special characters.
  complex,
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

  /// Generates a new CAPTCHA string based on the selected complexity level.
  void _generateCaptcha() {
    String characters;
    switch (widget.complexity) {
      case CaptchaComplexity.simple:
        characters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
        break;
      case CaptchaComplexity.medium:
        characters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
        break;
      case CaptchaComplexity.complex:
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

  /// The default validator for the CAPTCHA.
  ///
  /// Ensures that the input matches the generated CAPTCHA.
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
              child: Container(
                padding: const EdgeInsets.all(5.0),
                color: widget.captchaBackground ?? Colors.grey.shade200,
                child: Text(
                  _captcha,
                  style: widget.captchaTextStyle ??
                      const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
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
}
