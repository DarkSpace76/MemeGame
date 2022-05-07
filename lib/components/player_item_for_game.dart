import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mems_game/components/app_text.dart';
import 'package:mems_game/controller/game_controller.dart';
import 'package:mems_game/model/player.dart';
import 'package:mems_game/responsive.dart';

Widget playerItemFromGame(Player player) {
  GameController gameController = Get.find();
  return Container(
    padding: const EdgeInsets.all(10),
    margin: const EdgeInsets.symmetric(vertical: 4),
    decoration: BoxDecoration(
        border: gameController.isPlayer(player)
            ? Border.all(color: Colors.red, width: 1)
            : null,
        color: gameController.isPlayer(player)
            ? Colors.red.withOpacity(0.035)
            : Colors.blue.withOpacity(0.035),
        borderRadius: BorderRadius.circular(10)),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        gameController.isPlayer(player)
            ? appText(text: 'Играет:', size: 12, color: Colors.red)
            : const SizedBox(height: 10),
        Row(mainAxisSize: MainAxisSize.min, children: [
          if (!Responsive.isMobile(Get.context!))
            Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.blue, width: 1),
                  color: Colors.blue.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(360)),
              child: Center(
                child: appText(
                    text: player.name?.substring(0, 1).toUpperCase() ?? '',
                    size: 28,
                    color: Colors.black45),
              ),
            ),
          const SizedBox(width: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              appText(
                  text: player.name ?? '',
                  customStyle: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                      fontFamily: GoogleFonts.robotoSlab().fontFamily,
                      fontWeight: FontWeight.w300)),
              const SizedBox(height: 5),
              appText(
                  text: player.score.toString(),
                  customStyle: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                      fontFamily: GoogleFonts.robotoSlab().fontFamily,
                      fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(width: 30),
          CupertinoButton(
              padding: EdgeInsets.zero,
              child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(10)),
                  child: const Icon(Icons.add, color: Colors.white)),
              onPressed: () {
                gameController.incScore(player);
              })
        ]),
      ],
    ),
  );
}
