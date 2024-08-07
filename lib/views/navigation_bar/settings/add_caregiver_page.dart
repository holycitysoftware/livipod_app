import 'package:flutter/material.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
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
  final appUserService = AppUserService();
  String? base64Image;
  bool imageWasChanged = false;
  PhoneNumber? number;
  bool loading = false;
  String? errorTextPhone;
  String? errorTextEmail;

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
                !appUser.phoneNumber.contains(phoneNumberController.text) ||
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
    try {
      if (appUser != null) {
        setState(() {
          loading = true;
        });
        errorTextPhone = null;
        errorTextEmail = null;
        errorTextEmail = validateEmail(emailController.text);
        errorTextPhone =
            validatePhone(country.dialCode + phoneNumberController.text);
        if (errorTextPhone != null || errorTextEmail != null) {
          setState(() {});
          throw Exception();
        }
        if (errorTextEmail == null && errorTextPhone == null) {
          await setAppUser(
              fullNameController: fullNameController.text,
              emailController: emailController.text,
              phoneNumberController: phoneNumberController.text);
          appUser.base64EncodedImage = base64Image == null ? '' : base64Image!;
          appUser.phoneNumber =
              '${country.dialCode}${phoneNumberController.text}';
          final user = await appUserService.createUser(appUser);
          final loggedUser = authController.appUser;
          final list = <String>[];
          if (loggedUser!.caregiverIds != null) {
            list.addAll(loggedUser.caregiverIds);
            list.add(user.id);
          }
          loggedUser.caregiverIds = list;

          await appUserService.updateUser(loggedUser);
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
        title: Strings.addCaregiver,
        onPressed: () {},
        tail: [
          LiviTextIcon(
            onPressed: enabledSaveButton() ? saveUserInfo : () {},
            enabled: enabledSaveButton(),
            loading: loading,
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
              name: appUser.name,
              profilePic: base64Image,
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
              errorText: errorTextEmail,
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
                errorText: errorTextPhone,
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
