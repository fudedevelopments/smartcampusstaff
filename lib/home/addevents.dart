import 'dart:io';

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:smartcampusstaff/components/errorsnack.dart';
import 'package:smartcampusstaff/components/file_pick.dart';
import 'package:smartcampusstaff/home/apicallevent.dart';
import 'package:smartcampusstaff/home/controllers/events_controller.dart';
import 'package:smartcampusstaff/landing_page/ui/landing_page.dart';
import 'package:smartcampusstaff/models/EventsModel.dart';
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
                          final eventDate = TemporalDate(DateTime(
                            selectedDate!.year,
                            selectedDate!.month,
                            selectedDate!.day,
                          ));

                          final response = await createEvent(EventsModel(
                              eventname: eventNameController.text,
                              location: locationController.text,
                              date: eventDate,
                              details: detailsController.text,
                              registeredUrl: registerUrlController.text,
                              images: uploadedFileUrls,
                              createdAt: TemporalTimestamp.now(),
                              expiray: TemporalTimestamp.fromSeconds(ttl)));

                          if (response.data != null) {
                            widget.controller.loading.value = false;

                            // Clear the event cache to ensure fresh data
                            final eventApiService = EventApiService();
                            await eventApiService.clearCache();

                            // Get the events controller if it exists
                            if (Get.isRegistered<EventsController>()) {
                              final eventsController =
                                  Get.find<EventsController>();
                              // Refresh events data before navigating
                              await eventsController.refreshData();
                            }

                            // Show success message
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Event created successfully'),
                                backgroundColor: Colors.green,
                              ),
                            );

                            // Now navigate to landing page
                            navigatorpushandremove(context, LandingPage());
                          } else if (response.hasErrors) {
                            widget.controller.loading.value = false;
                            showErrorSnackBar(context,
                                "There was an Error Occurred: ${response.errors.map((e) => e.message).join(', ')}");
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
