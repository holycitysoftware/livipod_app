import 'package:flutter/material.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:provider/provider.dart';

import '../../../components/components.dart';
import '../../../controllers/controllers.dart';
import '../../../models/models.dart';
import '../../../services/app_user_service.dart';
import '../../../themes/livi_spacing/livi_spacing.dart';
import '../../../themes/livi_themes.dart';
import '../../../utils/countries.dart';
import '../../../utils/string_ext.dart';
import '../../../utils/strings.dart';

class AddCaregiverPage extends StatefulWidget {
  static const String routeName = '/my-pods-page';
  final String? medication;
  const AddCaregiverPage({
    super.key,
    this.medication,
  });

  @override
  State<AddCaregiverPage> createState() => _AddCaregiverPageState();
}

class _AddCaregiverPageState extends State<AddCaregiverPage> {
  late final AuthController authController;
  Medication? medication;
  bool isLoading = false;
  Country country = getUS();
  AppUser appUser = AppUser(name: '', phoneNumber: '');

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
            (appUser.name != fullNameController.text ||
                appUser.phoneNumber != phoneNumberController.text));
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
    fullNameFocus.addListener(() {
      if (!fullNameFocus.hasFocus) {
        setState(() {
          appUser.name = fullNameController.text;
        });
      }
    });
    // country = getCountryByCode(authController.appUser!.phoneNumber);
    super.initState();
  }

  Future<void> setAppUser(
      {required String fullNameController,
      String? emailController,
      required String phoneNumberController}) async {
    final timezone = await FlutterTimezone.getLocalTimezone();
    //Cache timezone?
    appUser = AppUser(
      name: fullNameController,
      email: emailController,
      appUserType: AppUserType.caregiver,
      phoneNumber: phoneNumberController,
      timezone: timezone,
    );
  }

  Future<void> saveUserInfo() async {
    if (appUser != null) {
      await setAppUser(
          fullNameController: fullNameController.text,
          emailController: emailController.text,
          phoneNumberController: phoneNumberController.text);
      final user = await AppUserService().createUser(appUser);
      final loggedUser = authController.appUser;
      final list = <String>[];
      if (loggedUser!.caregiverIds != null) {
        list.addAll(loggedUser.caregiverIds);
        list.add(user.id);
      }
      loggedUser.caregiverIds = list;
      await AppUserService().updateUser(authController.appUser!);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LiviThemes.colors.baseWhite,
      appBar: LiviAppBar(
        title: Strings.addCaregiver,
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
          NameCircleBox(
            name: authController.appUser!.name,
          ),
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
              textInputAction: TextInputAction.done,
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
