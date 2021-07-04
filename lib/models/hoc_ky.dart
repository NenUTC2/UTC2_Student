import 'package:utc2_student/models/mon_hoc.dart';

class HocKi {
  String namhoc;
  List<String> dsNoiDung;
  HocKi(this.namhoc, this.dsNoiDung);
  List<MonHoc> getDsMonHoc() {
    List<MonHoc> dsMonHoc = [];
    String stt, mamon, tenmon, stc, thilanmot, thilai;
    for (int i = 0; i < dsNoiDung.length; i++) {
      if (i % 6 == 0) {
        stt = dsNoiDung[i];
      }
      if (i % 6 == 1) {
        mamon = dsNoiDung[i];
      }
      if (i % 6 == 2) {
        tenmon = dsNoiDung[i];
      }
      if (i % 6 == 3) {
        stc = dsNoiDung[i];
      }
      if (i % 6 == 4) {
        thilanmot = dsNoiDung[i];
      }
      if (i % 6 == 5) {
        thilai = dsNoiDung[i];
        dsMonHoc.add(MonHoc(stt, mamon, tenmon, stc, thilanmot, thilai));
      }
    }
    return dsMonHoc;
  }

  String getDiemHe4() {
    List<MonHoc> dsMonHoc = getDsMonHoc();
    int tongtc = 0;
    double tongdiemhe4 = 0;
    double diem;
    for (int i = 0; i < dsMonHoc.length; i++) {
      if (dsMonHoc[i].mamon.trim() == 'GQP201.3' ||
          dsMonHoc[i].mamon.trim() == 'GQP203.3' ||
          dsMonHoc[i].mamon.trim() == 'GQP202.2' ||
          dsMonHoc[i].mamon.trim() == 'GDT01.1' ||
          dsMonHoc[i].mamon.trim() == 'ANHA1.4' ||
          dsMonHoc[i].mamon.trim() == 'ANHA2.4' ||
          dsMonHoc[i].mamon.trim() == 'GDT02.1' ||
          dsMonHoc[i].mamon.trim() == 'GDT03.1' ||
          dsMonHoc[i].mamon.trim() == 'GDT04.1') {
        continue;
      }
      tongtc += int.parse(dsMonHoc[i].tinchi);

      if (dsMonHoc[i].thilai.trim().isEmpty) {
        diem = double.parse(dsMonHoc[i].thilanmot);
      } else {
        diem = double.parse(dsMonHoc[i].thilai);
      }
      if (diem >= 3.0 && diem <= 3.9) {
        tongdiemhe4 += 0.5 * int.parse(dsMonHoc[i].tinchi);
      }
      if (diem >= 4.0 && diem <= 4.9) {
        tongdiemhe4 += int.parse(dsMonHoc[i].tinchi);
      }
      if (diem >= 5.0 && diem <= 5.4) {
        tongdiemhe4 += 1.5 * int.parse(dsMonHoc[i].tinchi);
      }
      if (diem >= 5.5 && diem <= 6.9) {
        tongdiemhe4 += 2.0 * int.parse(dsMonHoc[i].tinchi);
      }
      if (diem >= 7.0 && diem <= 8.4) {
        tongdiemhe4 += 3.0 * int.parse(dsMonHoc[i].tinchi);
      }
      if (diem >= 8.5) {
        tongdiemhe4 += 4 * int.parse(dsMonHoc[i].tinchi);
      }
    }
    return (tongdiemhe4 / tongtc).toStringAsFixed(2);
  }

  String getDiemHe10() {
    List<MonHoc> dsMonHoc = getDsMonHoc();
    double tongdiemhe10 = 0;
    int count = 0;
    for (int i = 0; i < dsMonHoc.length; i++) {
      if (dsMonHoc[i].mamon.trim() == 'GQP201.3' ||
          dsMonHoc[i].mamon.trim() == 'GQP203.3' ||
          dsMonHoc[i].mamon.trim() == 'GQP202.2' ||
          dsMonHoc[i].mamon.trim() == 'GDT01.1' ||
          dsMonHoc[i].mamon.trim() == 'ANHA1.4' ||
          dsMonHoc[i].mamon.trim() == 'ANHA2.4' ||
          dsMonHoc[i].mamon.trim() == 'GDT02.1' ||
          dsMonHoc[i].mamon.trim() == 'GDT03.1' ||
          dsMonHoc[i].mamon.trim() == 'GDT04.1') {
        continue;
      }
      count++;
      if (dsMonHoc[i].thilai.trim().isEmpty) {
        tongdiemhe10 += double.parse(dsMonHoc[i].thilanmot);
      } else {
        tongdiemhe10 += double.parse(dsMonHoc[i].thilai);
      }
    }
    return (tongdiemhe10 / count).toStringAsFixed(2);
  }
}
