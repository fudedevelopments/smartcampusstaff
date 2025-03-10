import 'dart:io';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

class FileDownloadHelper {
  final String downloadPath;
  final Map<String, bool> downloadedFiles;
  final Function(Map<String, bool>) onDownloadStatusChanged;
  final Function(String, double)?
      onDownloadProgress; // Callback for download progress

  // Cache for file paths to avoid repeated checks
  final Map<String, String> _filePathCache = {};

  // Track download progress
  final Map<String, double> _downloadProgress = {};

  FileDownloadHelper({
    required this.downloadPath,
    required this.downloadedFiles,
    required this.onDownloadStatusChanged,
    this.onDownloadProgress,
  });

  Future<void> requestStoragePermission() async {
    if (await Permission.storage.request().isGranted) {
      debugPrint("Storage permission granted");
      // Initialize the download directory
      _ensureDownloadDirectoryExists();
    } else {
      debugPrint("Storage permission denied");
    }
  }

  Future<void> _ensureDownloadDirectoryExists() async {
    final dir = Directory(downloadPath);
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }
  }

  Future<void> checkDownloadedFiles() async {
    await _ensureDownloadDirectoryExists();

    final dir = Directory(downloadPath);
    if (await dir.exists()) {
      final files = dir.listSync().map((e) => e.path.split('/').last).toSet();
      final updatedMap = Map<String, bool>.from(downloadedFiles);

      for (var doc in downloadedFiles.keys) {
        final filename = doc.split('/').last;
        final exists = files.contains(filename);
        updatedMap[doc] = exists;

        // Cache the file path if it exists
        if (exists) {
          _filePathCache[doc] = '$downloadPath/$filename';
        }
      }

      onDownloadStatusChanged(updatedMap);
    }
  }

  // Get current download progress
  double getProgress(String documentPath) {
    return _downloadProgress[documentPath] ?? 0.0;
  }

  Future<void> downloadFile(String documentPath) async {
    try {
      final filename = documentPath.split('/').last;
      final filepath = '$downloadPath/$filename';

      // Reset progress for this file
      _downloadProgress[documentPath] = 0.0;
      if (onDownloadProgress != null) {
        onDownloadProgress!(documentPath, 0.0);
      }

      // Check if we already have the file path cached
      final cachedPath = _filePathCache[documentPath];
      if (cachedPath != null) {
        try {
          final result = await OpenFile.open(cachedPath);
          debugPrint('File opened from cache: ${result.message}');
          return;
        } catch (e) {
          debugPrint('Error opening cached file: $e');
          // If there's an error, we'll continue and try to download again
          _filePathCache.remove(documentPath);
        }
      }

      // Check if file exists on disk
      final file = File(filepath);
      if (await file.exists()) {
        try {
          final result = await OpenFile.open(filepath);
          debugPrint('File opened: ${result.message}');

          // Cache the file path for future use
          _filePathCache[documentPath] = filepath;

          // Update the download status
          final updatedMap = Map<String, bool>.from(downloadedFiles);
          updatedMap[documentPath] = true;
          onDownloadStatusChanged(updatedMap);

          return;
        } catch (e) {
          debugPrint('Error opening file: $e');
          // If there's an error, we'll continue and try to download again
        }
      }

      await _ensureDownloadDirectoryExists();

      // Show download progress
      debugPrint('Downloading file: $filename');

      // Download with progress tracking
      final downloadOperation = Amplify.Storage.downloadFile(
        path: StoragePath.fromString(documentPath),
        localFile: AWSFile.fromPath(filepath),
        onProgress: (progress) {
          final progressValue = progress.fractionCompleted;
          _downloadProgress[documentPath] = progressValue;
          if (onDownloadProgress != null) {
            onDownloadProgress!(documentPath, progressValue);
          }
          debugPrint(
              'Download progress: ${(progressValue * 100).toStringAsFixed(1)}%');
        },
      );

      final result = await downloadOperation.result;

      // Cache the file path
      _filePathCache[documentPath] = filepath;

      // Update download status
      final updatedMap = Map<String, bool>.from(downloadedFiles);
      updatedMap[documentPath] = true;
      onDownloadStatusChanged(updatedMap);

      // Set progress to 100%
      _downloadProgress[documentPath] = 1.0;
      if (onDownloadProgress != null) {
        onDownloadProgress!(documentPath, 1.0);
      }

      debugPrint('Downloaded file is located at: ${result.localFile.path}');
      try {
        final openResult = await OpenFile.open(filepath);
        debugPrint('File opened after download: ${openResult.message}');
      } catch (e) {
        debugPrint('Error opening file after download: $e');
      }
    } on StorageException catch (e) {
      debugPrint("Storage error: ${e.message}");
      // Reset progress on error
      _downloadProgress[documentPath] = 0.0;
      if (onDownloadProgress != null) {
        onDownloadProgress!(documentPath, 0.0);
      }
    } on Exception catch (e) {
      debugPrint("General error: $e");
      // Reset progress on error
      _downloadProgress[documentPath] = 0.0;
      if (onDownloadProgress != null) {
        onDownloadProgress!(documentPath, 0.0);
      }
    }
  }
}
