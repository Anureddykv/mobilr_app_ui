import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:mobilr_app_ui/home/bottomsheet/features_screen_community_info.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'package:mobilr_app_ui/utils/snackbar_utils.dart';

// --- Message Type Enum ---
enum MessageType { text, image, audio, file }

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
    // Rebuild the input field UI when text changes
    _messageController.addListener(() => setState(() {}));
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
  }

  @override
  void dispose() {
    // Correctly remove the listener before disposing the controller
    _messageController.removeListener(() => setState(() {}));
    _messageController.dispose();
    _scrollController.dispose();
    _recorder.closeRecorder();
    super.dispose();
  }

  void _loadPlaceholderMessages() {
    setState(() {
      _messages = [
        ChatMessage(
          id: '1',
          type: MessageType.text,
          text: 'Blockbuster incoming',
          userId: 'user1',
          userName: 'Vamsi',
          avatarUrl: "https://placehold.co/40x40/FFC0CB/000?text=V",
          timestamp: DateTime.now().subtract(const Duration(minutes: 50)),
          isMe: false,
        ),
        ChatMessage(
          id: '2',
          type: MessageType.text,
          text: 'Pushpa records break chesthadhi',
          userId: 'user2',
          userName: 'Anu',
          avatarUrl: "https://placehold.co/40x40/FFFFFF/000?text=A",
          timestamp: DateTime.now().subtract(const Duration(minutes: 45)),
          isMe: true,
        ),
      ];
    });
  }

  /// Adds a message to the list and scrolls to the bottom.
  void _addMessage(ChatMessage message) {
    setState(() {
      _messages.add(message);
    });
    // Use a post-frame callback to ensure the list has been updated
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom(animated: true));
  }

  /// Scrolls the chat list to the very bottom.
  void _scrollToBottom({bool animated = false}) {
    if (_scrollController.hasClients) {
      final position = _scrollController.position.maxScrollExtent;
      if (animated) {
        _scrollController.animateTo(
          position,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      } else {
        _scrollController.jumpTo(position);
      }
    }
  }

  /// Creates and sends a text message.
  void _sendTextMessage() {
    if (_messageController.text.trim().isEmpty) return;

    final newMessage = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      type: MessageType.text,
      text: _messageController.text.trim(),
      userId: currentUserId,
      userName: "You",
      avatarUrl: "https://placehold.co/40x40/FFFFFF/000000?text=Y",
      timestamp: DateTime.now(),
      isMe: true,
    );

    _addMessage(newMessage);
    _messageController.clear();
  }

  /// Creates and sends a message with a file (image, audio, or document).
  void _sendFileMessage(String path, MessageType type) {
    final newMessage = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      type: type,
      filePath: path,
      userId: currentUserId,
      userName: "You",
      avatarUrl: "https://placehold.co/40x40/FFFFFF/000000?text=Y",
      timestamp: DateTime.now(),
      isMe: true,
    );
    _addMessage(newMessage);
  }

  // --- Media & File Handling ---

  Future<void> _openCamera() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      _sendFileMessage(image.path, MessageType.image);
    }
  }

  Future<void> _openGallery() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      _sendFileMessage(image.path, MessageType.image);
    }
  }

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null && result.files.single.path != null) {
      _sendFileMessage(result.files.single.path!, MessageType.file);
    }
  }

  Future<void> _toggleRecording() async {
    var status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      SnackBarUtils.showTopSnackBar(context, "Microphone permission is required", isError: true);
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
      if (path != null) {
        _sendFileMessage(path, MessageType.audio);
      }
    }
  }

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
          onPressed: () {
            Get.back(); 
          },
        ),

        title: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: (){
            Get.to(() => FeaturesScreenCommunityInfo(
              communityName: widget.communityName,
              communityImageUrl: widget.communityImageUrl,
              memberCount: 1200,
            ));
          },
          child: Row(
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
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(color: appBarTopBorderColor, height: 1.0),
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
                final bool showHeader = index == 0 || _messages[index - 1].userId != message.userId;
                return _MessageBubble(message: message, showHeader: showHeader);
              },
            ),
          ),
          _buildMessageInputField(),
        ],
      ),
    );
  }

  Widget _buildCustomIconButton(String imagePath, {required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Image.asset(
          imagePath,
          width: 24,
          height: 24,
          color: communitySecondaryTextColor,
        ),
      ),
    );
  }

  Widget _buildMessageInputField() {
    final bool hasText = _messageController.text.trim().isNotEmpty;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF141414).withOpacity(0.95),
        border: const Border(top: BorderSide(width: 0.8, color: appBarTopBorderColor)),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
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
                  maxLines: 5,
                  minLines: 1,
                  onSubmitted: (_) => _sendTextMessage(),
                ),
              ),
            ),
            const SizedBox(width: 8),
            // Conditionally show Send or Media buttons
            if (hasText)
              IconButton(
                icon: const Icon(Icons.send, color: messageBubbleColorMe),
                onPressed: _sendTextMessage,
              )
            else
              Row(
                children: [
                  _buildCustomIconButton('assets/images/camera.png', onTap: _openCamera),
                  _buildCustomIconButton(
                    _isRecording ? 'assets/images/mice.png' : 'assets/images/mice.png',
                    onTap: _toggleRecording,
                  ),
                  _buildCustomIconButton('assets/images/plus.png', onTap: _openAttachmentOptions),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

class ChatMessage {
  final String id;
  final MessageType type;
  final String? text;
  final String? filePath;
  final String userId;
  final String userName;
  final String avatarUrl;
  final DateTime timestamp;
  final bool isMe;

  ChatMessage({
    required this.id,
    required this.type,
    this.text,
    this.filePath,
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

  /// Builds the content of the bubble based on the message type.
  Widget _buildBubbleContent() {
    Color bubbleColor = message.isMe ? messageBubbleColorMe : messageBubbleColorOther;
    Color textColor = message.isMe ? Colors.white : communityPrimaryTextColor;

    switch (message.type) {
      case MessageType.text:
        return _TextBubble(
          text: message.text ?? '',
          timestamp: message.timestamp,
          bubbleColor: bubbleColor,
          textColor: textColor,
          isMe: message.isMe,
        );
      case MessageType.image:
        return _ImageBubble(
          filePath: message.filePath!,
          timestamp: message.timestamp,
          isMe: message.isMe,
        );
      case MessageType.audio:
      case MessageType.file:
        return _FileBubble(
          filePath: message.filePath!,
          timestamp: message.timestamp,
          bubbleColor: bubbleColor,
          textColor: textColor,
          isAudio: message.type == MessageType.audio,
        );
      default:
        return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMe = message.isMe;
    final messageHeader = showHeader
        ? Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: Text(
        message.userName,
        style: const TextStyle(
          color: communitySecondaryTextColor,
          fontSize: 12,
          fontWeight: FontWeight.w500,
          fontFamily: 'General Sans Variable',
        ),
      ),
    )
        : const SizedBox.shrink();

    return Padding(
      padding: EdgeInsets.only(top: showHeader ? 12.0 : 4.0),
      child: Row(
        mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isMe && showHeader)
            CircleAvatar(
              backgroundImage: NetworkImage(message.avatarUrl),
              radius: 16,
            )
          else if (!isMe && !showHeader)
            const SizedBox(width: 32), // Spacer for alignment

          if (!isMe) const SizedBox(width: 8),
          Flexible(
            child: Column(
              crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                if (!isMe && showHeader) messageHeader,
                _buildBubbleContent(),
              ],
            ),
          ),
          if (isMe) const SizedBox(width: 8),
          if (isMe && showHeader)
            CircleAvatar(
              backgroundImage: NetworkImage(message.avatarUrl),
              radius: 16,
            )
          else if (isMe && !showHeader)
            const SizedBox(width: 32), // Spacer
        ],
      ),
    );
  }
}

// --- Bubble Content Widgets ---

class _TextBubble extends StatelessWidget {
  final String text;
  final DateTime timestamp;
  final Color bubbleColor;
  final Color textColor;
  final bool isMe;

  const _TextBubble({
    required this.text,
    required this.timestamp,
    required this.bubbleColor,
    required this.textColor,
    required this.isMe,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: bubbleColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            text,
            style: TextStyle(color: textColor, fontSize: 14, fontFamily: 'General Sans Variable'),
          ),
          const SizedBox(height: 4),
          Text(
            DateFormat('h:mm a').format(timestamp),
            style: TextStyle(
              color: isMe ? Colors.white.withOpacity(0.7) : communitySecondaryTextColor,
              fontSize: 10,
              fontFamily: 'General Sans Variable',
            ),
          ),
        ],
      ),
    );
  }
}

class _ImageBubble extends StatelessWidget {
  final String filePath;
  final DateTime timestamp;
  final bool isMe;

  const _ImageBubble({required this.filePath, required this.timestamp, required this.isMe});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.6),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          alignment: Alignment.bottomRight,
          children: [
            Image.file(File(filePath)),
            Padding(
              padding: const EdgeInsets.all(6.0),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  DateFormat('h:mm a').format(timestamp),
                  style: const TextStyle(color: Colors.white, fontSize: 10),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FileBubble extends StatelessWidget {
  final String filePath;
  final DateTime timestamp;
  final Color bubbleColor;
  final Color textColor;
  final bool isAudio;

  const _FileBubble({
    required this.filePath,
    required this.timestamp,
    required this.bubbleColor,
    required this.textColor,
    required this.isAudio,
  });

  @override
  Widget build(BuildContext context) {
    final fileName = filePath.split('/').last;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: bubbleColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(isAudio ? Icons.graphic_eq : Icons.insert_drive_file, color: textColor, size: 28),
          const SizedBox(width: 10),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  fileName,
                  style: TextStyle(color: textColor, fontSize: 14, fontFamily: 'General Sans Variable'),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  DateFormat('h:mm a').format(timestamp),
                  style: TextStyle(color: textColor.withOpacity(0.7), fontSize: 10),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
