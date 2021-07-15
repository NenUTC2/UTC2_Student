
import 'package:utc2_student/path_finder/repo_path.dart';

class Dijsktra {
  static List<int> findPath(int diemDau, int diemCuoi) {
    diemDau = diemDau - 1;
    diemCuoi = diemCuoi - 1;
    int n = 39;
    var a = listDiem;
    List danhDau = List.filled(39, 0);
    List nhan = List.filled(39, 0);
    List truoc = List.filled(39, 0);
    int xp = 0, min = 0;
    for (int i = 0; i < n; i++) {
      nhan[i] = 100000;
      danhDau[i] = 0;
      truoc[i] = diemDau;
    }
    nhan[diemDau] = 0;
    danhDau[diemDau] = 1;
    xp = diemDau;
    while (xp != diemCuoi) {
      for (int j = 0; j < n; j++)
        if (a[xp][j] > 0 && nhan[j] > a[xp][j] + nhan[xp] && danhDau[j] == 0) {
          nhan[j] = a[xp][j] + nhan[xp];
          truoc[j] = xp;
        }
      min = 100000;
      for (int j = 0; j < n; j++)
        if (min > nhan[j] && danhDau[j] == 0) {
          min = nhan[j];
          xp = j;
        }
      danhDau[xp] = 1;
    }
    List<int> list = [];
    list.add(diemCuoi + 1);
    list.add(truoc[diemCuoi] + 1);
    int i = truoc[diemCuoi];
    while (i != diemDau) {
      i = truoc[i];
      list.add(i + 1);
    }
    return list.reversed.toList();
  }
}
