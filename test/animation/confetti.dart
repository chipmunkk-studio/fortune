//                import 'package:confetti/confetti.dart';
// import 'package:flutter/material.dart';
//
// main() {
//   runApp(
//     const MaterialApp(
//         // 기본적으로 필요한 언어 설정
//         home: _ConfettiTest()),
//   );
// }
//
// class _ConfettiTest extends StatefulWidget {
//   const _ConfettiTest({Key? key}) : super(key: key);
//
//   @override
//   State<_ConfettiTest> createState() => _ConfettiTestState();
// }
//
// class _ConfettiTestState extends State<_ConfettiTest> {
//   bool isPlaying = false;
//   final controller = ConfettiController();
//
//   @override
//   void initState() {
//     super.initState();
//     controller.play();
//     // controller.addListener(() {
//     //   setState(() {
//     //     isPlaying = controller.state == ConfettiControllerState.playing;
//     //   });
//     // });
//   }
//
//   @override
//   void dispose() {
//     super.dispose();
//     controller.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Align(
//       alignment: Alignment.topCenter,
//       child: ConfettiWidget(
//         confettiController: controller,
//         shouldLoop: true,
//         // up , 0>right, pi/2>down, pi>left, BlastDirectionality.explosive >> all
//         // blastDirection: -pi / 2,
//         blastDirectionality: BlastDirectionality.explosive,
//         // 0.0 -> 1.0
//         emissionFrequency: 0.00005,
//         numberOfParticles: 100,
//         // set intensity
//         minBlastForce: 5,
//         maxBlastForce: 10,
//         gravity: 0.05,
//         colors: const [
//           Colors.red,
//           Colors.green,
//           Colors.yellow,
//           Colors.blue,
//           Colors.purpleAccent,
//         ],
//         createParticlePath: (size) {
//           final path = Path();
//           path.addOval(
//             Rect.fromCircle(center: Offset.zero, radius: 10),xz
//           );
//           return path;
//         },
//       ),
//     );
//   }
// }
