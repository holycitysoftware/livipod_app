import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TermsOfServicePage extends StatelessWidget {
  const TermsOfServicePage({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Terms of Service Agreement'),
          backgroundColor: Colors.teal,
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              buildSectionTitle('Terms of Service Agreement'),
              buildSectionText(
                  'This Terms of Service Agreement is a legally binding agreement between you and '
                  'PharmRight Corporation. By using any Equipment and Services, you agree to these terms as '
                  'detailed below. Please read them carefully.'),
              buildSectionTitle('1. Definitions'),
              buildSectionText(
                  'Documentation: User guides, instructions, manuals, or videos provided by PharmRight.\n'
                  'End User: The individual or entity that ultimately uses or is intended to use the Equipment.\n'
                  'Equipment: The Livi™ medication management system, including related hardware and software.'),
              buildSectionTitle('2. System and Services'),
              buildSectionText(
                  '2.1 Provision of Services: PharmRight will provide the Services to Customer and End Users '
                  'in accordance with this agreement.\n'
                  '2.2 Modifications of Service: PharmRight reserves the right to modify, add, or eliminate Services.'),
              buildSectionTitle('3. Equipment'),
              buildSectionText(
                  '3.1 Installation: The Customer or End User is responsible for installing the Equipment.\n'
                  '3.2 Electrical Power: Equipment uses electrical power supplemented by backup battery power.'),
              buildSectionTitle('4. Activation, Payment, and Renewal'),
              buildSectionText(
                  '4.1 Installation: Services will not begin until the agreement is executed and initial payment is made.\n'
                  '4.2 Lease and Connectivity Fees: Fees are paid on a quarterly or monthly basis depending on the agreement.'),
              buildSectionTitle('5. Cancellation; Termination'),
              buildSectionText(
                  '5.1 Cancellation: Customer may cancel by providing written notice to PharmRight.\n'
                  '5.2 Termination: Lease will automatically renew unless terminated by either party.'),
              buildSectionTitle('6. Customer\'s PharmRight Account'),
              buildSectionText(
                  '6.1 Account Access: Customer can manage their account through a password-protected online account.\n'
                  '6.2 Responsibility for End Users: Customer is responsible for all actions taken by End Users.'),
              buildSectionTitle('7. License Restrictions'),
              buildSectionText(
                  'License Grant: Customer and its End Users are granted a limited, revocable, non-exclusive license to access '
                  'and use the Equipment and Services in accordance with this agreement.'),
              buildSectionTitle(
                  '8. Ownership of Information Submitted Via Services'),
              buildSectionText(
                  '8.1 Data Submissions: Customer grants PharmRight a perpetual, royalty-free right to use any data submitted '
                  'through the System.'),
              buildSectionTitle(
                  '9. Equipment Maintenance; Disclaimer of Warranties'),
              buildSectionText(
                  '9.1 Maintenance: PharmRight will maintain the Equipment according to the terms set forth in this agreement.\n'
                  '9.2 Limitations; Exclusions: No express warranties are provided beyond those explicitly stated.'),
              buildSectionTitle('10. Limitations on Liability'),
              buildSectionText(
                  '10.1 No Indirect Damages: PharmRight is not liable for indirect, incidental, consequential, special, or exemplary '
                  'damages arising from the use of the Services or Equipment.'),
              buildSectionTitle('Indemnification'),
              buildSectionText(
                  'Customer agrees to indemnify PharmRight against any and all claims arising from the use of the System, '
                  'misuse of the Equipment, or violation of the agreement.'),
              buildSectionTitle('Privacy'),
              buildSectionText(
                  'PharmRight maintains a Privacy Policy that governs the use of personal information and is subject to modifications.'),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildSectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Text(
        text,
        style: TextStyle(
            fontSize: 18, fontWeight: FontWeight.bold, color: Colors.teal[800]),
      ),
    );
  }

  Widget buildSectionText(String text) {
    return Text(
      text,
      style: TextStyle(fontSize: 16, height: 1.5),
    );
  }
}
