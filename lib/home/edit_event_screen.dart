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
import 'package:smartcampusstaff/model/eventmodel.dart';
import 'package:smartcampusstaff/models/EventsModel.dart';
import 'package:smartcampusstaff/utils/utils.dart';

class EditEventRequest extends GetxController {
  RxBool loading = false.obs;
  RxBool isLoading = true.obs;
  Rx<EventModel?> event = Rx<EventModel?>(null);
}

class EditEventScreen extends StatefulWidget {
  final String eventId;
  final EditEventRequest controller = Get.put(EditEventRequest());

  EditEventScreen({Key? key, required this.eventId}) : super(key: key);

  @override
  _EditEventScreenState createState() => _EditEventScreenState();
}

class _EditEventScreenState extends State<EditEventScreen> {
  final TextEditingController eventNameController = TextEditingController();
  final TextEditingController detailsController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController registerUrlController = TextEditingController();
  List<String> uploadedFileUrls = [];
  DateTime? selectedDate;
  DateTime? expiryDate;
  List<File> selectedFiles = [];

  @override
  void initState() {
    super.initState();
    _loadEventData();
  }

  Future<void> _loadEventData() async {
    try {
      widget.controller.isLoading.value = true;

      // Get the events controller
      final eventsController = Get.find<EventsController>();

      // Get the event data
      final event = await eventsController.getEvent(widget.eventId);

      if (event != null) {
        widget.controller.event.value = event;

        // Set the form fields
        eventNameController.text = event.eventName;
        detailsController.text = event.details;
        locationController.text = event.location;
        registerUrlController.text = event.registerUrl;

        // Set dates
        selectedDate = event.date;
        expiryDate = event.expiry;

        // Set images
        uploadedFileUrls = List<String>.from(event.images);
      } else {
        showErrorSnackBar(context, "Event not found");
        Navigator.pop(context);
      }
    } catch (e) {
      showErrorSnackBar(context, "Error loading event: $e");
    } finally {
      widget.controller.isLoading.value = false;
    }
  }

  /// Function to pick a date
  Future<void> _pickDate(BuildContext context, bool isExpiry) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: isExpiry
          ? (expiryDate ?? DateTime.now())
          : (selectedDate ?? DateTime.now()),
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
        title: Text("Edit Event"),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: Obx(() {
        if (widget.controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        return SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FilePickerBoxUI(
                  selectfiles: selectedFiles,
                  onFilesUpdated: handleFilesUpdated),
              SizedBox(height: 20),
              _buildTextField(eventNameController, "Event Name", Icons.event),
              _buildTextField(
                  detailsController, "Event Details", Icons.description),
              _buildTextField(
                  locationController, "Location", Icons.location_on),
              _buildTextField(
                  registerUrlController, "Register URL", Icons.link),

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

                            // Create updated event model
                            final updatedEvent = EventsModel(
                                id: widget.eventId,
                                eventname: eventNameController.text,
                                location: locationController.text,
                                date: eventDate,
                                details: detailsController.text,
                                registeredUrl: registerUrlController.text,
                                images: uploadedFileUrls,
                                createdAt: TemporalTimestamp.fromSeconds(widget
                                        .controller
                                        .event
                                        .value!
                                        .createdAt
                                        .millisecondsSinceEpoch ~/
                                    1000),
                                expiray: TemporalTimestamp.fromSeconds(ttl));

                            // Update the event
                            final response = await updateEvent(updatedEvent);

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
                                  content: Text('Event updated successfully'),
                                  backgroundColor: Colors.green,
                                ),
                              );

                              // Navigate back to the events page
                              Navigator.of(context).pop();
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
                      padding:
                          EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                      backgroundColor: Colors.blueAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      shadowColor: Colors.black45,
                      elevation: 8,
                    ),
                    child: widget.controller.loading.value
                        ? CircularProgressIndicator()
                        : Text("Update Event"),
                  ),
                ),
              ),
            ],
          ),
        );
      }),
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
