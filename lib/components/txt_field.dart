import 'package:flutter/material.dart';

class TxtField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final bool isPassword;
  final GestureTapCallback? onTap;

  const TxtField({
    super.key,
    required this.controller,
    required this.label,
    this.isPassword = false,
    this.onTap,
  });

  @override
  _TxtFieldState createState() => _TxtFieldState();
}

class _TxtFieldState extends State<TxtField> {
  bool _isObscured = true;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      onTap: widget.onTap,
      obscureText: widget.isPassword ? _isObscured : false,
      style: TextStyle(
        color: Theme.of(context).primaryColor,
        fontSize: 13.0,
      ),
      decoration: InputDecoration(
        border: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Theme.of(context).primaryColor,
            width: 2.0,
          ),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Theme.of(context).primaryColor,
            width: 0.5,
          ),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Theme.of(context).primaryColor,
            width: 2.0,
          ),
        ),
        hintText: widget.label,
        hintStyle: TextStyle(
          color: Theme.of(context).primaryColor,
        ),
        suffixIcon: widget.isPassword
            ? IconButton(
                icon: Icon(
                  _isObscured ? Icons.visibility_off : Icons.visibility,
                  color: Theme.of(context).primaryColor,
                ),
                onPressed: () {
                  setState(() {
                    _isObscured = !_isObscured;
                  });
                },
              )
            : null,
      ),
    );
  }
}
