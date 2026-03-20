import '../models/poll_model.dart';

class PollData {
  static final moviePoll = PollModel(
    id: "p1",
    question: "How excited are you about the upcoming movie Akhanda 2?",
    options: [
      PollOption(id: "o1", text: "Super Excited"),
      PollOption(id: "o2", text: "Excited"),
      PollOption(id: "o3", text: "Neutral"),
      PollOption(id: "o4", text: "Somewhat Excited"),
      PollOption(id: "o5", text: "Not Really"),
    ],
  );

  static final restaurantPoll = PollModel(
    id: "p2",
    question: "Which cuisine do you want to try next weekend?",
    options: [
      PollOption(id: "o1", text: "Hyderabadi Biryani"),
      PollOption(id: "o2", text: "North Indian Thali"),
      PollOption(id: "o3", text: "Continental"),
      PollOption(id: "o4", text: "Chinese"),
      PollOption(id: "o5", text: "Street Food"),
    ],
  );

  static final gadgetPoll = PollModel(
    id: "p3",
    question: "Which gadget are you most excited about this year?",
    options: [
      PollOption(id: "o1", text: "Smartphones"),
      PollOption(id: "o2", text: "Laptops"),
      PollOption(id: "o3", text: "Wearables"),
      PollOption(id: "o4", text: "Smart Home Devices"),
    ],
  );

  static final bookPoll = PollModel(
    id: "p4",
    question: "Which book genre do you prefer?",
    options: [
      PollOption(id: "o1", text: "Fiction"),
      PollOption(id: "o2", text: "Non-Fiction"),
      PollOption(id: "o3", text: "Mystery/Thriller"),
      PollOption(id: "o4", text: "Sci-Fi/Fantasy"),
    ],
  );

  static final gamePoll = PollModel(
    id: "p5",
    question: "What type of games do you enjoy the most?",
    options: [
      PollOption(id: "o1", text: "Action/Adventure"),
      PollOption(id: "o2", text: "Strategy"),
      PollOption(id: "o3", text: "Sports/Racing"),
      PollOption(id: "o4", text: "Puzzle/Simulation"),
    ],
  );
}
