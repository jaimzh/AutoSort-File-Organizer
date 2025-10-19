import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  static const String baseUrl = "http://127.0.0.1:8001";
  static bool isMonitoring = false;
  static bool isScanning = false;

  //health
  static Future<bool> isApiHealthy() async {
    final response = await http.get(Uri.parse("$baseUrl/health"));
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  // ===== CONFIG =====
  static Future<Map<String, dynamic>?> getConfig() async {
    final response = await http.get(Uri.parse("$baseUrl/config"));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      print("Error getting config: ${response.body}");
      return null;
    }
  }

  static Future<Map<String, List<String>>?> getExtensions() async {
    try {
      // Get the full config
      final response = await http.get(Uri.parse("$baseUrl/config"));

      if (response.statusCode == 200) {
        final Map<String, dynamic> config = jsonDecode(response.body);

        // Extract the "rules" section which contains extension mappings
        if (config.containsKey("rules")) {
          final Map<String, dynamic> rules = config["rules"];

          // Convert all values to List<String>
          final Map<String, List<String>> extensions = rules.map(
            (key, value) => MapEntry(key, List<String>.from(value)),
          );

          print("✅ Extensions fetched successfully: $extensions");
          return extensions;
        } else {
          print("⚠️ No 'rules' key found in config.json");
          return null;
        }
      } else {
        print(
          "❌ Error fetching config: ${response.statusCode} ${response.body}",
        );
        return null;
      }
    } catch (e) {
      print("⚠️ Exception while fetching extensions: $e");
      return null;
    }
  }

  static Future<Map<String, dynamic>?> resetDefaults() async {
    try {
      final response = await http.put(
        Uri.parse("$baseUrl/config/reset_defaults"),
        headers: {"Content-Type": "application/json"},
      );

      if (response.statusCode == 200) {
        print("✅ Configuration reset to defaults successfully");
        final data = jsonDecode(response.body);
        return data['config']; // return just the updated config
      } else {
        print(
          "❌ Failed to reset defaults: ${response.statusCode} ${response.body}",
        );
        return null;
      }
    } catch (e) {
      print("⚠️ Exception resetting config to defaults: $e");
      return null;
    }
  }

  static Future<Map<String, dynamic>?> updateFullConfig(
    Map<String, dynamic> fullConfig,
  ) async {
    try {
      final response = await http.put(
        Uri.parse("$baseUrl/config/full_update"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"config": fullConfig}), // ✅ wrap inside "config"
      );

      if (response.statusCode == 200) {
        print("✅ Full config updated successfully");
        return jsonDecode(response.body);
      } else {
        print(
          "❌ Error updating full config: ${response.statusCode} ${response.body}",
        );
        return null;
      }
    } catch (e) {
      print("⚠️ Exception updating full config: $e");
      return null;
    }
  }

  static Future<Map<String, dynamic>?> updateConfig({
    String? sourceFolder,
    String? destinationFolder,
    String? mode,
  }) async {
    final body = {};
    if (sourceFolder != null) body['source_folder'] = sourceFolder;
    if (destinationFolder != null) {
      body['destination_folder'] = destinationFolder;
    }
    if (mode != null) body['mode'] = mode;

    final response = await http.patch(
      Uri.parse("$baseUrl/config/update"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      print("Error updating config: ${response.body}");
      return null;
    }
  }

  static Future<Map<String, dynamic>?> updateConfigWithRules(
    Map<String, dynamic> newConfig,
  ) async {
    final response = await http.patch(
      Uri.parse("$baseUrl/config/rules"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(newConfig),
    );

    if (response.statusCode == 200) {
      print("✅ Config updated successfully");
      return jsonDecode(response.body);
    } else {
      print("❌ Error updating config: ${response.statusCode} ${response.body}");
      return null;
    }
  }

  static Future<Map<String, dynamic>?> deleteCategory(String category) async {
    final response = await http.patch(
      Uri.parse("$baseUrl/config/rules/delete_category"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({'category': category}),
    );

    if (response.statusCode == 200) {
      print("✅ Config deleted/updated successfully");
      return jsonDecode(response.body);
    } else {
      print("❌ Error deleting config: ${response.statusCode} ${response.body}");
      return null;
    }
  }

  // ===== SCAN =====
  static Future<void> startScan() async {
    final response = await http.post(Uri.parse("$baseUrl/scan/start"));
    if (response.statusCode == 200) {
      isScanning = true;
      print("✅ Scan started!");
    } else {
      print("❌ Error starting scan: ${response.body}");
    }
  }

  static Future<void> stopScan() async {
    final response = await http.post(Uri.parse("$baseUrl/scan/stop"));
    if (response.statusCode == 200) {
      isScanning = false;
      print("✅ Scan stopped!");
    } else {
      print("❌ Error stopping scan: ${response.body}");
    }
  }

  // ===== MONITOR =====
  static Future<void> startMonitor() async {
    final response = await http.post(Uri.parse("$baseUrl/monitor/start"));
    if (response.statusCode == 200) {
      isMonitoring = true;
      print("✅ Monitor started!");
    } else {
      print("❌ Error starting monitor: ${response.body}");
    }
  }

  static Future<void> stopMonitor() async {
    final response = await http.post(Uri.parse("$baseUrl/monitor/stop"));
    if (response.statusCode == 200) {
      isMonitoring = false;
      print("✅ Monitor stopped!");
    } else {
      print("❌ Error stopping monitor: ${response.body}");
    }
  }

  // ===== COUNTS =====
  static Future<Map<String, dynamic>?> getCounts() async {
    final response = await http.get(Uri.parse("$baseUrl/counts"));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      print("❌ Error getting counts: ${response.body}");
      return null;
    }
  }

  // ===== LOGS =====
  static Future<List<Map<String, dynamic>>?> getLogs() async {
    final response = await http.get(Uri.parse("$baseUrl/logs"));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return List<Map<String, dynamic>>.from(data['logs']);
    } else {
      print("❌ Error getting logs: ${response.body}");
      return null;
    }
  }

  static Future<List<Map<String, dynamic>>?> clearLogs() async {
    final response = await http.delete(Uri.parse("$baseUrl/logs/clear"));
    if (response.statusCode == 200) {
      isMonitoring = false;
      print("✅ logs all cleared: ${response.body}");
    } else {
      print("❌ Error clearing logs: ${response.body}");
    }
    return null;
  }

  // ===== EXCEPTIONS =====
  static Future<List<String>?> getExceptions() async {
    try {
      final response = await http.get(Uri.parse("$baseUrl/config/exceptions"));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return List<String>.from(data['exceptions']);
      } else {
        print(
          "❌ Error fetching exceptions: ${response.statusCode} ${response.body}",
        );
        return null;
      }
    } catch (e) {
      print("⚠️ Exception while fetching exceptions: $e");
      return null;
    }
  }

  static Future<List<String>?> updateExceptions(List<String> exceptions) async {
    try {
      final response = await http.patch(
        Uri.parse("$baseUrl/config/exceptions"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"exceptions": exceptions}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print("✅ Exceptions updated successfully");
        return List<String>.from(data['exceptions']);
      } else {
        print(
          "❌ Error updating exceptions: ${response.statusCode} ${response.body}",
        );
        return null;
      }
    } catch (e) {
      print("⚠️ Exception while updating exceptions: $e");
      return null;
    }
  }

  // ===== DARK MODE =====
  static Future<bool?> getDarkMode() async {
    final response = await http.get(Uri.parse('$baseUrl/config/dark_mode'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body)['dark_mode'];
    }
    return null;
  }

  static Future<void> updateDarkMode(bool value) async {
    await http.patch(Uri.parse('$baseUrl/config/dark_mode?value=$value'));
  }
}
