package com.mineria.reclutamiento.modelo;

import java.time.Instant;
import java.util.UUID;

public class Mensaje {
    private UUID id;
    private UUID postulacionId;
    private UUID remitenteId;
    private String contenido;
    private Instant fecha;

    public Mensaje(UUID id, UUID postulacionId, UUID remitenteId, String contenido) {
        this.id = id;
        this.postulacionId = postulacionId;
        this.remitenteId = remitenteId;
        this.contenido = contenido;
        this.fecha = Instant.now();
    }

    public UUID getId() { return id; }
}
