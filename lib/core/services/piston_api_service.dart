import 'dart:convert';
import 'package:http/http.dart' as http;

class PistonExecutionResult {
  final String stdout;
  final String stderr;
  final int exitCode;
  final String output;

  const PistonExecutionResult({
    required this.stdout,
    required this.stderr,
    required this.exitCode,
    required this.output,
  });

  bool get isSuccess => exitCode == 0 && stderr.isEmpty;
}

class PistonApiService {
  static const String _pistonUrl = 'https://emkc.org/api/v2/piston/execute';

  /// Execute code using Piston API for Dart
  static Future<PistonExecutionResult> executeDartCode(String code) async {
    try {
      final response = await http.post(
        Uri.parse(_pistonUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'language': 'dart',
          'version': '2.19.6',
          'files': [
            {'content': code}
          ],
        }),
      ).timeout(const Duration(seconds: 12));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final run = data['run'] ?? {};
        return PistonExecutionResult(
          stdout: run['stdout'] ?? '',
          stderr: run['stderr'] ?? '',
          exitCode: run['code'] ?? 0,
          output: run['output'] ?? (run['stdout'] ?? 'Execution completed.'),
        );
      } else {
        return PistonExecutionResult(
          stdout: '',
          stderr: 'HTTP Error ${response.statusCode}: Failed to reach compiler server.',
          exitCode: 1,
          output: 'Error executing code via Piston API.',
        );
      }
    } catch (e) {
      return PistonExecutionResult(
        stdout: '',
        stderr: e.toString(),
        exitCode: 1,
        output: 'Network or execution timeout error: $e',
      );
    }
  }
}
