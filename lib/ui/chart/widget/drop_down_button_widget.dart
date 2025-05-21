import 'package:flutter/material.dart';

import '../../../model/enum/calender_type.dart';

class DropDownButtonWidget extends StatelessWidget {
  const DropDownButtonWidget(
      {super.key, required this.onChanged, required this.value});

  final Function(String? value) onChanged;
  final String value;

  @override
  Widget build(BuildContext context) {
    return DropdownButton(
      menuWidth: 100,
      items: [
        DropdownMenuItem(
          child: Text(CalenderType.c2w.title),
          value: CalenderType.c2w.title,
        ),
        DropdownMenuItem(
          child: Text(CalenderType.c1m.title),
          value: CalenderType.c1m.title,
        ),
        DropdownMenuItem(
          child: Text(CalenderType.c1y.title),
          value: CalenderType.c1y.title,
        ),
      ],
      onChanged: onChanged,
      value: value,
    );
  }
}
