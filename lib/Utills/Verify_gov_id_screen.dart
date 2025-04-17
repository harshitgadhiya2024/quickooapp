import 'package:flutter/material.dart';

class VerifyGovIdScreen extends StatefulWidget {
  const VerifyGovIdScreen({super.key});

  @override
  State<VerifyGovIdScreen> createState() => _VerifyGovIdScreenState();
}

class _VerifyGovIdScreenState extends State<VerifyGovIdScreen> {
  bool _isLoadsing = true;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        _isLoadsing = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          color: Colors.teal,
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
                children: [
                  const Text(
                    "Which document would you like to upload?",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal,
                    ),
                  ),
                  const SizedBox(height: 40),
                  _isLoadsing
                      ? Center(child: CircularProgressIndicator())
                      :Column(
                    children: [
                      _buildDocumentTile(
                          title: "Passport",
                          subtitle: "Face photo page",
                          onTap: (){}
                      ),
                      const Divider(),
                      _buildDocumentTile(
                          title: "Aadhaar card",
                          subtitle: "Front and back",
                          onTap: (){}
                      ),
                      const Divider(),
                      _buildDocumentTile(
                          title: "PAN card",
                          subtitle: "Front and back",
                          onTap: (){}
                      ),
                    ],
                  ),
                  const Spacer(),
              const Text(
                 "The data collected by Comuto SA is necessary for verifying your identity. For more information and to exercise your rights, see our ",
                style: TextStyle(color: Colors.grey, fontSize: 12),),
              const Text(
                   "Privacy Policy.",
                    style: TextStyle(
                      color: Colors.teal,
                      fontSize: 12,
                      decoration: TextDecoration.underline),
              ),
                           const SizedBox(height: 20),
                ],
              ),
      ),
    );
  }

  Widget _buildDocumentTile({
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 15),
        child: Row(
          children: [
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.black)),
                const SizedBox(height: 4),
                Text(subtitle,
                    style: const TextStyle(fontSize: 14, color: Colors.grey)),
              ],
            ))
          ],
        ),
      ),
    );
  }
}
