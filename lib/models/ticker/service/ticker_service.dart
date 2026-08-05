import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:finonex_task/models/_models.dart';

class TickerService {
  TickerService({
    required this._client,
    required this._baseUrl,
    required this._authModel,
  });

  final http.Client _client;
  final String _baseUrl;
  final AuthModel _authModel;

  Future<Stream<TickerData>> getTickerDataStream() async {
    final token = await _authModel.getToken();
    if (token == null) throw Exception('No token available');

    final request = http.Request('GET', Uri.parse('$_baseUrl/stream'))
      ..headers['Authorization'] = 'Bearer $token'
      ..headers['Accept'] = 'text/event-stream'
      ..headers['Cache-Control'] = 'no-cache';

    final response = await _client.send(request);

    if (response.statusCode != 200) {
      throw Exception('Failed to connect to ticker stream: ${response.statusCode}');
    }

    String? currentEvent;
    return response.stream
        .transform(utf8.decoder)
        .transform(const LineSplitter())
        .map((line) {
          if (line.startsWith('event: ')) {
            currentEvent = line.substring(7);
          } else if (line.startsWith('data: ')) {
            if (currentEvent == 'tick') {
              final jsonString = line.substring(6);
              try {
                return TickerData.fromJson(jsonDecode(jsonString) as Map<String, dynamic>);
              } catch (_) {
                return null;
              }
            }
          } else if (line.isEmpty) {
            currentEvent = null;
          }
          return null;
        })
        .where((ticker) => ticker != null)
        .cast<TickerData>();
  }
}
