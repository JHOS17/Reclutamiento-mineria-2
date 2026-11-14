package com.mineria.reclutamiento.servicio;

import com.mineria.reclutamiento.modelo.Oferta;
import java.util.List;
import java.util.UUID;

public interface OfertaServicio {
    Oferta publicar(Oferta oferta);
    List<Oferta> buscar(String especialidad, String pais);
    void cerrar(UUID ofertaId);
    void archivarAntiguas(); // ofertas con mas de 6 meses
}
