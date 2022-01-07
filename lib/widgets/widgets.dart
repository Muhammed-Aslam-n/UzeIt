import 'package:flutter/material.dart';
import 'package:uzit/constants/constants.dart';

class CommonHeaders extends StatelessWidget {
  final String? text;
  final Color? color;
  final double? size;
  final FontWeight? weight;

  const CommonHeaders({this.text, this.weight, this.size, this.color});

  @override
  Widget build(BuildContext context) {
    return Text(
      text ?? '',
      style: TextStyle(
          color: color, fontSize: size, fontWeight: weight ?? FontWeight.w600),
    );
  }
}

class CommonText extends StatelessWidget {
  final String? text;
  final Color? color;
  final double? size;
  final FontWeight? weight;

  const CommonText({this.text, this.weight, this.size, this.color});

  @override
  Widget build(BuildContext context) {
    return Text(
      text ?? '',
      style: TextStyle(
          color: color ?? Colors.grey.shade800,
          fontSize: size,
          fontWeight: weight ?? FontWeight.w400),
    );
  }
}

class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}

class CommonTextField extends StatelessWidget {
  final TextEditingController? controller;
  final Color? bgColor;
  final Icon? prefixIcon;
  final String? label;
  final bool obscureText;
  final double? blurRadius, spreadRadius;

  const CommonTextField(
      {Key? key,
      this.controller,
      this.prefixIcon,
      this.label,
      this.obscureText = false,
      this.bgColor,
      this.blurRadius,
      this.spreadRadius})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Container(
      height: height * 0.065,
      width: width * 0.85,
      margin: const EdgeInsets.only(left: 20),
      decoration: BoxDecoration(
        borderRadius: tfRadius,
        color: bgColor ?? Colors.white,
        boxShadow: [
          BoxShadow(
              blurRadius: blurRadius ?? 10,
              spreadRadius: spreadRadius ?? 7,
              offset: const Offset(1, 1),
              color: Colors.grey.withOpacity(0.2)),
        ],
      ),
      child: TextFormField(
        controller: controller,
        textInputAction: TextInputAction.next,
        obscureText: obscureText,
        decoration: InputDecoration(
          floatingLabelBehavior: FloatingLabelBehavior.never,
          focusedBorder: tfOutlineBorder,
          enabledBorder: tfOutlineBorder,
          prefixIcon: prefixIcon,
          label: Text(label ?? ''),
        ),
      ),
    );
  }
}

class DataTextFields extends StatelessWidget {
  final String? labelText, errorText;
  final Icon? icon;
  final TextEditingController? controller;

  const DataTextFields(
      {Key? key, this.labelText, this.errorText, this.controller, this.icon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.05,
      width: MediaQuery.of(context).size.width * 0.8,
      child: TextFormField(
        autovalidateMode: AutovalidateMode.disabled,
        controller: controller,
        decoration: InputDecoration(
          floatingLabelBehavior: FloatingLabelBehavior.never,
          focusedBorder: tfOutlineBorder,
          enabledBorder: tfOutlineBorder,
          labelText: labelText,
          prefixIcon: icon,
        ),
        validator: (_val) {
          if (_val!.isEmpty) {
            return errorText;
          } else {
            return null;
          }
        },
      ),
    );
  }
}
