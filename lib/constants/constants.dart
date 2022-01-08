import 'package:flutter/material.dart';

const sizedh1 = SizedBox(
  height: 10,
);
const sizedh2 = SizedBox(
  height: 20,
);
const sizedw1 = SizedBox(
  width: 10,
);
const sizedw2 = SizedBox(
  width: 20,
);

final tfRadius = BorderRadius.circular(20);
const tfBorderSide = BorderSide(
  color: Colors.white,
  width: 1,
);
final tfOutlineBorder = OutlineInputBorder(
    borderRadius: tfRadius,
    borderSide: tfBorderSide
);

