import 'package:events_emitter/emitters/event_emitter.dart';

class GlobalEvent{
  final String type;
  final Map<String, dynamic> payload;
  GlobalEvent(this.type, this.payload);
}
final io = EventEmitter();