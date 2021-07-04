import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:utc2_student/models/hoc_ky.dart';
import 'package:utc2_student/scraper/student_info_scraper.dart';
import 'package:utc2_student/service/firestore/student_database.dart';
import 'package:web_scraper/web_scraper.dart';

class DiemScraper {
  final _streamDiemTong = PublishSubject<List>();
  Stream<List> get streamDiemTong => _streamDiemTong.stream;
  final _streamThongTin = PublishSubject<SinhVien>();
  Stream<SinhVien> get streamThongTin => _streamThongTin.stream;
  final _streamHocKy = PublishSubject<List<HocKi>>();
  Stream<List<HocKi>> get streamHocKy => _streamHocKy.stream;
  StreamController<String> streamController =
      StreamController<String>.broadcast();

  final webScraper = WebScraper();
  void getDiemTong() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var email = prefs.getString('userEmail');
    var student = await StudentDatabase.getStudentData(email);
    var msv = student.id;
    String diemHe4, diemHe10, soTc;
    if (await webScraper.loadFullURL(
        'http://xemdiem.utc2.edu.vn/svxemdiem.aspx?ID=$msv&istinchi=1')) {
      List<String> diem = webScraper.getElementTitle(
          'div#thongtinsinhvien > p> font > table > tbody > tr> td > font > strong');
      // print(diem[1]);
      diemHe4 = diem[1].split('|')[0].replaceAll('(Hệ 4)', '');
      diemHe10 = diem[1].split('|')[1].replaceAll('(Hệ 10)', '');
      soTc = diem[3];
    }

    _streamDiemTong.sink.add([diemHe4, diemHe10, int.parse(soTc)]);
  }

  Future<SinhVien> getThongTin(String msv) async {
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

      sinhvien =
          new SinhVien(hoten, masv, ngaysinh, noisinh, hedaotao, lop, khoa);
      print(sinhvien.hoten);
      _streamThongTin.sink.add(sinhvien);
    }
    return sinhvien;
  }

  void getDiem() async {
     SharedPreferences prefs = await SharedPreferences.getInstance();
    var email = prefs.getString('userEmail');
    var student = await StudentDatabase.getStudentData(email);
    var msv = student.id;
    List<String> dsNoiDung = [];
    List<HocKi> dsHocKi = [];
    if (await webScraper.loadFullURL(
        'http://xemdiem.utc2.edu.vn/svxemdiem.aspx?ID=$msv&istinchi=1')) {
      List<Map<String, dynamic>> noidung = webScraper.getElement(
          'div#thongtinsinhvien > p > table > tbody > tr > td > table > tbody > tr>td',
          ['']);
      String namhoc = '';
      bool kt = false;
      for (int i = 7; i < noidung.length; i++) {
        if (noidung[i].toString().contains('Năm học')) {
          dsHocKi.add(HocKi(namhoc, dsNoiDung));
          namhoc = noidung[i]
              .toString()
              .replaceAll('{title:', '')
              .replaceAll(', attributes: {: null}}', '')
              .trim();
          dsNoiDung = [];
          kt = true;
        } else {
          kt = false;
        }
        if (!kt) {
          String ndung = noidung[i]
              .toString()
              .replaceAll('{title:', '')
              .replaceAll(', attributes: {: null}}', '')
              .trim();
          dsNoiDung.add(ndung);
        }
      }
    }
    dsHocKi.removeAt(0);
    _streamHocKy.sink.add(dsHocKi);
  }

  void dispose() {
    _streamDiemTong.close();
    _streamThongTin.close();
    streamController.close();
    _streamHocKy.close();
  }
}
