import 'package:flutter/material.dart';

// --- Color Palette from Figma ---
const Color darkBackgroundColor = Color(0xFF0B0B0B);
const Color cardBackgroundColor = Color(0xFF141414);
const Color primaryTextColor = Colors.white;
const Color secondaryTextColor = Color(0xFFCBCBCB);
const Color defaultIconColor = Color(0xFF54B6E0);
const Color ratingBackgroundColor = Color(0xFF1E1E1E);
const Color dividerColor = Color(0xFF191919);

// --- Data Models for Comments ---

class Comment {
  final String author;
  final String date;
  final double rating;
  final String title;
  final String content;
  final int likes;
  final int replies;
  final String authorAvatarUrl;

  const Comment({
    required this.author,
    required this.date,
    required this.rating,
    required this.title,
    required this.content,
    required this.likes,
    required this.replies,
    required this.authorAvatarUrl,
  });
}

// --- Main Comments Screen Widget ---

class CommentsScreen extends StatelessWidget {
  final String itemTitle;
  final List<Comment> comments;
  final String iconAssetPath;
  final Color iconColor;

  const CommentsScreen({
    super.key,
    required this.itemTitle,
    required this.comments,
    this.iconAssetPath = "assets/images/restaurants.png",
    this.iconColor = defaultIconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkBackgroundColor,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: primaryTextColor, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Comments for $itemTitle',
          style: const TextStyle(
            color: primaryTextColor,
            fontSize: 14,
            fontFamily: 'General Sans Variable',
            fontWeight: FontWeight.w600,
          ),
          overflow: TextOverflow.ellipsis,
        ),
        backgroundColor: ratingBackgroundColor,
        elevation: 0,
        centerTitle: false,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(color: dividerColor, height: 1.0),
        ),
      ),
      body: comments.isEmpty
          ? const Center(
        child: Text(
          'No comments available.',
          style: TextStyle(color: secondaryTextColor, fontSize: 14,fontFamily: 'General Sans Variable'),
        ),
      )
          : Padding(
        padding: const EdgeInsets.all(18.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12.0),
          child: ListView.separated(
            itemCount: comments.length,
            itemBuilder: (context, index) {
              return _CommentCard(
                comment: comments[index],
                iconAssetPath: iconAssetPath,
                iconColor: iconColor,

              );
            },
            separatorBuilder: (context, index) => const Divider(
              color: dividerColor,
              height: 1,
            ),
          ),
        ),
      ),
    );
  }
}

// --- Comment Card (with Like/Dislike Buttons using Assets) ---

class _CommentCard extends StatefulWidget {
  final Comment comment;
  final String iconAssetPath;
  final Color iconColor;

  const _CommentCard({
    required this.comment,
    required this.iconAssetPath,
    required this.iconColor,
  });

  @override
  State<_CommentCard> createState() => _CommentCardState();
}

class _CommentCardState extends State<_CommentCard> {
  late int displayLikes;
  late int displayDislikes;
  bool isLiked = false;
  bool isDisliked = false;

  @override
  void initState() {
    super.initState();
    displayLikes = widget.comment.likes;
    displayDislikes = widget.comment.replies;
  }

  void _handleReviewInteraction(String id, bool isLike) {
    setState(() {
      if (isLike) {
        if (isLiked) {
          isLiked = false;
          displayLikes--;
        } else {
          isLiked = true;
          displayLikes++;
          if (isDisliked) {
            isDisliked = false;
            displayDislikes--;
          }
        }
      } else {
        if (isDisliked) {
          isDisliked = false;
          displayDislikes--;
        } else {
          isDisliked = true;
          displayDislikes++;
          if (isLiked) {
            isLiked = false;
            displayLikes--;
          }
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final comment = widget.comment;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 20),
      decoration: const BoxDecoration(
        color: cardBackgroundColor,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 20,
            backgroundImage: NetworkImage(comment.authorAvatarUrl),
            backgroundColor: secondaryTextColor,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildCardHeader(comment),
                const SizedBox(height: 14),
                _buildCardBody(comment),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCardHeader(Comment comment) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              comment.author,
              style: const TextStyle(
                color: primaryTextColor,
                fontSize: 14,
                fontWeight: FontWeight.w600,
                fontFamily: 'General Sans Variable',
              ),
            ),
            const SizedBox(height: 4),
            Text(
              comment.date,
              style: const TextStyle(
                color: secondaryTextColor,
                fontSize: 10,
                fontFamily: 'General Sans Variable',
              ),
            ),
          ],
        ),
        _StarRating(
          rating: comment.rating,
          iconAssetPath: widget.iconAssetPath,
          iconColor: widget.iconColor,
        ),
      ],
    );
  }

  Widget _buildCardBody(Comment comment) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          comment.title,
          style: const TextStyle(
            color: primaryTextColor,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          comment.content,
          style: const TextStyle(
            color: primaryTextColor,
            fontSize: 10,
            fontWeight: FontWeight.w500,
            height: 1.5,
          ),
        ),
        const SizedBox(height: 16),
        // --- Like / Dislike Buttons using Asset Icons ---
        Row(
          children: [
            _buildLikeDislikeButton(
              filledIconPath: "assets/images/thum_up.png",
              outlinedIconPath: "assets/images/thum_up.png",
              count: displayLikes,
              isToggled: isLiked,
              activeColor: widget.iconColor,
              onPressed: () => _handleReviewInteraction(comment.author, true),
            ),
            const SizedBox(width: 16),
            _buildLikeDislikeButton(
              filledIconPath: "assets/images/thum_down.png",
              outlinedIconPath: "assets/images/thum_down.png",
              count: displayDislikes,
              isToggled: isDisliked,
              activeColor: widget.iconColor,
              onPressed: () => _handleReviewInteraction(comment.author, false),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildLikeDislikeButton({
    required String filledIconPath,
    required String outlinedIconPath,
    required int count,
    required bool isToggled,
    required VoidCallback onPressed,
    required Color activeColor,
  }) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(8),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            isToggled ? filledIconPath : outlinedIconPath,
            width: 16,
            height: 16,
            color: isToggled ? activeColor : secondaryTextColor,
          ),
          const SizedBox(width: 6),
          Text(
            count.toString(),
            style: TextStyle(
              color: isToggled ? activeColor : secondaryTextColor,
              fontSize: 12,
              fontFamily: 'General Sans Variable',
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}

// --- Custom Star Rating Widget ---

class _StarRating extends StatelessWidget {
  final double rating;
  final String iconAssetPath;
  final Color iconColor;

  const _StarRating({
    required this.rating,
    required this.iconAssetPath,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      decoration: BoxDecoration(
        color: ratingBackgroundColor,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            rating.toStringAsFixed(1),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: 6),
          _buildStars(),
        ],
      ),
    );
  }

  Widget _buildStars() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        int fullStars = rating.floor();
        double fraction = rating - fullStars;
        Widget star;

        if (index < fullStars) {
          star = Image.asset(iconAssetPath, color: iconColor, width: 12, height: 12);
        } else if (index == fullStars && fraction >= 0.25) {
          star = Stack(
            children: [
              Image.asset(iconAssetPath, color: const Color(0xFF3F3F3F), width: 12, height: 12),
              ClipRect(
                child: Align(
                  alignment: Alignment.centerLeft,
                  widthFactor: fraction,
                  child: Image.asset(iconAssetPath, color: iconColor, width: 12, height: 12),
                ),
              ),
            ],
          );
        } else {
          star = Image.asset(iconAssetPath, color: const Color(0xFF3F3F3F), width: 12, height: 12);
        }
        return Padding(
          padding: const EdgeInsets.only(right: 1.0),
          child: star,
        );
      }),
    );
  }
}
