class Noti {
  String tieude;
  String thoigian;
  String link;
  int luotxem;
  // Noti({this.tieude, this.thoigian, this.link, this.luotxem = 0});
  Noti(String tieude, String thoigian, String link, int luotxem) {
    this.tieude = tieude;
    this.thoigian = thoigian;
    this.link = link;
    this.luotxem = luotxem;
  }
  @override
  String toString() {
    return 'Tieu de: ${this.tieude}\nThoi gian: ${this.thoigian}\nLink: ${this.link}\nLuot xem: ${this.luotxem}';
  }
}

