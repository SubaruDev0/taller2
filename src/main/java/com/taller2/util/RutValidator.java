package com.taller2.util;


public class RutValidator {


    public static boolean validarRut(String rutCompleto) {
        if (rutCompleto == null || rutCompleto.trim().isEmpty()) {
            return false;
        }

        try {
            // Limpiar RUT (eliminar puntos y guiones)
            String rutLimpio = rutCompleto.replace(".", "").replace("-", "").trim();

            if (rutLimpio.length() < 2) {
                return false;
            }

            // Separar número del dígito verificador
            String rutNumerico = rutLimpio.substring(0, rutLimpio.length() - 1);
            char dvIngresado = Character.toUpperCase(rutLimpio.charAt(rutLimpio.length() - 1));

            // Validar que la parte numérica sea un número
            int rut = Integer.parseInt(rutNumerico);

            // Detectar RUT de testeo (todos los dígitos iguales)
            if (esRutTesteo(rut)) {
                return false;
            }

            // Calcular dígito verificador
            char dvCalculado = calcularDigitoVerificador(rut);

            // Validar DV
            return dvIngresado == dvCalculado;

        } catch (NumberFormatException e) {
            return false;
        } catch (Exception e) {
            return false;
        }
    }


    private static char calcularDigitoVerificador(int rut) {
        int[] multiplicadores = {2, 3, 4, 5, 6, 7};
        int sumatoria = 0;
        int index = 0;

        // Recorrer el RUT de derecha a izquierda
        while (rut > 0) {
            int digito = rut % 10;
            sumatoria += digito * multiplicadores[index % multiplicadores.length];
            rut /= 10;
            index++;
        }

        int resto = 11 - (sumatoria % 11);

        if (resto == 11) {
            return '0';
        } else if (resto == 10) {
            return 'K';
        } else {
            return (char) (resto + '0');
        }
    }


    private static boolean esRutTesteo(int rut) {
        String rutStr = String.valueOf(rut);
        if (rutStr.length() < 2) {
            return false;
        }

        char primerDigito = rutStr.charAt(0);
        for (int i = 1; i < rutStr.length(); i++) {
            if (rutStr.charAt(i) != primerDigito) {
                return false;
            }
        }
        return true;
    }


    public static String formatearRut(String rut) {
        if (rut == null || rut.trim().isEmpty()) {
            return rut;
        }

        // Limpiar RUT
        String rutLimpio = rut.replace(".", "").replace("-", "").trim();

        if (rutLimpio.length() < 2) {
            return rut;
        }

        // Separar número y DV
        String numero = rutLimpio.substring(0, rutLimpio.length() - 1);
        String dv = rutLimpio.substring(rutLimpio.length() - 1);

        // Agregar puntos
        StringBuilder rutFormateado = new StringBuilder();
        int contador = 0;
        for (int i = numero.length() - 1; i >= 0; i--) {
            if (contador == 3) {
                rutFormateado.insert(0, '.');
                contador = 0;
            }
            rutFormateado.insert(0, numero.charAt(i));
            contador++;
        }

        rutFormateado.append('-').append(dv.toUpperCase());

        return rutFormateado.toString();
    }


    public static char obtenerDigitoVerificador(String rutSinDv) {
        try {
            String rutLimpio = rutSinDv.replace(".", "").replace("-", "").trim();
            int rut = Integer.parseInt(rutLimpio);
            return calcularDigitoVerificador(rut);
        } catch (Exception e) {
            return '?';
        }
    }
}
