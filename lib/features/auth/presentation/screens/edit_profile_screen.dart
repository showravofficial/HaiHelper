import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

final profileImageProvider = StateProvider<File?>((ref) => null);
final nameProvider = StateProvider<String>((ref) => '');
final emailProvider = StateProvider<String>((ref) => '');
final phoneProvider = StateProvider<String>((ref) => '');

class EditProfileScreen extends ConsumerWidget {
  const EditProfileScreen({super.key});

  Future<void> _pickImage(BuildContext context, WidgetRef ref) async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await showModalBottomSheet<XFile?>(
        context: context,
        builder: (BuildContext context) {
          return SafeArea(
            child: Wrap(
              children: <Widget>[
                ListTile(
                  leading: const Icon(Icons.photo_library),
                  title: const Text('Choose from Gallery'),
                  onTap: () async {
                    Navigator.pop(context,
                      await picker.pickImage(source: ImageSource.gallery),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.photo_camera),
                  title: const Text('Take a Photo'),
                  onTap: () async {
                    Navigator.pop(context,
                      await picker.pickImage(source: ImageSource.camera),
                    );
                  },
                ),
              ],
            ),
          );
        },
      );

      if (image != null) {
        ref.read(profileImageProvider.notifier).state = File(image.path);
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to pick image'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF7B6EF6).withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(
                        Icons.arrow_back,
                        color: Color(0xFF7B6EF6),
                      ),
                      onPressed: () => context.pop(),
                    ),
                  ),
                  const Expanded(
                    child: Center(
                      child: Text(
                        'Edit Profile',
                        style: TextStyle(
                          fontSize: 20,
                          color: Color(0xFF7B6EF6),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 40),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    // Profile Image
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 24),
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: const Color(0xFF7B6EF6).withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Stack(
                        children: [
                          Consumer(
                            builder: (context, ref, child) {
                              final profileImage = ref.watch(profileImageProvider);
                              return ClipOval(
                                child: SizedBox(
                                  width: 100,
                                  height: 100,
                                  child: profileImage != null
                                      ? Image.file(
                                    profileImage,
                                    fit: BoxFit.cover,
                                  )
                                      : Container(
                                    color: const Color(0xFF7B6EF6).withOpacity(0.1),
                                    child: const Icon(
                                      Icons.person,
                                      color: Color(0xFF7B6EF6),
                                      size: 32,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                          Positioned(
                            right: 0,
                            bottom: 0,
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: const BoxDecoration(
                                color: Color(0xFF7B6EF6),
                                shape: BoxShape.circle,
                              ),
                              child: IconButton(
                                icon: const Icon(
                                  Icons.camera_alt_outlined,
                                  color: Colors.white,
                                  size: 20,
                                ),
                                onPressed: () => _pickImage(context, ref),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Form Fields
                    const SizedBox(height: 24),
                    _buildTextField(
                      ref,
                      'Name',
                      Icons.person_outline,
                      nameProvider,
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      ref,
                      'Email',
                      Icons.email_outline,
                      emailProvider,
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      ref,
                      'Phone',
                      Icons.phone_outlined,
                      phoneProvider,
                    ),

                    // Save Button
                    const SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: () {
                          // Save profile data
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
                          'Save',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
      WidgetRef ref,
      String hint,
      IconData icon,
      StateProvider<String> provider,
      ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 25,
            spreadRadius: -5,
            offset: const Offset(0, 20),
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            spreadRadius: -5,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: TextFormField(
        onChanged: (value) => ref.read(provider.notifier).state = value,
        decoration: InputDecoration(
          hintText: hint,
          prefixIcon: Icon(icon, color: Colors.grey),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 16,
          ),
        ),
      ),
    );
  }
}
