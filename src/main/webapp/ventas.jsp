<%@ page import="com.minimarket.*" %>
<%@ page import="java.util.ArrayList" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    // Inicialización de objetos si no existen en sesión
    Inventario inventario = (Inventario) session.getAttribute("inventario");
    Venta venta = (Venta) session.getAttribute("venta");

    if (inventario == null) {
        inventario = new Inventario();
        session.setAttribute("inventario", inventario);
    }

    if (venta == null) {
        venta = new Venta(inventario);
        session.setAttribute("venta", venta);
    }

    // Procesos Formulario
    String accion = request.getParameter("accion");
    String mensaje = "";

    if ("agregar".equals(accion)) {
        int indiceProducto = Integer.parseInt(request.getParameter("producto"));
        int cantidad = Integer.parseInt(request.getParameter("cantidad"));

        Producto producto = inventario.obtenerProducto(indiceProducto - 1);
        if (producto != null) {
            venta.agregarAlCarrito(producto, cantidad);
            mensaje = "Producto agregado al carrito.";
        } else {
            mensaje = "Producto no encontrado.";
        }
    } else if ("finalizar".equals(accion)) {
        String metodoPago = request.getParameter("metodoPago");
        MetodoDePago pago = null;
        int vuelto = 0;

        if ("efectivo".equals(metodoPago)) {
            int montoPagado = Integer.parseInt(request.getParameter("montoPagado"));
            if (montoPagado < venta.getTotal()) {
                mensaje = "El monto pagado es insuficiente.";
            } else {
                vuelto = montoPagado - venta.getTotal();
                pago = new MetodoDePago("Efectivo", montoPagado);
            }
        } else if ("tarjeta".equals(metodoPago) || "transferencia".equals(metodoPago)) {
            pago = new MetodoDePago(metodoPago, venta.getTotal());
        }

        if (pago != null) {
            try {
                venta.finalizarVenta(pago);
                mensaje = "Venta finalizada correctamente.";
                if ("efectivo".equals(metodoPago)) {
                    mensaje += " El vuelto a entregar es: $" + vuelto;
                }
            } catch (Exception e) {
                mensaje = e.getMessage();
            }
        } else {
            mensaje = "Método de pago inválido o insuficiente.";
        }
    } else if ("verCarrito".equals(accion)) {
        mensaje = "Mostrando el carrito.";
    } else if ("cancelar".equals(accion)) {
        venta.cancelarVenta();
        mensaje = "Venta cancelada correctamente.";
    } else if ("mostrarGanancias".equals(accion)) {
        mensaje = "Ganancias diarias: $" + venta.getGanancias();
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Ventas</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            background-color: #f1e3c6;
            display: flex;
            flex-direction: column;
            justify-content: flex-start;
            align-items: center;
            height: 100vh;
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

        /* Estilos para el container */
        .container {
            max-width: 1200px;
            margin: 20px auto;
            padding: 20px;
            background-color: #ffffff;
            border-radius: 15px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            display: flex;
            flex-direction: column;
            align-items: center;
        }

        h1 {
            color: darkorange;
        }

        h2 {
            margin-top: 20px;
            color: #333;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin-bottom: 20px;
        }

        th, td {
            padding: 10px;
            text-align: center;
            border: 1px solid #ddd;
        }

        th {
            background-color: #f2f2f2;
        }

        form {
            margin-bottom: 20px;
        }

        label {
            margin-right: 10px;
        }

        input[type="number"], select {
            padding: 5px;
            margin-bottom: 10px;
        }

        button {
            padding: 10px 20px;
            background-color: darkorange;
            color: white;
            border: none;
            cursor: pointer;
            border-radius: 5px;
            transition: background-color 0.3s, transform 0.2s;
        }

        button:hover {
            background-color: orangered;
            transform: scale(1.05);
        }

        .mensaje {
            font-size: 18px;
            font-weight: bold;
            color: #d9534f;
        }
    </style>
</head>
<body>

<!-- Header -->
<header>
    <h1>Ventas</h1>
    <p>Realiza y administra tus ventas</p>
</header>

<!-- Container con bordes redondeados y sombra -->
<div class="container">
    <p class="mensaje"><%= mensaje %></p>

    <!-- Listar productos -->
    <h2>Productos disponibles</h2>
    <form action="ventas.jsp" method="post">
        <table>
            <tr>
                <th>#</th>
                <th>Nombre</th>
                <th>Precio</th>
                <th>Stock</th>
            </tr>
            <%
                // Listar productos desde el inventario
                ArrayList<Producto> productos = inventario.getProductos();
                for (int i = 0; i < productos.size(); i++) {
                    Producto p = productos.get(i);
            %>
            <tr>
                <td><%= i + 1 %></td>
                <td><%= p.getNombre() %></td>
                <td><%= p.getPrecio() %></td>
                <td><%= p.getStock() %></td>
            </tr>
            <%
                }
            %>
        </table>
        <label id="producto">Seleccione un producto:</label>
        <input type="number" name="producto" required min="1" max="<%= productos.size() %>">
        <label id="cantidad">Cantidad:</label>
        <input type="number" name="cantidad" required min="1">
        <button type="submit" name="accion" value="agregar">Agregar al carrito</button>
    </form>

    <!-- Ver carrito -->
    <h2>Carrito</h2>
    <form action="ventas.jsp" method="post">
        <%
            ArrayList<Producto> carrito = venta.getCarrito();
            if (carrito.size() > 0) {
        %>
        <table>
            <tr>
                <th>Producto</th>
                <th>Cantidad Total</th>
                <th>Precio</th>
            </tr>
            <%
                ArrayList<String> nombresProcesados = new ArrayList<>();
                double totalCarrito = 0;
                for (Producto p : carrito) {
                    if (!nombresProcesados.contains(p.getNombre())) {
                        int cantidad = (int) carrito.stream()
                                .filter(producto -> producto.getNombre().equals(p.getNombre()))
                                .count();
                        double totalProducto = p.getPrecio() * cantidad;
                        totalCarrito += totalProducto;
            %>
            <tr>
                <td><%= p.getNombre() %></td>
                <td><%= cantidad %></td>
                <td><%= totalProducto %></td>
            </tr>
            <%
                        nombresProcesados.add(p.getNombre());
                    }
                }
            %>
        </table>
        <p>Total: <%= totalCarrito %></p>
        <%
        } else {
        %>
        <p>El carrito está vacío.</p>
        <%
            }
        %>
    </form>

    <!-- Finalizar venta -->
    <h2>Finalizar Venta</h2>
    <form action="ventas.jsp" method="post">
        <label id="metodoPago">Método de pago:</label>
        <select name="metodoPago" required onchange="mostrarMontoPago()">
            <option value="tarjeta" selected>Tarjeta</option>
            <option value="efectivo">Efectivo</option>
            <option value="transferencia">Transferencia</option>
        </select>
        <div id="montoPagoDiv" style="display: none;">
            <label id="montoPagado">Monto pagado (solo efectivo):</label>
            <input type="number" name="montoPagado" min="1">
        </div>
        <button type="submit" name="accion" value="finalizar">Finalizar Venta</button>
    </form>

    <!-- Cancelar Venta -->
    <h2>Cancelar Venta</h2>
    <form action="ventas.jsp" method="post">
        <button type="submit" name="accion" value="cancelar">Cancelar Venta</button>
    </form>

    <!-- Mostrar ganancias diarias -->
    <h2>Mostrar Ganancias Diarias</h2>
    <form action="ventas.jsp" method="post">
        <button type="submit" name="accion" value="mostrarGanancias">Mostrar Ganancias</button>
    </form>

    <!-- Regresar al menú principal -->
    <h2>Menú Principal</h2>
    <form action="index.jsp" method="get">
        <button type="submit">Volver al Menú Principal</button>
    </form>
</div>

<script>
    function mostrarMontoPago() {
        var metodoPago = document.querySelector("select[name='metodoPago']").value;
        var montoPagoDiv = document.getElementById("montoPagoDiv");
        if (metodoPago === "efectivo") {
            montoPagoDiv.style.display = "block";
        } else {
            montoPagoDiv.style.display = "none";
        }
    }
</script>

</body>
</html>
