

import 'package:utc2_student/models/mon_hoc.dart';

class HocKi {
  String namhoc;
  List<String> ds_NoiDung;
  HocKi(this.namhoc, this.ds_NoiDung);
  List<MonHoc> getDsMonHoc() {
    List<MonHoc> ds_MonHoc = [];
    String stt, mamon, tenmon, stc, thilanmot, thilai;
    for (int i = 0; i < ds_NoiDung.length; i++) {
      if (i % 6 == 0) {
        stt = ds_NoiDung[i];
      }
      if (i % 6 == 1) {
        mamon = ds_NoiDung[i];
      }
      if (i % 6 == 2) {
        tenmon = ds_NoiDung[i];
      }
      if (i % 6 == 3) {
        stc = ds_NoiDung[i];
      }
      if (i % 6 == 4) {
        thilanmot = ds_NoiDung[i];
      }
      if (i % 6 == 5) {
        thilai = ds_NoiDung[i];
        ds_MonHoc.add(MonHoc(stt, mamon, tenmon, stc, thilanmot, thilai));
      }
    }
    return ds_MonHoc;
  }

  String getDiemHe4() {
    List<MonHoc> ds_MonHoc = getDsMonHoc();
    int tongtc = 0;
    double tongdiemhe4 = 0;
    double diem;
    for (int i = 0; i < ds_MonHoc.length; i++) {
      if (ds_MonHoc[i].mamon.trim() == 'GQP201.3' ||
          ds_MonHoc[i].mamon.trim() == 'GQP203.3' ||
          ds_MonHoc[i].mamon.trim() == 'GQP202.2' ||
          ds_MonHoc[i].mamon.trim() == 'GDT01.1' ||
          ds_MonHoc[i].mamon.trim() == 'ANHA1.4' ||
          ds_MonHoc[i].mamon.trim() == 'ANHA2.4' ||
          ds_MonHoc[i].mamon.trim() == 'GDT02.1' ||
          ds_MonHoc[i].mamon.trim() == 'GDT03.1' ||
          ds_MonHoc[i].mamon.trim() == 'GDT04.1') {
        continue;
      }
      tongtc += int.parse(ds_MonHoc[i].tinchi);

      if (ds_MonHoc[i].thilai.trim().isEmpty) {
        diem = double.parse(ds_MonHoc[i].thilanmot);
      } else {
        diem = double.parse(ds_MonHoc[i].thilai);
      }
      if (diem >= 3.0 && diem <= 3.9) {
        tongdiemhe4 += 0.5 * int.parse(ds_MonHoc[i].tinchi);
      }
      if (diem >= 4.0 && diem <= 4.9) {
        tongdiemhe4 += int.parse(ds_MonHoc[i].tinchi);
      }
      if (diem >= 5.0 && diem <= 5.4) {
        tongdiemhe4 += 1.5 * int.parse(ds_MonHoc[i].tinchi);
      }
      if (diem >= 5.5 && diem <= 6.9) {
        tongdiemhe4 += 2.0 * int.parse(ds_MonHoc[i].tinchi);
      }
      if (diem >= 7.0 && diem <= 8.4) {
        tongdiemhe4 += 3.0 * int.parse(ds_MonHoc[i].tinchi);
      }
      if (diem >= 8.5) {
        tongdiemhe4 += 4 * int.parse(ds_MonHoc[i].tinchi);
      }
    }
    return (tongdiemhe4 / tongtc).toStringAsFixed(2);
  }

  String getDiemHe10() {
    List<MonHoc> ds_MonHoc = getDsMonHoc();
    double tongdiemhe10 = 0;
    int count = 0;
    for (int i = 0; i < ds_MonHoc.length; i++) {
      if (ds_MonHoc[i].mamon.trim() == 'GQP201.3' ||
          ds_MonHoc[i].mamon.trim() == 'GQP203.3' ||
          ds_MonHoc[i].mamon.trim() == 'GQP202.2' ||
          ds_MonHoc[i].mamon.trim() == 'GDT01.1' ||
          ds_MonHoc[i].mamon.trim() == 'ANHA1.4' ||
          ds_MonHoc[i].mamon.trim() == 'ANHA2.4' ||
          ds_MonHoc[i].mamon.trim() == 'GDT02.1' ||
          ds_MonHoc[i].mamon.trim() == 'GDT03.1' ||
          ds_MonHoc[i].mamon.trim() == 'GDT04.1') {
        continue;
      }
      count++;
      if (ds_MonHoc[i].thilai.trim().isEmpty) {
        tongdiemhe10 += double.parse(ds_MonHoc[i].thilanmot);
      } else {
        tongdiemhe10 += double.parse(ds_MonHoc[i].thilai);
      }
    }
    return (tongdiemhe10 / count).toStringAsFixed(2);
  }
}
