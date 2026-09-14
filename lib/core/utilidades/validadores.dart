/// Reglas de formato reusables para `TextFormField.validator`. Solo
/// formato — la regla del proyecto se mantiene: **las reglas de negocio
/// del backend no se replican acá** (una patente duplicada, por ejemplo,
/// la sigue decidiendo el servidor).
abstract final class Validadores {
  static String? obligatorio(String? valor, {String etiqueta = 'Este campo'}) {
    if (valor == null || valor.trim().isEmpty) {
      return '$etiqueta es obligatorio';
    }
    return null;
  }

  static String? largoMaximo(String? valor, int maximo) {
    if (valor != null && valor.trim().length > maximo) {
      return 'No puede exceder los $maximo caracteres';
    }
    return null;
  }

  static String? rangoEntero(
    String? valor, {
    required int minimo,
    required int maximo,
    String etiqueta = 'El valor',
  }) {
    if (valor == null || valor.trim().isEmpty) {
      return '$etiqueta es obligatorio';
    }
    final numero = int.tryParse(valor.trim());
    if (numero == null) return 'Ingresa un numero valido';
    if (numero < minimo || numero > maximo) {
      return 'Debe estar entre $minimo y $maximo';
    }
    return null;
  }

  static String? decimalPositivo(String? valor, {String etiqueta = 'El valor'}) {
    if (valor == null || valor.trim().isEmpty) {
      return '$etiqueta es obligatorio';
    }
    final numero = double.tryParse(valor.trim().replaceAll(',', '.'));
    if (numero == null) return 'Ingresa un numero valido';
    if (numero < 0) return 'No puede ser negativo';
    return null;
  }

  /// Corre cada validador en orden y devuelve el primer mensaje de error,
  /// para poder componer reglas sin escribir una closure nueva por campo.
  static String? Function(String?) combinar(
    List<String? Function(String?)> validadores,
  ) {
    return (valor) {
      for (final validador in validadores) {
        final resultado = validador(valor);
        if (resultado != null) return resultado;
      }
      return null;
    };
  }
}
