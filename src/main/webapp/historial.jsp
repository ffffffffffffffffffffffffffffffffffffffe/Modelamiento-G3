<%@ page import="com.minimarket.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.util.ArrayList" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    // Usamos application.getRealPath() para obtener la ruta correcta en el servidor
    String archivoHistorial = application.getRealPath("/WEB-INF/historial_ventas.obj");

    ArrayList<Boleta> historialVentas = new ArrayList<>();

    // Intentamos cargar el historial desde el archivo
    try (ObjectInputStream ois = new ObjectInputStream(new FileInputStream(archivoHistorial))) {
        // Leer el historial de ventas desde el archivo
        historialVentas = (ArrayList<Boleta>) ois.readObject();
    } catch (IOException | ClassNotFoundException e) {
        // Manejo de errores si el archivo no se puede leer o no existe
        System.out.println("Error al cargar el historial: " + e.getMessage());
        historialVentas = new ArrayList<>();
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Historial de Ventas</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 20px;
        }
        h1 {
            color: darkorange;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }
        th, td {
            padding: 10px;
            text-align: center;
            border: 1px solid #ddd;
        }
        th {
            background-color: #f2f2f2;
        }
    </style>
</head>
<body>

<h1>Historial de Ventas</h1>

<% if (historialVentas.isEmpty()) { %>
<p>No se han registrado ventas.</p>
<% } else { %>
<table>
    <tr>
        <th>Fecha</th>
        <th>Total</th>
        <th>Productos</th>
    </tr>
    <%
        // Mostrar cada boleta registrada
        for (Boleta boleta : historialVentas) {
    %>
    <tr>
        <td><%= boleta.getFechaHora() %></td>
        <td><%= boleta.getTotal() %></td>
        <td>
            <%
                // Mostrar los productos dentro de cada boleta
                ArrayList<Producto> productos = boleta.getProductos();
                for (Producto producto : productos) {
            %>
            <%= producto.getNombre() + " " %>
            <%
                }
            %>
        </td>
    </tr>
    <% } %>
</table>
<% } %>

</body>
</html>


