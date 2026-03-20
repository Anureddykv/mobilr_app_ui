import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CommunityJoinBottomSheet extends StatelessWidget {
  final String communityId;
  final String communityName;
  final String communityImageUrl;
  final String communityDescription;
  final String memberCount;
  final Color accentColor;
  final VoidCallback onSendRequest;

  const CommunityJoinBottomSheet({
    super.key,
    required this.communityId,
    required this.communityName,
    required this.communityImageUrl,
    required this.communityDescription,
    this.memberCount = "1200+ Members", // Default or pass dynamically
    required this.accentColor,
    required this.onSendRequest,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: const ShapeDecoration(
        color: Color(0xFF141414),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(26),
            topRight: Radius.circular(26),
          ),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          _buildDescription(),
          _buildJoinButton(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      height: 180,
      decoration: BoxDecoration(
        color: Colors.grey,
        image: DecorationImage(
          image: NetworkImage(communityImageUrl),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment(0.5, -0.0),
            end: Alignment(0.5, 1.0),
            colors: [Color(0x26141414), Color(0xFF141414)],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    communityName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontFamily: 'General Sans Variable',
                      fontWeight: FontWeight.w600,
                      height: 0.72
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    memberCount,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontFamily: 'General Sans Variable',
                      fontWeight: FontWeight.w400,
                        height: 0.72
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDescription() {
    return Padding(
      padding: const EdgeInsets.only( left:16, right:16 , top:16, bottom:8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Description',
            style: TextStyle(
              color: Color(0xFF3F3F3F),
              fontSize: 12,
              fontFamily: 'General Sans Variable',
              fontWeight: FontWeight.w600,
                height: 0.72
            ),
          ),
          const SizedBox(height: 8),
          Text(
            communityDescription,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontFamily: 'General Sans Variable',
              fontWeight: FontWeight.w400,
                height: 0.72
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildJoinButton() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 56,20,18),
      child: GestureDetector(
        onTap: onSendRequest,
        child: Container(
          width: double.infinity,
          height: 48,
          decoration: ShapeDecoration(
            color: accentColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          child: const Center(
            child: Text(
              'Send Join Request',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontFamily: 'General Sans Variable',
                fontWeight: FontWeight.w600,
                  height: 0.72
              ),
            ),
          ),
        ),
      ),
    );
  }
}
