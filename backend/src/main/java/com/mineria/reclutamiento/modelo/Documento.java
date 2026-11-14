package com.mineria.reclutamiento.modelo;

import java.time.Instant;
import java.util.UUID;

/** Un solo original por hash SHA-256 (evita duplicados). */
public class Documento {
    private UUID id;
    private UUID propietarioId;
    private TipoDocumento tipo;
    private String nombreArchivo;
    private String sha256;
    private long tamanioBytes;
    private Instant fechaSubida;

    public Documento(UUID id, UUID propietarioId, TipoDocumento tipo, String nombreArchivo, String sha256, long tamanioBytes) {
        this.id = id;
        this.propietarioId = propietarioId;
        this.tipo = tipo;
        this.nombreArchivo = nombreArchivo;
        this.sha256 = sha256;
        this.tamanioBytes = tamanioBytes;
        this.fechaSubida = Instant.now();
    }

    public UUID getId() { return id; }
    public String getSha256() { return sha256; }
}
