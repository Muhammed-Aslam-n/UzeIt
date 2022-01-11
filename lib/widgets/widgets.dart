import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:uzit/constants/constants.dart';
import 'package:wc_form_validators/wc_form_validators.dart';

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
  final TextInputType? textInputType;
  final double? blurRadius, spreadRadius;

  const CommonTextField(
      {Key? key,
      this.controller,
      this.prefixIcon,
      this.label,
      this.obscureText = false,
      this.bgColor,
      this.blurRadius,
      this.spreadRadius, this.textInputType = TextInputType.emailAddress})
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
        style: TextStyle(color: Colors.grey.withOpacity(0.7)),
        controller: controller,
        textInputAction: TextInputAction.next,
        obscureText: obscureText,
        keyboardType: textInputType,
        decoration: InputDecoration(
          fillColor: Colors.white,
          floatingLabelBehavior: FloatingLabelBehavior.never,
          focusedBorder: tfOutlineBorder,
          enabledBorder: tfOutlineBorder,
          prefixIcon: prefixIcon,
          label: Text(label ?? '',style: TextStyle(color: Colors.grey.withOpacity(0.2)),),
        ),
      ),
    );
  }
}

class DataTextFields extends StatelessWidget {
  final String? labelText, errorText;
  final Icon? icon;
  final int? minLength,maxLength;
  final bool ismaxLength;
  final TextEditingController? controller;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputType? textInputType;

  const DataTextFields(
      {Key? key,
      this.labelText,
      this.errorText,
      this.controller,
      this.icon,
      this.inputFormatters,
      this.minLength,
      this.ismaxLength = false, this.textInputType, this.maxLength})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.07,
      width: MediaQuery.of(context).size.width * 0.8,
      child: TextFormField(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        controller: controller,
        keyboardType: textInputType??TextInputType.name,
        decoration: InputDecoration(
          floatingLabelBehavior: FloatingLabelBehavior.never,
          focusedBorder: OutlineInputBorder(
            borderRadius: tfRadius,
            borderSide: BorderSide(
              color: HexColor("#252942"),
              width: 1,
            ),
          ),
          enabledBorder: tfOutlineBorder,
          labelText: labelText,
          prefixIcon: icon,
        ),
        inputFormatters: inputFormatters,
        validator: Validators.compose(
          [
            Validators.required("$labelText is required"),
            Validators.minLength(
                minLength ?? 1,"$labelText must be greater than $minLength characters"),
            ismaxLength
                ? Validators.maxLength(maxLength??3,"$labelText must be less than ${maxLength??3} digits")
                : Validators.maxLength(150,"$labelText must be less than 150")
          ],
        ),
      ),
    );
  }
}




