# Modelamiento-G3
# Integrantes: 
- Daniel Canto Moreno
- Felipe Escobar Stuardo
- Pedro Marin Gallegos
- Carlos Pacheco Troncoso

## Tabla de Contenidos
- [Descripción](#descripción)
- [Requisitos](#requisitos)
- [Instalación](#instalación)

---

## Descripción
Este proyecto simula un sistema de gestión para un minimarket. Permite realizar ventas, gestionar un inventario de productos y mantener un historial de ventas. Entre las funcionalidades principales están:

- Gestión de inventario (agregar productos, modificar stock, generar solicitudes de reabastecimiento).
- Procesar ventas, generar boletas y registrar las ganancias.
- Manejar diferentes métodos de pago y calcular cambios.
- Persistencia de datos mediante serialización para inventario y ventas.

## Requisitos

1. Instala Smart Tomcat en Intellij IDEA>Settings>Plugins.
2. Instala [Tomcat ver.10.1.33.0](https://cdn.discordapp.com/attachments/973705374525968477/1315180483151265842/apache-tomcat-10.1.33-windows-x64.zip?ex=675678c6&is=67552746&hm=24f1f1ff8791ed27ea87e17ca836e00d284770fa0ab4b012534c045bd89d9e37&)
3. Descomprime el archivo 'apache-tomcat-10.1.33-windows-x64'.
4. Tener sdk openjdk-21 version 21 o superior.

## Instalación

1. Descarga el repositorio que contiene el proyecto.
2. Crea un nuevo proyecto con Maven Archetype en IntelliJ IDEA con el nombre "MinimarketDCWebsite".
3. Selecciona el Archertype "org.apache.maven.archetypes:maven-archetype-webapp"
4. Copia el repositorio dentro del nuevo proyecto creado.
5. Conecta la carpeta Tomcat en Settings>"Tomcat Server" seleccionando la carpeta 'apache-tomcat-10.1.33'.
6. Seleccionar Run `pom.xml` y Asignar "Use classpath of module: " la carpeta del proyecto y aplicar
7. Ejecuta la aplicación haciendo clic en el archivo principal (como `pom.xml`) y seleccionando **Run 'Smart Tomcat: Tomcat: MinimarketDCWebsite'**.

---
