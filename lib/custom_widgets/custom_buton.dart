//Following is the widget, that will draw the default button on the screen
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    Key? key,
    required this.label,
    required this.onTap,
  }) : super(key: key);

  final String label;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    //Getting the screen size
    var size = MediaQuery.of(context).size;

    return SizedBox(
      width: size.width * 0.8,
      height: 40,
      child: ElevatedButton(
          onPressed: () {
            onTap();
          },
          child: Text(
            label,
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
          )),
    );
  }
}
