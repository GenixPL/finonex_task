import 'dart:convert';
import 'package:finonex_task/models/auth/_auth.dart';
import 'package:finonex_task/models/ticker/_ticker.dart';
import 'package:http/http.dart' as http;
import 'package:rxdart/rxdart.dart';

class TickerService {
  TickerService({
    required this._client,
    required this._baseUrl,
    required this._authModel,
  });

  final http.Client _client;
  final String _baseUrl;
  final AuthModel _authModel;

  Future<Stream<TickerEvent>> getTickerDataStream({String? lastEventId}) async {
    final token = await _authModel.getToken();
    if (token == null) throw Exception('No token available');

    final request = http.Request('GET', Uri.parse('$_baseUrl/stream'))
      ..headers['Authorization'] = 'Bearer $token'
      ..headers['Accept'] = 'text/event-stream'
      ..headers['Cache-Control'] = 'no-cache';

    if (lastEventId != null) {
      request.headers['Last-Event-ID'] = lastEventId;
    }

    final response = await _client.send(request).timeout(const Duration(seconds: 5));

    if (response.statusCode != 200) {
      throw Exception('Failed to connect to ticker stream: ${response.statusCode}');
    }

    String? currentEvent;
    String? currentData;
    String? currentId;

    return response.stream
        //
        .transform(utf8.decoder)
        //
        .transform(const LineSplitter())
        //
        .map<TickerEvent?>((line) {
          if (line.startsWith('event: ')) {
            currentEvent = line.substring(7);
          } else if (line.startsWith('data: ')) {
            currentData = (currentData ?? '') + line.substring(6);
          } else if (line.startsWith('id: ')) {
            currentId = line.substring(4);
          } else if (line.startsWith(':')) {
            if (line.substring(1).trim() == 'ping') {
              return const TickerPingEvent();
            }
          } else if (line.isEmpty) {
            final eventName = currentEvent;
            final eventData = currentData;
            final eventId = currentId;
            currentEvent = null;
            currentData = null;
            currentId = null;

            if (eventName == 'tick' && eventData != null) {
              try {
                final data = TickerData.fromJson(jsonDecode(eventData) as Map<String, dynamic>);
                return TickerTickEvent(data, id: eventId);
              } catch (_) {
                return TickerUnknownEvent(event: eventName, data: eventData);
              }
            } else if (eventName == 'gap' && eventData != null) {
              try {
                final json = jsonDecode(eventData) as Map<String, dynamic>;
                return TickerGapEvent(json['resumeFrom'] as int);
              } catch (_) {
                return TickerUnknownEvent(event: eventName, data: eventData);
              }
            } else if (eventName != null || eventData != null) {
              return TickerUnknownEvent(event: eventName, data: eventData);
            }
          }
          return null;
        })
        .whereType<TickerEvent>();
  }
}
