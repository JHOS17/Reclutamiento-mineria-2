package com.mineria.reclutamiento.web;

import java.util.Map;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.oauth2.jwt.Jwt;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

/** Endpoints temporales para comprobar roles desde Postman. */
@RestController
public class PruebaControlador {
    @GetMapping("/v1/yo")
    public Map<String, String> yo(@AuthenticationPrincipal Jwt jwt) {
        return Map.of("id", jwt.getSubject(), "rol", jwt.getClaimAsString("rol"));
    }

    @GetMapping("/v1/trabajador/ping")
    public Map<String, String> trabajador() { return Map.of("mensaje", "Hola trabajador"); }

    @GetMapping("/v1/empresa/ping")
    public Map<String, String> empresa() { return Map.of("mensaje", "Hola empresa"); }

    @GetMapping("/v1/admin/ping")
    public Map<String, String> admin() { return Map.of("mensaje", "Hola administrador"); }
}
