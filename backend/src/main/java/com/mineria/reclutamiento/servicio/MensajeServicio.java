package com.mineria.reclutamiento.servicio;

import com.mineria.reclutamiento.modelo.Mensaje;
import java.util.UUID;

public interface MensajeServicio {
    Mensaje enviar(String claveIdempotencia, UUID postulacionId, UUID remitenteId, String contenido);
}
