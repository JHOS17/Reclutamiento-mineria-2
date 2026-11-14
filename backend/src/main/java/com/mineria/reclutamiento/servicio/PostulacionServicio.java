package com.mineria.reclutamiento.servicio;

import com.mineria.reclutamiento.modelo.EstadoPostulacion;
import com.mineria.reclutamiento.modelo.Postulacion;
import java.util.List;
import java.util.UUID;

public interface PostulacionServicio {
    Postulacion postular(String claveIdempotencia, UUID ofertaId, UUID trabajadorId, UUID cvId);
    Postulacion cambiarEstado(String claveIdempotencia, UUID postulacionId, EstadoPostulacion nuevoEstado);
    List<Postulacion> listarPorOferta(UUID ofertaId);
}
