<%@ page import="com.minimarket.*" %>
<%@ page import="java.util.ArrayList" %>
<%
    // Inicialización del inventario
    Inventario inventario = (Inventario) session.getAttribute("inventario");
    if (inventario == null) {
        inventario = new Inventario();
        session.setAttribute("inventario", inventario);
    }
    String mensaje = "";

    // Acción recibida del formulario
    String accion = request.getParameter("accion");

    // Acción para agregar un nuevo producto al inventario
    if ("agregar".equals(accion)) {
        String nombre = request.getParameter("nombre");
        int precio = Integer.parseInt(request.getParameter("precio"));
        int precioCosto = Integer.parseInt(request.getParameter("precioCosto"));
        int stock = Integer.parseInt(request.getParameter("stock"));

        // Verificar si el nombre del producto ya existe en el inventario
        boolean productoExistente = false;
        for (Producto p : inventario.getProductos()) {
            if (p.getNombre().equalsIgnoreCase(nombre)) {
                productoExistente = true;
                break;
            }
        }

        if (productoExistente) {
            mensaje = "Ya existe un producto con el mismo nombre. Por favor, ingrese un nombre diferente.";
        } else if (precio <= 0 || precioCosto <= 0 || stock < 0) {
            mensaje = "Los valores de precio y stock deben ser mayores que cero.";
        } else {
            Producto nuevoProducto = new Producto(nombre, precio, precioCosto, stock);
            inventario.agregarProducto(nuevoProducto);
            session.setAttribute("inventario", inventario); // Actualizar el inventario en sesión
            mensaje = "Producto agregado exitosamente.";
        }

    } else if ("agregarStock".equals(accion)) {
        int productoId = Integer.parseInt(request.getParameter("productoId"));
        int cantidad = Integer.parseInt(request.getParameter("cantidad"));

        // Verificar que el ID del producto sea válido
        if (productoId >= 1 && productoId <= inventario.getProductos().size()) {
            Producto producto = inventario.getProductos().get(productoId - 1);  // Restamos 1 porque el índice es 0-based
            producto.setStock(producto.getStock() + cantidad);
            session.setAttribute("inventario", inventario); // Actualizar el inventario en sesión
            mensaje = "Stock agregado exitosamente.";
        } else {
            mensaje = "Producto no encontrado.";
        }

    } else if ("solicitud".equals(accion)) {
        StringBuilder solicitud = new StringBuilder("Solicitud de reabastecimiento:\n");
        for (Producto p : inventario.getProductos()) {
            if (p.getStock() < 10) {
                solicitud.append(String.format("Producto: %s, Stock: %d\n", p.getNombre(), p.getStock()));
            }
        }
        mensaje = solicitud.length() > 0 ? solicitud.toString() : "No hay productos con bajo stock.";
    }

    // Obtener el filtro de búsqueda
    String filtro = request.getParameter("filtro");
    ArrayList<Producto> productos = inventario.getProductos();
    ArrayList<Producto> productosFiltrados = new ArrayList<>();

    if (filtro != null && !filtro.trim().isEmpty()) {
        for (Producto producto : productos) {
            if (producto.getNombre().toLowerCase().contains(filtro.toLowerCase())) {
                productosFiltrados.add(producto);
            }
        }
        mensaje = productosFiltrados.isEmpty() ? "No se encontraron productos con ese criterio." : "";
    } else {
        productosFiltrados = productos;
    }

    // Acción para eliminar un producto
    if ("eliminar".equals(accion)) {
        int productoId = Integer.parseInt(request.getParameter("productoId"));

        // Verificar que el ID del producto sea válido
        if (productoId >= 1 && productoId <= inventario.getProductos().size()) {
            Producto productoEliminado = inventario.getProductos().get(productoId - 1);  // Restamos 1 porque el índice es 0-based
            inventario.getProductos().remove(productoId - 1);  // Eliminar el producto de la lista
            session.setAttribute("inventario", inventario);  // Actualizar el inventario en sesión
            mensaje = "Producto '" + productoEliminado.getNombre() + "' eliminado exitosamente.";
        } else {
            mensaje = "Producto no encontrado.";
        }
    }
%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Inventario</title>
    <style>
        body {
            font-family: 'Roboto', sans-serif;
            margin: 0;
            background-color: #f1e3c6;
            color: #292a2b;
            display: flex;
            justify-content: flex-start;
            align-items: flex-start;
            height: 100%;
            flex-direction: column;
        }

        header {
            text-align: center;
            background-color: rgba(6, 6, 6, 0.85);
            padding: 50px 0;
            border-bottom: 5px solid #000000;
            color: #fafafb;
            width: 100%;
            position: relative;
        }

        header h1 {
            font-size: 15px;
            font-weight: bold;
            text-transform: uppercase;
            letter-spacing: 5px;
            text-shadow: 2px 2px 4px rgba(0, 0, 0, 0.2);
            color: white;
        }

        header p {
            font-size: 20px;
            margin: 5px 0;
            font-weight: bold;
        }

        .container {
            padding: 20px;
            background: rgba(255, 255, 255, 0.8);
            margin: 20px auto;
            border-radius: 10px;
            max-width: 700px;
            width: 100%;
            display: flex;
            flex-direction: column;
            align-items: center;
        }

        h2 {
            text-align: center;
        }

        .mensaje {
            text-align: center;
            font-weight: bold;
            color: darkred;
        }

        form {
            margin-bottom: 20px;
            display: flex;
            flex-direction: column;
            width: 100%;
            align-items: center;
        }

        form label, form input, form button {
            margin-bottom: 10px;
            width: 100%;
            max-width: 300px;
        }

        form input, form button {
            padding: 10px;
            font-size: 14px;
        }

        form button {
            background-color: darkorange;
            color: white;
            cursor: pointer;
            border-radius: 5px;
            border: none;
            transition: background 0.3s, transform 0.2s;
        }

        form button:hover {
            background-color: orangered;
            transform: scale(1.05);
        }

        table {
            width: 100%;
            border-collapse: collapse;
        }

        th, td {
            padding: 8px;
            text-align: center;
            border: 1px solid #ddd;
        }

        th {
            background-color: #f2f2f2;
        }

        /* Estilos para el acordeón */
        .accordion {
            width: 100%;
            margin: 10px 0;
        }

        .accordion button {
            background-color: #ff8c00;
            color: white;
            padding: 15px;
            width: 100%;
            text-align: left;
            font-size: 16px;
            border: none;
            cursor: pointer;
            transition: 0.3s;
            border-radius: 5px;
            margin-bottom: 5px;
        }

        .accordion button:hover {
            background-color: orangered;
        }

        .accordion .content {
            display: none;
            background-color: #f2f2f2;
            padding: 20px;
            border-radius: 5px;
        }

        .button-group {
            display: flex;
            justify-content: center;
            gap: 20px;  /* Añadido para separar los botones */
            width: 100%;
            margin-top: 20px;
        }

        .button-group form button {
            width: auto;
        }

    </style>
    <script>
        // Función para mostrar y ocultar el contenido del acordeón
        function toggleAccordion(id) {
            var content = document.getElementById(id);
            if (content.style.display === "block") {
                content.style.display = "none";
            } else {
                content.style.display = "block";
            }
        }
    </script>
</head>
<body>
<header>
    <h1>Inventario</h1>
    <p>Administra tus productos y existencias</p>
</header>

<div class="container">
    <div class="mensaje">
        <p><%= mensaje %></p>
    </div>

    <h2>Buscar Producto</h2>
    <form method="GET" action="inventario.jsp">
        <label for="filtro">Nombre del Producto:</label>
        <input type="text" id="filtro" name="filtro" placeholder="Escribe el nombre del producto">
        <button type="submit">Buscar</button>
        <% if (filtro != null && !filtro.trim().isEmpty()) { %>
        <button type="button" onclick="window.location.href='inventario.jsp'">Quitar Filtro</button>
        <% } %>
    </form>

    <h2>Listado de Productos</h2>
    <table>
        <thead>
        <tr>
            <th>#</th>
            <th>Nombre</th>
            <th>Precio de Venta</th>
            <th>Precio de Compra</th>
            <th>Stock</th>
        </tr>
        </thead>
        <tbody>
        <%
            for (int i = 0; i < productos.size(); i++) {
                Producto p = productos.get(i);
                if (filtro == null || filtro.trim().isEmpty() || p.getNombre().toLowerCase().contains(filtro.toLowerCase())) {
        %>
        <tr>
            <td><%= i + 1 %></td>
            <td><%= p.getNombre() %></td>
            <td><%= p.getPrecio() %></td>
            <td><%= p.getPrecioCosto() %></td>
            <td><%= p.getStock() %></td>
        </tr>
        <%
                }
            }
        %>
        </tbody>
    </table>

    <!-- Acordeón para las acciones -->
    <div class="accordion">
        <button type="button" onclick="toggleAccordion('agregarProducto')">Agregar Producto</button>
        <div id="agregarProducto" class="content">
            <form method="POST" action="inventario.jsp">
                <input type="hidden" name="accion" value="agregar">
                <label>Nombre del Producto</label>
                <input type="text" name="nombre" required>
                <label>Precio de Venta</label>
                <input type="number" name="precio" required>
                <label>Precio de Compra</label>
                <input type="number" name="precioCosto" required>
                <label>Cantidad en Stock</label>
                <input type="number" name="stock" required>
                <button type="submit">Agregar Producto</button>
            </form>
        </div>

        <button type="button" onclick="toggleAccordion('eliminarProducto')">Eliminar Producto</button>
        <div id="eliminarProducto" class="content">
            <form method="POST" action="inventario.jsp">
                <input type="hidden" name="accion" value="eliminar">
                <label>Seleccionar Producto (#)</label>
                <input type="number" name="productoId" required min="1" max="<%= productos.size() %>">
                <button type="submit">Eliminar Producto</button>
            </form>
        </div>

        <button type="button" onclick="toggleAccordion('agregarStock')">Agregar Stock a Producto Existente</button>
        <div id="agregarStock" class="content">
            <form method="POST" action="inventario.jsp">
                <input type="hidden" name="accion" value="agregarStock">
                <label>Seleccionar Producto (#)</label>
                <input type="number" name="productoId" required min="1" max="<%= productos.size() %>">
                <label>Cantidad a Agregar</label>
                <input type="number" name="cantidad" required min="1">
                <button type="submit">Agregar Stock</button>
            </form>
        </div>

        <button type="button" onclick="toggleAccordion('solicitudReabastecimiento')">Generar Solicitud de Reabastecimiento</button>
        <div id="solicitudReabastecimiento" class="content">
            <%
                // Crear una lista de productos con bajo stock
                ArrayList<Producto> productosBajoStock = new ArrayList<>();
                for (Producto p : inventario.getProductos()) {
                    if (p.getStock() < 10) {
                        productosBajoStock.add(p);
                    }
                }
            %>

            <% if (productosBajoStock.isEmpty()) { %>
            <p>No hay productos con bajo stock.</p>
            <% } else { %>
            <div style="border: 2px solid #f2a365; padding: 20px; background-color: #fdf7e1; border-radius: 10px; margin-bottom: 20px;">
                <h3>Productos con Bajo Stock:</h3>
                <ul style="list-style-type: none; padding-left: 0;">
                    <%
                        // Usar el índice del bucle para generar el número del producto
                        for (int i = 0; i < productosBajoStock.size(); i++) {
                            Producto p = productosBajoStock.get(i);
                    %>
                    <li style="padding: 10px; margin: 5px; background-color: #fff4cc; border-radius: 5px; box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);">
                        <strong>#<%= i + 1 %> - <%= p.getNombre() %></strong><br>
                        Stock Actual: <%= p.getStock() %><br>
                        Precio de Venta: <%= p.getPrecio() %><br>
                    </li>
                    <% } %>
                </ul>
            </div>
            <% } %>
        </div>
    </div>

    <h2>Menu Principal</h2>
    <div class="button-group">
        <form action="index.jsp" method="GET">
            <button type="submit">Volver al Menu Principal</button>
        </form>
    </div>
</div>

</body>
</html>
