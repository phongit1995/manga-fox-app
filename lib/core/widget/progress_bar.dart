import 'package:flutter/cupertino.dart';

class AppProgress extends StatelessWidget {
  final double percent;

  const AppProgress({super.key, required this.percent});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          gradient: LinearGradient(colors: const [
            Color(0xFFFF8C42),
            Color(0xFFFCAF58),
            Color(0xffCFCFCF),
          ], stops: [
            percent / 2,
            percent,
            percent,
          ])),
      child: const SizedBox(height: 4),
    );
  }
}
