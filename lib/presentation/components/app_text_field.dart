import 'package:flutter/material.dart';

class AppTextField extends StatefulWidget {
  const AppTextField({
    super.key,
    this.hint,
    this.isPassword = false,
    this.obscureText = false,
    this.maxLines = 1,
    this.minLines = 1,
    this.error,
    required this.label,
    required this.textInputType,
    required this.icon,
    required this.controller,
    this.onHidePassword,
  });

  final String? hint;
  final String? error;
  final int? maxLines;
  final int? minLines;
  final String label;
  final bool isPassword;
  final bool obscureText;
  final TextInputType textInputType;
  final Icon? icon;
  final VoidCallback? onHidePassword;
  final TextEditingController controller;

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.label, style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 10),
        TextFormField(
          controller: widget.controller,
          keyboardType: widget.textInputType,
          maxLines: widget.maxLines,
          minLines: widget.minLines,
          decoration: InputDecoration(
            hintText: widget.hint,
            prefixIcon: widget.icon,
            suffixIcon:
                widget.isPassword
                    ? IconButton(
                      onPressed: widget.onHidePassword,
                      icon: Icon(
                        widget.obscureText
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                    )
                    : null,
            hintStyle: TextStyle(color: Colors.grey.shade400),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            fillColor: Colors.black,
          ),
          obscureText: widget.obscureText,
          style: const TextStyle(color: Colors.black),
          validator:
              (val) => val!.isEmpty ? "${widget.label} cannot be empty" : null,
        ),

        widget.error != null
            ? Text(
              widget.error ?? "",
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(color: Colors.red),
            )
            : SizedBox(),
        const SizedBox(height: 20),
      ],
    );
  }
}
