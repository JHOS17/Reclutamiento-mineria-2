package com.mineria.reclutamiento.repositorio;

import com.mineria.reclutamiento.modelo.RegistroAuditoria;
import java.util.Optional;
import java.util.UUID;
import org.springframework.data.jpa.repository.JpaRepository;

public interface AuditoriaRepositorio extends JpaRepository<RegistroAuditoria, Long> {
}
