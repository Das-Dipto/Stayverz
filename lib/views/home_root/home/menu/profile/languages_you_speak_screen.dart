import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../controllers/profile_controller.dart';
import '../../../../../widgets/custom_input_text.dart';
import '../../../../../widgets/own_title_app_bar.dart';

class Language {
  final String name;
  bool isSelected;

  Language({required this.name, this.isSelected = false});
}

class LanguagesYouSpeakScreen extends StatefulWidget {
  const LanguagesYouSpeakScreen({super.key});

  @override
  State<LanguagesYouSpeakScreen> createState() =>
      _LanguagesYouSpeakScreenState();
}

class _LanguagesYouSpeakScreenState extends State<LanguagesYouSpeakScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ProfileController controller = Get.find<ProfileController>();

  final List<Language> _languages = [
    // ... your languages list as before ...
    Language(name: 'Afrikaans', isSelected: false),
    Language(name: 'Albanian', isSelected: false),
    Language(name: 'Amharic', isSelected: false),
    Language(name: 'Arabic', isSelected: false),
    Language(name: 'Armenian', isSelected: false),
    Language(name: 'Azerbaijani', isSelected: false),
    Language(name: 'Basque', isSelected: false),
    Language(name: 'Belarusian', isSelected: false),
    Language(name: 'Bengali', isSelected: false),
    Language(name: 'Bosnian', isSelected: false),
    Language(name: 'Bulgarian', isSelected: false),
    Language(name: 'Burmese', isSelected: false),
    Language(name: 'Catalan', isSelected: false),
    Language(name: 'Cebuano', isSelected: false),
    Language(name: 'Chinese (Simplified)', isSelected: false),
    Language(name: 'Chinese (Traditional)', isSelected: false),
    Language(name: 'Corsican', isSelected: false),
    Language(name: 'Croatian', isSelected: false),
    Language(name: 'Czech', isSelected: false),
    Language(name: 'Danish', isSelected: false),
    Language(name: 'Dutch', isSelected: false),
    Language(name: 'English', isSelected: true),
    Language(name: 'Esperanto', isSelected: false),
    Language(name: 'Estonian', isSelected: false),
    Language(name: 'Filipino', isSelected: false),
    Language(name: 'Finnish', isSelected: false),
    Language(name: 'French', isSelected: false),
    Language(name: 'Frisian', isSelected: false),
    Language(name: 'Galician', isSelected: false),
    Language(name: 'Georgian', isSelected: false),
    Language(name: 'German', isSelected: false),
    Language(name: 'Greek', isSelected: false),
    Language(name: 'Gujarati', isSelected: false),
    Language(name: 'Haitian Creole', isSelected: false),
    Language(name: 'Hausa', isSelected: false),
    Language(name: 'Hawaiian', isSelected: false),
    Language(name: 'Hebrew', isSelected: false),
    Language(name: 'Hindi', isSelected: false),
    Language(name: 'Hmong', isSelected: false),
    Language(name: 'Hungarian', isSelected: false),
    Language(name: 'Icelandic', isSelected: false),
    Language(name: 'Igbo', isSelected: false),
    Language(name: 'Indonesian', isSelected: false),
    Language(name: 'Irish', isSelected: false),
    Language(name: 'Italian', isSelected: false),
    Language(name: 'Japanese', isSelected: false),
    Language(name: 'Javanese', isSelected: false),
    Language(name: 'Kannada', isSelected: false),
    Language(name: 'Kazakh', isSelected: false),
    Language(name: 'Khmer', isSelected: false),
    Language(name: 'Kinyarwanda', isSelected: false),
    Language(name: 'Korean', isSelected: false),
    Language(name: 'Kurdish', isSelected: false),
    Language(name: 'Kyrgyz', isSelected: false),
    Language(name: 'Lao', isSelected: false),
    Language(name: 'Latin', isSelected: false),
    Language(name: 'Latvian', isSelected: false),
    Language(name: 'Lithuanian', isSelected: false),
    Language(name: 'Luxembourgish', isSelected: false),
    Language(name: 'Macedonian', isSelected: false),
    Language(name: 'Malagasy', isSelected: false),
    Language(name: 'Malay', isSelected: false),
    Language(name: 'Malayalam', isSelected: false),
    Language(name: 'Maltese', isSelected: false),
    Language(name: 'Maori', isSelected: false),
    Language(name: 'Marathi', isSelected: false),
    Language(name: 'Mongolian', isSelected: false),
    Language(name: 'Nepali', isSelected: false),
    Language(name: 'Norwegian', isSelected: false),
    Language(name: 'Nyanja (Chichewa)', isSelected: false),
    Language(name: 'Odia (Oriya)', isSelected: false),
    Language(name: 'Pashto', isSelected: false),
    Language(name: 'Persian', isSelected: false),
    Language(name: 'Polish', isSelected: false),
    Language(name: 'Portuguese (Portugal, Brazil)', isSelected: false),
    Language(name: 'Punjabi', isSelected: false),
    Language(name: 'Romanian', isSelected: false),
    Language(name: 'Russian', isSelected: false),
    Language(name: 'Samoan', isSelected: false),
    Language(name: 'Scots Gaelic', isSelected: false),
    Language(name: 'Serbian', isSelected: false),
    Language(name: 'Sesotho', isSelected: false),
    Language(name: 'Shona', isSelected: false),
    Language(name: 'Sindhi', isSelected: false),
    Language(name: 'Sinhala (Sinhalese)', isSelected: false),
    Language(name: 'Slovak', isSelected: false),
    Language(name: 'Slovenian', isSelected: false),
    Language(name: 'Somali', isSelected: false),
    Language(name: 'Spanish', isSelected: false),
    Language(name: 'Sundanese', isSelected: false),
    Language(name: 'Swahili', isSelected: false),
    Language(name: 'Swedish', isSelected: false),
    Language(name: 'Tagalog (Filipino)', isSelected: false),
    Language(name: 'Tajik', isSelected: false),
    Language(name: 'Tamil', isSelected: false),
    Language(name: 'Tatar', isSelected: false),
    Language(name: 'Telugu', isSelected: false),
    Language(name: 'Thai', isSelected: false),
    Language(name: 'Turkish', isSelected: false),
    Language(name: 'Turkmen', isSelected: false),
    Language(name: 'Ukrainian', isSelected: false),
    Language(name: 'Urdu', isSelected: false),
    Language(name: 'Uyghur', isSelected: false),
    Language(name: 'Uzbek', isSelected: false),
    Language(name: 'Vietnamese', isSelected: false),
    Language(name: 'Welsh', isSelected: false),
    Language(name: 'Xhosa', isSelected: false),
    Language(name: 'Yiddish', isSelected: false),
    Language(name: 'Yoruba', isSelected: false),
    Language(name: 'Zulu', isSelected: false),
    // add more languages here ...
  ];

  List<Language> _filteredLanguages = [];

  @override
  void initState() {
    super.initState();

    // Get selected languages from the controller
    final List<String> selectedLanguages =
        controller.profile.value?.profile?.languages ?? [];

    // Set isSelected = true for matched languages
    for (var lang in _languages) {
      if (selectedLanguages.contains(lang.name)) {
        lang.isSelected = true;
      }
    }

    _filteredLanguages = List.from(_languages);
    _searchController.addListener(_filterLanguages);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterLanguages() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredLanguages =
          _languages
              .where((lang) => lang.name.toLowerCase().contains(query))
              .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: OwnTitleAppBar(
        appBarText: 'Languages You Speak',
        fontColor: Colors.black,
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Search Bar
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16),
            child: CustomInputText(
              controller: _searchController,
              helperText: 'Search',
              prefixIcon: const Icon(
                Icons.search,
                color: Color(0xFF999999),
                size: 20,
              ),
              borderColor: const Color(0xFFEEEEEE),
              fillColor: Colors.white,
              borderWidth: 1,
              borerRadius: 4,
              onChange: (value) {
                _filterLanguages();
              },
            ),
          ),

          // Language List
          Expanded(
            child: Scrollbar(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _filteredLanguages.length,
                itemBuilder: (context, index) {
                  final language = _filteredLanguages[index];
                  return Container(
                    height: 60,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Colors.grey.shade200,
                          width: 1,
                        ),
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Text(
                              language.name,
                              style: const TextStyle(
                                fontSize: 16,
                                color: Color(0xFF333333),
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              language.isSelected = !language.isSelected;
                            });
                          },
                          child: Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(
                                color:
                                    language.isSelected
                                        ? const Color(0xFF1A1A1A)
                                        : Colors.grey.shade400,
                                width: 1.5,
                              ),
                              color:
                                  language.isSelected
                                      ? const Color(0xFF1A1A1A)
                                      : Colors.transparent,
                            ),
                            child:
                                language.isSelected
                                    ? const Icon(
                                      Icons.check,
                                      size: 16,
                                      color: Colors.white,
                                    )
                                    : null,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),

          // Save Button with loading state
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(
                top: BorderSide(color: Color(0xFFEEEEEE), width: 1),
              ),
            ),
            child: Obx(() {
              return SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed:
                      controller.isLoading.value
                          ? null
                          : () async {
                            final selectedLanguages =
                                _languages
                                    .where((lang) => lang.isSelected)
                                    .map((lang) => lang.name)
                                    .toList();

                            if (selectedLanguages.isEmpty) {
                              Get.snackbar(
                                'Error',
                                'Please select at least one language',
                                backgroundColor: Colors.red.shade600,
                                colorText: Colors.white,
                                snackPosition: SnackPosition.BOTTOM,
                              );
                              return;
                            }

                            try {
                              Get.back();
                              await controller.updateUserLanguages(
                                selectedLanguages,
                              );
                              controller.fetchProfile();
                            } catch (_) {
                              // error handled in controller
                            }
                          },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1A1A1A),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 0,
                  ),
                  child:
                      controller.isLoading.value
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                            'Save',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.5,
                              fontFamily: 'Inter',
                            ),
                          ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}

// Hello I am Tamim