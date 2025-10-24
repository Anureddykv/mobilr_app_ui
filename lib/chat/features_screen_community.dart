import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';

// --- Colors ---
const Color communityScreenBackgroundColor = Color(0xFF0B0B0B);
const Color communityAppBarColor = Color(0xFF1E1E1E);
const Color messageBubbleColorMe = Color(0xFF436BEF);
const Color messageBubbleColorOther = Color(0xFF141414);
const Color communityPrimaryTextColor = Color(0xFFE6EAED);
const Color communitySecondaryTextColor = Color(0xFF626365);
const Color appBarTopBorderColor = Color(0xFF191919);

// --- Text Styles ---
const TextStyle appBarTitleStyle = TextStyle(
  color: Colors.white,
  fontSize: 18,
  fontFamily: 'General Sans Variable',
  fontWeight: FontWeight.w600,
);

const TextStyle appBarSubtitleStyle = TextStyle(
  color: communitySecondaryTextColor,
  fontSize: 12,
  fontFamily: 'General Sans Variable',
  fontWeight: FontWeight.w400,
);

class FeaturesScreenCommunity extends StatefulWidget {
  final String communityId;
  final String communityName;
  final String communityImageUrl;

  const FeaturesScreenCommunity({
    super.key,
    required this.communityId,
    required this.communityName,
    required this.communityImageUrl,
  });

  @override
  State<FeaturesScreenCommunity> createState() =>
      _FeaturesScreenCommunityState();
}

class _FeaturesScreenCommunityState extends State<FeaturesScreenCommunity> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FlutterSoundRecorder _recorder = FlutterSoundRecorder();
  bool _isRecording = false;

  final String currentUserId = "currentUser123";
  List<ChatMessage> _messages = [];

  @override
  void initState() {
    super.initState();
    _loadPlaceholderMessages();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
    });
  }

  void _loadPlaceholderMessages() {
    setState(() {
      _messages = [
        ChatMessage(
            id: '1',
            text: 'Blockbuster incoming',
            userId: 'user1',
            userName: 'Vamsi',
            avatarUrl: "https://placehold.co/40x40/FFC0CB/000?text=V",
            timestamp: DateTime.now().subtract(const Duration(minutes: 50)),
            isMe: false),
        ChatMessage(
            id: '2',
            text: 'Pushpa records break chesthadhi',
            userId: 'user2',
            userName: 'Anu',
            avatarUrl: "https://placehold.co/40x40/FFFFFF/000?text=A",
            timestamp: DateTime.now().subtract(const Duration(minutes: 45)),
            isMe: true),
      ];
    });
  }

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;

    final newMessage = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: _messageController.text.trim(),
      userId: currentUserId,
      userName: "You",
      avatarUrl: "https://placehold.co/40x40/FFFFFF/000000?text=Y",
      timestamp: DateTime.now(),
      isMe: true,
    );

    setState(() {
      _messages.add(newMessage);
      _messageController.clear();
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  // 📷 Open Camera
  Future<void> _openCamera() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      print("📷 Picked image: ${image.path}");
      // Here you could send the image as message
    }
  }

  // 🖼️ Open Gallery
  Future<void> _openGallery() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      print("🖼️ Picked gallery image: ${image.path}");
    }
  }

  // 📁 Pick File
  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null && result.files.single.path != null) {
      File file = File(result.files.single.path!);
      print("📁 Picked file: ${file.path}");
    }
  }

  // 🎤 Record Audio
  Future<void> _toggleRecording() async {
    var status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      Get.snackbar("Permission Denied", "Microphone permission is required");
      return;
    }

    if (!_isRecording) {
      Directory tempDir = await getTemporaryDirectory();
      String filePath = '${tempDir.path}/audio_${DateTime.now().millisecondsSinceEpoch}.aac';

      await _recorder.openRecorder();
      await _recorder.startRecorder(toFile: filePath);
      setState(() => _isRecording = true);
    } else {
      final path = await _recorder.stopRecorder();
      await _recorder.closeRecorder();
      setState(() => _isRecording = false);
      print("🎤 Recorded audio: $path");
    }
  }

  // ➕ Bottom Sheet for Attachments
  void _openAttachmentOptions() {
    showModalBottomSheet(
      backgroundColor: const Color(0xFF1C1C1C),
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt, color: Colors.white),
                title: const Text("Camera", style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.pop(context);
                  _openCamera();
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library, color: Colors.white),
                title: const Text("Gallery", style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.pop(context);
                  _openGallery();
                },
              ),
              ListTile(
                leading: const Icon(Icons.insert_drive_file, color: Colors.white),
                title: const Text("Files", style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.pop(context);
                  _pickFile();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: communityScreenBackgroundColor,
      appBar: AppBar(
        backgroundColor: communityAppBarColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(widget.communityImageUrl),
              radius: 20,
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.communityName, style: appBarTitleStyle),
                const Text('8 Online', style: appBarSubtitleStyle),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onPressed: () {},
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(
            color: appBarTopBorderColor,
            height: 1.0,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 18.0),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                final bool showHeader =
                    index == 0 || _messages[index - 1].userId != message.userId;
                return _MessageBubble(message: message, showHeader: showHeader);
              },
            ),
          ),
          _buildMessageInputField(),
        ],
      ),
    );
  }

  Widget _buildMessageInputField() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF141414).withOpacity(0.95),
        border: const Border(
          top: BorderSide(width: 0.8, color: appBarTopBorderColor),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            // 📝 Text input
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFF0B0B0B),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: TextField(
                  controller: _messageController,
                  style: const TextStyle(
                    color: communityPrimaryTextColor,
                    fontSize: 14,
                    fontFamily: 'General Sans Variable',
                  ),
                  decoration: const InputDecoration(
                    hintText: 'Type here',
                    hintStyle: TextStyle(
                      color: communitySecondaryTextColor,
                      fontSize: 14,
                      fontFamily: 'General Sans Variable',
                    ),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  onSubmitted: (_) => _sendMessage(),
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.camera_alt_outlined,
                  color: communitySecondaryTextColor, size: 24),
              onPressed: _openCamera,
            ),
            IconButton(
              icon: Icon(
                _isRecording ? Icons.stop_circle : Icons.mic_none_rounded,
                color: _isRecording ? Colors.redAccent : communitySecondaryTextColor,
                size: 24,
              ),
              onPressed: _toggleRecording,
            ),
            IconButton(
              icon: const Icon(Icons.add,
                  color: communitySecondaryTextColor, size: 26),
              onPressed: _openAttachmentOptions,
            ),
          ],
        ),
      ),
    );
  }
}

class ChatMessage {
  final String id;
  final String text;
  final String userId;
  final String userName;
  final String avatarUrl;
  final DateTime timestamp;
  final bool isMe;

  ChatMessage({
    required this.id,
    required this.text,
    required this.userId,
    required this.userName,
    required this.avatarUrl,
    required this.timestamp,
    required this.isMe,
  });
}

class _MessageBubble extends StatelessWidget {
  final ChatMessage message;
  final bool showHeader;

  const _MessageBubble({required this.message, required this.showHeader});

  @override
  Widget build(BuildContext context) {
    final isMe = message.isMe;

    final bubbleContent = Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: isMe ? messageBubbleColorMe : messageBubbleColorOther,
        borderRadius: isMe
            ? const BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
          bottomLeft: Radius.circular(12),
        )
            : const BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
          bottomRight: Radius.circular(12),
        ),
      ),
      child: Column(
        crossAxisAlignment:
        isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            message.text,
            style: TextStyle(
              color: isMe ? Colors.white : communityPrimaryTextColor,
              fontSize: 14,
              fontFamily: 'General Sans Variable',
            ),
          ),
          const SizedBox(height: 4),
          Text(
            DateFormat('h:mm a').format(message.timestamp),
            style: TextStyle(
              color: isMe
                  ? Colors.white.withOpacity(0.7)
                  : communitySecondaryTextColor,
              fontSize: 10,
              fontFamily: 'General Sans Variable',
            ),
          ),
        ],
      ),
    );

    return Padding(
      padding: EdgeInsets.only(top: showHeader ? 18.0 : 8.0),
      child: Row(
        mainAxisAlignment:
        isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isMe)
            Opacity(
              opacity: showHeader ? 1.0 : 0.0,
              child: CircleAvatar(
                backgroundImage: NetworkImage(message.avatarUrl),
                radius: 14,
              ),
            ),
          if (!isMe) const SizedBox(width: 9),
          Flexible(
            child: bubbleContent,
          ),
          if (isMe) const SizedBox(width: 9),
          if (isMe)
            CircleAvatar(
              backgroundImage: NetworkImage(message.avatarUrl),
              radius: 14,
            ),
        ],
      ),
    );
  }
}
