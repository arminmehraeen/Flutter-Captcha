# Changelog

## [0.0.1]
- A customizable Flutter form field widget for CAPTCHA verification, ensuring secure user authentication.

## [0.0.2]
### Added
- **CAPTCHA generation**: Basic CAPTCHA generation using alphanumeric characters with a customizable length (`captchaLength`, default: 6).
- **Manual CAPTCHA refresh**: Users can regenerate the CAPTCHA manually by tapping the CAPTCHA text in the suffix.
- **Validation support**: Added `validator` callback for custom validation and a default validator to check for required input and CAPTCHA match.
- **Customizable label and input**: Support for `labelText` and `inputDecoration` to customize the input field appearance.
- **Change listener**: Added `onChanged` callback to track changes in the input.

### Fixed
- Proper disposal of the `TextEditingController` in the `dispose` method to prevent memory leaks.

## [0.0.3]
### Added
- **Timer-based CAPTCHA refresh**: Introduced automatic CAPTCHA regeneration every `captchaDuration` seconds using a periodic timer.
- **CAPTCHA complexity levels**: Added `CaptchaComplexity` enum to allow selecting between `easy` (numbers only), `medium` (alphanumeric), and `hard` (alphanumeric with special characters).
- **Custom CAPTCHA background**: Added `captchaBackground` parameter to customize the CAPTCHA display container with gradients or other decorations.
- **CAPTCHA text styling**: Added `captchaTextStyle` and `captchaTheme` parameters for flexible styling of the CAPTCHA text.
- **Custom error messages**: Added `requiredErrorMessage` and `mismatchErrorMessage` parameters to customize validation error messages.

### Changed
- Default CAPTCHA length remains at 6 characters but can now dynamically adjust complexity based on the `captchaComplexity` setting.
- Updated CAPTCHA suffix widget to include a smooth transition using `AnimatedSwitcher`.

### Fixed
- Ensured that the CAPTCHA timer stops (`_timer?.cancel()`) when the widget is disposed, preventing memory leaks or redundant updates.

### Notes
- This version introduces enhanced customization options and automatic refresh for the CAPTCHA. Ensure to test periodic updates and styling in your app before deployment.

## [0.0.4]
### Improved
- Added DartDoc comments for public APIs to improve usability and readability.
  
