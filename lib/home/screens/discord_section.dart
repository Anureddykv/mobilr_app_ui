import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobilr_app_ui/home/widgets/HorizontalCardList.dart';
import 'package:mobilr_app_ui/widgets/discord_card.dart';

import 'discord_redirection_screen.dart';

class DiscordSection extends StatelessWidget {
  final List<Map<String, String>> servers;

  const DiscordSection({super.key, required this.servers});

  @override
  Widget build(BuildContext context) {
    return HorizontalCardList<Map<String, String>>(
      title: 'DISCORD SERVERS',
      items: servers,
      listHeight: 160,

      cardBuilder: (context, server) {
        return DiscordServerCard(
          title: server['name']!,
          description: server['desc']!,
          imageUrl: server['imageUrl']!,
          onJoin: () {
            Get.to(() => DiscordRedirectionScreen(
              serverName: server['name']!,
              serverImageUrl: /*server['imageUrl']!*/ "assets/images/Vector.png",
              serverInviteUrl: "https://discord.gg/${server['id']}",
            ));
          },
        );
      },

    );
  }
}
