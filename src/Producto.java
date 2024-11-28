import java.io.Serializable;

public class Producto implements Serializable {
    private static final long serialVersionUID = 1L; // Ayuda con la compatibilidad de versiones
    private String nombre;
    private int precio;
    private int precioCosto; // Precio de costo para calcular ganancias
    private int stock;
    private int ventasTotales;

    public Producto(String nombre, int precio, int precioCosto, int stock) {
        if (precio < 0 || precioCosto < 0 || stock < 0) {
            throw new IllegalArgumentException("Precio, precio de costo y stock no pueden ser negativos.");
        }
        if (nombre == null || nombre.trim().isEmpty()) {
            throw new IllegalArgumentException("El nombre del producto no puede estar vacío.");
        }
        this.nombre = nombre;
        this.precio = precio;
        this.precioCosto = precioCosto;
        this.stock = stock;
        this.ventasTotales = 0;
    }


    public String getNombre() {
        return nombre;
    }

    public int getPrecio() {
        return precio;
    }

    public int getPrecioCosto() {
        return precioCosto;
    }

    public int getStock() {
        return stock;
    }

    public void setStock(int stock) {
        this.stock = stock;
    }

    public void registrarVenta(int cantidad) {
        this.ventasTotales += cantidad;
    }

    @Override
    public String toString() {
        return nombre + " - $" + precio + " - Stock: " + stock + " - Ventas: " + ventasTotales;
    }
}
