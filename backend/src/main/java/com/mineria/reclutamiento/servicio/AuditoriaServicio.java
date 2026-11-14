package com.mineria.reclutamiento.servicio;

import java.util.UUID;

public interface AuditoriaServicio {
    void registrar(UUID usuarioId, String accion, String recurso, boolean permitido);
}
