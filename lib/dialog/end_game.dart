import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mems_game/components/app_text.dart';
import 'package:mems_game/components/button.dart';
import 'package:mems_game/controller/game_controller.dart';
import 'package:mems_game/model/player.dart';
import 'package:mems_game/responsive.dart';

enum DialogResult { end, resume }

AlertDialog endGameDialog() {
  return AlertDialog(
    content: _content(),
  );
}

Widget _content() {
  GameController gameController = Get.find();
  List<Player> resultTabel = [];
  resultTabel.addAll(gameController.getPlayer());
  resultTabel.sort((a, b) => b.score.compareTo(a.score));
  return Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      appText(text: 'Завершить игру?'),
      const SizedBox(height: 15),
      SingleChildScrollView(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          for (var player in resultTabel)
            Container(
              height: 45,
              child: Row(
                children: [
                  Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.blue, width: 1),
                        color: Colors.blue.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(360)),
                    child: Center(
                      child: appText(
                          text: player.name?.substring(0, 1) ?? '',
                          size: 28,
                          color: Colors.black45),
                    ),
                  ),
                  const Spacer(),
                  appText(text: player.score.toString())
                ],
              ),
            ),
        ]),
      ),
      if (Responsive.isMobile(Get.context!))
        Column(mainAxisSize: MainAxisSize.min, children: _dialogButton)
      else
        Row(children: _dialogButton)
    ],
  );
}

List<Widget> get _dialogButton => [
      skipButton(title: 'Продолжить', onPress: () => Get.back<DialogResult>()),
      button(
          title: 'Завершить',
          onPress: () => Get.back<DialogResult>(result: DialogResult.end)),
    ];
