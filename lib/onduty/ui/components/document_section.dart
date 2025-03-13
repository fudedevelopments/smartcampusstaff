import 'package:flutter/material.dart';
import 'package:smartcampusstaff/model/newonduty.dart';

class DocumentSection extends StatelessWidget {
  final OnDutyModel model;
  final Map<String, bool> downloadedFiles;
  final Function(String) onDownloadFile;
  final Map<String, double>? downloadProgress; // Track download progress

  const DocumentSection({
    Key? key,
    required this.model,
    required this.downloadedFiles,
    required this.onDownloadFile,
    this.downloadProgress,
  }) : super(key: key);

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
            const Text(
              'Documents',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            model.validDocuments.isEmpty
                ? _buildEmptyDocumentsMessage()
                : ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: model.validDocuments.length,
                    itemBuilder: (context, index) {
                      final docPath = model.validDocuments[index];
                      final fileName = docPath.split('/').last;
                      final isDownloaded = downloadedFiles[docPath] == true;
                      final progress = downloadProgress?[docPath] ?? 0.0;
                      final isDownloading = progress > 0 && progress < 1.0;

                      return Card(
                        elevation: 2,
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        child: ListTile(
                          leading: _buildLeadingIcon(
                              context, isDownloaded, isDownloading, progress),
                          title: Text(
                            fileName.length > 20
                                ? '${fileName.substring(0, 20)}...'
                                : fileName,
                            style: const TextStyle(fontWeight: FontWeight.w500),
                          ),
                          subtitle: isDownloading
                              ? LinearProgressIndicator(
                                  value: progress,
                                  backgroundColor: Colors.grey.shade200,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Theme.of(context).primaryColor,
                                  ),
                                )
                              : Text(
                                  isDownloaded
                                      ? 'Downloaded'
                                      : 'Tap to download',
                                  style: TextStyle(
                                    color: isDownloaded
                                        ? Colors.green.shade700
                                        : Colors.grey.shade600,
                                    fontSize: 12,
                                  ),
                                ),
                          onTap: () => onDownloadFile(docPath),
                        ),
                      );
                    },
                  ),
          ],
        ),
      ),
    );
  }

  Widget _buildLeadingIcon(BuildContext context, bool isDownloaded,
      bool isDownloading, double progress) {
    if (isDownloading) {
      // Show circular progress indicator when downloading
      return SizedBox(
        width: 24,
        height: 24,
        child: CircularProgressIndicator(
          value: progress,
          strokeWidth: 2.0,
          valueColor: AlwaysStoppedAnimation<Color>(
            Theme.of(context).primaryColor,
          ),
        ),
      );
    } else if (isDownloaded) {
      // Show file icon when downloaded
      return Icon(
        Icons.insert_drive_file,
        color: Theme.of(context).primaryColor,
      );
    } else {
      // Show download icon when not downloaded
      return Icon(
        Icons.download,
        color: Theme.of(context).primaryColor,
      );
    }
  }

  Widget _buildEmptyDocumentsMessage() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      alignment: Alignment.center,
      child: const Text(
        'No documents available',
        style: TextStyle(
          color: Colors.grey,
          fontStyle: FontStyle.italic,
        ),
      ),
    );
  }
}
