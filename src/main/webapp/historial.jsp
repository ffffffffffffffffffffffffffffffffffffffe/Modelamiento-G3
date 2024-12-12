<%@ page import="com.minimarket.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.time.LocalDateTime" %>
<%@ page import="java.time.ZoneId" %>
<%@ page import="java.util.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    String archivoHistorial = Venta.getRutaHistorialVentas();

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
            margin: 0;
            background-color: #f1e3c6;
        }

        /* Estilos del header */
        @keyframes fadeInFromTop {
            0% {
                opacity: 0;
                transform: translateY(-50px);
            }
            100% {
                opacity: 1;
                transform: translateY(0);
            }
        }

        header {
            text-align: center;
            background-color: rgba(6, 6, 6, 0.85);
            padding: 50px 0;
            border-bottom: 5px solid #000000;
            animation: fadeInFromTop 1s ease-out;
            color: #fafafb;
            width: 100%; /* Asegura que ocupe todo el ancho */
            position: relative;
        }

        header h1 {
            font-size: 15px; /* Aumento del tamaño de la fuente */
            font-weight: bold;
            text-transform: uppercase;
            letter-spacing: 5px;
            text-shadow: 2px 2px 4px rgba(0, 0, 0, 0.2);
            color: white; /* Cambié el color a blanco */
        }

        header p {
            font-size: 20px;
            margin: 5px 0;
            font-weight: bold;
        }

        /* Estilos para la tabla */
        h1 {
            color: darkorange;
        }

        .container-table {
            background-color: white;
            border-radius: 10px;
            padding: 20px;
            margin: 20px auto;
            width: 80%;
            box-shadow: 0 10px 20px rgba(0, 0, 0, 0.2);
        }

        table {
            width: 100%;
            border-collapse: collapse;
        }

        th, td {
            padding: 10px;
            text-align: center;
            border: 1px solid #ddd;
        }

        th {
            background-color: #f2f2f2;
        }

        td {
            background-color: white; /* Fondo blanco para las celdas de datos */
        }

        .volver {
            margin-top: 20px;
            text-align: center;
        }

        .volver button {
            background-color: darkorange;
            color: white;
            padding: 10px 20px;
            border: none;
            border-radius: 5px;
            font-size: 16px;
            cursor: pointer;
        }

        .volver button:hover {
            background-color: orangered;
        }
    </style>
</head>
<body>

<!-- Header -->
<header>
    <h1>Historial de Ventas</h1>
    <p>Consulta las ventas realizadas</p>
</header>

<!-- Contenedor de la tabla -->
<div class="container-table">

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
            // Formato de fecha
            SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm");
            sdf.setTimeZone(TimeZone.getTimeZone("America/Santiago"));

            // Mostrar cada boleta registrada
            for (Boleta boleta : historialVentas) {
                // Convertir LocalDateTime a Date
                LocalDateTime fechaLocal = boleta.getFechaHora();
                Date fecha = Date.from(fechaLocal.atZone(ZoneId.systemDefault()).toInstant());
                String fechaFormateada = sdf.format(fecha);

                // Procesar los productos
                ArrayList<Producto> productos = boleta.getProductos();
                // Crear un mapa para contar la cantidad de cada producto
                Map<String, Integer> productosContados = new HashMap<>();

                // Contamos las repeticiones de cada producto
                for (Producto producto : productos) {
                    String nombre = producto.getNombre();
                    productosContados.put(nombre, productosContados.getOrDefault(nombre, 0) + 1);
                }
        %>
        <tr>
            <td><%= fechaFormateada %></td>
            <td><%= boleta.getTotal() %></td>
            <td>
                <%
                    // Mostrar los productos con la cantidad
                    for (Map.Entry<String, Integer> entry : productosContados.entrySet()) {
                        String producto = entry.getKey();
                        int cantidad = entry.getValue();
                        out.print(producto + " x" + cantidad + " ");
                    }
                %>
            </td>
        </tr>
        <% } %>
    </table>
    <% } %>

</div>

<div class="volver">
    <button onclick="location.href='index.jsp'">Volver al Menú Principal</button>
</div>

</body>
</html>
