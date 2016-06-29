(defrule MarcaSobreValorados1
    (ValorSociedad
        (Nombre ?Nombre)
        (EtiquetaPer Alto)
        (EtiquetaRpd Bajo)
    )
    (not (ValorSobrevalorado (Nombre ?Nombre)))
    =>
    (assert (ValorSobrevalorado (Nombre ?Nombre)))
)

(defrule MarcaSobrevalorados2
    (or (ValorSociedad
            (Nombre ?Nombre)
            (Tamanio PEQUENIA)
            (EtiquetaPer Alto)
        )
        (ValorSociedad
            (Nombre ?Nombre)
            (Tamanio PEQUENIA)
            (EtiquetaPer Medio)
            (EtiquetaRpd Bajo)
        )
    )
    (not (ValorSobrevalorado (Nombre ?Nombre)))
    =>
    (assert (ValorSobrevalorado (Nombre ?Nombre)))
)

(defrule MarcaSobrevalorados3
    (or (ValorSociedad
            (Nombre ?Nombre)
            (Tamanio GRANDE)
            (EtiquetaRpd Bajo)
            (EtiquetaPer Alto)
        )
        (ValorSociedad
            (Nombre ?Nombre)
            (Tamanio GRANDE)
            (EtiquetaRpd Bajo)
            (EtiquetaPer Medio)
        )
        (ValorSociedad
            (Nombre ?Nombre)
            (Tamanio GRANDE)
            (EtiquetaRpd Medio)
            (EtiquetaPer Alto)
        )
    )
    (not (ValorSobrevalorado (Nombre ?Nombre)))
    =>
    (assert (ValorSobrevalorado (Nombre ?Nombre)))
)
