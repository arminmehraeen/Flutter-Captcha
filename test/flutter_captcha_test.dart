import 'package:flutter_captcha_form_field/flutter_captcha_form_field.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('CAPTCHA generation length matches provided length', () {
    const captchaLength = 6;
    const captchaField = CaptchaFormField(captchaLength: captchaLength);
  });
}


