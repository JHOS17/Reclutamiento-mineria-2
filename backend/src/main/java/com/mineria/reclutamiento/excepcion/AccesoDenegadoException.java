package com.mineria.reclutamiento.excepcion;

/** Equivale a un error 403. */
public class AccesoDenegadoException extends RuntimeException {
    public AccesoDenegadoException(String mensaje) { super(mensaje); }
}
