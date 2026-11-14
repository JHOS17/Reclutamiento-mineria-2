package com.mineria.reclutamiento.servicio;

import com.mineria.reclutamiento.modelo.Perfil;
import java.util.List;
import java.util.UUID;

public interface PerfilServicio {
    Perfil obtener(UUID usuarioId);
    Perfil actualizar(Perfil perfil);
    List<Perfil> filtrar(String especialidad, int minAniosExperiencia);
}
