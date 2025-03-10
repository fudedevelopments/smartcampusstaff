import 'package:flutter/material.dart';
import 'package:smartcampusstaff/model/newonduty.dart';

class HeaderSection extends StatelessWidget {
  final OnDutyModel model;

  const HeaderSection({
    Key? key,
    required this.model,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            model.eventName,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor,
            ),
          ),
          SizedBox(height: 12),
          Row(
            children: [
              Icon(Icons.person, size: 20),
              SizedBox(width: 8),
              Text(
                model.name,
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
          SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.badge, size: 20),
              SizedBox(width: 8),
              Text(
                'Reg No: ${model.regNo}',
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
