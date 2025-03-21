import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:country_picker/country_picker.dart';
import '../../../../core/widgets/custom_bottom_nav_bar.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

// Providers for form fields
final nameProvider = StateProvider<String>((ref) => 'Md Shahadat Hossain');
final emailProvider = StateProvider<String>((ref) => 'melpeters@gmail.com');
final cellProvider = StateProvider<String>((ref) => '+966 11 352 4444');
final dobProvider = StateProvider<String>((ref) => '23/05/1995');
final countryProvider = StateProvider<Country?>((ref) => null);
final profileImageProvider = StateProvider<File?>((ref) => null);

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  // Initialize controllers
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController cellController;

  @override
  void initState() {
    super.initState();
    // Initialize controllers with initial values
    nameController = TextEditingController(text: ref.read(nameProvider));
    emailController = TextEditingController(text: ref.read(emailProvider));
    cellController = TextEditingController(text: ref.read(cellProvider));
  }

  @override
  void dispose() {
    // Dispose controllers
    nameController.dispose();
    emailController.dispose();
    cellController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final country = ref.watch(countryProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Profile Picture
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  const Text(
                    'Edit Profile',
                    style: TextStyle(
                      color: Color(0xFF7B6EF6),
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Stack(
                    children: [
                      Consumer(
                        builder: (context, ref, child) {
                          final profileImage = ref.watch(profileImageProvider);
                          return Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: profileImage != null
                                  ? DecorationImage(
                                      image: FileImage(profileImage),
                                      fit: BoxFit.cover,
                                    )
                                  : const DecorationImage(
                                      image: AssetImage('assets/images/profile.png'), // Add your default profile image
                                      fit: BoxFit.cover,
                                    ),
                            ),
                          );
                        },
                      ),
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: GestureDetector(
                          onTap: () => _pickImage(context, ref),
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: const BoxDecoration(
                              color: Color(0xFF7B6EF6),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.camera_alt_outlined,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Form Fields with Save Button
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLabel('Name'),
                    _buildTextField(nameController, nameProvider),
                    const SizedBox(height: 24),

                    _buildLabel('Email'),
                    _buildTextField(emailController, emailProvider),
                    const SizedBox(height: 24),

                    _buildLabel('Cell'),
                    _buildTextField(cellController, cellProvider),
                    const SizedBox(height: 24),

                    _buildLabel('Date of Birth'),
                    _buildDateField(context, ref),
                    const SizedBox(height: 24),

                    _buildLabel('Country/Region'),
                    _buildCountryField(context, ref, country),
                    
                    // Add spacing before the Save button
                    const SizedBox(height: 40),

                    // Save Button
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: () {
                            // Handle save changes
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Profile updated successfully'),
                                backgroundColor: Color(0xFF7B6EF6),
                              ),
                            );
                            context.pop();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF7B6EF6),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 0,
                          ),
                          child: const Text(
                            'Save changes',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                    
                    // Add bottom padding
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, StateProvider<String> provider) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.grey.shade300,
            width: 1,
          ),
        ),
      ),
      child: TextField(
        controller: controller,
        onChanged: (value) => ref.read(provider.notifier).state = value,
        decoration: const InputDecoration(
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 12),
        ),
        style: const TextStyle(
          fontSize: 16,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _buildDateField(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () async {
        final date = await showDatePicker(
          context: context,
          initialDate: DateTime(1995, 5, 23),
          firstDate: DateTime(1900),
          lastDate: DateTime.now(),
          builder: (context, child) {
            return Theme(
              data: Theme.of(context).copyWith(
                colorScheme: const ColorScheme.light(
                  primary: Color(0xFF7B6EF6),
                ),
              ),
              child: child!,
            );
          },
        );
        if (date != null) {
          ref.read(dobProvider.notifier).state = 
              '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
        }
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Colors.grey.shade300,
              width: 1,
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              ref.watch(dobProvider),
              style: const TextStyle(fontSize: 16),
            ),
            const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
          ],
        ),
        padding: const EdgeInsets.symmetric(vertical: 12),
      ),
    );
  }

  Widget _buildCountryField(BuildContext context, WidgetRef ref, Country? selectedCountry) {
    return GestureDetector(
      onTap: () {
        showCountryPicker(
          context: context,
          showPhoneCode: false,
          countryListTheme: CountryListThemeData(
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(20),
            ),
            inputDecoration: InputDecoration(
              labelText: 'Search',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          onSelect: (Country country) {
            ref.read(countryProvider.notifier).state = country;
          },
        );
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Colors.grey.shade300,
              width: 1,
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              selectedCountry?.name ?? 'Select Country',
              style: TextStyle(
                fontSize: 16,
                color: selectedCountry != null ? Colors.black87 : Colors.grey,
              ),
            ),
            const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
          ],
        ),
        padding: const EdgeInsets.symmetric(vertical: 12),
      ),
    );
  }

  Future<void> _pickImage(BuildContext context, WidgetRef ref) async {
    try {
      final ImagePicker picker = ImagePicker();
      
      // First show the bottom sheet with options
      final ImageSource? source = await showModalBottomSheet<ImageSource>(
        context: context,
        builder: (BuildContext context) {
          return SafeArea(
            child: Wrap(
              children: <Widget>[
                ListTile(
                  leading: const Icon(Icons.photo_library),
                  title: const Text('Choose from Gallery'),
                  onTap: () {
                    Navigator.pop(context, ImageSource.gallery);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.photo_camera),
                  title: const Text('Take a Photo'),
                  onTap: () {
                    Navigator.pop(context, ImageSource.camera);
                  },
                ),
              ],
            ),
          );
        },
      );

      // If user selected a source, then pick the image
      if (source != null) {
        final XFile? image = await picker.pickImage(
          source: source,
          imageQuality: 80, // Optimize image quality
          maxWidth: 1000, // Limit max width
          maxHeight: 1000, // Limit max height
        );

        if (image != null && context.mounted) {
          // Check if context is still valid
          ref.read(profileImageProvider.notifier).state = File(image.path);
        }
      }
    } catch (e) {
      if (context.mounted) { // Check if context is still valid
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to pick image'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
} 