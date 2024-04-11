import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controllers/auth_controller.dart';
import '../registration/welcome_page.dart';

class TestCreateUser extends StatefulWidget {
  const TestCreateUser({super.key});

  @override
  State<TestCreateUser> createState() => _TestCreateUserState();
}

class _TestCreateUserState extends State<TestCreateUser> {
  final _formKey = GlobalKey<FormState>();
  final _phoneNumberController = TextEditingController();
  final _smsFormKey = GlobalKey<FormState>();
  final _smsCodeController = TextEditingController();

  @override
  void dispose() {
    _phoneNumberController.dispose();
    _smsCodeController.dispose();
    super.dispose();
  }

  Future<void> goToWelcomePage() async {
    await Navigator.push(
        context, MaterialPageRoute(builder: (context) => WelcomePage()));
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthController>(builder: (context, controller, child) {
      if (!controller.promptForUserCode &&
          controller.firebaseAuthUser == null) {
        if (mounted) {
          WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
            goToWelcomePage();
          });
        }
      }

      return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text('Create User'),
        ),
        body: Padding(
            padding: const EdgeInsets.all(16.0), child: getView(controller)),
      );
    });
  }

  Widget getView(AuthController controller) {
    if (!controller.promptForUserCode && controller.firebaseAuthUser == null) {
      return Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              controller: _phoneNumberController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                hintText: '+15555555555',
                labelText: 'Phone Number',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter a phone number';
                }
                // Add additional phone number validation if needed
                return null;
              },
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  // Handle form submission
                  final String phoneNumber = _phoneNumberController.text;
                  controller.verifyPhoneNumber(phoneNumber);
                }
              },
              child: const Text('Create'),
            ),
            if (controller.verificationError.isNotEmpty) ...[
              const SizedBox(height: 16.0),
              Text(
                controller.verificationError,
                style: const TextStyle(color: Colors.red),
                textAlign: TextAlign.center,
              )
            ]
          ],
        ),
      );
    } else if (controller.promptForUserCode &&
        controller.firebaseAuthUser == null) {
      return Form(
        key: _smsFormKey,
        child: Column(
          children: [
            TextFormField(
              controller: _smsCodeController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Enter code',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter a code';
                }
                // Add additional phone number validation if needed
                return null;
              },
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                if (_smsFormKey.currentState!.validate()) {
                  // Handle form submission
                  final String code = _smsCodeController.text;
                  controller.validate(code);
                }
              },
              child: const Text('Validate'),
            ),
          ],
        ),
      );
    } else {
      return Center(
        child: Column(
          children: [
            const Text('You are authenticated'),
            const SizedBox(height: 16.0),
            Text(controller.firebaseAuthUser!.uid),
            const SizedBox(height: 16.0),
            Text(controller.firebaseAuthUser!.refreshToken ?? ''),
            const SizedBox(height: 16.0),
            Text(controller.firebaseAuthUser!.phoneNumber ?? ''),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                _smsCodeController.text = '';
                _phoneNumberController.text = '';
                controller.signOut();
              },
              child: const Text('Sign Out'),
            ),
          ],
        ),
      );
    }
  }
}
