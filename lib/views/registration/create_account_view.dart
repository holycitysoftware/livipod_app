import 'package:flutter/material.dart';

import '../../components/components.dart';
import '../../themes/livi_spacing/livi_spacing.dart';
import '../../themes/livi_themes.dart';
import '../../utils/strings.dart';

class CreateAccountPage extends StatefulWidget {
  const CreateAccountPage({super.key});
  @override
  _CreateAccountPageState createState() => _CreateAccountPageState();
}

class _CreateAccountPageState extends State<CreateAccountPage> {
  final _formKey = GlobalKey<FormState>();
  bool _agreedToTOS = false;

  void _setAgreedToTOS(bool newValue) {
    setState(() {
      _agreedToTOS = newValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LiviThemes.colors.baseWhite,
      resizeToAvoidBottomInset: true,
      bottomNavigationBar: LiviFilledButton(
        text: Strings.continueText,
        onTap: () {},
      ),
      appBar: AppBar(
        toolbarHeight: 30,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            // Handle back action
          },
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: kSpacer_16),
          children: [
            LiviThemes.icons.logo,
            LiviThemes.spacing.heightSpacer16(),
            Align(
              child: LiviTextStyles.interSemiBold24(Strings.createAnAccount),
            ),
            LiviThemes.spacing.heightSpacer16(),
            LiviTextStyles.interRegular16(
              Strings.afterCreatingYourAccount,
              textAlign: TextAlign.center,
            ),
            Spacer(),
            LiviInputField(
              title: Strings.fullName,
              hint: Strings.steveJobsFullName,
            ),
            LiviInputField(
              title: Strings.email,
              subTitle: Strings.optional,
              hint: Strings.steveJobsEmail,
            ),
            TextFormField(
              decoration: InputDecoration(
                labelText: "Phone number*",
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your phone number';
                }
                return null;
              },
            ),
            Row(
              children: [
                // Checkbox(
                //   value: _agreedToTOS,
                //   onChanged: _setAgreedToTOS,
                // ),
                Expanded(
                  child: GestureDetector(
                    onTap: () => _setAgreedToTOS(!_agreedToTOS),
                    child: LiviTextStyles.interRegular16(
                      Strings.afterCreatingYourAccount,
                      textAlign: TextAlign.start,
                      maxLines: 3,
                    ),
                  ),
                ),
              ],
            ),
            Spacer(flex: 2),
          ],
        ),
      ),
    );
  }
}
