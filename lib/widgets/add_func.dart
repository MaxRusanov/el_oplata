String monthYearFromDate(String myDate) {
  // String _postDate = '2000-12-31'; // 'yyyy-mm-dd'
  List<String> mylist = myDate.split('-');
  String year = '${mylist[0]}г.';
  int imtMonth = int.tryParse(mylist[1]) ?? 12;
  String month = '';
  switch (imtMonth) {
    case 1:
      month = 'Январь';
      break;
    case 2:
      month = 'Февраль';
      break;
    case 3:
      month = 'Март';
      break;
    case 4:
      month = 'Апрель';
      break;
    case 5:
      month = 'Май';
      break;
    case 6:
      month = 'Июнь';
      break;
    case 7:
      month = 'Июль';
      break;
    case 8:
      month = 'Август';
      break;
    case 9:
      month = 'Сентябрь';
      break;
    case 10:
      month = 'Октябрь';
      break;
    case 11:
      month = 'Ноябрь';
      break;
    case 12:
      month = 'Декабрь';
      break;
  }
  month = month + ' - ';
  return month + year;
}

String addMonth(String myDate) {
  // String _postDate = '2000-12-31'; // 'yyyy-mm-dd'
  List<String> mylist = myDate.split('-');
  int year = int.tryParse(mylist[0]) ?? 2000;
  int month = int.tryParse(mylist[1]) ?? 12;
  if (month < 12) {
    month += 1;
  } else {
    month = 1;
    year += 1;
  }
  if (month < 10) {
    return '$year-0$month-01';
  } else {
    return '$year-$month-01';
  }
}
