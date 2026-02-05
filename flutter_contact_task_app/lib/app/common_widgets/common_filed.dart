import 'package:flutter/material.dart';

TextFormField buildTextField({
  required TextEditingController controller,
  required String label,
  required String hint,
  required IconData icon,
  TextInputType? keyboardType,
  TextInputAction? textInputAction,
  TextCapitalization? textCapitalization,
  int? maxLength,
  String? Function(String?)? validator,
}) {
  return TextFormField(
    // autovalidateMode: AutovalidateMode.onUserInteraction,
    controller: controller,
    decoration: InputDecoration(
      labelText: label,
      hintText: hint,
      prefixIcon: Icon(icon),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
      counterText: maxLength != null ? '' : null,
    ),
    keyboardType: keyboardType,
    textInputAction: textInputAction,
    textCapitalization: textCapitalization ?? TextCapitalization.none,
    maxLength: maxLength,
    validator: validator,
  );
}
