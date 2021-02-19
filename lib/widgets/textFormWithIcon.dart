import 'package:flutter/material.dart';

class TextFormWithIcon extends StatelessWidget {
  final String text;
  final IconData iconData;
  final String Function(String) validator;
  final void Function(String) onSave;
  final void Function(String) onChanged;
  final String initialValue;

  const TextFormWithIcon(
    this.iconData,
    this.text, {
    this.initialValue,
    this.onChanged,
    this.validator,
    this.onSave,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        initialValue: initialValue,
        onChanged: onChanged,
        onSaved: onSave,
        textInputAction: TextInputAction.next,
        validator: validator,
        decoration: InputDecoration(
          filled: true,
          labelText: text,
          icon: Icon(iconData),
        ),
      ),
    );
  }
}

