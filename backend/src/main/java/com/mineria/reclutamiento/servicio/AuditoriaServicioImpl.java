package com.mineria.reclutamiento.servicio;

import com.mineria.reclutamiento.modelo.RegistroAuditoria;
import com.mineria.reclutamiento.repositorio.AuditoriaRepositorio;
import java.util.UUID;
import org.springframework.stereotype.Service;

@Service
public class AuditoriaServicioImpl implements AuditoriaServicio {
    private final AuditoriaRepositorio repo;

    public AuditoriaServicioImpl(AuditoriaRepositorio repo) { this.repo = repo; }

    @Override
    public void registrar(UUID usuarioId, String accion, String recurso, boolean permitido) {
        repo.save(new RegistroAuditoria(usuarioId, accion, recurso, permitido));
    }
}
