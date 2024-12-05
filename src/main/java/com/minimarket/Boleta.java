package com.minimarket;

import java.io.Serializable;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;

public class Boleta implements Serializable {
    private static final long serialVersionUID = 1L;
    private ArrayList<Producto> productos;
    private int total;
    private String metodoPago;
    private LocalDateTime fechaHora; // Nueva propiedad para la fecha y hora de la venta

    public Boleta(ArrayList<Producto> productos, int total, String metodoPago) {
        this.productos = productos;
        this.total = total;
        this.metodoPago = metodoPago;
        this.fechaHora = LocalDateTime.now(); // Registrar la fecha y hora actuales
    }

    public int getTotal() {
        return total;
    }

    public String getMetodoPago() {
        return metodoPago;
    }

    public LocalDateTime getFechaHora() {
        return fechaHora;
    }

    public ArrayList<Producto> getProductos() {
        return productos;
    }

    public void generarBoleta() {
        System.out.println("\n--- Boleta de Compra ---");
        System.out.println("Fecha y Hora: " + obtenerFechaHora());
        ArrayList<String> nombresProcesados = new ArrayList<>();
        for (Producto producto : productos) {
            if (!nombresProcesados.contains(producto.getNombre())) {
                int cantidad = (int) productos.stream()
                        .filter(p -> p.equals(producto))
                        .count();
                System.out.println("- " + producto.getNombre() + " x" + cantidad + " $" + (producto.getPrecio() * cantidad));
                nombresProcesados.add(producto.getNombre());
            }
        }
        System.out.println("Total: $" + total);
        System.out.println("Método de pago: " + metodoPago);
        System.out.println("------------------------");
    }

    public String obtenerFechaHora() {
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd-MM-yyyy HH:mm:ss");
        return fechaHora.format(formatter);
    }

    @Override
    public String toString() {
        StringBuilder sb = new StringBuilder();
        sb.append(fechaHora.toString()).append(";"); // Fecha y hora
        sb.append(total).append(";").append(metodoPago).append(";");
        for (Producto producto : productos) {
            sb.append(producto.getNombre()).append(",");
        }
        return sb.toString();
    }


}


