// ignore_for_file: file_names, must_be_immutable, avoid_unnecessary_containers, prefer_typing_uninitialized_variables, prefer_const_literals_to_create_immutables, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:rider_app/res/colors/colors.dart';

Widget CustomTextFieldWidget({
  required String hintText,
  String? labelText,
  String? label,
  String? errorText,
  var errorStyle,
  bool filled = false,
  Color? filledColor,
  InputBorder? errorBorder,
  var labelStyle,
  var preffixIcon,
  Widget? suffixIcon,
  var initialValue,
  int maxLines = 1,
  FocusNode? focusNode,
  bool autoFocus = false,
  bool obscureText = false,
  bool readOnly = false,
  bool inDense = false,
  var style,
  double radius = 8,
  TextEditingController? controller,
  String? Function(String?)? onValidator,
  String? Function(String)? onChanged,
  String? Function(String)? onFieldSubmitted,
  final TapRegionCallback? onTapOutSide,
  Function()? suffixTap,
  TextInputType? keyboardType,
  TextInputAction? textInputAction,
}) {
  return Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10.0),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.2),
          spreadRadius: 1,
          blurRadius: 5,
          offset: const Offset(0, 2),
        ),
      ],
    ),
    child: TextFormField(
      onTapOutside: onTapOutSide,
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r"[a-zA-Z0-9\s]")),
        LengthLimitingTextInputFormatter(30),
      ],
      controller: controller,
      initialValue: initialValue,
      focusNode: focusNode,
      autofocus: autoFocus,
      readOnly: readOnly,
      style: TextStyle(
        fontWeight: FontWeight.w600,
        color: Colors.black,
        fontSize: 14.sp,
      ),
      maxLines: maxLines,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: onValidator,
      onChanged: onChanged,
      onFieldSubmitted: onFieldSubmitted,
      obscureText: obscureText,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      decoration: InputDecoration(
        isDense: inDense,
        fillColor: Colors.white,
        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 14.h),
        errorText: errorText,
        errorStyle: errorStyle,
        labelStyle: labelStyle,
        labelText: labelText,
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: const BorderSide(color: Colors.transparent, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: const BorderSide(color: Colors.transparent, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: const BorderSide(color: Colors.transparent, width: 1),
        ),
        errorBorder: errorBorder,
        suffixIcon: suffixIcon,
        hintText: hintText,
        prefixIcon: preffixIcon,
        hintStyle: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.grey[500],

          fontSize: 14.sp,
        ),
      ),
    ),
  );
}
