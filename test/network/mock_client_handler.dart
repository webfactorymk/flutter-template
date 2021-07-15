import 'dart:convert';
import 'package:flutter_template/model/task/task.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

import 'tasks_api_service_test.dart';
import 'network_test_helper.dart';

final badRequest = http.Response(json.encode({'error': 'bad request'}), 400);
final unauthorized = http.Response(json.encode({'error': 'unauthorized'}), 401);
final notFound = http.Response(json.encode({'error': 'not found'}), 404);

http.Response success(dynamic body) => http.Response(json.encode(body), 200);

MockClientHandler withMockClientHandler() {
  return (request) async {
    final pathSegments = request.url.pathSegments;
    final requestMethod = request.method;

    if (pathSegments.isEmpty) {
      return notFound;
    }

    // All no or invalid token requests return 401 except for 'refresh-token'
    if (request.headers['Authorization'] !=
        'Bearer ' + NetworkTestHelper.validToken) {
      return unauthorized;
    }

    if (pathSegments[0] == 'tasks') {
      if (pathSegments.length == 1) {
        //tasks
        if (requestMethod == 'GET') {
          return success(taskMap.values.toList());
        } else if (requestMethod == 'POST') {
          return success([request.body]
              .map<Map<String, dynamic>>((body) => json.decode(body))
              .map((jsonMap) => jsonMap..putIfAbsent('id', () => '1'))
              //.map((jsonMap) => json.encode(jsonMap))
              .first);
        }
      } else {
        //tasks/{id}
        if (requestMethod == 'GET') {
          try {
            final Task? taskById = taskMap[int.parse(pathSegments[1])];
            return taskById != null ? success(taskById) : badRequest;
          } catch (exp) {
            return badRequest;
          }
        }
      }
    } else if (pathSegments[0] == 'task-groups') {
      //todo make it more sophisticated
      return success(taskMap.values.toList());
    }

    return notFound;
  };
}
