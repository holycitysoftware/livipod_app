import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:provider/provider.dart';
import 'package:regexed_validator/regexed_validator.dart';

import '../../../components/components.dart';
import '../../../controllers/controllers.dart';
import '../../../models/models.dart';
import '../../../themes/livi_spacing/livi_spacing.dart';
import '../../../themes/livi_themes.dart';
import '../../../utils/countries.dart';
import '../../../utils/string_ext.dart';
import '../../../utils/strings.dart';
import '../../../utils/utils.dart';

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
  String? base64Image;
  bool imageWasChanged = false;
  PhoneNumber? number;
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final FocusNode fullNameFocus = FocusNode();
  final FocusNode emailFocus = FocusNode();
  final FocusNode phoneFocus = FocusNode();
  String? errorTextPhone;
  String? errorTextEmail;
  bool loading = false;

  bool enabledSaveButton() {
    return fullNameController.text.isNotEmpty &&
        phoneNumberController.text.isNotEmpty &&
        (appUser != null &&
            (appUser!.name != fullNameController.text ||
                appUser!.phoneNumber != phoneNumberController.text ||
                appUser!.email != emailController.text ||
                imageWasChanged));
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
    emailController.addListener(() {
      setState(() {});
    });
    // country = getCountryByCode(authController.appUser!.phoneNumber);
    setAppUser();
    doAsyncStuff();
    super.initState();
  }

  Future<void> doAsyncStuff() async {
    await getCountry();
  }

  Future<void> getCountry() async {
    if (appUser!.phoneNumber.isEmpty) {
      return;
    }
    number =
        await PhoneNumber.getRegionInfoFromPhoneNumber(appUser!.phoneNumber);
    if (number != null) {
      final String parsableNumber = number!.dialCode ?? '';
      country = getCountryByCode('+$parsableNumber');
      if (number != null && number!.phoneNumber != null) {
        phoneNumberController.text = parseNumber(number!.phoneNumber!, country);
      }
      setState(() {});
    }
  }

  void setAppUser() {
    appUser = authController.appUser;
    if (appUser != null) {
      fullNameController.text = appUser!.name;
      if (appUser!.email != null && appUser!.email!.isNotEmpty) {
        emailController.text = appUser!.email!;
      }
    }
  }

  Future<void> saveUserInfo() async {
    try {
      setState(() {
        loading = true;
      });
      errorTextPhone = null;
      errorTextEmail = null;
      errorTextEmail = validateEmail(emailController.text);
      errorTextPhone = validatePhone(phoneNumberController.text);
      if (errorTextPhone != null || errorTextEmail != null) {
        setState(() {});
        throw Exception();
      }

      if (errorTextEmail == null && errorTextPhone == null) {
        if (appUser != null) {
          appUser!.name = fullNameController.text;
          appUser!.email = emailController.text;
          if (imageWasChanged) {
            appUser!.base64EncodedImage =
                base64Image == null ? '' : base64Image!;
          }
          // appUser!.phoneNumber = phoneNumberController.text;
          await authController.editAppUser(appUser!);
          setState(() {
            loading = false;
          });
          Navigator.pop(context);
        }
      }
    } catch (e) {
      print(e);
      FocusScope.of(context).unfocus();
      setState(() {
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LiviThemes.colors.baseWhite,
      appBar: LiviAppBar(
        title: Strings.editInfo,
        cancelDescription: true,
        onPressed: () {},
        tail: [
          LiviTextIcon(
            onPressed: enabledSaveButton() ? saveUserInfo : () {},
            enabled: enabledSaveButton(),
            text: Strings.save,
            loading: loading,
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
      body: Consumer<AuthController>(builder: (context, value, child) {
        return ListView(
          children: [
            LiviThemes.spacing.heightSpacer16(),
            NameCircleBox(
              profilePic: imageWasChanged
                  ? base64Image
                  : value.appUser!.base64EncodedImage,
              name: value.appUser!.name,
            ),
            LiviThemes.spacing.heightSpacer8(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 64),
              child: LiviTextButton(
                  text: value.appUser!.base64EncodedImage.isEmpty
                      ? Strings.addImage
                      : Strings.edit,
                  onTap: () async {
                    final result = await updateImage(
                        context,
                        imageWasChanged
                            ? base64Image ?? ''
                            : value.appUser!.base64EncodedImage);
                    if (result != null) {
                      base64Image = result;
                      imageWasChanged = true;
                    } else {
                      if (result != base64Image && result != null) {
                        imageWasChanged = true;
                        base64Image = result;
                      }
                    }
                    setState(() {});
                  }),
            ),
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
              errorText: errorTextEmail,
              controller: emailController,
            ),
            Consumer<AuthController>(builder: (context, authController, child) {
              return LiviInputField(
                errorText: errorTextPhone,
                // staticHint: country.dialCode,
                padding: const EdgeInsets.symmetric(
                    horizontal: kSpacer_16, vertical: kSpacer_8),
                title: Strings.phoneNumber.requiredSymbol(),
                controller: phoneNumberController,
                focusNode: phoneFocus,
                readOnly: true,
                prefix: Container(
                  height: 32,
                  width: 32,
                  alignment: Alignment.center,
                  child: LiviTextStyles.interRegular14(
                    country.code,
                    textAlign: TextAlign.center,
                  ),
                ),
                hint: Strings.steveJobsNumber,
              );
            }),
          ],
        );
      }),
    );
  }
}
