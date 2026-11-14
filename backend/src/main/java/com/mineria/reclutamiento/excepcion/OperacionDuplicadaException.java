package com.mineria.reclutamiento.excepcion;

public class OperacionDuplicadaException extends RuntimeException {
    public OperacionDuplicadaException(String clave) { super("Operacion repetida: " + clave); }
}
