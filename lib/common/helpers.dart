import 'package:intl/intl.dart';

String getFormatDate(String date) {
  if (date != "") {
    return DateFormat('dd/MM/yyyy').format(DateTime.parse(date));
  } else {
    return "";
  }
}

firstLetterUpperCase(String word) {
  word = word.substring(0, 1).toUpperCase() +
      word.substring(1, word.length).toLowerCase();
  return word;
}

String getFormatDateTimestamp(DateTime? date) {
  // ignore: prefer_interpolation_to_compose_strings
  String d = "Actualizado el " +
      DateFormat('dd').format(date!) +
      " de " +
      month(DateFormat('MM').format(date)) +
      " a las " +
      DateFormat('hh:mm').format(date);
  // return DateFormat('dd MM yyyy').format(date!);
  return d;
}

double transformInts(String a, String b) {
  if (a.isEmpty || b.isEmpty) {
    return 0.0;
  } else {
    var r = double.parse(a) - double.parse(b);
    return r;
  }
}

String month(String date) {
  switch (date) {
    case "01":
      return "Enero";
    case "02":
      return "Febrero";
    case "03":
      return "Marzo";
    case "04":
      return "Abril";
    case "05":
      return "Mayo";
    case "06":
      return "Junio";
    case "07":
      return "Julio";
    case "08":
      return "Agosto";
    case "09":
      return "Septiembre";
    case "10":
      return "Octubre";
    case "11":
      return "Noviembre";
    default:
      return "Diciembre";
  }
}
