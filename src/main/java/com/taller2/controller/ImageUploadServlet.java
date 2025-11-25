package com.taller2.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;

import java.io.File;
import java.io.IOException;
import java.nio.file.Paths;

@WebServlet("/upload/imagen")
@MultipartConfig(fileSizeThreshold = 1024 * 1024 * 2, // 2MB
        maxFileSize = 1024 * 1024 * 10, // 10MB
        maxRequestSize = 1024 * 1024 * 50 // 50MB
)
public class ImageUploadServlet extends HttpServlet {

    private static final String UPLOAD_DIR = "img";

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        try {
            // Obtener el archivo subido
            Part filePart = request.getPart("file");

            if (filePart == null) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write("{\"success\": false, \"message\": \"No se recibió ningún archivo\"}");
                return;
            }

            String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();

            // Validar extensión
            String extension = fileName.substring(fileName.lastIndexOf(".")).toLowerCase();
            if (!extension.matches("\\.(jpg|jpeg|png|gif|webp)")) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write(
                        "{\"success\": false, \"message\": \"Formato de archivo no permitido. Use JPG, PNG, GIF o WEBP\"}");
                return;
            }

            // Generar nombre único si es necesario
            String uniqueFileName = System.currentTimeMillis() + "_" + fileName;

            // Obtener la ruta real del directorio img en el contexto de la aplicación
            String applicationPath = request.getServletContext().getRealPath("");
            String uploadPath = applicationPath + File.separator + UPLOAD_DIR;

            // Crear el directorio si no existe
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) {
                uploadDir.mkdirs();
            }

            // Guardar el archivo usando InputStream
            String filePath = uploadPath + File.separator + uniqueFileName;
            try (java.io.InputStream input = filePart.getInputStream();
                    java.io.FileOutputStream output = new java.io.FileOutputStream(filePath)) {
                byte[] buffer = new byte[1024];
                int bytesRead;
                while ((bytesRead = input.read(buffer)) != -1) {
                    output.write(buffer, 0, bytesRead);
                }
            }

            // Responder con éxito
            response.setStatus(HttpServletResponse.SC_OK);
            response.getWriter().write(String.format(
                    "{\"success\": true, \"fileName\": \"%s\", \"message\": \"Imagen subida correctamente\"}",
                    uniqueFileName));

        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write(String.format(
                    "{\"success\": false, \"message\": \"Error al subir la imagen: %s\"}",
                    e.getMessage()));
        }
    }
}
