import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:mems_game/components/app_text.dart';
import 'package:mems_game/components/button.dart';
import 'package:mems_game/components/player_item_from_add.dart';
import 'package:mems_game/controller/game_controller.dart';
import 'package:mems_game/model/player.dart';
import 'package:mems_game/responsive.dart';

class PlayerModeDialog extends StatefulWidget {
  GameController controller;
  PlayerModeDialog({Key? key, required this.controller}) : super(key: key);

  @override
  State<PlayerModeDialog> createState() => _PlayerModeDialogState();
}

class _PlayerModeDialogState extends State<PlayerModeDialog> {
  late FocusNode myFocusNode;

  @override
  void initState() {
    myFocusNode = FocusNode();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15), topRight: Radius.circular(15))),
      child: PageView(
        controller: widget.controller.pageController,
        physics: const NeverScrollableScrollPhysics(),
        scrollDirection: Axis.vertical,
        children: [
          if (!widget.controller.isPlayerMode)
            _pageViewFirst(widget.controller),
          _pageViewTwo(widget.controller, focusNode: myFocusNode)
        ],
      ),
    );
  }
}

Widget _pageViewFirst(GameController controller) {
  Widget adapriveBlock(List<Widget> child) {
    return Responsive(
        mobile: Column(children: child),
        desctop:
            Row(mainAxisAlignment: MainAxisAlignment.center, children: child),
        tablet: Row(children: child));
  }

  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      appText(text: 'Создать список игроков?', size: 30),
      const SizedBox(height: 20),
      adapriveBlock([
        skipButton(
            title: 'Нет?',
            onPress: () {
              controller.startGame();
              Get.back();
            }),
        button(
            title: 'Да',
            onPress: () {
              controller.playerModeOn();
              controller.nextPage();
            }),
      ])
    ],
  );
}

Widget _pageViewTwo(GameController controller,
    {required FocusNode? focusNode}) {
  TextEditingController playerTextController = TextEditingController();

  Widget adaptiveBlock(Widget child) {
    return Responsive(
        mobile: child,
        desctop: SizedBox(width: Get.width * 0.5, child: child),
        tablet: SizedBox(width: Get.width * 0.5, child: child));
  }

  return Obx(() =>
      Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        appText(text: 'Список игроков:', size: 30),
        Expanded(
            child: !controller.isPlayersEmpty()
                ? adaptiveBlock(ListView.builder(
                    itemCount: controller.playersLength(),
                    itemBuilder: (context, item) {
                      return playerItem(controller.getPlayerByIndex(item));
                    },
                  ))
                : _emptyHolder()),
        Container(
            constraints: const BoxConstraints(maxHeight: 100),
            decoration: const BoxDecoration(
                border: Border(top: BorderSide(color: Colors.blue, width: 1))),
            child: adaptiveBlock(Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                    child: _inputNamePlayer(playerTextController,
                        onEnterClick: () async {
                  controller
                      .addNewPlayer(Player(name: playerTextController.text));
                  playerTextController.clear();
                })),
                const SizedBox(width: 10),
                _addNewPlayerButton(onPress: () {
                  if (playerTextController.text.isNotEmpty) {
                    controller
                        .addNewPlayer(Player(name: playerTextController.text));
                    playerTextController.clear();
                  }
                }),
                _startGameButton(
                    onPress: controller.isPlayersNotEmpty()
                        ? () {
                            Get.back();
                            controller.startGame();
                          }
                        : null)
              ],
            )))
      ]));
}

Widget _emptyHolder() {
  Widget mobile() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.receipt_long, size: 70, color: Colors.grey.withOpacity(0.3)),
        const SizedBox(width: 15),
        appText(
            text: 'Список игроков пуст',
            size: 30,
            color: Colors.grey.withOpacity(0.3)),
      ],
    );
  }

  Widget descAndTablet() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.receipt_long, size: 70, color: Colors.grey.withOpacity(0.3)),
        const SizedBox(width: 15),
        appText(
            text: 'Список игроков пуст',
            size: 30,
            color: Colors.grey.withOpacity(0.3)),
      ],
    );
  }

  return Responsive(
    mobile: mobile(),
    tablet: descAndTablet(),
    desctop: descAndTablet(),
  );
}

Widget _addNewPlayerButton({Function()? onPress}) {
  return CupertinoButton(
    onPressed: onPress,
    child: const Icon(Icons.add),
  );
}

Widget _startGameButton({Function()? onPress}) {
  return CupertinoButton(
    onPressed: onPress,
    child: appText(text: 'Начать игру'),
  );
}

Widget _inputNamePlayer(TextEditingController controller,
    {Function()? onEnterClick, FocusNode? focusNode}) {
  return RawKeyboardListener(
    focusNode: FocusNode(),
    child: Padding(
      padding: const EdgeInsets.only(left: 10),
      child: TextFormField(
        controller: controller,
        maxLines: 1,
        autofocus: true,
        onFieldSubmitted: (str) {
          if (str.isNotEmpty) {
            if (onEnterClick != null) onEnterClick();
          }
        },
        style: const TextStyle(fontSize: 20),
        textAlignVertical: TextAlignVertical.center,
        decoration: const InputDecoration(
            border: InputBorder.none,
            hintText: 'Как их величать?',
            hintStyle: TextStyle(color: Colors.black38)),
      ),
    ),
  );
}
