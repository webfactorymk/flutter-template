import 'dart:async';
import 'dart:core';
import 'dart:io';

import 'package:flutter_template/config/flavor_config.dart';
import 'package:flutter_template/log/abstract_logger.dart';
import 'package:flutter_template/util/developer_util.dart';
import 'package:path_provider/path_provider.dart';
import 'package:synchronized/synchronized.dart';

final Lock globalLogFileLock = Lock();

/// Logger that outputs messages to a file.
///
/// See [sendDeveloperInfo]
class FileLogger implements AbstractLogger {
  static late final FileLogger _instance = FileLogger.withDefaultFile();

  final Lock _bufferLock = Lock();
  final Lock _fileLock;
  final Future<File> Function() createFileFn;
  File? _logFile;
  String _logLineBuffer = '';

  /// Singleton constructor, will always return the same instance.
  ///
  /// _Mind that the other constructors will create new instances._
  factory FileLogger.instance() => _instance;

  /// Creates a new file logger with file in the application's
  /// documents directory named flutter_logs_{platform}_{flavor}.txt
  factory FileLogger.withDefaultFile() =>
      FileLogger(globalLogFileLock, () async {
        final flavor = FlavorConfig.isDev() ? "dev" : "stg";
        final platform = Platform.isIOS ? "iOS" : "Android";

        final dirPath = (await getApplicationDocumentsDirectory()).path;
        final logFilename = "flutter_logs_${platform}_$flavor.txt";

        return File('$dirPath/$logFilename');
      });

  /// Creates a new file logger with the provided file.
  FileLogger.withFile(this._fileLock, this._logFile)
      : createFileFn = (() => Future.value(_logFile));

  FileLogger(this._fileLock, this.createFileFn);

  @override
  void d(String message) {
    _log('(D) $message');
  }

  @override
  void w(String message) {
    _log('(W) $message');
  }

  @override
  void e(Object error) {
    _log('(E) ${error.toString()}');
  }

  /// Determines the absolute file path and file name.
  Future<String> getLogFilePath() => _ensureFileSet().then((file) => file.path);

  /// Ensures we have a log file by creating one if it doesn't exist,
  /// or returning the already created one.
  Future<File> _ensureFileSet() async {
    if (_logFile != null) {
      return _logFile!;
    }
    _logFile = await createFileFn();

    // opens the file, writes, closes the file
    return _logFile!.writeAsString(
      '${new DateTime.now()}: LOGGING STARTED\n',
      mode: FileMode.write,
      flush: true,
    );
  }

  /// Returns all log messages buffered while the previous log
  /// file write op was being executed.
  Future<String> _flushLogBuffer() => _bufferLock.synchronized(() {
        final bufferedLogs = _logLineBuffer;
        _logLineBuffer = '';
        return bufferedLogs;
      });

  /// Appends the lines at the end of the log file.
  /// The file needs to be initialized beforehand.
  Future<void> _appendLines(String lines) async {
    await _logFile!.writeAsString(lines, mode: FileMode.append, flush: true);
  }

  Future<void> _log(String message) async {
    // The writing message rate might be slower than the incoming
    // message rate so we buffer messages while we wait for file operations.
    //
    // We'll buffer all incoming logs until the previous log message is being
    // written to a file.
    // On the next file write iteration we want to write all buffered lines,
    // instead of writing line by line.
    await _bufferLock.synchronized(() {
      _logLineBuffer += '${DateTime.now()}: $message\n';
    });

    // We use a different lock here to separate file ops from other actions.
    await _fileLock.synchronized(() async {
      //print('FileLogger: Entering file lock');
      final appendText = await _flushLogBuffer();
      if (appendText.isEmpty) {
        return;
      }
      await _ensureFileSet();
      await _appendLines(appendText);
      //print('FileLogger: Exiting file lock');
    });
  }
}
