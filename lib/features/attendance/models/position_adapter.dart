import 'package:hive/hive.dart';
import 'package:geolocator/geolocator.dart';

@HiveType(typeId: 3)
class PositionAdapter extends TypeAdapter<Position> {
  @override
  final typeId = 3;

  @override
  Position read(BinaryReader reader) {
    return Position(
      longitude: reader.readDouble(),
      latitude: reader.readDouble(),
      timestamp: DateTime.fromMillisecondsSinceEpoch(reader.readInt()),
      accuracy: reader.readDouble(),
      altitude: reader.readDouble(),
      heading: reader.readDouble(),
      speed: reader.readDouble(),
      speedAccuracy: reader.readDouble(),
      altitudeAccuracy: 0.0,
      headingAccuracy: 0.0,
    );
  }

  @override
  void write(BinaryWriter writer, Position obj) {
    writer.writeDouble(obj.longitude);
    writer.writeDouble(obj.latitude);
    writer.writeInt(obj.timestamp.millisecondsSinceEpoch);
    writer.writeDouble(obj.accuracy);
    writer.writeDouble(obj.altitude);
    writer.writeDouble(obj.heading);
    writer.writeDouble(obj.speed);
    writer.writeDouble(obj.speedAccuracy);
  }
}