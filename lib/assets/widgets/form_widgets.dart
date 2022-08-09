import 'package:abizeitung_mobile/assets/assets.dart';
import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  final bool? password;
  final String label;
  final String? Function(String?) validator;
  final Function(String?) onSave;
  final String? value;
  final Function(String?)? onChanged;

  const CustomTextField(
      {Key? key,
      this.password,
      required this.label,
      required this.validator,
      required this.onSave,
      this.value,
      this.onChanged})
      : super(key: key);

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late final bool _password;
  bool _obscureText = false;
  bool _activeTextField = false;

  void _toggleVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  void initState() {
    super.initState();

    _password = widget.password ?? false;
    _obscureText = _password;
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      child: TextFormField(
        validator: widget.validator,
        maxLines: 1,
        obscureText: _obscureText,
        initialValue: widget.value,
        decoration: InputDecoration(
          labelText: widget.label,
          labelStyle: TextStyle(
            color: Colors.white.withAlpha(225),
          ),
          enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: primaryColor),
          ),
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: primaryColor),
          ),
          suffixIcon: _password && _activeTextField
              ? GestureDetector(
                  onTap: () {
                    _toggleVisibility();
                  },
                  child: Icon(
                    _obscureText ? Icons.visibility : Icons.visibility_off,
                    color: primaryColor,
                  ),
                )
              : null,
          contentPadding: const EdgeInsets.symmetric(vertical: 6.0),
          /* errorText: false ? 'Passwort falsch' : null, */
        ),
        cursorColor: primaryColor,
        style: const TextStyle(color: Colors.white),
        onChanged: widget.onChanged,
        onSaved: widget.onSave,
      ),
      onFocusChange: (hasFocus) {
        setState(() {
          _activeTextField = hasFocus;
        });
      },
    );
  }
}

class CustomCheckbox extends StatefulWidget {
  final String label;
  final Function(bool?) onChanged;
  const CustomCheckbox({Key? key, required this.label, required this.onChanged})
      : super(key: key);

  @override
  State<CustomCheckbox> createState() => _CustomCheckboxState();
}

class _CustomCheckboxState extends State<CustomCheckbox> {
  bool _value = false;

  Color getColor(Set<MaterialState> states) {
    return primaryColor;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Checkbox(
          value: _value,
          fillColor: MaterialStateProperty.resolveWith(getColor),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(1.0)),
          ),
          // activeColor: const Color(0xFFACFCD9),
          checkColor: Colors.black,
          onChanged: (value) {
            setState(() {
              _value = value!;
            });
            widget.onChanged(value);
          },
        ),
        Text(
          widget.label,
          style: const TextStyle(color: Colors.white),
        ),
      ],
    );
  }
}
