package com.mineria.reclutamiento.servicio;

import com.mineria.reclutamiento.modelo.Documento;
import com.mineria.reclutamiento.modelo.TipoDocumento;
import java.util.UUID;

public interface DocumentoServicio {
    Documento subir(UUID propietarioId, TipoDocumento tipo, String nombre, byte[] contenido); // max 10 MB
    String calcularSha256(byte[] contenido);
    boolean existeDuplicado(String sha256);
}
