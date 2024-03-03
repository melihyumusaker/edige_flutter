// ignore_for_file: file_names
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FirstScreenRouteButtons extends StatelessWidget {
  final double width;
  final double height;
  final String buttonName;
  final String destinationPage;

  const FirstScreenRouteButtons({
    Key? key,
    required this.width,
    required this.height,
    required this.buttonName,
    required this.destinationPage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width + 15,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white, // Buton rengi beyaz
            elevation: 5, // Gölgelendirme yok
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            shadowColor: Colors.greenAccent),
        onPressed: () {
          Get.toNamed(destinationPage);
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              buttonName,
              style: const TextStyle(
                fontFamily: "PlayfairDisplay",
                color: Colors.black, // Metin rengi siyah
                fontSize: 16, // Metin boyutu
              ),
            ),
            const Spacer(),
            Container(
              decoration: BoxDecoration(shape: BoxShape.circle, boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 4,
                  blurRadius: 15,
                  offset: const Offset(0, 3),
                )
              ]),
              child: const CircleAvatar(
                backgroundColor: Color.fromARGB(255, 136, 178, 215),
                child: Icon(Icons.arrow_right_alt_rounded, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
