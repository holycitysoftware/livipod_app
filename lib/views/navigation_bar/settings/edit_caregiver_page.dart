import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:provider/provider.dart';

import '../../../components/components.dart';
import '../../../controllers/controllers.dart';
import '../../../models/models.dart';
import '../../../services/services.dart';
import '../../../themes/livi_spacing/livi_spacing.dart';
import '../../../themes/livi_themes.dart';
import '../../../utils/countries.dart';
import '../../../utils/string_ext.dart';
import '../../../utils/strings.dart';
import '../../../utils/utils.dart';

class EditCaregiverPage extends StatefulWidget {
  static const String routeName = '/my-pods-page';
  final AppUser appUser;
  const EditCaregiverPage({
    super.key,
    required this.appUser,
  });

  @override
  State<EditCaregiverPage> createState() => _EditCaregiverPageState();
}

class _EditCaregiverPageState extends State<EditCaregiverPage> {
  late final AuthController authController;
  Medication? medication;
  bool isLoading = false;
  Country country = getUS();
  AppUser? appUser;
  var grantPermissionToDispense = true;
  final appUserService = AppUserService();
  String? base64Image;
  bool imageWasChanged = false;
  String? errorTextPhone;
  String? errorTextEmail;

  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  PhoneNumber? number;
  final FocusNode fullNameFocus = FocusNode();
  final FocusNode emailFocus = FocusNode();
  final FocusNode phoneFocus = FocusNode();

  bool enabledSaveButton() {
    return fullNameController.text.isNotEmpty &&
        phoneNumberController.text.isNotEmpty &&
        (appUser != null &&
            (appUser!.name != fullNameController.text ||
                appUser!.phoneNumber !=
                    country.dialCode + phoneNumberController.text ||
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
        phoneNumberController.text = number!.parseNumber().replaceAll('+', '');
      }
      setState(() {});
    }
  }

  Future<void> updateAllowRemoteDispensing(AppUser user, bool value) async {
    user.allowRemoteDispensing = value;
    await appUserService.updateUser(user);
  }

  Future<void> removeCaregiver() async {
    if (appUser != null && authController.appUser != null) {
      final remove =
          await LiviAlertDialog.removeCaregiver(context, appUser!.name);
      if (remove) {
        await appUserService.deleteUser(appUser!);
        authController.appUser!.caregiverIds.remove(appUser!.id);
        await appUserService.updateUser(authController.appUser!);
        Navigator.pop(context);
      }
    }
  }

  void setAppUser() {
    appUser = widget.appUser;
    if (appUser != null) {
      fullNameController.text = widget.appUser.name;
      if (widget.appUser.email != null && widget.appUser.email!.isNotEmpty) {
        emailController.text = widget.appUser.email!;
      }
    }
  }

  Future<void> saveUserInfo() async {
    errorTextPhone = null;
    errorTextEmail = null;
    errorTextEmail = validateEmail(emailController.text);
    errorTextPhone =
        validatePhone(country.dialCode + phoneNumberController.text);
    if (errorTextPhone != null || errorTextEmail != null) {
      setState(() {});
    }
    if (errorTextEmail == null && errorTextPhone == null) {
      if (appUser != null) {
        appUser!.name = fullNameController.text;
        appUser!.email = emailController.text;
        if (imageWasChanged) {
          appUser!.base64EncodedImage = base64Image == null ? '' : base64Image!;
        }
        appUser!.phoneNumber =
            '${country.dialCode}${phoneNumberController.text}';
        await authController.editAppUser(appUser!);
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Padding(
        padding: EdgeInsets.fromLTRB(16, 6, 16, 24),
        child: LiviFilledButton(
          color: LiviThemes.colors.baseWhite,
          text: Strings.removeCaregiver,
          borderColor: LiviThemes.colors.error300,
          textColor: LiviThemes.colors.error600,
          onTap: () {
            removeCaregiver();
          },
        ),
      ),
      backgroundColor: LiviThemes.colors.baseWhite,
      appBar: LiviAppBar(
        title: Strings.editCaregiver,
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
              profilePic:
                  imageWasChanged ? base64Image : appUser!.base64EncodedImage,
              name: appUser!.name,
            ),
            LiviThemes.spacing.heightSpacer8(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 64),
              child: LiviTextButton(
                  text: appUser!.base64EncodedImage.isEmpty
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
              errorText: errorTextEmail,
            ),
            Consumer<AuthController>(builder: (context, authController, child) {
              return LiviInputField(
                padding: const EdgeInsets.symmetric(
                    horizontal: kSpacer_16, vertical: kSpacer_8),
                title: Strings.phoneNumber.requiredSymbol(),
                controller: phoneNumberController,
                focusNode: phoneFocus,
                errorText: errorTextPhone,
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
            LiviThemes.spacing.heightSpacer8(),
            LiviDivider(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: LiviTextStyles.interMedium14(
                          Strings.grantPermissionToDispense,
                          maxLines: 2,
                        ),
                      ),
                      StreamBuilder<AppUser>(
                          stream: appUserService.listenToUserRealTime(appUser!),
                          builder: (context, snapshot) {
                            if (snapshot.data == null) {
                              return SizedBox();
                            }
                            final user = snapshot.data!;
                            return LiviSwitchButton(
                              value: user.allowRemoteDispensing,
                              onChanged: (e) {
                                updateAllowRemoteDispensing(appUser!, e);
                              },
                            );
                          }),
                    ],
                  ),
                  LiviTextStyles.interRegular14(
                      Strings.caregiverMustBePresentAtThePod),
                ],
              ),
            )
          ],
        );
      }),
    );
  }
}
