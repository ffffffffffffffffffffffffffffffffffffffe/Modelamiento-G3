<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Salir</title>
    <script type="text/javascript">
        window.close();
        <%
            session.invalidate();
        %>
    </script>
</head>
<body>
<p>Gracias por utilizar el sistema.</p>
</body>
</html>
