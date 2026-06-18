import 'tracking_client.dart';
import 'events/app_events.dart';
import 'events/session_events.dart';
import 'events/item_events.dart';
import 'events/feedback_events.dart';
import 'events/comment_events.dart';
import 'events/search_events.dart';
import 'events/tag_events.dart';

class StarNestTracker with 
    AppEvents, 
    SessionEvents, 
    ItemEvents, 
    FeedbackEvents, 
    CommentEvents, 
    SearchEvents, 
    TagEvents {
  
  static final StarNestTracker instance = StarNestTracker._internal();

  StarNestTracker._internal();

  void init({String? userId, String? token}) {
    if (token != null && userId != null) {
      TrackingClient.instance.setAuth(token, userId);
    }
  }

  // Common aliases or helper methods can go here if needed
}
