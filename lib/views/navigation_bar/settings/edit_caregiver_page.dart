import 'package:flutter/material.dart';
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

  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final FocusNode fullNameFocus = FocusNode();
  final FocusNode emailFocus = FocusNode();
  final FocusNode phoneFocus = FocusNode();

  bool enabledSaveButton() {
    return fullNameController.text.isNotEmpty ||
        phoneNumberController.text.isNotEmpty ||
        (appUser != null &&
            (widget.appUser.name != fullNameController.text ||
                widget.appUser.phoneNumber != phoneNumberController.text)) ||
        base64Image != null;
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
      phoneNumberController.text = widget.appUser.phoneNumber;
    }
  }

  Future<void> saveUserInfo() async {
    if (appUser != null) {
      appUser!.name = fullNameController.text;
      appUser!.email = emailController.text;
      if (appUser != null && base64Image != null) {
        appUser!.base64EncodedImage = base64Image!;
      }
      await authController.editAppUser(appUser!);
      Navigator.pop(context);
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
          onTap: () => removeCaregiver(),
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
      body: ListView(
        children: [
          LiviThemes.spacing.heightSpacer16(),
          NameCircleBox(
            name: appUser!.name,
            onTap: () async {
              base64Image = await updateImage(context, widget.appUser);

              setState(() {});
            },
            profilePic: base64Image,
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
      ),
    );
  }
}
