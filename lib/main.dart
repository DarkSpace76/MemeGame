import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mems_game/components/app_text.dart';
import 'package:mems_game/components/button.dart';
import 'package:mems_game/components/player_item_for_game.dart';
import 'package:mems_game/controller/game_controller.dart';
import 'package:mems_game/dialog/player_mode_dlg.dart';
import 'package:mems_game/responsive.dart';

void main() {
  Get.put(GameController());
  runApp(const MyGame());
}

class MyGame extends StatelessWidget {
  const MyGame({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  GameController gameController = Get.find();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Obx(() {
        if (gameController.isGameState == GameState.play) {
          return GameSheet();
        }
        return startSheet();
      }),
    );
  }
}

class GameSheet extends StatelessWidget {
  GameController gameController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Obx(() => !gameController.isLoadingQuestion()
        ? Stack(
            children: [
              Column(
                children: [
                  Expanded(
                    flex: 8,
                    child: GestureDetector(
                      onTap: () {
                        gameController.nextQuest();
                      },
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: gameText(
                              context: context,
                              text: gameController.getQuest()),
                        ),
                      ),
                    ),
                  ),
                  if (gameController.isPlayerMode)
                    Expanded(
                      flex: Responsive.isMobile(Get.context!) ? 5 : 2,
                      child: SingleChildScrollView(
                        child: Wrap(
                          runSpacing: 20,
                          spacing: 20,
                          children: gameController
                              .getPlayer()
                              .map((e) => playerItemFromGame(e))
                              .toList(),
                        ),
                      ),
                    )
                ],
              ),
              Positioned(
                  top: 10,
                  right: 10,
                  child: skipButton(
                      title: 'Завершить',
                      borderColor: Colors.grey.withOpacity(0.3),
                      textColor: Colors.grey.withOpacity(0.3),
                      onPress: () {
                        gameController.endGame();
                      })),
            ],
          )
        : const Center(child: CircularProgressIndicator()));
  }
}

Widget startSheet() {
  GameController gameController = Get.find();

  return SizedBox(
    width: double.infinity,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(child: Image.asset('assets/images/logo.jpg')),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 40),
          child: SizedBox(
              height: 80,
              width: 300,
              child: InkWell(
                //padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                borderRadius: BorderRadius.circular(15),
                onTap: () {
                  if (gameController.isPlayerMode &&
                      gameController.isPlayersNotEmpty()) {
                    gameController.startGame();
                  } else {
                    Get.bottomSheet(
                        PlayerModeDialog(controller: gameController));
                  }
                },
                child: Center(
                    child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const FlutterLogo(
                      size: 30,
                    ),
                    const SizedBox(width: 15),
                    appText(
                        text: 'Start Game',
                        customStyle: TextStyle(
                            fontSize: 30,
                            color: Colors.black,
                            fontFamily: GoogleFonts.robotoSlab().fontFamily,
                            fontWeight: FontWeight.bold)),
                  ],
                )),
              )),
        ),
      ],
    ),
  );
}
