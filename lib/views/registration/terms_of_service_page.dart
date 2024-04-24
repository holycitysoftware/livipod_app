import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../components/components.dart';
import '../../themes/livi_themes.dart';

class TermsOfServicePage extends StatelessWidget {
  const TermsOfServicePage({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          foregroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          automaticallyImplyLeading: false,
          title: BackBar(
            title: 'Terms of Service',
          ),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              buildTitle('Livi Terms of Service Agreement'),
              buildSectionText(
                  '\nThis Terms of Service Agreement is a legally binding agreement between you and PharmRight Corporation. When you click "Submit," check a box, or otherwise provide consent during the process of ordering, activating, or using any Equipment and Services, you and we are agreeing to be bound by this agreement to the same extent as if you and we had manually executed a paper copy of this agreement. You understand that you are entering into a binding agreement electronically, and you intend to enter into this agreement electronically.\n'),
              buildSectionText(
                  'Notwithstanding anything to the contrary in this agreement or any other agreement between PharmRight and Customer, PharmRight may not continue to conduct business, and may not be able to provide the system or perform its other obligations hereunder, for the entire term set forth in Customer’s order or any period of time beyond such term.'),
              buildSectionText(
                  '\nThese Terms and Conditions, the Terms of Service (as defined below), and any addenda attached hereto or referenced herein (each of which is hereby incorporated by this reference) (collectively, this “Agreement”), describe the relationship between PharmRight and the Customer identified on the Order (“Customer”). This Agreement will become effective as of the date executed by Customer (the “Effective Date”). Customer acknowledges and agrees that these terms and conditions for the Equipment, Services, Site, and System (each as defined below and may be updated from time to time) form a part of this Agreement and describe the rights, obligations, restrictions, and liabilities of the parties with respect to the Equipment, Services, System, and Site. Capitalized terms used but not defined herein shall have the meanings set forth in the Order. Words that are capitalized have the specific meanings set forth in the “Definitions” section below.'),
              buildSectionTitle('1. Definitions'),
              buildSectionText(
                  'PharmRight participates in interest-based advertising (IBA), also known as Online Behavioral Advertising. We use third-party advertising companies to display ads tailored to your individual interests based on how you browse and shop online.'),
              buildSectionText(
                  '\nWe allow third-party companies to collect certain information when you visit our websites or use our mobile applications. This information is used to serve ads for PharmRight products or services or for the products or services of other companies when you visit this website or other websites. These companies use non-personally-identifiable information (e.g., click stream information, browser type, time and date, subject of advertisements clicked or scrolled over, hardware/software information, cookie and session ID) and personally identifiable information (e.g., static IP address) during your visits to this and other websites in order to provide advertisements about goods and services likely to be of greater interest to you. These parties typically use a cookie, web beacon or other similar tracking technologies to collect this information.'),
              buildSectionTitle('Our do-not-track Policy.'),
              buildSectionText(
                  'Some browsers have a "do not track" feature that lets you tell websites that you do not want to have your online activities tracked. At this time, we do not respond to browser "do not track" signals, but we do provide you the option to opt out of interest-based advertising. To learn more about IBA or to opt-out of this type of advertising, visit the Network Advertising Initiative website and the Digital Advertising Alliance website. Options you select are browser- and device specific.'),
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
                  '• Fulfill and manage purchases, orders, payments and returns/exchanges\n • Respond to requests for information about our products and services\n • Connect with you regarding customer service via our contact center, customer service desk or on social media or Internet chat platform'),
              buildSectionText('Our Marketing Purposes.\n', isBlackBold: true),
              buildSectionText(
                  '• Fulfill and manage purchases, orders, payments and returns/exchanges\n • Respond to requests for information about our products and services\n • Connect with you regarding customer service via our contact center, customer service desk or on social media or Internet chat platform'),
              buildSectionText('Internal Operations.\n', isBlackBold: true),
              buildSectionText(
                  '• Fulfill and manage purchases, orders, payments and returns/exchanges\n • Respond to requests for information about our products and services\n • Connect with you regarding customer service via our contact center, customer service desk or on social media or Internet chat platform'),
              buildSectionText('Prevention of Fraud & Other Harm.\n',
                  isBlackBold: true),
              buildSectionText(
                  '• Fulfill and manage purchases, orders, payments and returns/exchanges\n • Respond to requests for information about our products and services\n • Connect with you regarding customer service via our contact center, customer service desk or on social media or Internet chat platform'),
              buildSectionText('Legal Compliance.\n', isBlackBold: true),
              buildSectionText(
                  '• Fulfill and manage purchases, orders, payments and returns/exchanges\n • Respond to requests for information about our products and services\n • Connect with you regarding customer service via our contact center, customer service desk or on social media or Internet chat platform'),
              buildSectionTitle('How is Your Information Shared?'),
              buildSectionText(
                  'We share information within PharmRight Corporation, which includes all subsidiaries and affiliates. This information may be used to offer you products and services that may be of interest to you.'),
              buildSectionTitle(
                  'How do You Access and Update Your Personal Information?'),
              buildSectionText(
                  'You can access or update your personal information by logging into your account on our website or by contacting us directly.'),
              buildSectionTitle('How is Your Personal Information Protected?'),
              buildSectionText(
                  'We maintain administrative, technical, and physical safeguards to protect your personal information. However, no system is completely secure or "hacker proof."'),
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
