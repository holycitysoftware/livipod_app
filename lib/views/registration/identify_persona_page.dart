import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../components/components.dart';
import '../../controllers/controllers.dart';
import '../../models/models.dart';
import '../../models/persona_page.dart';
import '../../themes/livi_themes.dart';
import '../../utils/persona_page_info_list.dart';
import '../../utils/strings.dart';
import '../views.dart';

class IdentifyPersonaPage extends StatefulWidget {
  final PersonaPageInfo personaPageInfo;
  const IdentifyPersonaPage({
    super.key,
    required this.personaPageInfo,
  });

  @override
  State<IdentifyPersonaPage> createState() => _IdentifyPersonaPageState();
}

class _IdentifyPersonaPageState extends State<IdentifyPersonaPage> {
  late PersonaOption selectedOption = widget.personaPageInfo.options[0];

  @override
  void initState() {
    selectedOption = widget.personaPageInfo.options[0];
    super.initState();
  }

  Widget stepsBar(int index) {
    return Row(
      children: [
        stepBar(index == 1, head: true),
        stepBar(index == 2),
        stepBar(index == 3),
        stepBar(index == 4),
        stepBar(index == 5),
        stepBar(index == 6),
        stepBar(index == 7),
        stepBar(index == 8, tail: true),
      ],
    );
  }

  Widget stepBar(bool enabled, {bool head = false, bool tail = false}) {
    return Container(
      margin: EdgeInsets.fromLTRB(head ? 0 : 8, 2, tail ? 0 : 8, 0),
      width: (MediaQuery.of(context).size.width / 8) - 18,
      height: 3,
      color:
          enabled ? LiviThemes.colors.brand600 : LiviThemes.colors.randomGray2,
    );
  }

  Future<void> addNewOption() async {
    Provider.of<AuthController>(context, listen: false)
        .personaOptions
        .removeWhere(
            (element) => element.index == widget.personaPageInfo.index);
    Provider.of<AuthController>(context, listen: false)
        .personaOptions
        .add(selectedOption);
  }

  Future<void> goToNextPage() async {
    if (widget.personaPageInfo.index == 8) {
      await addNewOption();
      await Provider.of<AuthController>(context, listen: false).setPersona();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => FinishRegistrationPage(),
        ),
      );
    } else {
      addNewOption();
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => IdentifyPersonaPage(
            key: Key('identify-persona-page${widget.personaPageInfo.index}'),
            personaPageInfo: personaPageInfoList[widget.personaPageInfo.index],
          ),
        ),
      );
    }
  }

  String questionString() {
    return '${Strings.question} ${widget.personaPageInfo.index} of 8';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LiviThemes.colors.baseWhite,
      appBar: LiviAppBar(
          //TODO:Back button
          title: Strings.identifyMyPersona),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            stepsBar(widget.personaPageInfo.index),
            LiviThemes.spacing.heightSpacer16(),
            LiviTextStyles.interSemiBold24(widget.personaPageInfo.question),
            LiviThemes.spacing.heightSpacer16(),
            Align(
              alignment: Alignment.centerLeft,
              child: LiviTextStyles.interRegular16(
                Strings.selectTheMostAccurateAnswer,
              ),
            ),
            LiviThemes.spacing.heightSpacer32(),
            Expanded(
              flex: 3,
              child: ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: widget.personaPageInfo.options.length,
                  itemBuilder: (context, index) {
                    final item = widget.personaPageInfo.options[index];
                    return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: CheckPersonaCard(
                          option: item.option,
                          onTap: () {
                            setState(() {
                              selectedOption = item;
                            });
                          },
                          isSelected: selectedOption.option == item.option,
                        ));
                  }),
            ),
            Spacer(),
            LiviTextStyles.interMedium16(
              questionString(),
              textAlign: TextAlign.center,
            ),
            LiviThemes.spacing.heightSpacer16(),
            LiviFilledButton(
              text: Strings.continueText,
              onTap: goToNextPage,
              isCloseToNotch: true,
            ),
          ],
        ),
      ),
    );
  }
}
