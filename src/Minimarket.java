import java.util.Scanner;

public class Minimarket {
    public static void main(String[] args) {
        Scanner scanner = new Scanner(System.in);
        Inventario inventario = new Inventario();
        Venta venta = new Venta(inventario);
        
        System.out.println("\nCargando inventario...");
        inventario.cargarInventario();
        System.out.println("\nCargando historial de ventas...");
        venta.cargarHistorial();

        boolean salir = false;
        while (!salir) {
            try {
                System.out.println("\n=== MENÚ PRINCIPAL ===");
                System.out.println("1. Menú Ventas");
                System.out.println("2. Menú Gestión de Inventario");
                System.out.println("3. Ver Historial de Ventas");
                System.out.println("4. Salir");
                System.out.print("Selecciona una opción: ");
                int opcion = scanner.nextInt();

                switch (opcion) {
                    case 1 -> menuVentas(scanner, inventario, venta);
                    case 2 -> menuInventario(scanner, inventario);
                    case 3 -> venta.verHistorial();
                    case 4 -> {
                        System.out.println("Saliendo del sistema...");
                        salir = true;
                    }
                    default -> System.out.println("Opción no válida. Por favor, selecciona una opción del 1 al 4.");
                }
            } catch (Exception e) {
                System.out.println("Error: Entrada no válida. Por favor, ingresa un número entero.");
                scanner.nextLine(); // Limpiar el buffer
            }
        }
        scanner.close();
    }

    private static void menuVentas(Scanner scanner, Inventario inventario, Venta venta) {
        boolean salirVentas = false;
        while (!salirVentas) {
            try {
                System.out.println("\n=== MENÚ VENTAS ===");
                System.out.println("1. Mostrar carrito");
                System.out.println("2. Agregar al carrito");
                System.out.println("3. Finalizar venta");
                System.out.println("4. Cancelar venta");
                System.out.println("5. Ver ganancias diarias");
                System.out.println("6. Regresar al menú principal");
                System.out.print("Selecciona una opción: ");
                int opcion = scanner.nextInt();

                switch (opcion) {
                    case 1 -> venta.verCarrito();
                    case 2 -> {
                        inventario.listarProductos();
                        System.out.print("Selecciona el índice del producto: ");
                        int indice = scanner.nextInt() - 1;
                        System.out.print("Cantidad: ");
                        int cantidad = scanner.nextInt();

                        Producto producto = inventario.obtenerProducto(indice);
                        if (producto != null) {
                            venta.agregarAlCarrito(producto, cantidad);
                        } else {
                            System.out.println("Producto no encontrado.");
                        }
                    }
                    case 3 -> {
                        System.out.println("\nSelecciona el método de pago:");
                        System.out.println("1. Efectivo");
                        System.out.println("2. Tarjeta");
                        System.out.println("3. Transferencia");
                        System.out.print("Opción: ");
                        int metodoIndex = scanner.nextInt();

                        String metodo = switch (metodoIndex) {
                            case 1 -> "Efectivo";
                            case 2 -> "Tarjeta";
                            case 3 -> "Transferencia";
                            default -> {
                                System.out.println("Método no válido. Cancelando venta.");
                                yield null;
                            }
                        };

                        if (metodo != null) {
                            double montoPagado = 0.0;
                            if (metodo.equals("Efectivo")) {
                                System.out.print("Monto pagado: ");
                                montoPagado = scanner.nextDouble();
                            }
                            venta.finalizarVenta(new MetodoDePago(metodo, montoPagado));
                        }
                    }
                    case 4 -> venta.cancelarVenta();
                    case 5 -> System.out.println("Ganancias diarias: $" + venta.getGanancias());
                    case 6 -> salirVentas = true;
                    default -> System.out.println("Opción no válida.");
                }
            } catch (Exception e) {
                System.out.println("Error: Entrada no válida. Por favor, intenta de nuevo.");
                scanner.nextLine(); // Limpiar el buffer
            }
        }
    }

    private static void menuInventario(Scanner scanner, Inventario inventario) {
        boolean salirInventario = false;
        while (!salirInventario) {
            try {
                System.out.println("\n=== MENÚ GESTIÓN DE INVENTARIO ===");
                System.out.println("1. Mostrar inventario");
                System.out.println("2. Agregar producto al inventario");
                System.out.println("3. Generar solicitud de stock");
                System.out.println("4. Regresar al menú principal");
                System.out.print("Selecciona una opción: ");
                int opcion = scanner.nextInt();

                switch (opcion) {
                    case 1 -> inventario.listarProductos();
                    case 2 -> {
                        scanner.nextLine(); // Limpiar buffer
                        System.out.print("Nombre del producto: ");
                        String nombre = scanner.nextLine();
                        System.out.print("Precio de venta: ");
                        int precioVenta = scanner.nextInt();
                        System.out.print("Precio de costo: ");
                        int precioCosto = scanner.nextInt();
                        System.out.print("Cantidad en stock: ");
                        int stock = scanner.nextInt();

                        Producto nuevoProducto = new Producto(nombre, precioVenta, precioCosto, stock);
                        inventario.agregarProducto(nuevoProducto);
                        System.out.println("Producto agregado exitosamente.");
                    }
                    case 3 -> inventario.generarSolicitud();
                    case 4 -> salirInventario = true;
                    default -> System.out.println("Opción no válida. Por favor, selecciona una opción del 1 al 4.");
                }
            } catch (Exception e) {
                System.out.println("Error: Entrada no válida. Por favor, intenta de nuevo.");
                scanner.nextLine(); // Limpiar el buffer
            }
        }
    }
}
