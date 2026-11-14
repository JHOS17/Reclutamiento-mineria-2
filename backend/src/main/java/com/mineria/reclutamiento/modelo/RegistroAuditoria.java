package com.mineria.reclutamiento.modelo;

import jakarta.persistence.*;
import java.time.Instant;
import java.util.UUID;

/** Guarda inicios de sesion, registros, accesos a datos personales e intentos 403. */
@Entity
@Table(name = "auditoria")
public class RegistroAuditoria {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    private UUID usuarioId;
    private String accion;
    private String recurso;
    private boolean permitido;
    private Instant fecha = Instant.now();

    protected RegistroAuditoria() {}

    public RegistroAuditoria(UUID usuarioId, String accion, String recurso, boolean permitido) {
        this.usuarioId = usuarioId;
        this.accion = accion;
        this.recurso = recurso;
        this.permitido = permitido;
    }
}
