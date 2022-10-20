import 'package:flutter/material.dart';

class SearchButton extends StatelessWidget {
  final String text;
  final Function() onPressed;

  const SearchButton({required this.text, required this.onPressed, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    const primaryColor = Colors.blue;

    const double borderRadius = 30;

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 105.0),
        child: OutlinedButton(
          onPressed: onPressed,
          style: ButtonStyle(
              side: MaterialStateProperty.all(
                  const BorderSide(color: primaryColor, width: 1.4)),
              padding: MaterialStateProperty.all(
                  const EdgeInsets.symmetric(vertical: 7, horizontal: 35)),
              shape: MaterialStateProperty.all(const RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.all(Radius.circular(borderRadius))))),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text(
              text,
              style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w300,
                  color: primaryColor),
            ),
            const Icon(Icons.arrow_forward, color: primaryColor)
          ]),
        ),
      ),
    );
  }
}
