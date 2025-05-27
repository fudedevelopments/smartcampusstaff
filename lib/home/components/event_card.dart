import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smartcampusstaff/components/display_image.dart';
import 'package:smartcampusstaff/home/event_details.dart';
import 'package:smartcampusstaff/model/eventmodel.dart';
import 'package:smartcampusstaff/utils/utils.dart';

class EventCard extends StatelessWidget {
  final EventModel event;
  final VoidCallback? onDelete;
  final VoidCallback? onEdit;

  const EventCard({
    Key? key,
    required this.event,
    this.onDelete,
    this.onEdit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Calculate width based on screen size, accounting for margins
    final cardWidth = MediaQuery.of(context).size.width - 32;

    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          // Navigate to event details
          navigationpush(context, EventDetailsPage(event: event));
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
              child: SizedBox(
                height: 120,
                width: double.infinity,
                child: event.images.isNotEmpty
                    ? ImageDisplay(
                        imageUrlFuture: getimage(path: event.images.first),
                        height: 120,
                        width: cardWidth,
                        fit: BoxFit.cover,
                        maxHeight: 240, // Explicit max height (2x display size)
                        maxWidth: (cardWidth * 2)
                            .toInt(), // Convert to int for max width
                        errorWidget: Container(
                          color: Colors.blue.shade100,
                          child: const Center(
                            child: Icon(
                              Icons.event,
                              size: 50,
                              color: Colors.blue,
                            ),
                          ),
                        ),
                        loadingWidget: Container(
                          color: Colors.blue.shade50,
                          child: const Center(
                            child: CircularProgressIndicator(),
                          ),
                        ),
                      )
                    : Container(
                        color: Colors.blue.shade100,
                        child: const Center(
                          child: Icon(
                            Icons.event,
                            size: 50,
                            color: Colors.blue,
                          ),
                        ),
                      ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          event.eventName,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (onEdit != null || onDelete != null)
                        Row(
                          children: [
                            if (onEdit != null)
                              IconButton(
                                icon: const Icon(Icons.edit,
                                    color: Colors.blue, size: 20),
                                onPressed: onEdit,
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
                                tooltip: 'Edit Event',
                              ),
                            if (onEdit != null && onDelete != null)
                              const SizedBox(width: 8),
                            if (onDelete != null)
                              IconButton(
                                icon: const Icon(Icons.delete,
                                    size: 20, color: Colors.red),
                                onPressed: onDelete,
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
                                tooltip: 'Delete Event',
                              ),
                          ],
                        ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.location_on, size: 16),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          event.location,
                          style: TextStyle(color: Colors.grey.shade700),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.calendar_today, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        DateFormat('MMM dd, yyyy').format(event.date),
                        style: TextStyle(color: Colors.grey.shade700),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  if (event.details.isNotEmpty)
                    Text(
                      event.details,
                      style: const TextStyle(fontSize: 14),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
