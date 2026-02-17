import 'package:flutter/material.dart';
import 'package:csv/csv.dart';
import 'package:universal_html/html.dart' as html;
import 'dart:convert';
import '../core/error_handler.dart';

class DataExporter {
  // Export to CSV
  static Future<void> exportToCSV(
    BuildContext context, {
    required List<List<dynamic>> data,
    required String filename,
  }) async {
    try {
      String csv = const ListToCsvConverter().convert(data);
      _downloadFile(csv, '$filename.csv', 'text/csv');
      
      if (context.mounted) {
        AppNotification.showSuccess(
          context,
          'Data exported successfully to $filename.csv',
        );
      }
    } catch (e) {
      if (context.mounted) {
        ErrorHandler.handleError(e, null, context: context);
      }
    }
  }

  // Export to JSON
  static Future<void> exportToJSON(
    BuildContext context, {
    required Map<String, dynamic> data,
    required String filename,
  }) async {
    try {
      String json = const JsonEncoder.withIndent('  ').convert(data);
      _downloadFile(json, '$filename.json', 'application/json');
      
      if (context.mounted) {
        AppNotification.showSuccess(
          context,
          'Data exported successfully to $filename.json',
        );
      }
    } catch (e) {
      if (context.mounted) {
        ErrorHandler.handleError(e, null, context: context);
      }
    }
  }

  // Helper method to trigger download in web
  static void _downloadFile(
    String content,
    String filename,
    String mimeType,
  ) {
    final bytes = utf8.encode(content);
    final blob = html.Blob([bytes], mimeType);
    final url = html.Url.createObjectUrlFromBlob(blob);
    html.AnchorElement(href: url)
      ..setAttribute('download', filename)
      ..click();
    html.Url.revokeObjectUrl(url);
  }
}

class ExportButton extends StatelessWidget {
  final List<List<dynamic>> data;
  final String filename;
  final String? label;
  final IconData? icon;

  const ExportButton({
    super.key,
    required this.data,
    required this.filename,
    this.label,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () => _showExportOptions(context),
      icon: Icon(icon ?? Icons.download),
      label: Text(label ?? 'Export'),
    );
  }

  void _showExportOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.table_chart),
              title: const Text('Export to CSV'),
              onTap: () {
                Navigator.pop(context);
                DataExporter.exportToCSV(
                  context,
                  data: data,
                  filename: filename,
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.code),
              title: const Text('Export to JSON'),
              onTap: () {
                Navigator.pop(context);
                // Convert List<List> to Map for JSON export
                final jsonData = {
                  'data': data,
                  'exportedAt': DateTime.now().toIso8601String(),
                };
                DataExporter.exportToJSON(
                  context,
                  data: jsonData,
                  filename: filename,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
