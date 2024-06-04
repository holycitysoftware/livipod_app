import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:image_picker/image_picker.dart';
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

  Future<void> updateImage() async {
    final ImagePicker picker = ImagePicker();
    XFile? file;
    await showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        height: 90,
        padding: const EdgeInsets.all(kSpacer_16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: ListTile(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(60)),
                leading: Icon(
                  Icons.camera_alt,
                  color: LiviThemes.colors.brand600,
                ),
                title: LiviTextStyles.interRegular16(Strings.takePicture),
                onTap: () async {
                  file = await picker.pickImage(source: ImageSource.camera);
                  if (file != null) {
                    Navigator.pop(context);
                  }
                },
              ),
            ),
            LiviDivider(
              isVertical: true,
            ),
            Expanded(
              child: ListTile(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(60)),
                leading: Icon(
                  Icons.image,
                  color: LiviThemes.colors.brand600,
                ),
                title: LiviTextStyles.interRegular16(Strings.pickImage),
                onTap: () async {
                  file = await picker.pickImage(source: ImageSource.gallery);
                  if (file != null) {
                    Navigator.pop(context);
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
    if (file != null) {
      final fileListInt = await convertToListInt(file);
      if (fileListInt != null) {
        final base64 = base64Encode(fileListInt);

        authController.appUser!.base64EncodedImage = base64;
        await authController.editAppUser(authController.appUser!);
      }
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
          NameCircleBox(
              profilePic: authController.appUser!.base64EncodedImage,
              name: authController.appUser!.name,
              onTap: updateImage),
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
      ),
    );
  }

  Future<List<int>?> convertToListInt(XFile? file) async {
    if (file != null) {
      return file.readAsBytes();
    }
    return null;
  }
}
