// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:open_file/open_file.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:smartcampusstaff/model/newonduty.dart';
import 'package:smartcampusstaff/utils/apicall.dart';
import 'package:smartcampusstaff/utils/authservices.dart';

class DetailsOnduty extends StatefulWidget {
  final OndutyController ondutyController = Get.put(OndutyController());

  final OnDutyModel model;
  final String index;
  DetailsOnduty({
    super.key,
    required this.model,
    required this.index,
  });

  @override
  // ignore: library_private_types_in_public_api
  _DetailsOndutyState createState() => _DetailsOndutyState();
}

class _DetailsOndutyState extends State<DetailsOnduty> {
  final String downloadPath = '/storage/emulated/0/Download/smartcampusdocs';
  final Map<String, bool> downloadedFiles = {};
  String selectedStatus = "PENDING";
  AuthService authService = AuthService();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    requestStoragePermission();
    _checkDownloadedFiles();
    if (widget.index == "Proctor") {
      selectedStatus = widget.model.proctorStatus.toUpperCase();
    } else if (widget.index == "Academic Coordinator") {
      selectedStatus = widget.model.acStatus.toUpperCase();
    } else if (widget.index == "HOD") {
      selectedStatus = widget.model.hodStatus.toUpperCase();
    }
  }

  Future<void> _checkDownloadedFiles() async {
    final dir = Directory(downloadPath);
    if (await dir.exists()) {
      final files = dir.listSync().map((e) => e.path.split('/').last).toSet();
      setState(() {
        for (var doc in widget.model.validDocuments) {
          final filename = doc.split('/').last;
          downloadedFiles[doc] = files.contains(filename);
        }
      });
    }
  }

  Future<void> requestStoragePermission() async {
    if (await Permission.storage.request().isGranted) {
      debugPrint("Storage permission granted");
    } else {
      debugPrint("Storage permission denied");
    }
  }

  Future<void> downloadFile(String documentPath) async {
    try {
      final filename = documentPath.split('/').last;
      final filepath = '$downloadPath/$filename';
      final file = File(filepath);

      if (await file.exists()) {
        try {
          final result = await OpenFile.open(filepath);
          debugPrint('File opened: ${result.message}');
        } catch (e) {
          debugPrint('Error opening file: $e');
        }
        return;
      }

      if (!await Directory(downloadPath).exists()) {
        await Directory(downloadPath).create(recursive: true);
      }

      final result = await Amplify.Storage.downloadFile(
        path: StoragePath.fromString(documentPath),
        localFile: AWSFile.fromPath(filepath),
      ).result;

      setState(() {
        downloadedFiles[documentPath] = true;
      });

      debugPrint('Downloaded file is located at: ${result.localFile.path}');
      try {
        final openResult = await OpenFile.open(filepath);
        debugPrint('File opened after download: ${openResult.message}');
      } catch (e) {
        debugPrint('Error opening file after download: $e');
      }
    } on StorageException catch (e) {
      debugPrint("Storage error: ${e.message}");
    } on Exception catch (e) {
      debugPrint("General error: $e");
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status.toUpperCase()) {
      // Changed to uppercase comparison
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
      // Changed to uppercase comparison
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
      subtitle: Text(status.toUpperCase(),
          style: TextStyle(
              color: _getStatusColor(status))),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('On Duty Details'),
        elevation: 0,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).primaryColor.withOpacity(0.1),
              Colors.white,
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            elevation: 8,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.model.eventName,
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
                                widget.model.name,
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
                                'Reg No: ${widget.model.regNo}',
                                style: TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    Card(
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
                            if (widget.index == "Proctor")
                              _buildDropdown(
                                  'Proctor Status', widget.model.proctorStatus),
                            if (widget.index == "Academic Coordinator")
                              _buildDropdown(
                                  'AC Status', widget.model.acStatus),
                            if (widget.index == "HOD")
                              _buildDropdown(
                                  'HOD Status', widget.model.hodStatus),
                            Divider(height: 24),
                            _buildStatusTile(
                                "Proctor", widget.model.proctorStatus),
                            _buildStatusTile(
                                "Academic Coordinator", widget.model.acStatus),
                            _buildStatusTile("HOD", widget.model.hodStatus),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Card(
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
                              'Event Details',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 12),
                            _buildDetailRow(Icons.school, 'Department',
                                widget.model.department),
                            _buildDetailRow(Icons.calendar_today, 'Year',
                                widget.model.year),
                            _buildDetailRow(Icons.location_on, 'Location',
                                widget.model.location),
                            _buildDetailRow(
                                Icons.event, 'Event', widget.model.eventName),
                            _buildDetailRow(
                                Icons.date_range, 'Date', widget.model.date),
                            SizedBox(height: 16),
                            Text(
                              'Additional Details:',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 8),
                            Container(
                              padding: EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.grey[100],
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                widget.model.details,
                                style: TextStyle(fontSize: 14),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Card(
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
                              'Documents',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 12),
                            ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: widget.model.validDocuments.length,
                              itemBuilder: (context, index) {
                                final docPath =
                                    widget.model.validDocuments[index];
                                return Card(
                                  elevation: 2,
                                  margin: EdgeInsets.symmetric(vertical: 4),
                                  child: ListTile(
                                    leading: Icon(
                                      downloadedFiles[docPath] == true
                                          ? Icons.insert_drive_file
                                          : Icons.download,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                    title: Text(
                                      'Document ${index + 1}',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500),
                                    ),
                                    onTap: () => downloadFile(docPath),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey[600]),
          SizedBox(width: 8),
          Text(
            '$label: ',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  Future<bool> _showConfirmationDialog() async {
    return await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Confirm Status Update'),
              content: Text('Are you sure you want to change this status?'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: Text('Cancel'),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: Text('Yes'),
                ),
              ],
            );
          },
        ) ??
        false;
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _updateStatus() async {
    final bool confirm = await _showConfirmationDialog();
    if (!confirm) return;

    setState(() {
      isLoading = true;
    });

    try {
      if (widget.index == "Proctor") {
        await widget.ondutyController.updateProctor(
          token: authService.idToken!,
          id: widget.model.id,
          value: selectedStatus,
        );
      } else if (widget.index == "Academic Coordinator") {
        await widget.ondutyController.updateAC(
          token: authService.idToken!,
          id: widget.model.id,
          value: selectedStatus,
        );
      } else if (widget.index == "HOD") {
        await widget.ondutyController.updateHOD(
          token: authService.idToken!,
          id: widget.model.id,
          value: selectedStatus,
        );
      }

      await widget.ondutyController.fetchData(
        tablename: "onDutyModel-2jskpek75veajd4yfnqjmkppmu-NONE",
        indexname: _getIndexName(widget.index),
        token: authService.idToken!,
        limit: 5,
        partitionKey: _getPartitionKey(widget.index),
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
      _showErrorDialog('Failed to update status: ${e.toString()}');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
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

  Widget _buildDropdown(String title, String status) {
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
              onChanged: (String? newValue) {
                if (newValue != null) {
                  setState(() {
                    selectedStatus = newValue;
                  });
                }
              },
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
              onPressed: isLoading ? null : _updateStatus,
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
}
