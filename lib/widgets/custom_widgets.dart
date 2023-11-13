import 'package:flutter/material.dart';
import 'package:windchat/main.dart';

//custom options card (for copy, edit, delete, etc.)
class OptionItem extends StatelessWidget {
  final Icon icon;
  final String name;
  final VoidCallback onTap;

  const OptionItem(
      {super.key, required this.icon, required this.name, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () => onTap(),
        child: Padding(
          padding: EdgeInsets.only(
              left: mq.width * .05,
              top: mq.height * .015,
              bottom: mq.height * .015),
          child: Row(children: [
            icon,
            Flexible(
                child: Text('    $name',
                    style: TextStyle(
                        fontSize: 15,
                        color: Theme.of(context).primaryColorDark,
                        letterSpacing: 0.5)))
          ]),
        ));
  }
}
