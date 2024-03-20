// import 'package:flutter/material.dart';
// import 'package:fortune/network/util/logger.dart';
// import 'package:fortune/network/util/textstyle.dart';
// import 'package:fortune/network/widgets/button/fortune_text_button.dart';
// import 'package:fortune/network/widgets/fortune_cached_network_Image.dart';
// import 'package:fortune/network/widgets/fortune_scaffold.dart';
// import 'package:fortune/domain/supabase/entity/ingredient_entity.dart';
// import 'package:fortune/presentation/ingredientaction/giftbox_action_param.dart';
// import 'package:scratcher/scratcher.dart';
// class RandomScratcherView extends StatefulWidget {
//   final List<IngredientEntity> randomNormalIngredients;
//   final IngredientActionParam randomNormalSelected;
//
//   const RandomScratcherView({
//     super.key,
//     required this.randomNormalIngredients,
//     required this.randomNormalSelected,
//   });
//
//   @override
//   State<RandomScratcherView> createState() => _RandomScratcherViewState();
// }
//
// class _RandomScratcherViewState extends State<RandomScratcherView> with SingleTickerProviderStateMixin {
//   double validScratches = 0;
//   late AnimationController _animationController;
//   late Animation<double> _animation;
//
//   @override
//   void initState() {
//     _animationController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 1200),
//     )..addStatusListener(
//           (listener) {
//         if (listener == AnimationStatus.completed) {
//           _animationController.reverse();
//         }
//       },
//     );
//     _animation = Tween(begin: 1.0, end: 1.25).animate(
//       CurvedAnimation(
//         parent: _animationController,
//         curve: Curves.elasticIn,
//       ),
//     );
//     super.initState();
//   }
//
//   @override
//   void dispose() {
//     _animationController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//           children: [
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 const Text(
//                   'Scratcher',
//                   style: TextStyle(
//                     fontFamily: 'The unseen',
//                     color: Colors.blueAccent,
//                     fontSize: 50,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 const Text(
//                   'scratch to win!',
//                   style: TextStyle(
//                     fontFamily: 'The unseen',
//                     color: Colors.black,
//                     fontSize: 20,
//                   ),
//                 ),
//                 Container(
//                   margin: const EdgeInsets.only(top: 10),
//                   height: 1,
//                   width: 300,
//                   color: Colors.black12,
//                 )
//               ],
//             ),
//             buildRow(_googleIcon, _flutterIcon, _googleIcon),
//             buildRow(_dartIcon, _flutterIcon, _googleIcon),
//             buildRow(_dartIcon, _flutterIcon, _dartIcon),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget buildRow(String left, String center, String right) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         ScratchBox(image: left),
//         ScratchBox(
//           image: center,
//           animation: _animation,
//           onScratch: () {
//             setState(() {
//               validScratches++;
//               if (validScratches == 3) {
//                 _animationController.forward();
//               }
//             });
//           },
//         ),
//         ScratchBox(image: right),
//       ],
//     );
//   }
// }
//
// class ScratchBox extends StatefulWidget {
//   ScratchBox({
//     required this.image,
//     this.onScratch,
//     this.animation,
//   });
//
//   final String image;
//   final VoidCallback? onScratch;
//   final Animation<double>? animation;
//
//   @override
//   _ScratchBoxState createState() => _ScratchBoxState();
// }
//
// class _ScratchBoxState extends State<ScratchBox> {
//   bool isScratched = false;
//   double opacity = 0.5;
//
//   @override
//   Widget build(BuildContext context) {
//     var icon = AnimatedOpacity(
//       opacity: opacity,
//       duration: const Duration(milliseconds: 750),
//       child: Image.asset(
//         widget.image,
//         width: 70,
//         height: 70,
//         fit: BoxFit.contain,
//       ),
//     );
//
//     return Container(
//       width: 80,
//       height: 80,
//       margin: const EdgeInsets.all(10),
//       child: Scratcher(
//         accuracy: ScratchAccuracy.low,
//         color: Colors.blueGrey,
//         image: Image.asset('assets/scratch.png'),
//         brushSize: 15,
//         threshold: 60,
//         onThreshold: () {
//           setState(() {
//             opacity = 1;
//             isScratched = true;
//           });
//           widget.onScratch?.call();
//         },
//         child: Container(
//           child: widget.animation == null
//               ? icon
//               : ScaleTransition(
//             scale: widget.animation!,
//             child: icon,
//           ),
//         ),
//       ),
//     );
//   }
// }
//
