package com.mineria.reclutamiento.servicio;

import java.io.InputStream;

public interface ImportacionServicio {
    int importarOfertas(InputStream archivo, String formato); // CSV o JSON
    int importarPerfiles(InputStream archivo, String formato);
}
