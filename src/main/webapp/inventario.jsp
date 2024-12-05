<%@ page import="com.minimarket.*" %>
<%@ page import="java.io.File" %>
<%

    Inventario inventario = new Inventario();
    String mensaje = "";

    String accion = request.getParameter("accion");

    if ("agregar".equals(accion)) {
        String nombre = request.getParameter("nombre");
        int precio = Integer.parseInt(request.getParameter("precio"));
        int precioCosto = Integer.parseInt(request.getParameter("precioCosto"));
        int stock = Integer.parseInt(request.getParameter("stock"));

        Producto nuevoProducto = new Producto(nombre, precio, precioCosto, stock);
        inventario.agregarProducto(nuevoProducto);
        mensaje = "Producto agregado exitosamente.";
    } else if ("solicitud".equals(accion)) {
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

        inventario.listarProductos();
    } finally {
        System.setOut(originalOut);
    }
    String inventarioOutput = stringWriter.toString();
%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Inventario</title>
    <style>
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

        body {
            font-family: 'Roboto', sans-serif;
            margin: 0;
            background-color: #f1e3c6;
            background-size: cover;
            background-position: center;
            color: #292a2b;
            height: 100vh;
            overflow: auto; /* Permite el scroll */
        }

        header {
            text-align: center;
            background-color: rgba(6, 6, 6, 0.85);
            padding: 50px 0;
            border-bottom: 5px solid #000000;
            animation: fadeInFromTop 1s ease-out;
            color: #fafafb;
        }

        header h1 {
            font-size: 15px;
            font-weight: bold;
            text-transform: uppercase;
            letter-spacing: 5px;
            text-shadow: 2px 2px 4px rgba(0, 0, 0, 0.2);
        }

        header p {
            font-size: 20px;
            margin: 5px 0;
            font-weight: bold;
        }

        .container {
            display: flex;
            justify-content: center;
            align-items: center;
            padding: 20px;
            background: rgba(255, 255, 255, 0.8);
            border-radius: 10px;
            margin: 20px auto;
            width: 80%;
            flex-direction: column;
            box-shadow: 0 6px 15px rgba(0, 0, 0, 0.2);
            max-height: 90vh; /* Limita la altura para que haya scroll si el contenido es largo */
            overflow-y: auto; /* Permite el scroll vertical */
        }

        .volver-menu {
            margin-top: 20px;
            text-align: center;
        }

        .volver-menu button {
            background-color: #292a2b;
            color: white;
            padding: 10px 20px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            transition: background 0.3s;
        }

        .volver-menu button:hover {
            background-color: #444444;
        }

        h2 {
            text-align: center;
            font-size: 24px;
            margin-bottom: 10px;
        }

        .mensaje {
            text-align: center;
            font-weight: bold;
            color: darkred;
            margin-bottom: 20px;
        }

        form {
            margin-bottom: 20px;
            width: 100%;
        }

        form label {
            display: block;
            font-weight: bold;
            margin-bottom: 5px;
        }

        form input, form button {
            width: 100%;
            padding: 10px;
            margin-bottom: 10px;
            border: 1px solid #ddd;
            border-radius: 5px;
        }

        form button {
            background-color: #292a2b;
            color: white;
            border: none;
            cursor: pointer;
            transition: background 0.3s;
        }

        form button:hover {
            background-color: #444444;
        }

        .inventario-list {
            font-family: monospace;
            background: #e9ecef;
            padding: 10px;
            border-radius: 8px;
            white-space: pre-wrap;
            width: 100%;
        }
    </style>
</head>
<body>
<header>
    <h1>Menu Inventario</h1>
    <p>Administra tus productos y existencias</p>
</header>

<div class="container">
    <div class="mensaje">
        <p><%= mensaje %></p>
    </div>
    <h2>Listado de Productos</h2>
    <div class="inventario-list">
        <pre><%= inventarioOutput %></pre>
    </div>
    <div class="volver-menu">
        <form action="index.jsp" method="GET">
            <button type="submit">Volver al Menu Principal</button>
        </form>
    </div>
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
    <h2>Generar Solicitud de Reabastecimiento</h2>
    <form method="POST" action="inventario.jsp">
        <input type="hidden" name="accion" value="solicitud">
        <button type="submit">Generar Solicitud</button>
    </form>

</div>
</body>
</html>




