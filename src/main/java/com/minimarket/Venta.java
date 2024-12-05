package com.minimarket;

import java.io.*;
import java.util.ArrayList;

public class Venta implements Serializable {
    private static final long serialVersionUID = 1L;
    private ArrayList<Producto> carrito;
    private int total;
    private int ganancias;
    private ArrayList<Boleta> historialVentas; // Guardamos objetos de tipo Boleta
    private Inventario inventario; // Referencia al inventario

    private final String archivoHistorial = "historial_ventas.obj";

    public int getTotal() {
        return total;
    }

    public Venta(Inventario inventario) {
        this.carrito = new ArrayList<>();
        this.total = 0;
        this.ganancias = 0;
        this.historialVentas = new ArrayList<>();
        this.inventario = inventario;
        cargarHistorial();
    }

    public void agregarAlCarrito(Producto producto, int cantidad) {
        if (producto.getStock() >= cantidad) {
            producto.setStock(producto.getStock() - cantidad);
            producto.registrarVenta(cantidad);
            for (int i = 0; i < cantidad; i++) {
                carrito.add(producto);
                total += producto.getPrecio();
            }
            System.out.println("Producto agregado al carrito.");
        } else {
            System.out.println("No hay suficiente stock.");
        }
    }

    public ArrayList<Producto> getCarrito() {
        return carrito;
    }

    public void finalizarVenta(MetodoDePago metodoDePago) {
        if (carrito.isEmpty()) {
            throw new IllegalStateException("El carrito está vacío. No se puede finalizar la venta.");
        }

        double cambio;
        try {
            cambio = metodoDePago.calcularCambio(total);
            if (metodoDePago.getTipo().equalsIgnoreCase("Efectivo") && cambio < 0) {
                throw new IllegalArgumentException("El monto pagado no puede ser menor al total de la compra.");
            }
        } catch (Exception e) {
            System.out.println("Error al calcular el cambio: " + e.getMessage());
            return;
        }

        System.out.println("\nVenta finalizada.");
        System.out.println("Total: $" + total + " CLP");
        System.out.println("Método de pago: " + metodoDePago.getTipo());
        if (cambio > 0) {
            System.out.println("Cambio: $" + cambio + " CLP");
        }

        registrarGanancias();

        try {
            Boleta boleta = new Boleta(new ArrayList<>(carrito), total, metodoDePago.getTipo());
            boleta.generarBoleta();
            guardarVenta(boleta); // Guardar boleta en el historial
            inventario.guardarInventario(); // Persistir inventario
        } catch (Exception e) {
            System.out.println("Error al guardar la venta o el inventario: " + e.getMessage());
        }

        carrito.clear();
        total = 0;
    }

    public void guardarVenta(Boleta boleta) {
        historialVentas.add(boleta);
        try (ObjectOutputStream oos = new ObjectOutputStream(new FileOutputStream(archivoHistorial))) {
            oos.writeObject(historialVentas);
            System.out.println("Venta registrada exitosamente.");
        } catch (IOException e) {
            System.out.println("Error al guardar la venta: " + e.getMessage());
        }
    }
    public void cargarHistorial() {
        try (ObjectInputStream ois = new ObjectInputStream(new FileInputStream(archivoHistorial))) {
            historialVentas = (ArrayList<Boleta>) ois.readObject();
            System.out.println("Historial de ventas cargado exitosamente.");
        } catch (FileNotFoundException e) {
            System.out.println("No se encontró un archivo de historial. Creando uno nuevo.");
        } catch (IOException | ClassNotFoundException e) {
            System.out.println("Error al cargar el historial: " + e.getMessage());
        }
    }

    public void verHistorial() {
        if (historialVentas.isEmpty()) {
            System.out.println("\nNo hay datos de ventas disponibles.");
        } else {
            System.out.println("\n--- Historial de Ventas ---");
            for (Boleta boleta : historialVentas) {
                boleta.generarBoleta();
            }
        }
    }



    public void verCarrito() {
        if (carrito.isEmpty()) {
            System.out.println("\nEl carrito está vacío.");
        } else {
            System.out.println("\n--- Carrito ---");
            ArrayList<String> nombresProcesados = new ArrayList<>();
            for (Producto producto : carrito) {
                if (!nombresProcesados.contains(producto.getNombre())) {
                    int cantidad = (int) carrito.stream()
                            .filter(p -> p.equals(producto))
                            .count();
                    System.out.println("- " + producto.getNombre() + " x" + cantidad + " $" + (producto.getPrecio() * cantidad));
                    nombresProcesados.add(producto.getNombre());
                }
            }
            System.out.println("Total actual: $" + total);
        }
    }


    public void registrarGanancias() {
        for (Producto p : carrito) {
            ganancias += (p.getPrecio() - p.getPrecioCosto());
        }
    }

    public void cancelarVenta() {
        for (Producto p : carrito) {
            p.setStock(p.getStock() + 1);
        }
        carrito.clear();
        total = 0;
        System.out.println("Venta cancelada.");
    }

    public int getGanancias() {
        return ganancias;
    }
}





