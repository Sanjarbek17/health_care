import 'package:flutter/material.dart';

class EmergencyCall extends StatelessWidget {
  const EmergencyCall({super.key});

  @override
  Widget build(BuildContext context) {
    return ExpansionPanelList.radio(
      children: [
        ExpansionPanelRadio(
          value: 1,
          headerBuilder: (context, isExpanded) => Container(
            margin: const EdgeInsets.all(8),
            color: Colors.red,
          ),
          body: const ExpansionTile(
            title: Text('nimadir'),
          ),
        )
      ],
    );
  }
}
