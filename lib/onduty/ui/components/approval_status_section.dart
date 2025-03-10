import 'package:flutter/material.dart';
import 'package:smartcampusstaff/model/newonduty.dart';

class ApprovalStatusSection extends StatelessWidget {
  final OnDutyModel model;
  final String userRole;
  final String selectedStatus;
  final bool isLoading;
  final Function(String?) onStatusChanged;
  final VoidCallback onUpdateStatus;

  const ApprovalStatusSection({
    Key? key,
    required this.model,
    required this.userRole,
    required this.selectedStatus,
    required this.isLoading,
    required this.onStatusChanged,
    required this.onUpdateStatus,
  }) : super(key: key);

  IconData _getStatusIcon(String status) {
    switch (status.toUpperCase()) {
      case 'APPROVED':
        return Icons.check_circle;
      case 'REJECTED':
        return Icons.cancel;
      case 'PENDING':
      default:
        return Icons.hourglass_empty;
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toUpperCase()) {
      case 'APPROVED':
        return Colors.green;
      case 'REJECTED':
        return Colors.red;
      case 'PENDING':
      default:
        return Colors.orange;
    }
  }

  Widget _buildStatusTile(String title, String status) {
    return ListTile(
      leading: Icon(
        _getStatusIcon(status),
        color: _getStatusColor(status),
      ),
      title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(
        status.toUpperCase(),
        style: TextStyle(color: _getStatusColor(status)),
      ),
    );
  }

  Widget _buildDropdown(BuildContext context, String title, String status) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: DropdownButton<String>(
              value: selectedStatus,
              isExpanded: true,
              underline: SizedBox(),
              onChanged: onStatusChanged,
              items: ["APPROVED", "REJECTED", "PENDING"].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(
                    value,
                    style: TextStyle(
                      color: _getStatusColor(value),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: isLoading ? null : onUpdateStatus,
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              child: isLoading
                  ? SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : Text(
                      "Update Status",
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Approval Status',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 12),
            if (userRole == "Proctor")
              _buildDropdown(context, 'Proctor Status', model.proctorStatus),
            if (userRole == "Academic Coordinator")
              _buildDropdown(context, 'AC Status', model.acStatus),
            if (userRole == "HOD")
              _buildDropdown(context, 'HOD Status', model.hodStatus),
            Divider(height: 24),
            _buildStatusTile("Proctor", model.proctorStatus),
            _buildStatusTile("Academic Coordinator", model.acStatus),
            _buildStatusTile("HOD", model.hodStatus),
          ],
        ),
      ),
    );
  }
}
