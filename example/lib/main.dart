import 'package:flutter/material.dart';
import 'package:flutter_captcha_form_field/flutter_captcha_form_field.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Captcha',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: "Name",
                    border: const OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value == "") {
                      return "This field is required";
                    }
                  },
                ),
                const SizedBox(
                  height: 15,
                ),
                const CaptchaFormField(),
                const SizedBox(
                  height: 15,
                ),
                CaptchaFormField(
                  captchaDuration: Duration(seconds: 3),
                  captchaBackground: BoxDecoration(
                      gradient:
                          LinearGradient(colors: [Colors.red, Colors.blue])),
                  labelText: "Captcha",
                  captchaLength: 6,
                  onChanged: (value) {
                    print(value);
                  },
                ),
                const SizedBox(
                  height: 15,
                ),
                ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Form validation successfully')),
                        );
                      }
                    },
                    child: const Text("Verify"))
              ],
            )),
      ),
    );
  }
}
