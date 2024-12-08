<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
  <title>Login - Minimarket</title>
  <style>
    body {
      font-family: 'Roboto', sans-serif;
      margin: 0;
      background-color: #4c4c4c;
      display: flex;
      justify-content: center;
      align-items: center;
      height: 100vh;
      background-image: url('images/loginBackground.jpg'); /* Imagen de fondo opcional */
      background-size: cover;
      background-position: center;
    }

    .login-container {
      background-color: rgba(255, 255, 255, 0.9);
      padding: 30px 40px;
      border-radius: 10px;
      box-shadow: 0 4px 10px rgba(0, 0, 0, 0.2);
      width: 100%;
      max-width: 400px;
      text-align: center;
    }

    .login-container h2 {
      margin-bottom: 20px;
      font-size: 24px;
      color: #333;
    }

    .login-container form {
      display: flex;
      flex-direction: column;
      gap: 15px;
    }

    .login-container input[type="text"],
    .login-container input[type="password"] {
      width: 100%;
      padding: 12px;
      font-size: 16px;
      border: 1px solid #ccc;
      border-radius: 5px;
      box-sizing: border-box;
    }

    .login-container button {
      padding: 12px;
      font-size: 16px;
      background-color: #007BFF;
      color: white;
      border: none;
      border-radius: 5px;
      cursor: pointer;
      transition: background-color 0.3s ease;
    }

    .login-container button:hover {
      background-color: #0056b3;
    }

    .login-container a {
      margin-top: 15px;
      display: block;
      font-size: 14px;
      color: #007BFF;
      text-decoration: none;
    }

    .login-container a:hover {
      text-decoration: underline;
    }
  </style>
</head>
<body>

<div class="login-container">
  <h2>Iniciar Sesión</h2>
  <form action="LoginServlet" method="post">
    <input type="text" name="username" placeholder="Usuario" required>
    <input type="password" name="password" placeholder="Contraseña" required>
    <button type="submit">Iniciar Sesión</button>
  </form>
</div>

</body>
</html>
