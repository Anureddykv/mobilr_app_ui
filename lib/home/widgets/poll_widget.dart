import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/poll_controller.dart';
import '../models/poll_model.dart';

class PollWidget extends StatelessWidget {
  final PollModel poll;
  final PollController controller = Get.put(PollController());

  PollWidget({super.key, required this.poll});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final submitted = controller.hasSubmitted(poll.id);

      return Container(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF141414),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFF333333), width: 1.5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              poll.question,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),

            ...poll.options.map((option) {
              if (!submitted) {
                final isSelected = controller.isSelected(poll.id, option.id);
                return GestureDetector(
                  onTap: () => controller.selectOption(poll.id, option.id),
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.white : Colors.transparent,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected ? Colors.white : const Color(0xFF333333),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
                          color: isSelected ? Colors.black : Colors.white,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          option.text,
                          style: TextStyle(
                            color: isSelected ? Colors.black : Colors.white,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              } else {
                final percentage = controller.getPercentage(poll.id, option.id);
                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(option.text, style: const TextStyle(color: Colors.white, fontSize: 14)),
                      const SizedBox(height: 4),
                      Stack(
                        children: [
                          Container(
                            height: 20,
                            decoration: BoxDecoration(
                              color: Colors.grey[800],
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          Container(
                            height: 20,
                            width: MediaQuery.of(context).size.width * (percentage / 100),
                            decoration: BoxDecoration(
                              color: Colors.blueAccent,
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          Positioned.fill(
                            child: Center(
                              child: Text(
                                "${percentage.toStringAsFixed(1)}%",
                                style: const TextStyle(color: Colors.white, fontSize: 12),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              }
            }).toList(),

            const SizedBox(height: 16),
            if (!submitted)
              Center(
                child: ElevatedButton(
                  onPressed: () => controller.submitPoll(poll),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text("Submit"),
                ),
              ),
          ],
        ),
      );
    });
  }
}
