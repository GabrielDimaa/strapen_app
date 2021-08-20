import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:strapen_app/app/shared/components/dialog/dialog_default.dart';

class CupertinoDate extends StatefulWidget {
  @override
  _CupertinoDateState createState() => _CupertinoDateState();

  static DateTime date = DateTime(2000, 1, 1);

  static show(BuildContext context) async {
    return DialogDefault.show(
      context: context,
      content: CupertinoDate(),
      actions: [
        TextButton(
          onPressed: () => Modular.to.pop(date),
          child: Text("Confirmar"),
        ),
      ],
    );
  }
}

class _CupertinoDateState extends State<CupertinoDate> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.25,
      child: CupertinoTheme(
        data: CupertinoThemeData(
          textTheme: CupertinoTextThemeData(
            dateTimePickerTextStyle: TextStyle(color: Colors.white),
            pickerTextStyle: TextStyle(color: Colors.green),
          ),
        ),
        child: CupertinoDatePicker(
          initialDateTime: CupertinoDate.date,
          maximumDate: DateTime.now(),
          mode: CupertinoDatePickerMode.date,
          onDateTimeChanged: (DateTime value) => CupertinoDate.date = value,
        ),
      ),
    );
  }
}
