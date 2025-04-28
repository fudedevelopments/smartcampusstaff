// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smartcampusstaff/model/newonduty.dart';
import 'package:smartcampusstaff/utils/apicall.dart';
import 'package:smartcampusstaff/utils/authservices.dart';
import 'package:smartcampusstaff/onduty/ui/components/header_section.dart';
import 'package:smartcampusstaff/onduty/ui/components/approval_status_section.dart';
import 'package:smartcampusstaff/onduty/ui/components/event_details_section.dart';
import 'package:smartcampusstaff/onduty/ui/components/document_section.dart';
import 'package:smartcampusstaff/onduty/ui/components/file_download_helper.dart';
import 'package:smartcampusstaff/onduty/ui/components/status_update_helper.dart';
import 'package:smartcampusstaff/utils/image_cache_service.dart';

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
  final Map<String, double> downloadProgress = {}; // Track download progress
  String selectedStatus = "PENDING";
  AuthService authService = AuthService();
  bool isLoading = false;
  late FileDownloadHelper fileDownloadHelper;
  late StatusUpdateHelper statusUpdateHelper;

  @override
  void initState() {
    super.initState();

    // Initialize download progress for each document
    for (var doc in widget.model.validDocuments) {
      downloadProgress[doc] = 0.0;
    }

    fileDownloadHelper = FileDownloadHelper(
      downloadPath: downloadPath,
      downloadedFiles: downloadedFiles,
      onDownloadStatusChanged: (updatedMap) {
        setState(() {
          for (var key in updatedMap.keys) {
            downloadedFiles[key] = updatedMap[key]!;
          }
        });
      },
      onDownloadProgress: (docPath, progress) {
        setState(() {
          downloadProgress[docPath] = progress;
        });
      },
    );

    statusUpdateHelper = StatusUpdateHelper(
      ondutyController: widget.ondutyController,
      model: widget.model,
      userRole: widget.index,
      context: context,
      authService: authService,
    );

    fileDownloadHelper.requestStoragePermission();
    _initializeDownloadedFiles();
    _initializeSelectedStatus();

    // Clear image cache to ensure fresh images
    ImageCacheService().clearCache();
  }

  void _initializeDownloadedFiles() async {
    await fileDownloadHelper.checkDownloadedFiles();
  }

  void _initializeSelectedStatus() {
    if (widget.index == "Proctor") {
      selectedStatus = widget.model.proctorStatus.toUpperCase();
    } else if (widget.index == "Academic Coordinator") {
      selectedStatus = widget.model.acStatus.toUpperCase();
    } else if (widget.index == "HOD") {
      selectedStatus = widget.model.hodStatus.toUpperCase();
    }
  }

  void _onStatusChanged(String? newValue) {
    if (newValue != null) {
      setState(() {
        selectedStatus = newValue;
      });
    }
  }

  void _updateStatus() async {
    setState(() {
      isLoading = true;
    });

    try {
      await statusUpdateHelper.updateStatus(selectedStatus);
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('On Duty Details'),
        elevation: 0,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.white,
              Colors.white,
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  HeaderSection(model: widget.model),
                  const SizedBox(height: 20),
                  ApprovalStatusSection(
                    model: widget.model,
                    userRole: widget.index,
                    selectedStatus: selectedStatus,
                    isLoading: isLoading,
                    onStatusChanged: _onStatusChanged,
                    onUpdateStatus: _updateStatus,
                  ),
                  const SizedBox(height: 20),
                  EventDetailsSection(model: widget.model),
                  const SizedBox(height: 20),
                  DocumentSection(
                    model: widget.model,
                    downloadedFiles: downloadedFiles,
                    downloadProgress:
                        downloadProgress, // Pass download progress
                    onDownloadFile: (docPath) =>
                        fileDownloadHelper.downloadFile(docPath),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
