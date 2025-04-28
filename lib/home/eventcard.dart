import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smartcampusstaff/components/cached_image_provider.dart';
import 'package:smartcampusstaff/home/event_details.dart';
import 'package:smartcampusstaff/model/eventmodel.dart';
import 'package:smartcampusstaff/utils/utils.dart';

class EventCard extends StatelessWidget {
  final EventModel event;
  final VoidCallback? onDelete; // Callback for delete action

  const EventCard({super.key, required this.event, this.onDelete});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        navigationpush(context, EventDetailsPage(event: event));
      },
      child: Container(
        width: 260,
        margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          clipBehavior: Clip.antiAlias,
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Event Image
                  event.images.isNotEmpty
                      ? SizedBox(
                          height: 120,
                          width: double.infinity, // Ensure it takes full width
                          child: CachedImageProvider(
                            imagePath: event.images[0],
                            height: 120, // Match the SizedBox height
                            width: double.infinity,
                            fit: BoxFit.cover, // Ensure it covers the area
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(12),
                            ),
                            // Higher quality image settings
                            maxHeight: 600,
                            maxWidth: 800,
                          ),
                        )
                      : Container(
                          height: 120,
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Colors.grey, Colors.black45],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(12),
                            ),
                          ),
                          child: const Center(
                            child: Icon(Icons.event,
                                color: Colors.white, size: 32),
                          ),
                        ),
                  // Event Details
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Event Name
                        Text(
                          event.eventName,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 6),
                        // Date and Location
                        Row(
                          children: [
                            const Icon(Icons.calendar_today,
                                size: 14, color: Colors.grey),
                            const SizedBox(width: 4),
                            Text(
                              DateFormat('MMM d, yyyy').format(event.date),
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(width: 12),
                            const Icon(Icons.location_on,
                                size: 14, color: Colors.grey),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                event.location,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        // Event Details Snippet
                        Text(
                          event.details,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.black54,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8),
                      ],
                    ),
                  ),
                ],
              ),
              // Delete Button
              Positioned(
                bottom: 8,
                right: 8,
                child: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.redAccent),
                  onPressed: onDelete ??
                      () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Deleted ${event.eventName}')),
                        );
                      },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
