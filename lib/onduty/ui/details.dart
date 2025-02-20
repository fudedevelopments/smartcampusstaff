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
  String selectedStatus = "pending";
  AuthService authService = AuthService();

  @override
  void initState() {
    super.initState();
    requestStoragePermission();
    _checkDownloadedFiles();
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
    switch (status.toLowerCase()) {
      case 'approved':
        return Icons.check_circle;
      case 'rejected':
        return Icons.cancel;
      case 'pending':
      default:
        return Icons.hourglass_empty;
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'approved':
        return Colors.green;
      case 'rejected':
        return Colors.red;
      case 'pending':
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
      subtitle: Text(status, style: TextStyle(color: _getStatusColor(status))),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('On Duty Details')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 4,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.model.eventName,
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  Text('Reg No: ${widget.model.regNo}',
                      style: TextStyle(fontSize: 16)),
                  SizedBox(height: 8),
                  Text('Name: ${widget.model.name}',
                      style: TextStyle(fontSize: 16)),
                  Divider(),
                  if (widget.index == "Proctor")
                    _buildDropdown(
                        'Proctor Status', widget.model.proctorStatus),
                  if (widget.index == "Academic Coordinator")
                    _buildDropdown('AC Status', widget.model.acStatus),
                  if (widget.index == "HOD")
                    _buildDropdown('HOD Status', widget.model.hodStatus),
                  Divider(),
                  _buildStatusTile("Proctor", widget.model.proctorStatus),
                  _buildStatusTile(
                      "Academic Coordinator", widget.model.acStatus),
                  _buildStatusTile(
                    "HOD",
                    widget.model.hodStatus,
                  ),
                  Divider(),
                  Text('Department: ${widget.model.department}',
                      style: TextStyle(fontSize: 16)),
                  Text('Year: ${widget.model.year}',
                      style: TextStyle(fontSize: 16)),
                  Text('Location: ${widget.model.location}',
                      style: TextStyle(fontSize: 16)),
                  Text('Event: ${widget.model.eventName}',
                      style: TextStyle(fontSize: 16)),
                  Text('Date: ${widget.model.date}',
                      style: TextStyle(fontSize: 16)),
                  Divider(),
                  Text('Details:',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  Text(widget.model.details, style: TextStyle(fontSize: 14)),
                  Divider(),
                  Text('Documents:',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: widget.model.validDocuments.length,
                    itemBuilder: (context, index) {
                      final docPath = widget.model.validDocuments[index];
                      return ListTile(
                        title: Text('Document ${index + 1}'),
                        trailing: Icon(
                          downloadedFiles[docPath] == true
                              ? Icons.insert_drive_file
                              : Icons.download,
                        ),
                        onTap: () => downloadFile(docPath),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDropdown(String title, String status) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        DropdownButton<String>(
          value: selectedStatus,
          onChanged: (String? newValue) {
            setState(() {
              selectedStatus = newValue ?? status;
            });
          },
          items: ["approved", "rejected", "pending"].map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
        ElevatedButton(
          onPressed: () async {
            if (widget.index == "Proctor") {
              await widget.ondutyController.updateDynamoDBItem(
                  tablename: "onDutyModel-2jskpek75veajd4yfnqjmkppmu-NONE",
                  token: authService.idToken!,
                  id: widget.model.id,
                  staffId: widget.model.ac,
                  key: "proctorstatus",
                  value: selectedStatus,
                  studentid: widget.model.student,
                  );
            }
          },
          child: Text("Change Status"),
        )
      ],
    );
  }
}
