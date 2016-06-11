(defrule MarcaInfravalorados1
    (ValorSociedad
        (Nombre ?N)
        (EtiquetaPer Bajo)
        (EtiquetaRpd Alto)
    )
    =>
    (assert (ValorInfravalorado (Nombre ?N)))
)

(defrule MarcaInfravalorados2
    (ValorSociedad
        (Nombre ?N)
        (VarTrimestre ?VarTrimestre)
        (VarSemestre ?VarSemestre)
        (VarAnio ?VarAnio)
        (VarMes ?VarMes)
        (EtiquetaPer Bajo)
        (EtiquetaRpd Alto)
    )
    (or (test (< ?VarSemestre -0.3))
    (or (test (< ?VarTrimestre -0.3))
        (test (< ?VarAnio -0.3))))

    (test (> ?VarMes 0))
    (test (< ?VarMes 10))
    =>
    (assert (ValorInfravalorado (Nombre ?N)))
)

(defrule MarcaInfravalorados3
    (ValorSociedad
        (Nombre ?N)
        (Tamanio GRANDE)
        (VarMes ?VarMes)
        (EtiquetaPer Medio)
        (EtiquetaRpd Alto)
        (Sector ?Sector)
        (VarSector5 ?VarSector5)
    )

    (ValorSector
        (Nombre ?Sector)
    )

    (test (>= ?VarMes 0))
    (test (< ?VarMes 10))
    (test (> ?VarSector5 0))
    =>
    (assert (ValorInfravalorado (Nombre ?N)))
)
