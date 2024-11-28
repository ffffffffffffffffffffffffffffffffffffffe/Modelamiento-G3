import java.io.*;
import java.util.ArrayList;

public class Inventario implements Serializable {
    private static final long serialVersionUID = 1L;
    private ArrayList<Producto> productos;
    private final String archivoInventario = "inventario.txt"; // Archivo para guardar el inventario

    public Inventario() {
        this.productos = new ArrayList<>();
        cargarInventario(); // Cargar inventario al inicializar
    }

    public void agregarProducto(Producto producto) {
        productos.add(producto);
        guardarInventario(); // Actualizar el archivo al agregar un producto
    }

    public void listarProductos() {
        if (productos.isEmpty()) {
            System.out.println("\nEl inventario está vacío.");
        } else {
            System.out.println("\n--- Inventario ---");
            for (int i = 0; i < productos.size(); i++) {
                Producto p = productos.get(i);
                System.out.println((i + 1) + ". " + p); // Mostrar índice + 1
            }
        }
    }

    public Producto obtenerProducto(int indice) {
        if (indice >= 0 && indice < productos.size()) {
            return productos.get(indice);
        }
        return null;
    }

    public Producto buscarProductoPorNombre(String nombre) {
        for (Producto producto : productos) {
            if (producto.getNombre().equalsIgnoreCase(nombre)) {
                return producto;
            }
        }
        return null; // Retorna null si no se encuentra el producto
    }

    public void generarSolicitud() {
        System.out.println("\n--- Solicitud de Stock ---");
        for (Producto p : productos) {
            if (p.getStock() <= 10) {
                System.out.println("Solicitar más de: " + p.getNombre());
            }
        }
    }

    public void guardarInventario() {
        try (ObjectOutputStream oos = new ObjectOutputStream(new FileOutputStream(archivoInventario))) {
            oos.writeObject(productos);
            System.out.println("Inventario guardado exitosamente.");
        } catch (IOException e) {
            System.out.println("Error al guardar el inventario: " + e.getMessage());
        }
    }



    public void cargarInventario() {
        try (ObjectInputStream ois = new ObjectInputStream(new FileInputStream(archivoInventario))) {
            productos = (ArrayList<Producto>) ois.readObject();
            System.out.println("Inventario cargado exitosamente.");
        } catch (FileNotFoundException e) {
            System.out.println("No se encontró un archivo de inventario. Creando uno nuevo.");
        } catch (IOException | ClassNotFoundException e) {
            System.out.println("Error al cargar el inventario: " + e.getMessage());
        }
    }

}

