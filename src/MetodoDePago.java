public class MetodoDePago {
    private String tipo;
    private double montoPagado;

    public MetodoDePago(String tipo, double montoPagado) {
        this.tipo = tipo;
        this.montoPagado = montoPagado;
    }

    public double calcularCambio(double totalCompra) {
        return (tipo.equalsIgnoreCase("Efectivo") && montoPagado >= totalCompra) ? montoPagado - totalCompra : 0.0;
    }

    public String getTipo() {
        return tipo;
    }
}
