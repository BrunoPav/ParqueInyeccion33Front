import 'package:intl/intl.dart';

/// Formato de fecha, moneda y kilometraje, en un solo lugar. Devuelven
/// `String`: quien las muestre en pantalla decide si además necesita
/// `TextStyle(...).conCifrasTabulares` (ver `tipografia.dart`) para que los
/// dígitos no salten al alinearse en columna.
abstract final class Formatos {
  static final DateFormat _fecha = DateFormat('dd/MM/yyyy');

  static String fecha(DateTime valor) => _fecha.format(valor);

  static String moneda(double valor) => '\$ ${valor.toStringAsFixed(2)}';

  static String kilometraje(int valor) => '$valor km';
}
