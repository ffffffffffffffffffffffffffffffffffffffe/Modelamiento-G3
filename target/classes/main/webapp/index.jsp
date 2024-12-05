<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Minimarket - Menú Principal</title>
    <style>
        /* Animación de Fadein desde arriba */
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
            background-image: url('images/minimarketFront.jpeg'); /* Imagen fondo */
            background-size: cover;
            background-position: center;
            color: #292a2b;
            height: 100vh;
            overflow: hidden;
        }

        header {
            text-align: center;
            background-color: rgba(6, 6, 6, 0.85);
            padding: 50px 0;
            border-bottom: 5px solid #000000;
            animation: fadeInFromTop 1s ease-out;
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 20px 50px;
        }

        .header-left {
            text-align: left;
        }

        .header-right {
            text-align: right;
        }

        header h1 {
            font-size: 15px;
            margin: 0;
            font-weight: bold;
            color: #fafafb;
            text-transform: uppercase;
            letter-spacing: 5px;
            text-shadow: 2px 2px 4px rgba(0, 0, 0, 0.2);
        }

        header p {
            font-size: 20px;
            margin: 5px 0;
            color: #fafafb;
            font-weight: bold;
        }

        header .header-right p:last-child {
            font-size: 90px;
            font-weight: bolder;
            color: #fafafb;
            text-transform: uppercase;
        }

        .container {
            display: flex;
            justify-content: center;
            align-items: center;
            height: 70%;
            padding: 20px;
        }

        /* Menú */
        .menu {
            display: flex;
            flex-direction: column;
            gap: 40px;
            padding-right: 50px;
        }

        .menu a {
            display: block;
            padding: 35px 50px;
            background-color: #000000;
            color: white;
            text-decoration: none;
            font-size: 28px;
            font-weight: bold;
            text-align: center;
            border-radius: 0 0 30px 30px;
            position: relative;
            transition: all 0.3s ease;
            box-shadow: 0 6px 15px rgba(0, 0, 0, 0.3);
        }

        /* Hover para cambiar color de fondo y sombra */
        .menu a:hover {
            background-color: #444444;
            box-shadow: 0 10px 25px rgba(0, 0, 0, 0.4);
        }

        footer {
            text-align: center;
            background-color: rgba(93, 58, 27, 0.8);
            color: #f1e3c6;
            padding: 15px;
            font-size: 18px;
        }

    </style>
</head>
<body>

<header>
    <div class="header-left">
        <h1>Minimarket</h1>
        <p>SUPERMERCADO Y BOTILLERÍA</p>
    </div>
    <div class="header-right">
        <p>JS</p>
    </div>
</header>

<div class="container">

    <!-- Menú -->
    <div class="menu">
        <a href="ventas.jsp">Menú Ventas</a>
        <a href="inventario.jsp">Menú Inventario</a>
        <a href="historial.jsp">Historial de Ventas</a>
        <a href="salir.jsp">Salir</a>
    </div>

</div>

<footer>
    <p>Dirección: Brisas Mediterráneas 1845 - Num. Contacto: +56 985124881 </p>
</footer>

</body>
</html>