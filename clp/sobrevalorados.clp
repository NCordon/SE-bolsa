(defrule MarcaSobreValorados1
    (ValorSociedad
        (Nombre ?N)
        (EtiquetaPer Alto)
        (EtiquetaRpd Bajo)
    )
    =>
    (assert (ValorSobrevalorado (Nombre ?N)))
)

(defrule MarcaSobrevalorados2
    (or (ValorSociedad
            (Nombre ?N)
            (Tamanio PEQUENIA)
            (EtiquetaPer Alto)
        )
        (ValorSociedad
            (Nombre ?N)
            (Tamanio PEQUENIA)
            (EtiquetaRpd Medio)
            (EtiquetaPer Alto)
        )
    )
    =>
    (assert (ValorSobrevalorado (Nombre ?N)))
)

(defrule MarcaSobrevalorados3
    (or (ValorSociedad
            (Nombre ?N)
            (Tamanio GRANDE)
            (EtiquetaRpd Bajo)
            (EtiquetaPer Alto)
        )
        (ValorSociedad
            (Nombre ?N)
            (Tamanio GRANDE)
            (EtiquetaRpd Medio)
            (EtiquetaPer Alto)
        )
    )
    =>
    (assert (ValorSobrevalorado (Nombre ?N)))
)
