import 'dart:io';

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:smartcampusstaff/components/errorsnack.dart';
import 'package:smartcampusstaff/components/file_pick.dart';
import 'package:smartcampusstaff/home/apicallevent.dart';
import 'package:smartcampusstaff/landing_page/ui/landing_page.dart';
import 'package:smartcampusstaff/models/ModelProvider.dart';
import 'package:smartcampusstaff/utils/utils.dart';

class AddEventRequest extends GetxController {
  RxBool loading = false.obs;
}

class CreateEventScreen extends StatefulWidget {
  final AddEventRequest controller = Get.put(AddEventRequest());
  CreateEventScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _CreateEventScreenState createState() => _CreateEventScreenState();
}

class _CreateEventScreenState extends State<CreateEventScreen> {
  final TextEditingController eventNameController = TextEditingController();
  final TextEditingController detailsController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController registerUrlController = TextEditingController();
  TemporalTimestamp awsTimestamp = TemporalTimestamp(DateTime.now().toUtc());
  List<String> uploadedFileUrls = [];
  DateTime? selectedDate;
  DateTime? expiryDate;
  List<File> selectedFiles = [];

  /// Function to pick a date
  Future<void> _pickDate(BuildContext context, bool isExpiry) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: Colors.blueAccent,
            hintColor: Colors.blueAccent,
            colorScheme: ColorScheme.light(primary: Colors.blueAccent),
            buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      setState(() {
        if (isExpiry) {
          expiryDate = pickedDate;
        } else {
          selectedDate = pickedDate;
        }
      });
    }
  }

  /// Function to calculate TTL (Time to Live) for AWS DynamoDB
  int? _calculateTTL() {
    if (expiryDate != null) {
      return expiryDate!.millisecondsSinceEpoch ~/ 1000;
    }
    return null;
  }

  void handleFilesUpdated(List<Map<String, String>> uploadedFiles) {
    for (var file in uploadedFiles) {
      if (file.containsKey('url')) {
        uploadedFileUrls.add(file['url']!);
      }
    }
  }

  bool _validateFields() {
    if (eventNameController.text.isEmpty ||
        detailsController.text.isEmpty ||
        locationController.text.isEmpty ||
        registerUrlController.text.isEmpty ||
        selectedDate == null ||
        expiryDate == null) {
      showErrorSnackBar(context, "Please Fill the All Fields");
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Create Event"),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FilePickerBoxUI(
                selectfiles: selectedFiles, onFilesUpdated: handleFilesUpdated),
            SizedBox(height: 20),
            _buildTextField(eventNameController, "Event Name", Icons.event),
            _buildTextField(
                detailsController, "Event Details", Icons.description),
            _buildTextField(locationController, "Location", Icons.location_on),
            _buildTextField(registerUrlController, "Register URL", Icons.link),

            SizedBox(height: 16),

            // Event Date Picker
            _buildDatePickerTile(
              "Select Event Date",
              selectedDate,
              Icons.calendar_today,
              () => _pickDate(context, false),
            ),

            SizedBox(height: 12),

            // Expiry Date Picker
            _buildDatePickerTile(
              "Select Expiry Date",
              expiryDate,
              Icons.timer_off,
              () => _pickDate(context, true),
              showTTL: true,
            ),

            SizedBox(height: 20),

            // Submit Button with Gradient
            Center(
              child: Obx(
                () => ElevatedButton(
                  onPressed: () async {
                    try {
                      if (_validateFields()) {
                        int? ttl = _calculateTTL();
                        if (ttl != null) {
                          widget.controller.loading.value = true;
                          final response = await createEvent(Events(
                              model: "Events",
                              images: uploadedFileUrls,
                              eventname: eventNameController.text,
                              details: detailsController.text,
                              location: locationController.text,
                              date: selectedDate.toString(),
                              createdAt: awsTimestamp,
                              registerUrl: registerUrlController.text,
                              expiry: ttl));
                          if (response.data != null) {
                            widget.controller.loading.value = false;
                            Get.find<EventController>().reload();
                            navigatorpushandremove(context, LandingPage());
                          } else if (response.hasErrors) {
                            showErrorSnackBar(
                                context, "There was an Error Occured");
                          }
                        }
                      }
                    } on Exception catch (e) {
                      widget.controller.loading.value = false;
                      showErrorSnackBar(
                          context, "An unexpected error occurred: $e");
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                    backgroundColor: Colors.blueAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    shadowColor: Colors.black45,
                    elevation: 8,
                  ),
                  child: widget.controller.loading.value
                      ? CircularProgressIndicator()
                      : Text("Submit"),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Reusable Function to Build Stylish TextFields
  Widget _buildTextField(
      TextEditingController controller, String label, IconData icon) {
    return Container(
      margin: EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Colors.blueAccent),
          hintText: label,
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        ),
      ),
    );
  }

  /// Reusable Function to Build Elegant Date Pickers
  Widget _buildDatePickerTile(
      String label, DateTime? date, IconData icon, VoidCallback onTap,
      {bool showTTL = false}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
      ),
      child: ListTile(
        title: Text(
          date == null
              ? label
              : "$label: ${DateFormat('yyyy-MM-dd').format(date)}",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        subtitle: showTTL && date != null
            ? Text("TTL: ${_calculateTTL()} seconds",
                style: TextStyle(
                    color: Colors.blueAccent, fontWeight: FontWeight.bold))
            : null,
        trailing: Icon(icon, color: Colors.blueAccent),
        onTap: onTap,
      ),
    );
  }
}
