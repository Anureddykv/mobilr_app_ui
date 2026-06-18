import 'dart:async';
import '../tracking_client.dart';

mixin CommentEvents {
  void trackCommentCreate({
    required String targetId,
    required String text,
    String? userId,
  }) {
    unawaited(TrackingClient.instance.post('/api/comments', {
      "userId": userId ?? TrackingClient.instance.userId,
      "targetId": targetId,
      "text": text,
    }));
  }

  void trackCommentReply({
    required String commentId,
    required String text,
    String? userId,
  }) {
    unawaited(TrackingClient.instance.post('/api/comments/$commentId/reply', {
      "userId": userId ?? TrackingClient.instance.userId,
      "text": text,
    }));
  }

  void trackCommentEdit({
    required String commentId,
    required String text,
  }) {
    unawaited(TrackingClient.instance.put('/api/comments/$commentId', {
      "text": text,
    }));
  }

  void trackCommentDelete({
    required String commentId,
    String? userId,
  }) {
    unawaited(TrackingClient.instance.delete('/api/comments/$commentId', {
      "userId": userId ?? TrackingClient.instance.userId,
    }));
  }

  void trackCommentReport({
    required String commentId,
    required String reason,
    String? userId,
  }) {
    assert(reason.isNotEmpty, 'reason is required for trackCommentReport');
    unawaited(TrackingClient.instance.post('/api/comments/$commentId/report', {
      "user_id": userId ?? TrackingClient.instance.userId,
      "reason": reason,
    }));
  }

  void trackReactionAdd({
    required String commentId,
    String? userId,
  }) {
    unawaited(TrackingClient.instance.put('/api/comments/$commentId/like', {
      "user_id": userId ?? TrackingClient.instance.userId,
    }));
  }

  void trackReactionRemove({
    required String commentId,
    String? userId,
  }) {
    unawaited(TrackingClient.instance.delete('/api/comments/$commentId/like', {
      "user_id": userId ?? TrackingClient.instance.userId,
    }));
  }
}
