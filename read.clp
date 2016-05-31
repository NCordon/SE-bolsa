;;; Template para valores de las acciones al cierre de mercados

(deftemplate ValorSociedad
    (field Nombre)
    (field Precio)
    (field Variacion)
    (field Capitalizacion)
    (field Per)
    (field Rpd)
    (field Tamanio)
    (field PorcentajeIbex)
    (field EtiquetaPer)
    (field EtiquetaRpd)
    (field Sector)
    (field VarPrecio5)
    (field Perdiendo3)
    (field Perdiendo5)
    (field VarSector5)
    (field VarSectorLower-5)
    (field VarMes)
    (field VarTrimestre)
    (field VarSemestre)
    (field VarAnio)
)

;;; Template para valores del estado de los sectores

(deftemplate ValorSector
    (field Nombre)
    (field Variacion)
    (field Capitalizacion)
    (field Per)
    (field Rpd)
    (field Tamanio)
    (field VarPrecio5)
    (field Perdiendo3)
    (field Perdiendo5)
    (field VarMes)
    (field VarTrimestre)
    (field VarSemestre)
    (field VarAnio)
)


;;; Template para valores inestables

(deftemplate ValorInestable
    (field Nombre)
)

(defrule OpenAcciones
    (declare (salience 100))
    =>
    (open "Analisis.txt" acciones "r+")
    (assert (SeguirLeyendoAcciones))
)


(defrule ReadValorSociedad
    ?f <- (SeguirLeyendoAcciones)
    =>
    (retract ?f)
    (bind ?Nombre (read acciones))

    (if (neq ?Nombre EOF) then
        (bind ?Precio (read acciones))
        (bind ?Variacion (read acciones))
        (bind ?Capitalizacion (read acciones))
        (bind ?Per (read acciones))
        (bind ?Rpd (read acciones))
        (bind ?Tamanio (read acciones))
        (bind ?PorcentajeIbex (read acciones))
        (bind ?EtiquetaPer (read acciones))
        (bind ?EtiquetaRpd (read acciones))
        (bind ?Sector (read acciones))
        (bind ?VarPrecio5 (read acciones))
        (bind ?Perdiendo3 (read acciones))
        (bind ?Perdiendo5 (read acciones))
        (bind ?VarSector5 (read acciones))
        (bind ?VarSectorLower-5 (read acciones))
        (bind ?VarMes (read acciones))
        (bind ?VarTrimestre (read acciones))
        (bind ?VarSemestre (read acciones))
        (bind ?VarAnio (read acciones))

        (assert (ValorSociedad
            (Nombre ?Nombre)
            (Precio ?Precio)
            (Variacion ?Variacion)
            (Capitalizacion ?Capitalizacion)
            (Per ?Per)
            (Rpd ?Rpd)
            (Tamanio ?Tamanio)
            (PorcentajeIbex ?PorcentajeIbex)
            (EtiquetaPer ?EtiquetaPer)
            (EtiquetaRpd ?EtiquetaRpd)
            (Sector ?Sector)
            (VarPrecio5 ?VarPrecio5)
            (Perdiendo3 ?Perdiendo3)
            (Perdiendo5 ?Perdiendo5)
            (VarSector5 ?VarSector5)
            (VarSectorLower-5 ?VarSectorLower-5)
            (VarMes ?VarMes)
            (VarTrimestre ?VarTrimestre)
            (VarSemestre ?VarSemestre)
            (VarAnio ?VarAnio)
        ))
        (assert (SeguirLeyendoAcciones))
    )

)


;;; Leer los valores de sectores

(defrule OpenSectores
    (declare (salience 100))
    =>
    (open "AnalisisSectores.txt" sectores "r+")
    (assert (SeguirLeyendoSectores))
)

;;;

(defrule ReadValorSectores
    ?f <- (SeguirLeyendoSectores)
    =>
    (retract ?f)
    (bind ?Nombre (read sectores))

    (if (neq ?Nombre EOF) then
        (bind ?Variacion (read sectores))
        (bind ?Capitalizacion (read sectores))
        (bind ?Per (read sectores))
        (bind ?Rpd (read sectores))
        (bind ?Tamanio (read sectores))
        (bind ?VarPrecio5 (read sectores))
        (bind ?Perdiendo3 (read sectores))
        (bind ?Perdiendo5 (read sectores))
        (bind ?VarMes (read sectores))
        (bind ?VarTrimestre (read sectores))
        (bind ?VarSemestre (read sectores))
        (bind ?VarAnio (read sectores))

        (assert (ValorSector
            (Nombre ?Nombre)
            (Variacion ?Variacion)
            (Capitalizacion ?Capitalizacion)
            (Per ?Per)
            (Rpd ?Rpd)
            (Tamanio ?Tamanio)
            (VarPrecio5 ?VarPrecio5)
            (Perdiendo3 ?Perdiendo3)
            (Perdiendo5 ?Perdiendo5)
            (VarMes ?VarMes)
            (VarTrimestre ?VarTrimestre)
            (VarSemestre ?VarSemestre)
            (VarAnio ?VarAnio)
        ))
        (assert (SeguirLeyendoSectores))
    )
)


;;; Deducción de valores inestables

(defrule MarcaInestablesConstruccion
    (ValorSociedad
        (Nombre ?N)
        (Sector Construccion)
    )

    =>

    (assert (ValorInestable (Nombre ?N)))
)

(defrule VerdadEconomiaBajando
    (ValorSector
        (Nombre Ibex)
        (Variacion ?Variacion)
    )

    (test (< ?Variacion 0))

    =>

    (assert (EconomiaBajando))
)

(defrule MarcaInestablesServicios
    (ValorSociedad
        (Nombre ?N)
        (Sector Servicios)
    )

    (EconomiaBajando)
    =>

    (assert (ValorInestable (Nombre ?N)))

)
