import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../components/components.dart';
import '../../themes/livi_themes.dart';
import '../../utils/strings.dart';

final Uri _networkAdvertisingUrl =
    Uri.parse('http://www.networkadvertising.org/choices/');
final Uri _digitalAdvertisingUrl =
    Uri.parse('http://www.aboutads.info/choices');
final Uri _adobe = Uri.parse('http://www.adobe.com/privacy.html');
final Uri _google = Uri.parse('http://www.google.com/policies/privacy');
final Uri _dlpage = Uri.parse('https://tools.google.com/dlpage/gaoptout');

class PrivacyPolicyPage extends StatelessWidget {
  static const String routeName = '/privacy-policy-page';
  const PrivacyPolicyPage({super.key});

  Future<void> launchUrlPrivacy(Uri uri) async {
    if (await canLaunchUrl(uri)) {
      launchUrl(uri);
    } else {
      throw 'Could not launch $uri';
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: LiviThemes.colors.baseWhite,
        appBar: LiviAppBar(
          title: Strings.privacyPolicy,
          backButton: true,
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              buildTitle('PharmRight Corporation Privacy Policy'),
              Padding(
                padding: const EdgeInsets.all(16),
                child: buildSectionText(
                    'Your privacy is important to us at PharmRight. We respect your privacy regarding any information we may collect from you across our applications.',
                    textAlign: TextAlign.center),
              ),
              buildSectionTitle('What information do we collect?'),
              buildSectionText(
                  'Types of information we collect may include:\n\n • Name\n • Mailing address\n • Email Address\n • Phone (or mobile) number\n • Bank account information\n • Credit/debit card information\n • Purchase/return/exchange information\n • Device name\n • Medication orders\n • Medication schedule\n • Caregiver(s) name(s)\n • Caregiver(s) email address(s). \n\n If you choose not to provide information, we may not be able to provide you with requested products, services or information.'),
              buildSectionTitle('Automation Information Collection.'),
              buildSectionText(
                  'We and our service providers use cookies, web beacons and other technologies to receive and store certain types of information whenever you interact with us through your computer or mobile device.'),
              buildSectionText(
                  '\nThis information, which includes, but is not limited to: the pages you visit on our site or mobile application, which web address you came from, the type of browser/device/hardware you are using, purchase information and checkout process, search terms, and IP-based geographic location, helps us recognize you, customize your website experience and make our marketing messages more relevant.'),
              buildSectionText(
                  '\nThis includes PharmRight content presented on another website or mobile application. These technologies also enable us to provide features such as storage of items in your cart between visits and Short Message Service (SMS)/text messages you have chosen to receive.'),
              buildSectionTitle(
                  'Third-Party Automated Collection and Interest-Based Advertising.'),
              buildSectionText(
                  'PharmRight participates in interest-based advertising (IBA), also known as Online Behavioral Advertising. We use third-party advertising companies to display ads tailored to your individual interests based on how you browse and shop online.'),
              buildSectionText(
                  '\nWe allow third-party companies to collect certain information when you visit our websites or use our mobile applications. This information is used to serve ads for PharmRight products or services or for the products or services of other companies when you visit this website or other websites. These companies use non-personally-identifiable information (e.g., click stream information, browser type, time and date, subject of advertisements clicked or scrolled over, hardware/software information, cookie and session ID) and personally identifiable information (e.g., static IP address) during your visits to this and other websites in order to provide advertisements about goods and services likely to be of greater interest to you. These parties typically use a cookie, web beacon or other similar tracking technologies to collect this information.'),
              buildSectionTitle('Our do-not-track Policy.'),
              RichText(
                  text: TextSpan(children: [
                TextSpan(
                  text:
                      'Some browsers have a "do not track" feature that lets you tell websites that you do not want to have your online activities tracked. At this time, we do not respond to browser "do not track" signals, but we do provide you the option to opt out of interest-based advertising. To learn more about IBA or to opt-out of this type of advertising, visit the ',
                  style: LiviThemes.typography.interRegular_16
                      .copyWith(color: LiviThemes.colors.baseBlack),
                ),
                TextSpan(
                  text: 'Network Advertising Initiative ',
                  recognizer: TapGestureRecognizer()
                    ..onTap = () => launchUrlPrivacy(_networkAdvertisingUrl),
                  style: LiviThemes.typography.interRegular_16
                      .copyWith(color: LiviThemes.colors.brand600),
                ),
                TextSpan(
                  text: 'website and the ',
                  style: LiviThemes.typography.interRegular_16
                      .copyWith(color: LiviThemes.colors.baseBlack),
                ),
                TextSpan(
                  text: 'Digital Advertising Alliance website. ',
                  style: LiviThemes.typography.interRegular_16
                      .copyWith(color: LiviThemes.colors.brand600),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () => launchUrlPrivacy(_digitalAdvertisingUrl),
                ),
                TextSpan(
                  text: 'Options you select are browser- and device specific.',
                  style: LiviThemes.typography.interRegular_16
                      .copyWith(color: LiviThemes.colors.baseBlack),
                  recognizer: TapGestureRecognizer(),
                  // ..onTap = goToPrivacyPolicyPage,
                ),
              ])),
              buildSectionTitle('User Experience Information.'),
              buildSectionText(
                  'In order to improve customer experiences, help with fraud identification and assist our customer relations representatives in resolving issues customers may experience in completing online purchases, we use tools to monitor certain user experience information; including login information, IP address, data regarding pages visited and ads clicked, specific actions taken on pages visited (e.g. information entered during checkout process) and browser information.'),
              buildSectionTitle('Social Media.'),
              buildSectionText(
                  'PharmRight engages with customers on multiple social media platforms (e.g., Facebook, Twitter). If you contact us on one of our social media platforms, request customer service via social media or otherwise direct us to communicate with you via social media, we may contact you via direct message or use other social media tools to interact with you. In these instances, your interactions with us are governed by this privacy policy as well as the privacy policy of the social media platform you use.'),
              buildSectionTitle('Social Media Widgets.'),
              buildSectionText(
                  'Our sites may include social media features, such as the Facebook Like button, Google Plus, and Twitter widgets. These features may collect information about your IP address and which page you’re visiting on our site, and they may set a cookie or employ other tracking technologies. Social media features and widgets are either hosted by a third party or hosted directly on our site. Your interactions with those features are governed by the privacy policies of the companies that provide them.'),
              buildSectionTitle('Information from other sources.'),
              buildSectionText(
                  'We collect data that’s publicly available. For example, information you submit in a public forum (e.g., a blog, chat room or social network) can be read, collected or used by us and others, and could be used to personalize your experience. You are responsible for the information you choose to submit in these instances.'),
              buildSectionText(
                  '\nWe also obtain information provided by third parties. For instance, we obtain information from companies that can enhance our existing customer information to improve the accuracy and add to the information we have about our customers (e.g., adding address information).'),
              buildSectionText(
                  '\nThis improves our ability to contact you and increases the relevance of our marketing by providing better product recommendations or special offers that may interest you.'),
              buildSectionTitle('How is Your Information Used?'),
              buildSectionText(
                  'Examples of how we use the information we collect include:\n'),
              buildSectionText('Product & Service Fulfillment.\n',
                  isBlackBold: true),
              buildSectionText(
                  '• Fulfill and manage purchases, orders, payments and returns/exchanges'),
              buildSectionText(
                  '• Respond to requests for information about our products and services'),
              buildSectionText(
                  '• Connect with you regarding customer service via our contact center, customer service desk or on social media or Internet chat platforms\n'),
              buildSectionText('Our Marketing Purposes.\n', isBlackBold: true),
              buildSectionText(
                  '• Deliver newsletters, e-mails, mobile messages and social media notifications'),
              buildSectionText(
                  '• Provide interactive features of the website, send marketing communications and other information regarding products, services and promotions'),
              buildSectionText(
                  '• Administer promotions, surveys and focus groups\n'),
              buildSectionText('Internal Operations.\n', isBlackBold: true),
              buildSectionText(
                  '• Improve the effectiveness of our website, mobile experience and marketing efforts'),
              buildSectionText(
                  '• Conduct research and analysis, including focus groups and surveys'),
              buildSectionText(
                  '• Perform other business activities as needed, or as described elsewhere in this policy\n'),
              buildSectionText('Prevention of Fraud & Other Harm.\n',
                  isBlackBold: true),
              buildSectionText(
                  '• Prevent fraudulent transactions, monitor against theft and otherwise protect our customers and our business\n'),
              buildSectionText('Legal Compliance.\n', isBlackBold: true),
              buildSectionText(
                  '• For example, assist law enforcement and respond to legal/regulatory inquiries'),
              buildSectionTitle('How is Your Information Shared?'),
              buildSectionText('PharmRight Subsidiaries & Affiliates.\n',
                  isBlackBold: true),
              buildSectionText(
                  'We share the information we collect within PharmRight Corporation, which includes all PharmRight subsidiaries and affiliates. PharmRight Corporation may use this information to offer you products and services that may be of interest to you.\n'),
              buildSectionText(
                  'PharmRight Corporation owns and operates PharmRight websites and mobile applications. PharmRight Corporation subsidiaries and affiliates include, but are not limited to: Med One Capital.\n'),
              buildSectionText('Service Providers.\n', isBlackBold: true),
              buildSectionText(
                'We may share the information we collect with companies that provide support services to us or that help us market our products and services. These companies may need information about you in order to perform their functions.\n',
              ),
              buildSectionText('Legal Requirements.\n', isBlackBold: true),
              buildSectionText(
                'We may disclose information we collect when we believe disclosure is appropriate to comply with the law; to enforce or apply applicable terms and conditions and other agreements; to facilitate the financing, securitization, insuring, sale, assignment, bankruptcy or disposal of all or part of our business or assets; or to protect the rights, property or safety of our company, our customers or others.\n',
              ),
              buildSectionText(
                  'Sharing non-identifiable or Aggregate Information with Third Parties.\n',
                  isBlackBold: true),
              buildSectionText(
                'We may share non-identifiable or aggregate information with third parties for lawful purposes.\n',
              ),
              buildSectionText('Business Transfers.\n', isBlackBold: true),
              buildSectionText(
                'In connection with the sale or transfer of some or all of our business assets, we may transfer the corresponding information regarding our customers. We also may retain a copy of that customer information..\n',
              ),
              buildSectionTitle('What Choices do You Have?'),
              buildSectionText('Telephone.\n', isBlackBold: true),
              buildSectionText(
                'If you do not wish to receive promotional telephone calls, email help@liviathome.com with your first and last name and telephone number or call 843-277-8250 to opt.\n',
              ),
              buildSectionText('Mobile Text Messages.\n', isBlackBold: true),
              buildSectionText(
                'We distribute device and system alerts via text messages. Log in to your LiviWeb account to change your messaging preferences.\n',
              ),
              buildSectionText(
                  'Cookies, Tracking & Interest-Based Advertising.\n',
                  isBlackBold: true),
              buildSectionText(
                'The help function of your browser should contain instructions on how to set your computer to accept all cookies, to notify you when a cookie is issued or to not receive cookies at any time. If you set your device to not receive cookies at any time, certain personalized services cannot be provided to you, and accordingly, you may not be able to take full advantage of all of our features (i.e. you will be able to browse the site, but will not be able to make a purchase).\n',
              ),
              buildSectionText('Interest-Based Advertising.\n',
                  isBlackBold: true),
              RichText(
                  text: TextSpan(children: [
                TextSpan(
                  text: 'To opt out of interest-based advertising, visit the ',
                  style: LiviThemes.typography.interRegular_16
                      .copyWith(color: LiviThemes.colors.baseBlack),
                ),
                TextSpan(
                  text: 'Network Advertising Initiative ',
                  recognizer: TapGestureRecognizer()
                    ..onTap = () => launchUrlPrivacy(_networkAdvertisingUrl),
                  style: LiviThemes.typography.interRegular_16
                      .copyWith(color: LiviThemes.colors.brand600),
                ),
                TextSpan(
                  text: ' and the ',
                  style: LiviThemes.typography.interRegular_16
                      .copyWith(color: LiviThemes.colors.baseBlack),
                ),
                TextSpan(
                  text: 'Digital Advertising Alliance website.\n',
                  style: LiviThemes.typography.interRegular_16.copyWith(
                    color: LiviThemes.colors.brand600,
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () => launchUrlPrivacy(_digitalAdvertisingUrl),
                ),
              ])),
              buildSectionText('Other Website Analytics Services.\n',
                  isBlackBold: true),
              buildSectionText(
                'Analytics services such as Site Catalyst by Adobe Analytics and Google Analytics provide services that analyze information regarding visits to our websites and mobile applications. They use cookies, web beacons and other tracking mechanisms to collect this information.\n',
              ),
              RichText(
                  text: TextSpan(children: [
                TextSpan(
                  text:
                      '• To learn about Adobe Analytics privacy practices or to opt out of cookies set to facilitate reporting, click ',
                  style: LiviThemes.typography.interRegular_16
                      .copyWith(color: LiviThemes.colors.baseBlack),
                ),
                TextSpan(
                  text: 'here.\n',
                  recognizer: TapGestureRecognizer()
                    ..onTap = () => launchUrlPrivacy(_adobe),
                  style: LiviThemes.typography.interRegular_16
                      .copyWith(color: LiviThemes.colors.brand600),
                ),
                TextSpan(
                  text:
                      '• To learn more about Google’s privacy practices, click ',
                  style: LiviThemes.typography.interRegular_16
                      .copyWith(color: LiviThemes.colors.baseBlack),
                ),
                TextSpan(
                  text: 'here.',
                  recognizer: TapGestureRecognizer()
                    ..onTap = () => launchUrlPrivacy(_google),
                  style: LiviThemes.typography.interRegular_16
                      .copyWith(color: LiviThemes.colors.brand600),
                ),
                TextSpan(
                  text:
                      ' To access and use the Analytics Opt-out Browser Add-on, click',
                  style: LiviThemes.typography.interRegular_16
                      .copyWith(color: LiviThemes.colors.baseBlack),
                ),
                TextSpan(
                  text: ' here. ',
                  recognizer: TapGestureRecognizer()
                    ..onTap = () => launchUrlPrivacy(_dlpage),
                  style: LiviThemes.typography.interRegular_16
                      .copyWith(color: LiviThemes.colors.brand600),
                ),
              ])),
              buildSectionText('California Residents.\n', isBlackBold: true),
              buildSectionText(
                'If you are a California resident under 18 years old and a registered user, you can request that we remove content or information that you have posted to our website or other online services. Note that fulfillment of the request may not ensure complete or comprehensive removal (e.g., if the content or information has been reposted by another user). To request removal of content or information, please email help@liviathome.com or call 843-277-8250.\n',
              ),
              buildSectionTitle(
                  'How do You Access and Update Your Personal Information?'),
              buildSectionText(
                'In order to keep your personal information accurate and complete, you can access or update some of it in the following ways:\n',
              ),
              buildSectionText(
                  '• If you have created a mylivi.liviathome.com account, you can log in to review and update your account information, including contact, billing and alerting information.\n'),
              buildSectionText(
                  '• Email help@liviathome.com or call 843-277-8250 with your current and the personal information you would like to access. We will provide you the personal information requested if reasonably available, or will describe the types of personal information we typically collect.\n'),
              buildSectionTitle('How is Your Personal Information Protected?'),
              buildSectionText('Security Methods.\n', isBlackBold: true),
              buildSectionText(
                  'We maintain administrative, technical and physical safeguards to protect your personal information. When we collect or transmit sensitive information such as a credit or debit card number, we use industry standard methods to protect that information. However, no e-commerce solution, website, mobile application, database or system is completely secure or "hacker proof." You are also responsible for taking reasonable steps to protect your personal information against unauthorized disclosure or misuse.\n'),
              buildSectionText('Email Security.\n', isBlackBold: true),
              buildSectionText(
                  '"Phishing" is a scam designed to steal your personal information. If you receive an email that looks like it is from us asking you for your personal information, do not respond. We will never request your password, username, credit card information or other personal information through email.\n'),
              buildSectionTitle('PharmRight Privacy Policy Scope.'),
              buildSectionText(
                  'This privacy policy applies to all current or former customer personal information.\n'),
              buildSectionText(
                  'Our website may offer links to other sites. If you visit one of these sites, you may want to review the privacy policy on that site. In addition, you may have visited our website through a link or a banner advertisement on another site. In such cases, the site you linked from may collect information from people who click on the banner or link. You may want to refer to the privacy policies on those sites to see how they collect and use this information.\n'),
              buildSectionTitle('How do You Contact PharmRight?'),
              buildSectionText(
                  'PharmRight Corporation. 295 Seven Farms Drive, Box C-261. Charleston, SC 29492.\n'),
              buildSectionText(
                  'Phone: 843-277-8250\nEmail: help@liviathome.com\n\n')
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTitle(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: LiviThemes.typography.interSemiBold_36,
      ),
    );
  }

  Widget buildSectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Text(
        text,
        style: LiviThemes.typography.interSemiBold_24,
      ),
    );
  }

  Widget buildSectionText(String text,
      {TextAlign textAlign = TextAlign.start, bool isBlackBold = false}) {
    return Text(
      text,
      style: isBlackBold
          ? LiviThemes.typography.interSemiBold_16.copyWith(
              color: LiviThemes.colors.gray700,
            )
          : LiviThemes.typography.interRegular_16.copyWith(
              color: LiviThemes.colors.gray700,
            ),
      textAlign: textAlign,
    );
  }
}
