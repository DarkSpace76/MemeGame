import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mems_game/components/app_text.dart';
import 'package:mems_game/controller/game_controller.dart';
import 'package:mems_game/model/player.dart';

Widget playerItem(Player player) {
  GameController gameController = Get.find();
  return Container(
    padding: const EdgeInsets.all(10),
    margin: const EdgeInsets.symmetric(vertical: 4),
    decoration: BoxDecoration(
        //border: Border.all(color: Colors.blue, width: 1),
        color: Colors.blue.withOpacity(0.035),
        borderRadius: BorderRadius.circular(10)),
    child: Row(children: [
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
      appText(
          text: player.name ?? '',
          customStyle: TextStyle(
              fontSize: 20,
              color: Colors.black,
              fontFamily: GoogleFonts.robotoSlab().fontFamily,
              fontWeight: FontWeight.w300)),
      Spacer(),
      CupertinoButton(
          padding: EdgeInsets.zero,
          child: Icon(Icons.person_remove, color: Colors.red),
          onPressed: () {
            gameController.removePlayer(player);
          })
    ]),
  );
}
