import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smartcampusstaff/model/newonduty.dart';
import 'package:smartcampusstaff/utils/authservices.dart';
import 'package:smartcampusstaff/utils/apicall.dart';
import 'package:smartcampusstaff/onduty/ui/components/dialog_helper.dart';

class StatusUpdateHelper {
  final OndutyController ondutyController;
  final OnDutyModel model;
  final String userRole;
  final BuildContext context;
  final AuthService authService;

  StatusUpdateHelper({
    required this.ondutyController,
    required this.model,
    required this.userRole,
    required this.context,
    required this.authService,
  });

  String getIndexName(String category) {
    switch (category) {
      case 'Academic Coordinator':
        return 'onDutyModelsByAcAndCreatedAt';
      case 'HOD':
        return 'onDutyModelsByHodAndCreatedAt';
      default:
        return 'onDutyModelsByProctorAndCreatedAt';
    }
  }

  String getPartitionKey(String category) {
    switch (category) {
      case 'Academic Coordinator':
        return 'Ac';
      case 'HOD':
        return 'Hod';
      default:
        return 'Proctor';
    }
  }

  Future<void> updateStatus(String selectedStatus) async {
    final bool confirm = await DialogHelper.showConfirmationDialog(context);
    if (!confirm) return;

    try {
      if (userRole == "Proctor") {
        await ondutyController.updateProctor(
          token: authService.idToken!,
          id: model.id,
          value: selectedStatus,
        );
      } else if (userRole == "Academic Coordinator") {
        await ondutyController.updateAC(
          token: authService.idToken!,
          id: model.id,
          value: selectedStatus,
        );
      } else if (userRole == "HOD") {
        await ondutyController.updateHOD(
          token: authService.idToken!,
          id: model.id,
          value: selectedStatus,
        );
      }

      await ondutyController.fetchData(
        tablename: "onDutyModel-2jskpek75veajd4yfnqjmkppmu-NONE",
        indexname: getIndexName(userRole),
        token: authService.idToken!,
        limit: 5,
        partitionKey: getPartitionKey(userRole),
        partitionKeyValue: authService.sub!,
      );

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Status updated successfully'),
          backgroundColor: Colors.green,
        ),
      );

      // Navigate back to landing page with refresh flag
      Get.back(result: true);
    } catch (e) {
      DialogHelper.showErrorDialog(
          context, 'Failed to update status: ${e.toString()}');
    }
  }
}
