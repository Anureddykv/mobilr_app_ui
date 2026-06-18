# StarNest Event Tracking System

A clean, non-intrusive analytics/event layer for StarNest.

## Setup

Initialize the tracker once at app start in `main.dart`:

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  StarNestTracker.instance.init();
  runApp(const MyApp());
}
```

## Auth

Update auth state when the user logs in or out:

```dart
// After login
StarNestTracker.instance.sessionStart(
  token: response.token,
  userId: response.userId,
  sessionId: '...',
);

// After logout
StarNestTracker.instance.sessionEnd(
  userId: currentUserId,
  sessionId: '...',
);
```

## Impression Tracking

Impression tracking requires a 1-second visibility timer. Implement it in your widget like this:

```dart
Timer? _impressionTimer;

@override
void initState() {
  super.initState();
  _impressionTimer = Timer(const Duration(seconds: 1), () {
    if (mounted) {
      StarNestTracker.instance.trackImpression(
        module: 'movies/movie',
        itemId: widget.movie.id,
        userId: currentUserId,
        section: 'trending',
        position: widget.position,
      );
    }
  });
}

@override
void dispose() {
  _impressionTimer?.cancel();
  super.dispose();
}
```

## Verifying Events

Open the Flutter DevTools console and filter by `StarNest Tracker` to see all fired events.

Logs follow this format:
- `🌟 StarNest Tracker | EVENT: impression | TARGET: item | ID: abc123`
- `🌟 StarNest Tracker | POST /api/movies/movie/abc123/click → 200 OK`
- `🌟 StarNest Tracker | ❌ ERROR /api/events → SocketException: ...`

## Module Reference

Use these module paths for `trackClick`, `trackImpression`, etc.:

| Content Type | Module Path |
|--------------|-------------|
| Movies       | movies/movie|
| Games        | games       |
| Books        | books       |
| Gadgets      | gadgets     |
| Restaurants  | restaurants |

## Validations

Some events have mandatory fields that will trigger an `AssertionError` in **DEBUG** mode if missing:

| Event | Required Field |
|-------|----------------|
| `trackShare` | `channel` |
| `trackReport` | `reason` |
| `trackSearch` | `query` |
| `trackRating` | `value` (1-10) |
| `trackCommentReport` | `reason` |
