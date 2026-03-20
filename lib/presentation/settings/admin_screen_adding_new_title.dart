import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AdminScreenAddingNewTitle extends StatefulWidget {
  const AdminScreenAddingNewTitle({super.key});

  @override
  State<AdminScreenAddingNewTitle> createState() =>
      _AdminScreenAddingNewTitleState();
}

class _AdminScreenAddingNewTitleState extends State<AdminScreenAddingNewTitle> {
  // --- Functional State Variables ---
  String? selectedType;
  String? selectedStatus;
  String selectedRole = "Choose";

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  // Image State
  final List<File> _selectedImages = [];
  final ImagePicker _picker = ImagePicker();

  final List<String> types = ['Film', 'TV Series', 'OTT Series', 'Anime', 'Animated', 'Others'];
  final List<String> statuses = ['Released', 'Upcoming', 'Pre Production', 'Post Production', 'Announced'];
  final List<String> roles = ['Director/Producer/Writer', 'a member of the Cast / Crew', 'PR/Publicist/Agent', 'Fan', 'Non of the above'];

  // Function to pick images
  Future<void> _pickImages() async {
    final List<XFile> pickedFiles = await _picker.pickMultiImage();
    if (pickedFiles.isNotEmpty) {
      setState(() {
        _selectedImages.addAll(pickedFiles.map((file) => File(file.path)));
      });
    }
  }

  // Unified Submit Logic (Formerly the Go button logic)
  void _handleSubmit() {
    if (selectedType == null || selectedStatus == null || _titleController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please fill all required fields (Title, Type, and Status)"),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    // Logic for saving data goes here...
    print("Saving: ${_titleController.text} as $selectedType");

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1F1F1F),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1F1F1F),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          '',
          style: TextStyle(color: Colors.white, fontSize: 14, fontFamily: 'General Sans Variable'),
        ),
        actions: [
          // Moved "Go" functionality here to the AppBar as a "Save" action
          TextButton(
            onPressed: _handleSubmit,
            child: const Text(
              'Save',
              style: TextStyle(
                color: Color(0xFF436BEF), // Using your brand blue color
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              decoration: const ShapeDecoration(
                color: Color(0xFF0B0B0B),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
              ),
              padding: const EdgeInsets.only(top: 24, left: 10, right: 10, bottom: 100),
              child: Column(
                spacing: 24,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Text(
                          'Add new Title',
                          style: TextStyle(color: Colors.white, fontSize: 14, fontFamily: 'General Sans Variable'),
                        ),
                        const SizedBox(width: 10,),
                        const Padding(
                          padding: EdgeInsets.only(top: 2.0),
                          child: Icon(Icons.info_outline_rounded, size: 14, color: Colors.white,),
                        )
                      ],
                    ),
                  ),
                  _buildMainFormCard(),
                  _buildImageUploadCard(),
                  // The blue Go button section was removed from here
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMainFormCard() {
    return Container(
      width: double.infinity,
      decoration: ShapeDecoration(
        color: const Color(0xFF141414),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      child: Column(
        children: [
          _buildInputHeader("Title"),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            child: _buildTextField(_titleController, "Type here"),
          ),

          _buildInputHeader("Type"),
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              spacing: 12,
              children: types.map((t) => _buildSelectionRow(t, selectedType, (val) => setState(() => selectedType = val))).toList(),
            ),
          ),

          _buildInputHeader("Status"),
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              spacing: 12,
              children: statuses.map((s) => _buildSelectionRow(s, selectedStatus, (val) => setState(() => selectedStatus = val))).toList(),
            ),
          ),

          _buildInputHeader("Adding as a"),
          Padding(
            padding: const EdgeInsets.all(14),
            child: Container(
              height: 33,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(color: const Color(0xFF0B0B0B), borderRadius: BorderRadius.circular(10)),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: selectedRole == "Choose" ? null : selectedRole,
                  hint: Text(selectedRole, style: const TextStyle(color: Color(0xFF626365), fontSize: 10)),
                  dropdownColor: const Color(0xFF141414),
                  isExpanded: true,
                  items: roles.map((r) => DropdownMenuItem(value: r, child: Text(r, style: const TextStyle(color: Colors.white, fontSize: 10)))).toList(),
                  onChanged: (val) => setState(() => selectedRole = val!),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageUploadCard() {
    return Container(
      width: double.infinity,
      decoration: ShapeDecoration(
        color: const Color(0xFF141414),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      child: Column(
        children: [
          _buildInputHeader("Add Images", showInfo: true),
          const SizedBox(height: 16),

          if (_selectedImages.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _selectedImages.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemBuilder: (context, index) {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.file(_selectedImages[index], fit: BoxFit.cover),
                  );
                },
              ),
            ),

          const SizedBox(height: 16),
          GestureDetector(
            onTap: _pickImages,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 14),
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 20),
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFF191919)),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Column(
                children: [
                  Icon(Icons.add_a_photo_outlined, color: Colors.white54),
                  SizedBox(height: 8),
                  Text('Select Images', style: TextStyle(color: Colors.white, fontSize: 10)),
                ],
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(14),
            child: _buildTextField(_descriptionController, "Describe your view", fontSize: 8),
          ),
        ],
      ),
    );
  }

  Widget _buildInputHeader(String title, {bool showInfo = false}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFF191919))),
      ),
      child: Row(
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: 10,),
          if (showInfo)
            const Padding(
              padding: EdgeInsets.only(top: 4.0),
              child: Icon(
                Icons.info_outline_rounded,
                color: Colors.white,
                size: 14,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hint, {double fontSize = 10}) {
    return Container(
      height: 33,
      decoration: BoxDecoration(color: const Color(0xFF0B0B0B), borderRadius: BorderRadius.circular(10)),
      child: TextField(
        controller: controller,
        style: TextStyle(color: Colors.white, fontSize: fontSize),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: const Color(0xFF626365), fontSize: fontSize),
          contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget _buildSelectionRow(String label, String? groupVal, Function(String) onTap) {
    bool isSelected = label == groupVal;
    return GestureDetector(
      onTap: () => onTap(label),
      child: Row(
        children: [
          Container(
            width: 16, height: 16,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: isSelected ? Colors.white : const Color(0xFF626365), width: 1),
              color: isSelected ? Colors.white : Colors.transparent,
            ),
            child: isSelected ? const Icon(Icons.check, size: 10, color: Colors.black) : null,
          ),
          const SizedBox(width: 10),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : const Color(0xFF626365),
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
