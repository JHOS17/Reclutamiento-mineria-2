package com.mineria.reclutamiento.repositorio;

import com.mineria.reclutamiento.modelo.Perfil;
import java.util.Optional;
import java.util.UUID;
import org.springframework.data.jpa.repository.JpaRepository;

public interface PerfilRepositorio extends JpaRepository<Perfil, UUID> {
}
