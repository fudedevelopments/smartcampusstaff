import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:smartcampusstaff/model/newonduty.dart';
import 'package:smartcampusstaff/onduty/ui/details.dart';
import 'package:smartcampusstaff/utils/utils.dart';
import 'package:smartcampusstaff/utils/apicall.dart';
import 'package:smartcampusstaff/utils/authservices.dart';

class StatusCard extends StatelessWidget {
  final OnDutyModel onDutyModel;
  final String index;
  final AuthService authService = AuthService();

  StatusCard({
    super.key,
    required this.onDutyModel,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final result = await navigationpush(
            context, DetailsOnduty(index: index, model: onDutyModel));
        if (result == true) {
          // Refresh the data when returning from details page
          final ondutyController = Get.find<OndutyController>();
          ondutyController.fetchData(
            tablename: "onDutyModel-2jskpek75veajd4yfnqjmkppmu-NONE",
            indexname: _getIndexName(index),
            token: authService.idToken!,
            limit: 5,
            partitionKey: _getPartitionKey(index),
            partitionKeyValue: authService.sub!,
          );
        }
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.orange.shade100.withOpacity(0.3),
              spreadRadius: 1,
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.orange.shade600, Colors.yellow.shade700],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(14),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.request_page,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Request: ${onDutyModel.eventName}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            // Content
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInfoTile(
                    icon: Icons.person,
                    label: 'Requested by',
                    value: onDutyModel.name,
                    color: Colors.orange.shade700,
                  ),
                  const SizedBox(height: 12),
                  _buildInfoTile(
                    icon: Icons.badge,
                    label: 'Reg No',
                    value: onDutyModel.regNo,
                    color: Colors.orange.shade700,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: _buildInfoTile(
                          icon: Icons.calendar_today,
                          label: 'Date',
                          value: onDutyModel.date,
                          color: Colors.yellow.shade800,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildInfoTile(
                          icon: Icons.location_on,
                          label: 'Location',
                          value: onDutyModel.location,
                          color: Colors.yellow.shade800,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoTile({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Icon(
            icon,
            size: 20,
            color: color,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey.shade900,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _getIndexName(String category) {
    switch (category) {
      case 'Academic Coordinator':
        return 'onDutyModelsByAcAndCreatedAt';
      case 'HOD':
        return 'onDutyModelsByHodAndCreatedAt';
      default:
        return 'onDutyModelsByProctorAndCreatedAt';
    }
  }

  String _getPartitionKey(String category) {
    switch (category) {
      case 'Academic Coordinator':
        return 'Ac';
      case 'HOD':
        return 'Hod';
      default:
        return 'Proctor';
    }
  }
}
