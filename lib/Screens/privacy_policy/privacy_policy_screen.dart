import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy Policy'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Html(
          data:
          """<p style="text-align: justify;"><b>At SchoolWorksPro</b>, we prioritize the privacy and security of our users' personal and sensitive data. We are committed to transparently outlining how we collect, utilize, and safeguard user information within our application. Please review the following policy to understand our practices and how they affect you.</p>
              <br>
              <p style="text-align: justify;"><b>Collection of Personal and Sensitive User Data:</b><br>
              At SchoolWorksPro, we collect a limited set of personal and sensitive user data, primarily consisting of email addresses, phone numbers, user image, student id and parent details provided by the institution during the account creation process. This information is essential for facilitating communication and enhancing the functionality of our services within the educational context.<br>
              We prioritize user privacy and adhere to strict guidelines regarding the access, collection, use, and sharing of personal and sensitive user data. Our practices align with app functionality and policy-compliant purposes that are expected by the user. This includes compliance with Google Play's Ads policy for advertising-related data usage. <br>
              Rest assured, the data we collect is utilized solely for the purpose of delivering and improving our educational services. We respect the privacy and confidentiality of our users' information and are committed to maintaining the highest standards of data protection.</p>
              <br>
              <p style="text-align: justify;"><b>Security Measures:</b><br>
              We handle all personal and sensitive user data securely, ensuring that it is transmitted using modern cryptography methods such as HTTPS. Our app employs robust security protocols to protect user information from unauthorized access, alteration, or disclosure.</p>
              <br>
              <p style="text-align: justify;"><b>User Consent and Disclosure:</b><br>
              In cases where data collection may not align with users' reasonable expectations, we provide prominent disclosures within the app. These disclosures describe the data being accessed, how it will be used and/or shared, and other relevant details.<br>
              Requests for user consent and runtime permissions are preceded by clear in-app disclosures to ensure users fully understand and agree to data collection practices.</p>
              <br>
              <p style="text-align: justify;"><b>Third-Party Integrations:</b><br>
              If our app integrates third-party code designed to collect personal and sensitive user data, we ensure compliance with disclosure and consent requirements. We promptly provide evidence demonstrating adherence to policy standards upon request from Google Play.</p>
              <br>
              <p style="text-align: justify;"><b>Privacy Policy and Data Safety:</b><br>
              We maintain a comprehensive privacy policy accessible within our app and Play Console. Your activities on an Online Course/Class are shared with the course/class provider for academic research purposes. This includes the comments and review you make to learning resources.  We comply with all relevant laws on Privacy and Data Protection. In general, this means that we will only collect or process personal information for specific and lawful purposes, we won’t collect more than we need for those purposes or keep it for longer than necessary, we’ll do our best to keep it accurate, and we’ll keep it as safe as we can. This policy details how we access, collect, use, and share user data, including developer information, data handling procedures, and retention policies.</p>
              <br>
              <p style="text-align: justify;"><b>Account Deletion Requirement:</b><br>
              As SchoolWorksPro serves schools and colleges subscribed to our package, user accounts are created based on institution-provided details. While institutions can disable user accounts, the deletion of accounts is not within their capability.<br>
              However, we acknowledge the importance of user control over their data. Therefore, we ensure that users have the option to request the deactivation of their accounts and associated data.<br>
              Within the app and on our website, we provide easily discoverable options for users to request account deactivation. While accounts may be disabled at the institution's discretion, the deletion of accounts and associated data is facilitated upon user request to the extent feasible within our system.</p>
              <br>
              <p style="text-align: justify;"><b>Usage of App Set ID:</b><br>
              We do not use the App Set ID for ads personalization or measurement. We ensure transparency and obtain users' legally valid consent where required.<br>
              By continuing to use SchoolWorksPro, you acknowledge and consent to the practices outlined in this Privacy Policy. For any inquiries or concerns regarding your privacy and data security, please contact us at <b>digitechnology001@gmail.com</b></p>
              <br>
              <p style="text-align: justify;"><b>Thank you for trusting SchoolWorksPro with your information.</b></p>""",
        ),
      ),
    );
  }
}
