class Light {
  String location;
  String name;
  bool status;
  List<double> position;
  int tile;

  Light.fromMap(Map data) {
    this.location = data['location'] ?? 'No location.';
    this.name = data['name'] ?? 'No name.';
    this.status = data['status'] ?? false;
    this.position = data['position'] ?? [0.0];
    this.tile = data['tile'] ?? 0;
  }
}

class Building {
  String name;
  List<double> position;
  String image;
  bool status;

  Building.fromMap(Map data) {
    this.name = data['name'] ?? 'No name.';
    this.status = data['status'] ?? false;
    this.position = data['position'] ?? [0.0];
    this.image = data['image'] ?? [''];
  }
}

class Room {
  String name;
  List<double> position;
  String image;
  bool status;
  String building;

  Room.fromMap(Map data) {
    this.name = data['name'] ?? 'No name.';
    this.status = data['status'] ?? false;
    this.position = data['position'] ?? [0.0];
    this.image = data['image'] ?? [''];
    this.building = data['building'] ?? [''];
  }
}
