import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smartcampusstaff/components/cached_image_provider.dart';
import 'package:smartcampusstaff/model/eventmodel.dart';
import 'package:url_launcher/url_launcher.dart';

class EventDetailsPage extends StatelessWidget {
  final EventModel event;

  const EventDetailsPage({super.key, required this.event});

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Event Details",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Event Image
            if (event.images.isNotEmpty)
              SizedBox(
                height: 200,
                width: double.infinity,
                child: CachedImageProvider(
                  imagePath: event.images[0],
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  borderRadius: BorderRadius.zero,
                  maxHeight: 800,
                  maxWidth: 1200,
                ),
              )
            else
              Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.grey, Colors.black45],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Center(
                  child: Icon(Icons.event, color: Colors.white, size: 64),
                ),
              ),

            // Event Title and Date
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event.eventName,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.calendar_today, size: 16, color: Colors.blue),
                      SizedBox(width: 8),
                      Text(
                        DateFormat('EEEE, MMM d, yyyy').format(event.date),
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[700],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 24),

                  // Location
                  _buildDetailSection(
                    context,
                    'Location',
                    Icons.location_on,
                    event.location,
                  ),
                  SizedBox(height: 16),

                  // Details
                  _buildDetailSection(
                    context,
                    'About this Event',
                    Icons.info_outline,
                    event.details,
                    isExpandable: true,
                  ),
                  SizedBox(height: 16),

                  // Registration Link
                  _buildDetailSection(
                    context,
                    'Registration',
                    Icons.link,
                    event.registerUrl,
                    isLink: true,
                    onTap: () => _launchURL(event.registerUrl),
                  ),
                  SizedBox(height: 16),

                  // Expiry
                  _buildDetailSection(
                    context,
                    'expiry',
                    Icons.timer_outlined,
                    DateFormat('EEEE, MMM d, yyyy').format(event.expiry),
                  ),
                  SizedBox(height: 24),

                  // Created and Updated
                  Divider(),
                  SizedBox(height: 8),
                  Text(
                    'Event created on ${DateFormat('MMM d, yyyy').format(event.createdAt)}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Last updated on ${DateFormat('MMM d, yyyy').format(event.updatedAt)}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                  SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailSection(
    BuildContext context,
    String title,
    IconData icon,
    String content, {
    bool isExpandable = false,
    bool isLink = false,
    VoidCallback? onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 20, color: Colors.blue),
            SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ],
        ),
        SizedBox(height: 8),
        isLink
            ? GestureDetector(
                onTap: onTap,
                child: Text(
                  content,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
                  ),
                ),
              )
            : isExpandable
                ? Text(
                    content,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black87,
                      height: 1.5,
                    ),
                  )
                : Text(
                    content,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                  ),
      ],
    );
  }
}
