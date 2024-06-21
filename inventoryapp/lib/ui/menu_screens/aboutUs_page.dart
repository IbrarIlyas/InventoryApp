import 'package:flutter/material.dart';
import 'package:inventoryapp/Utils/image_paths.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutUsPage extends StatefulWidget {
  @override
  _AboutUsPageState createState() => _AboutUsPageState();
}

class _AboutUsPageState extends State<AboutUsPage> {

  Images images=Images();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth > 480) {
            return _buildWideLayout();
          } else {
            return _buildNarrowLayout();
          }
        },
      ),
    );
  }

  Widget _buildWideLayout() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Center(
              child: CircleAvatar(
                radius: 60,
                backgroundImage: AssetImage(images.darkLogo),
              ),
            ),
            const SizedBox(height: 20),
            const Center(
              child: Text(
                'Biz IT Solution',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2C1E5E), // Custom purple color
                ),
              ),
            ),
            const SizedBox(height: 10),
            Center(
              child: Text(
                'Making the world a better place, one line of code at a time.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontStyle: FontStyle.italic,
                  color: Colors.grey[700],
                ),
              ),
            ),
            const SizedBox(height: 30),
            _buildSection('Who We Are', 'Welcome to Bizit Solutions! Based in Ireland, we specialize in providing a seamless and easy-to-use Point of Sale & Inventory app tailored for business owners.',false),
            const SizedBox(height: 20),
            _buildSection('Our Mission', ' Our app simplifies daily operations, allowing you to manage sales and inventory effortlessly.',false),
            const SizedBox(height: 20),
            const SizedBox(height: 20),
            _buildSection('Contact Us', 'Reach out to us at support@bizitsolutions.ie for support and inquiries.',true),
          ],
        ),
      ),
    );
  }

  Widget _buildNarrowLayout() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Center(
              child: CircleAvatar(
                radius: 60,
                backgroundImage: AssetImage(images.darkLogo),
              ),
            ),
            const SizedBox(height: 20),
            const Center(
              child: Text(
                'Biz IT Solution',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2C1E5E), // Custom purple color
                ),
              ),
            ),
            const SizedBox(height: 10),
            Center(
              child: Text(
                'Making the world a better place, one line of code at a time.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontStyle: FontStyle.italic,
                  color: Colors.grey[700],
                ),
              ),
            ),
            const SizedBox(height: 30),
            _buildSection('Who We Are', 'We are a team of passionate developers and designers committed to creating amazing software solutions. Our mission is to deliver high-quality products that bring value to our customers.',false),
            const SizedBox(height: 20),
            _buildSection('Our Mission', 'Our mission is to innovate and lead in the tech industry, providing state-of-the-art solutions that improve efficiency and drive success for our clients.',true),
            const SizedBox(height: 20),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, String content,bool isUrl) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          title,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2C1E5E), // Custom purple color
          ),
        ),
        const SizedBox(height: 10),
        InkWell(
          child: Text(
            content,
            style: const TextStyle(
              fontSize: 16,
              height: 1.5,
            ),
          ),
          onTap: ()=>isUrl?launchUrl(Uri.parse('https://bizitsolutions.ie')):null,
        ),
      ],
    );
  }

}
