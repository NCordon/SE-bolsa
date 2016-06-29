(defrule MarcaInfravalorados1
    (ValorSociedad
        (Nombre ?Nombre)
        (EtiquetaPer Bajo)
        (EtiquetaRpd Alto)
    )
    =>
    (assert (ValorInfravalorado (Nombre ?Nombre)))
)

(defrule MarcaInfravalorados2
    (ValorSociedad
        (Nombre ?Nombre)
        (VarTrimestre ?VarTrimestre)
        (VarSemestre ?VarSemestre)
        (VarAnio ?VarAnio)
        (VarMes ?VarMes)
        (EtiquetaPer Bajo)
    )
    (or (test (< ?VarSemestre -30))
        (test (< ?VarTrimestre -30))
        (test (< ?VarAnio -0.3)))

    (test (> ?VarMes 0))
    (test (< ?VarMes 10))
    =>
    (assert (ValorInfravalorado (Nombre ?Nombre)))
)

(defrule MarcaInfravalorados3
    (ValorSociedad
        (Nombre ?Nombre)
        (Tamanio GRANDE)
        (VarMes ?VarMes)
        (EtiquetaPer Medio)
        (EtiquetaRpd Alto)
        (VarSector5 ?VarSector5)
    )

    ;;; No está bajando
    (test (>= ?VarMes 0))
    ;;; Se comporta mejor que su sector
    (test (> ?VarSector5 0))
    =>
    (assert (ValorInfravalorado (Nombre ?Nombre)))
)
