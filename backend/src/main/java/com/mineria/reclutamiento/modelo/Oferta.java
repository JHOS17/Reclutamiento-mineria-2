package com.mineria.reclutamiento.modelo;

import java.time.Instant;
import java.util.UUID;

/** Fechas en UTC (ISO 8601), moneda ISO 4217. */
public class Oferta {
    private UUID id;
    private UUID empresaId;
    private String titulo;
    private String descripcion;
    private String especialidadRequerida;
    private double salario;
    private String moneda;
    private EstadoOferta estado;
    private Instant fechaPublicacion;

    public Oferta(UUID id, UUID empresaId, String titulo) {
        this.id = id;
        this.empresaId = empresaId;
        this.titulo = titulo;
        this.estado = EstadoOferta.ABIERTA;
        this.fechaPublicacion = Instant.now();
    }

    public UUID getId() { return id; }
    public UUID getEmpresaId() { return empresaId; }
    public String getTitulo() { return titulo; }
    public EstadoOferta getEstado() { return estado; }
    public Instant getFechaPublicacion() { return fechaPublicacion; }
}
