import 'dart:math';
import 'package:get/get.dart';
import '../models/poll_model.dart';

class PollController extends GetxController {
  var selectedOptions = <String, String>{}.obs;
  var pollResults = <String, Map<String, double>>{}.obs;

  void selectOption(String pollId, String optionId) {
    selectedOptions[pollId] = optionId;
  }

  bool isSelected(String pollId, String optionId) {
    return selectedOptions[pollId] == optionId;
  }

  void submitPoll(PollModel poll) {
    final selected = selectedOptions[poll.id];
    if (selected == null) return;

    final random = Random();
    double selectedPercent = (40 + random.nextInt(20)) as double;
    double remaining = 100 - selectedPercent;

    List<double> others = List.generate(poll.options.length - 1, (_) => random.nextDouble());
    double sum = others.fold(0, (a, b) => a + b);
    others = others.map((o) => (o / sum) * remaining).toList();

    final result = <String, double>{};
    for (int i = 0, j = 0; i < poll.options.length; i++) {
      if (poll.options[i].id == selected) {
        result[poll.options[i].id] = selectedPercent;
      } else {
        result[poll.options[i].id] = others[j++];
      }
    }

    pollResults[poll.id] = result;
  }

  bool hasSubmitted(String pollId) {
    return pollResults.containsKey(pollId);
  }

  double getPercentage(String pollId, String optionId) {
    return pollResults[pollId]?[optionId] ?? 0;
  }
}
