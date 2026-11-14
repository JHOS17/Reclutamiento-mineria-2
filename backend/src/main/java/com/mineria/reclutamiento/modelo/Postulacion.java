package com.mineria.reclutamiento.modelo;

import java.time.Instant;
import java.util.UUID;

public class Postulacion {
    private UUID id;
    private UUID ofertaId;
    private UUID trabajadorId;
    private UUID documentoCvId;
    private EstadoPostulacion estado;
    private Instant fecha;

    public Postulacion(UUID id, UUID ofertaId, UUID trabajadorId, UUID documentoCvId) {
        this.id = id;
        this.ofertaId = ofertaId;
        this.trabajadorId = trabajadorId;
        this.documentoCvId = documentoCvId;
        this.estado = EstadoPostulacion.ENVIADA;
        this.fecha = Instant.now();
    }

    public UUID getId() { return id; }
    public UUID getOfertaId() { return ofertaId; }
    public UUID getTrabajadorId() { return trabajadorId; }
    public EstadoPostulacion getEstado() { return estado; }
    public void setEstado(EstadoPostulacion estado) { this.estado = estado; }
}
