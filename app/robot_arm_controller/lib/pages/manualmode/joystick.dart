import 'package:flutter/material.dart';
import 'package:flutter_joystick/flutter_joystick.dart';
import 'package:robot_arm_controller/pages/manualmode/ball.dart';
import 'package:robot_arm_controller/pages/manualmode/ballProperties.dart';
import 'package:robot_arm_controller/pages/manualmode/joysticModeDropdown.dart';

import 'ManualMoveControll.dart';

BallProperties properties = BallProperties();

class BasicJoystick extends StatefulWidget {
  const BasicJoystick({super.key});

  @override
  State<BasicJoystick> createState() => _JoystickExampleState();
}

class _JoystickExampleState extends State<BasicJoystick> {
  // JoystickMode _joystickMode = JoystickMode.all;
  String _statusMessage = '자동 제어 시작';

  // 조이스틱 움직임에 따른 함수 동작 예제 구현
  void moveUp() {
    print('Move Up');
  }
  void moveDown() {
    print('Move Down');
  }
  void moveLeft() {
    print('Move Left');
  }
  void moveRight() {
    print('Move Right');
  }
  void moveStop() {
    print('Move Stop');
  }
  Future<void> sendRequestStop() async {
    final HttpService httpService = HttpService('http://192.168.0.11:8000/move_motor/11/stop');
    setState(() {
      _statusMessage = '정지 중 ...';
    });

    final result = await httpService.sendRequest();
    setState(() {
      _statusMessage = result;
    });
    print('Move Stop');
  }
  // 조이스틱 움직임에 따른 함수 동작 예제 구현

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        // 상하좌우만 동작하도록 구현, 만약 다른 방향 동작이 필요할 때 추석해제 하면 됨.
        // actions: [
        //   JoystickModeDropdown(
        //     mode: _joystickMode,
        //     onChanged: (JoystickMode value) {
        //       setState(() {
        //         _joystickMode = value;
        //       });
        //     },
        //   ),
        // ],
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Align(
              alignment: const Alignment(0, 0.8),
              child: Joystick(
                mode: JoystickMode.horizontalAndVertical,
                listener: (details) {
                  // 조이스틱 방향에 따른 동작
                  if (details.y > 0.5) {
                    moveDown();
                  } else if (details.y < -0.5) {
                    moveUp();
                  } else if (details.x > 0.5) {
                    moveRight();
                  } else if (details.x < -0.5) {
                    moveLeft();
                  } else if (details.x == 0 || details.y == 0) {
                    moveStop();
                    sendRequestStop();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
