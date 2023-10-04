import 'package:flutter/material.dart';

class CustomInputField extends StatefulWidget {
  final String labelText;
  final String hintText;
  final TextStyle style;
  final TextEditingController controllers;
  final String Function(String) validator;
  final bool suffixIcon;
  final TextInputType textinput;
  final InputBorder Borders;
  final bool isDense;
  final bool obscureText;

  const CustomInputField({
    Key key,
    this.style,
    @required this.labelText,
    @required this.hintText,
    this.Borders,
    @required this.validator,
    this.controllers,
    this.textinput,
    this.suffixIcon = false,
    this.isDense,
    this.obscureText = false, controller, bool readOnly
  }) : super(key: key);

  @override
  State<CustomInputField> createState() => _CustomInputFieldState();
}

class _CustomInputFieldState extends State<CustomInputField> {
  //
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width * 0.9,
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 3),
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(widget.labelText, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
          ),
          TextFormField(
            
            obscureText: (widget.obscureText && _obscureText),
            controller: widget.controllers,
            style: widget.style,
            decoration: InputDecoration(
              border: widget.Borders,
              isDense: (widget.isDense != null) ? widget.isDense : false,
              hintText: widget.hintText,
              suffixIcon: widget.suffixIcon ? IconButton(
                icon: Icon(
                  _obscureText ? Icons.remove_red_eye : Icons.visibility_off_outlined,
                  color: Colors.black54,
                ),
                onPressed: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
              ): null,
              suffixIconConstraints: (widget.isDense != null) ? const BoxConstraints(
                  maxHeight: 33
              ): null,
            ),
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: widget.validator,
          ),
        ],
      ),
    );
  }
}