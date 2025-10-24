class PollOption {
  final String id;
  final String text;

  PollOption({required this.id, required this.text});
}

class PollModel {
  final String id;
  final String question;
  final List<PollOption> options;

  PollModel({
    required this.id,
    required this.question,
    required this.options,
  });
}

