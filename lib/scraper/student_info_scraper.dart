import 'package:web_scraper/web_scraper.dart';

Future<SinhVien> getThongTin(String msv) async {
  print(msv);
  final webScraper = WebScraper('http://utc2.edu.vn');
  SinhVien sinhvien;
  if (await webScraper.loadFullURL(
      'http://xemdiem.utc2.edu.vn/svxemdiem.aspx?ID=$msv&istinchi=1')) {
    List<String> thongTinSV = webScraper.getElementTitle(
        'div#thongtinsinhvien > table> tbody > tr > td > font');
    String hoten = thongTinSV[2];
    String masv = thongTinSV[3];
    String ngaysinh = thongTinSV[4];
    String noisinh = thongTinSV[5];
    String hedaotao = thongTinSV[6];
    String lop = thongTinSV[7];
    String khoa = thongTinSV[8];
    hoten = hoten.replaceAll('  ', ' ');
    sinhvien =
        new SinhVien(hoten, masv, ngaysinh, noisinh, hedaotao, lop, khoa);
    print(sinhvien.hoten);
  }
  return sinhvien;
}

class SinhVien {
  String hoten, msv, ngaysinh, noisinh, hedaotao, lop, khoa;
  SinhVien(this.hoten, this.msv, this.ngaysinh, this.noisinh, this.hedaotao,
      this.lop, this.khoa);
}
