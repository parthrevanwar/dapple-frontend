import 'dart:convert';
import 'package:dapple/core/widgets/buttons/custom_button.dart';
import 'package:dapple/features/ai_talk_dapple/presentation/widgets/suggestions_tile.dart';
import 'package:encrypt_shared_preferences/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_palette.dart';
import '../../../../core/widgets/indicators/xp_indicator_orange.dart';
import '../../../../core/widgets/text/custom_text_rubik.dart';
import '../../../../init_dependencies.dart';
import 'package:http/http.dart' as http;

class AiTalkHomeScreen extends StatefulWidget {
  const AiTalkHomeScreen({super.key});

  @override
  State<AiTalkHomeScreen> createState() => _AiTalkHomeScreenState();
}

class _AiTalkHomeScreenState extends State<AiTalkHomeScreen> {
  String selectedRole = "";
  TextEditingController mobileNumberController = TextEditingController();
  final String apiBaseUrl = dotenv.env['AI_TALK_BACKEND_URL'] ?? "";
  int selectedRoleIndex = -1;

  Future<void> makeCall(String phoneNumber) async {
    final String url = '$apiBaseUrl/api/call';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'to_number': phoneNumber}),
      );

      if (response.statusCode == 200) {
        print('Call initiated successfully: ${response.body}');
      } else {
        print('Failed to make call: ${response.statusCode}, ${response.body}');
      }
    } catch (e) {
      print('Error making call: $e');
    }
  }

  Future<void> selectRole(BuildContext context, String role) async {
    final url = Uri.parse('$apiBaseUrl/api/role/active');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({"role": role}),
    );

    final responseData = jsonDecode(response.body);

    if (response.statusCode == 200 && responseData['success']) {
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(content: Text(responseData['message'])),
      // );
      setState(() {
        selectedRole = role;
        selectedRoleIndex = suggestionData.indexWhere(
            (element) => element['title'].toString().toLowerCase() == role);
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to set role. Please try again.')),
      );
    }
  }

  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppPalette.transparent,
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.7,
          minChildSize: 0.3,
          maxChildSize: 0.9,
          expand: false,
          builder: (context, scrollController) {
            return Container(
              decoration: BoxDecoration(
                color: AppPalette.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Container(
                        width: 80,
                        height: 5,
                        decoration: BoxDecoration(
                          color: Color(0xFFF1F2F6),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text(
                      "Enter Your Mobile Number",
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          color: AppPalette.blackColor,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          height: 1.4),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: TextFormField(
                      scrollPadding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom + 100,
                      ),
                      controller: mobileNumberController,
                      keyboardType: TextInputType.phone,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(10),
                        // Limit to 10 digits
                      ],
                      decoration: InputDecoration(
                        hintText: 'mobile number',
                        prefixIcon: Icon(Icons.phone),
                      ),
                      style: Theme.of(
                        context,
                      )
                          .textTheme
                          .labelSmall!
                          .copyWith(color: AppPalette.blackColor),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your mobile number';
                        }
                        if (value.length != 10) {
                          return 'Mobile number must be 10 digits';
                        }
                        return null;
                      },
                    ),
                  ),
                  Spacer(),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: CustomButton(
                        onTap: () async {
                          await makeCall("+91${mobileNumberController.text}");
                        },
                        buttonText: "Request Call"),
                  )
                ],
              ),
            );
          },
        );
      },
    );
  }

  final List<Map<String, dynamic>> suggestionData = [
    {
      "imageUrl": "assets/dapple-girl/karan.jpeg",
      "title": "Buddy",
      "description":
          "Chat with a friend about an assignment you can't work on.",
    },
    {
      "imageUrl": "assets/dapple-girl/meera.jpeg",
      "title": "Teacher",
      "description":
          "Get clear explanations from a patient teacher who encourages learning.",
    },
    {
      "imageUrl": "assets/dapple-girl/neha.jpeg",
      "title": "Colleague",
      "description":
          "Discuss workplace advice and ideas with a helpful colleague.",
    },
    {
      "imageUrl": "assets/dapple-girl/raj.jpeg",
      "title": "Sibling",
      "description": "Receive practical life advice from a wise elder sibling.",
    },
    {
      "imageUrl": "assets/dapple-girl/aditi.jpeg",
      "title": "Partner",
      "description":
          "Stay motivated and get coursework help from a dedicated study partner.",
    },
    {
      "imageUrl": "assets/dapple-girl/raj.jpeg",
      "title": "Mentor",
      "description":
          "Gain professional guidance and insights from an experienced career mentor.",
    },
    {
      "imageUrl": "assets/dapple-girl/raj.jpeg",
      "title": "dapple",
      "description":
          "Gain professional guidance and insights from an experienced career mentor.",
    },
  ];

  @override
  Widget build(BuildContext context) {
    EncryptedSharedPreferences sharedPreferences = serviceLocator();
    int xp = sharedPreferences.getInt("userXp") ?? 0;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppPalette.transparent,
        title: Row(
          children: [
            SizedBox(
              width: 3,
            ),
            CustomTextRubik(
                text: "Talk with Dapple",
                weight: FontWeight.w600,
                size: 20,
                color: AppPalette.blackColor),
            Spacer(),
            XpIndicatorOrange(xp)
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Center(
                child: Image.asset(
                  "assets/dapple-girl/dapple_instruct.png",
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Text(
                "Talk with Dapple by selecting any role or topic of your choice! Talk upto 10 minutes",
                style: GoogleFonts.rubik(
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                    height: 1.5,
                    letterSpacing: 0),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Text(
                "Select Role",
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    color: AppPalette.blackColor,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    height: 1.4),
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  SizedBox(
                    width: 20,
                  ),
                  for (int i = 0; i < suggestionData.length; i++)
                    GestureDetector(
                      onTap: () {
                        selectRole(
                            context, suggestionData[i]['title']!.toLowerCase());
                      },
                      child: SuggestionsTile(
                        imageUrl: suggestionData[i]["imageUrl"],
                        title: suggestionData[i]["title"],
                        description: suggestionData[i]["description"],
                        isSelected: i == selectedRoleIndex,
                      ),
                    ),
                  SizedBox(
                    width: 10,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: CustomButton(
                  onTap: () => _showBottomSheet(context),
                  buttonText: "Request Call"),
            )
          ],
        ),
      ),
    );
  }
}
