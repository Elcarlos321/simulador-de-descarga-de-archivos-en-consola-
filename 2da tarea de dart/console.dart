import 'dart:io';

class DescargaArchivo {
  final String nombre_archivo;
  final int progreso_descarga;
  final String estado;
  DescargaArchivo({
    required this.nombre_archivo,
    required this.progreso_descarga,
    required this.estado,
  });
  String get mensaje_descarga {
    switch (estado) {
      case "iniciando":
        return "Preparando la descarga del archivo ($nombre_archivo)...";

      case "descargando":
        return "Progreso de descarga: $progreso_descarga%";

      case "completado":
        return "La descarga del archivo $nombre_archivo ha sido completada";

      default:
        return "Error al descargar el archivo $nombre_archivo";
    }
  }
}

Stream<DescargaArchivo> progresoDescarga(String nombreArchivo) async* {
  yield DescargaArchivo(
    nombre_archivo: nombreArchivo,
    progreso_descarga: 0,
    estado: "iniciando",
  );

  await Future.delayed(Duration(seconds: 1));

  for (var x = 0; x <= 100; x += 20) {
    await Future.delayed(Duration(seconds: 1));

    yield DescargaArchivo(
      nombre_archivo: nombreArchivo,
      progreso_descarga: x,
      estado: x < 100 ? "descargando" : "completado",
    );
  }
}

Future<void> descarga(String archivo) async {
  await for (var progreso in progresoDescarga(archivo)) {
    print(progreso.mensaje_descarga);
  }
  print("\nla descarga del $archivo ha sido completada \n");
}

void main() async {
  int? resp = 0;

  while (resp != 6) {
    print("=== Simulador de descarga de archivos ===");
    print("1- archivo.zip");
    print("2- archivo.txt");
    print("3- archivo.docs");
    print("4- archivo.png");
    print("5- archivo.pdf");
    print("6- salir");
    print("==========================================");
    stdout.write("Selecciona una opcion: ");

    String? respu = stdin.readLineSync();
    resp = int.tryParse(respu ?? '');

    if (resp == null || resp < 1 || resp > 6) {
      print("opcion invalida, intentalo de nuevo\n");
      continue;
    }

    switch (resp) {
      case 1:
        await descarga("Archivo.zip");
        break;
      case 2:
        await descarga("Archivo.txt");
        break;
      case 3:
        await descarga("Archivo.docs");
        break;
      case 4:
        await descarga("Archivo.png");
        break;
      case 5:
        await descarga("Archivo.pdf");
        break;
      default:
        print("saliendo del programa...");
        break;
    }
  }
}
