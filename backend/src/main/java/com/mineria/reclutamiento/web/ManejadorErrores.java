package com.mineria.reclutamiento.web;

import com.mineria.reclutamiento.excepcion.AccesoDenegadoException;
import java.util.Map;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.security.authentication.LockedException;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;

@RestControllerAdvice
public class ManejadorErrores {
    private ResponseEntity<Map<String, String>> error(HttpStatus s, String msg) {
        return ResponseEntity.status(s).body(Map.of("error", msg));
    }

    @ExceptionHandler(MethodArgumentNotValidException.class)
    ResponseEntity<Map<String, String>> validacion(MethodArgumentNotValidException e) {
        return error(HttpStatus.BAD_REQUEST, e.getBindingResult().getAllErrors().get(0).getDefaultMessage());
    }

    @ExceptionHandler(IllegalArgumentException.class)
    ResponseEntity<Map<String, String>> argumento(IllegalArgumentException e) { return error(HttpStatus.BAD_REQUEST, e.getMessage()); }

    @ExceptionHandler(IllegalStateException.class)
    ResponseEntity<Map<String, String>> conflicto(IllegalStateException e) { return error(HttpStatus.CONFLICT, e.getMessage()); }

    @ExceptionHandler(BadCredentialsException.class)
    ResponseEntity<Map<String, String>> credenciales(BadCredentialsException e) { return error(HttpStatus.UNAUTHORIZED, e.getMessage()); }

    @ExceptionHandler(LockedException.class)
    ResponseEntity<Map<String, String>> bloqueada(LockedException e) { return error(HttpStatus.LOCKED, e.getMessage()); }

    @ExceptionHandler(AccesoDenegadoException.class)
    ResponseEntity<Map<String, String>> denegado(AccesoDenegadoException e) { return error(HttpStatus.FORBIDDEN, e.getMessage()); }
}
