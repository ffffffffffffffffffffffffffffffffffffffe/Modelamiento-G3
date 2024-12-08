<%@ page import="com.minimarket.*" %>
<%@ page import="java.util.ArrayList" %>
<%
    // Inicialización del inventario
    Inventario inventario = (Inventario) session.getAttribute("inventario");
    if (inventario == null) {
        // Si no existe en la sesión, inicializar uno nuevo
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

        Producto nuevoProducto = new Producto(nombre, precio, precioCosto, stock);
        inventario.agregarProducto(nuevoProducto);
        mensaje = "Producto agregado exitosamente.";

        // Acción para agregar stock a un producto existente
    } else if ("agregarStock".equals(accion)) {
        int productoId = Integer.parseInt(request.getParameter("productoId"));
        int cantidad = Integer.parseInt(request.getParameter("cantidad"));

        Producto producto = inventario.obtenerProducto(productoId);
        if (producto != null) {
            producto.setStock(producto.getStock() + cantidad); // Aumenta el stock
            mensaje = "Stock agregado exitosamente.";
        } else {
            mensaje = "Producto no encontrado.";
        }

        // Acción para generar la solicitud de reabastecimiento
    } else if ("solicitud".equals(accion)) {
        // Generar la solicitud de reabastecimiento
        java.io.StringWriter stringWriter = new java.io.StringWriter();
        java.io.PrintWriter printWriter = new java.io.PrintWriter(stringWriter);
        java.io.PrintStream originalOut = System.out;

        try {
            System.setOut(new java.io.PrintStream(new java.io.OutputStream() {
                @Override
                public void write(int b) {
                    printWriter.write(b);
                }
            }));

            inventario.generarSolicitud();
        } finally {
            System.setOut(originalOut);
        }
        mensaje = stringWriter.toString();
    }

    // Obtener la lista de productos
    ArrayList<Producto> productos = inventario.getProductos();
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
            justify-content: flex-start; /* Cambio aquí para no afectar al header */
            align-items: flex-start; /* Cambio aquí para no afectar al header */
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
            position: relative; /* Asegura que el header se mantenga en su lugar */
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

        .button-group {
            display: flex;
            flex-direction: column;
            gap: 10px;
            align-items: center;
            width: 100%;
        }

        .button-group form {
            width: 100%;
            display: flex;
            justify-content: center;
        }
    </style>
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
            // Mostrar productos existentes en el inventario
            for (int i = 0; i < productos.size(); i++) {
                Producto p = productos.get(i);
        %>
        <tr>
            <td><%= i + 1 %></td>
            <td><%= p.getNombre() %></td>
            <td><%= p.getPrecio() %></td>
            <td><%= p.getPrecioCosto() %></td>
            <td><%= p.getStock() %></td>
        </tr>
        <% } %>
        </tbody>
    </table>

    <h2>Agregar Producto</h2>
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

    <h2>Agregar Stock a Producto Existente</h2>
    <form method="POST" action="inventario.jsp">
        <input type="hidden" name="accion" value="agregarStock">
        <label>Seleccionar Producto</label>
        <select name="productoId" required>
            <%
                // Crear un selector de productos
                for (int i = 0; i < productos.size(); i++) {
                    Producto p = productos.get(i);
            %>
            <option value="<%= i %>"><%= p.getNombre() %> - Stock Actual: <%= p.getStock() %></option>
            <%
                }
            %>
        </select>
        <label>Cantidad a Agregar</label>
        <input type="number" name="cantidad" required min="1">
        <button type="submit">Agregar Stock</button>
    </form>

    <h2>Generar Solicitud de Reabastecimiento</h2>
    <form method="POST" action="inventario.jsp">
        <input type="hidden" name="accion" value="solicitud">
        <button type="submit">Generar Solicitud</button>
    </form>

    <!-- Botón de volver al menú principal -->
    <div class="button-group">
        <form action="index.jsp" method="GET">
            <button type="submit">Volver al Menu Principal</button>
        </form>
    </div>
</div>
</body>
</html>
