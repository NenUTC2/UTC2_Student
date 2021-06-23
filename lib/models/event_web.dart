class Event {
  String tittle;
  String img;
  String link;
  String thu;
  String ngay;
  String luotxem;

  Event(String tittle, String img, String link, String thu, String ngay,
      String luotxem) {
    this.tittle = tittle;
    this.img = img;
    this.link = link;
    this.thu = thu;
    this.ngay = ngay;
    this.luotxem = luotxem;
  }
  @override
  String toString() {
    return this.tittle +
        '\n' +
        this.img +
        '\n' +
        this.link +
        '\n' +
        this.thu +
        '\n' +
        this.ngay +
        '\n' +
        this.luotxem;
  }
}


