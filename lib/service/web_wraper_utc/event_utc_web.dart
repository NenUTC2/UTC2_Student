import 'package:rxdart/rxdart.dart';
import 'package:utc2_student/models/content_utc_web.dart';
import 'package:utc2_student/models/event_web.dart';
import 'package:web_scraper/web_scraper.dart';

String url = 'https://utc2.edu.vn';

class EventScraper {
  final _stream = PublishSubject<List<Event>>();
  Stream<List<Event>> get stream => _stream.stream;
  final _streamContent = PublishSubject<List<Block>>();
  Stream<List<Block>> get streamContent => _streamContent.stream;

  final webScraper = WebScraper(url);

  fetchEvent() async {
    List<Event> dsTinTuc = [];
    List<String> dsTittle;
    List<Map<String, dynamic>> dsIMG, dsLink;
    if (await webScraper.loadWebPage('/tin-tuc/p=1')) {
      dsTittle = webScraper.getElementTitle('div#kuntraict>div.mucdichvu>h3>a');
      dsIMG =
          webScraper.getElement('div#kuntraict>div.mucdichvu>a>img', ['src']);
      dsLink = webScraper.getElement('div#kuntraict>div.mucdichvu>a', ['href']);
    }
    String tittle, img, link;

    for (int i = 0; i < dsTittle.length; i++) {
      tittle = dsTittle[i].trim();
      img = url +
          '/' +
          dsIMG[i]
              .toString()
              .trim()
              .substring(28, dsIMG[i].toString().trim().length - 2);
      link = url +
          '/' +
          dsLink[i]
              .toString()
              .trim()
              .substring(55, dsLink[i].toString().trim().length - 2);
      if (await webScraper.loadWebPage(link.substring(url.length))) {
        String thoigian = webScraper
            .getElementTitle('div#kuntraict>div.ngaydangctcon')
            .first
            .toString()
            .trim();
        thoigian = thoigian.substring(10, thoigian.length);
        List<String> time = thoigian.split('-');
        List<String> ngay = time[0].split(' ');

        String year = ngay[3].split('/')[2];
        String month = ngay[3].split('/')[1];
        String day = ngay[3].split('/')[0];
        String hour = time[1].trim().substring(0, 2);
        String minute = time[1].trim().substring(3, 5);
        DateTime date = DateTime.parse('$year-$month-$day $hour:$minute:00');
        DateTime dateNow = DateTime.now();
        var daydiff = dateNow.difference(date).inDays;
        var hourdiff = dateNow.difference(date).inHours;
        var timediff;
        if (daydiff > 7)
          timediff = ngay[3];
        else if (daydiff > 0)
          timediff = daydiff.toString() + ' ngày';
        else if (hourdiff > 0)
          timediff = hourdiff.toString() + ' giờ';
        else
          timediff = dateNow.difference(date).inMinutes.toString() + ' phút';
        //event model
        Event td = Event(tittle, img, link, ngay[3].trim(), timediff.toString(),
            time[2].trim().substring(10, time[2].trim().length));
        dsTinTuc.add(td);
      }
      if (i % 1 == 0 && i != 0)
        _stream.sink.add(dsTinTuc);
      else if (i == 10) _stream.sink.add(dsTinTuc);
    }
  }

  getContent(String link) async {
    List<Block> listContent = [];
    if (await webScraper.loadWebPage(link.substring(url.length))) {
      List<Map<String, dynamic>> noidung = webScraper
          .getElement('div#noidungtrong>p', ['src'], extraAddress: 'img');
      for (int i = 0; i < noidung.length; i++) {
        String a = noidung[i].toString().replaceAll(new RegExp('{'), '');
        a = a.replaceAll(new RegExp('}'), '');
        a = a.replaceAll(new RegExp(', attributes: '), '');
        a = a.replaceAll(new RegExp('title: '), '');
        List<String> c = a.split('src: ');
        Block b;
        if (c.length > 1) {
          b = Block(text: c[0], imgLink: c[1]);
        } else {
          b = Block(text: c[0]);
        }
        listContent.add(b);
      }
    }
    _streamContent.sink.add(listContent);
  }

  void dispose() {
    _stream.close();
    _streamContent.close();
  }
}
