import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../components/components.dart';
import '../../../controllers/controllers.dart';
import '../../../models/models.dart';
import '../../../themes/livi_spacing/livi_spacing.dart';
import '../../../themes/livi_themes.dart';
import '../../../utils/countries.dart';
import '../../../utils/string_ext.dart';
import '../../../utils/strings.dart';

class EditInfoPage extends StatefulWidget {
  static const String routeName = '/my-pods-page';
  final String? medication;
  const EditInfoPage({
    super.key,
    this.medication,
  });

  @override
  State<EditInfoPage> createState() => _EditInfoPageState();
}

class _EditInfoPageState extends State<EditInfoPage> {
  late final AuthController authController;
  Medication? medication;
  bool isLoading = false;
  Country country = getUS();
  AppUser? appUser;

  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final FocusNode fullNameFocus = FocusNode();
  final FocusNode emailFocus = FocusNode();
  final FocusNode phoneFocus = FocusNode();

  bool enabledSaveButton() {
    return fullNameController.text.isNotEmpty &&
        phoneNumberController.text.isNotEmpty &&
        (appUser != null &&
            (appUser!.name != fullNameController.text ||
                appUser!.phoneNumber != phoneNumberController.text));
  }

  @override
  void initState() {
    authController = Provider.of<AuthController>(context, listen: false);
    fullNameController.addListener(() {
      setState(() {});
    });
    phoneNumberController.addListener(() {
      setState(() {});
    });
    // country = getCountryByCode(authController.appUser!.phoneNumber);
    setAppUser();
    super.initState();
  }

  void setAppUser() {
    appUser = authController.appUser;
    if (appUser != null) {
      fullNameController.text = appUser!.name;
      if (appUser!.email != null && appUser!.email!.isNotEmpty) {
        emailController.text = appUser!.email!;
      }
      phoneNumberController.text = appUser!.phoneNumber;
    }
  }

  Future<void> saveUserInfo() async {
    if (appUser != null) {
      appUser!.name = fullNameController.text;
      appUser!.email = emailController.text;
      await authController.editAppUser(appUser!);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LiviThemes.colors.baseWhite,
      appBar: LiviAppBar(
        title: Strings.editInfo,
        onPressed: () {},
        tail: [
          LiviTextIcon(
            onPressed: enabledSaveButton() ? saveUserInfo : () {},
            enabled: enabledSaveButton(),
            text: Strings.save,
            icon: Padding(
              padding: const EdgeInsets.only(left: 4),
              child: LiviThemes.icons.checkIcon(
                color: enabledSaveButton()
                    ? LiviThemes.colors.brand600
                    : LiviThemes.colors.gray400,
              ),
            ),
          )
        ],
      ),
      body: ListView(
        children: [
          LiviThemes.spacing.heightSpacer16(),
          NameCircleBox(name: authController.appUser!.name),
          LiviThemes.spacing.heightSpacer16(),
          LiviInputField(
            focusNode: fullNameFocus,
            padding: const EdgeInsets.symmetric(
                horizontal: kSpacer_16, vertical: kSpacer_8),
            title: Strings.fullName.requiredSymbol(),
            textCapitalization: TextCapitalization.words,
            hint: Strings.steveJobsFullName,
            controller: fullNameController,
          ),
          LiviInputField(
            focusNode: emailFocus,
            padding: const EdgeInsets.symmetric(
                horizontal: kSpacer_16, vertical: kSpacer_8),
            title: Strings.email,
            subTitle: Strings.optional,
            hint: Strings.steveJobsEmail,
            controller: emailController,
          ),
          Consumer<AuthController>(builder: (context, authController, child) {
            return LiviInputField(
              padding: const EdgeInsets.symmetric(
                  horizontal: kSpacer_16, vertical: kSpacer_8),
              title: Strings.phoneNumber.requiredSymbol(),
              controller: phoneNumberController,
              focusNode: phoneFocus,
              errorText: authController.verificationError.isEmpty
                  ? null
                  : authController.verificationError,
              prefix: CountryDropdownButton(
                country: country!,
                onChanged: (Country? value) {
                  setState(() {
                    country = value!;
                  });
                },
              ),
              hint: Strings.steveJobsNumber,
            );
          }),
        ],
      ),
    );
  }
}
