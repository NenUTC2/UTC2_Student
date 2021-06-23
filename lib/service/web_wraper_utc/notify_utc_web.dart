import 'package:utc2_student/models/content_utc_web.dart';
import 'package:utc2_student/models/notify_web.dart';
import 'package:web_scraper/web_scraper.dart';
import 'package:rxdart/rxdart.dart';
String url = 'https://utc2.edu.vn';
class NotiScraper {
  final _stream = PublishSubject<List<Noti>>();
  Stream<List<Noti>> get stream => _stream.stream;
  final _streamContent = PublishSubject<List<Block>>();
  Stream<List<Block>> get streamContent => _streamContent.stream;

  final webScraper = WebScraper(url);

  // Response of getElement is always List<Map<String, dynamic>>
  List<Map<String, dynamic>> tieuDeNoti;
  List<Map<String, dynamic>> thoiGianNoti;
  List<Noti> dsNoti;

  fetchProducts() async {
    // Loads web page and downloads into local state of library
    if (await webScraper.loadWebPage('/thong-bao')) {
      tieuDeNoti = webScraper
          .getElement('div#kuntraict > div.mucdichvu > h3 > a', ['href']);
      thoiGianNoti = webScraper.getElement(
          'div#kuntraict > div.mucdichvu > p.ngaymucdichvu > span', []);
      Noti thongBao;
      dsNoti = [];
      Map<String, dynamic> attributes;
      for (int i = 0; i < tieuDeNoti.length; i++) {
        attributes = tieuDeNoti[i]['attributes'];
        thongBao = new Noti(tieuDeNoti[i]['title'], thoiGianNoti[i]['title'],
            webScraper.baseUrl + '/' + attributes['href'], 0);
        dsNoti.add(thongBao);
      }
      _stream.sink.add(dsNoti);

   
    }
  }

  getContent(String link) async {
    if (await webScraper.loadWebPage(link.substring(url.length))) {
      String luotXem;
      Block b;
      List<Block> c = [];
      List<Map<String, dynamic>> noidung = webScraper
          .getElement('div#noidungtrong>p', ['href'], extraAddress: 'a');
      luotXem =
          webScraper.getElementTitle('div.ngaydangctcon').first.toString();
      luotXem = luotXem.substring(
          luotXem.indexOf('Lượt xem:') + 10, luotXem.length - 1);
      for (int i = 0; i < noidung.length; i++) {
        String a = noidung[i].toString().replaceAll(new RegExp('{'), '');
        a = a.replaceAll(new RegExp('}'), '');
        a = a.replaceAll(new RegExp(', attributes: '), '');
        a = a.replaceAll(new RegExp('title: '), '');
        List<String> d = a.split('href: ');
        if (d.length > 1) {
          b = new Block(text: d[0], imgLink: '', luotxem: luotXem, link: d[1]);
        } else
          b = new Block(text: a, imgLink: '', luotxem: luotXem);
        c.add(b);
      }
      _streamContent.add(c);
    }
  }

  void dispose() {
    _stream.close();
    _streamContent.close();
  }
}
