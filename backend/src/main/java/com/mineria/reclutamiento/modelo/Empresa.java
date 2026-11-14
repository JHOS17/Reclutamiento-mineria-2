package com.mineria.reclutamiento.modelo;

import jakarta.persistence.*;
import java.util.UUID;

@Entity
@Table(name = "empresas")
public class Empresa {
    @Id
    private UUID id;
    private UUID usuarioId;
    private String razonSocial;
    private String pais;

    protected Empresa() {}

    public Empresa(UUID id, UUID usuarioId, String razonSocial, String pais) {
        this.id = id;
        this.usuarioId = usuarioId;
        this.razonSocial = razonSocial;
        this.pais = pais;
    }

    public UUID getId() { return id; }
    public UUID getUsuarioId() { return usuarioId; }
    public String getRazonSocial() { return razonSocial; }
    public String getPais() { return pais; }
}
