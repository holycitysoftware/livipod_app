import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
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
    doAsyncStuff();
    super.initState();
  }

  Future<void> doAsyncStuff() async {
    await getCountry();
  }

  Future<void> getCountry() async {
    number =
        await PhoneNumber.getRegionInfoFromPhoneNumber(appUser!.phoneNumber);
    if (number != null) {
      final String parsableNumber = number!.dialCode ?? '';
      country = getCountryByCode('+$parsableNumber');
      if (number != null && number!.phoneNumber != null) {
        phoneNumberController.text = number!.parseNumber().replaceAll('+', '');
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
      phoneNumberController.text = appUser!.phoneNumber;
    }
  }

  Future<void> saveUserInfo() async {
    if (appUser != null) {
      appUser!.name = fullNameController.text;
      appUser!.email = emailController.text;
      appUser!.base64EncodedImage = base64Image == null ? '' : base64Image!;
      appUser!.phoneNumber = '${country.dialCode}${phoneNumberController.text}';
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
                  text: !imageWasChanged &&
                          value.appUser!.base64EncodedImage.isEmpty
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
                  country: country,
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
        );
      }),
    );
  }
}
