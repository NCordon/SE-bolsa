
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Lectura de valores al cierre
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defrule OpenAcciones
    =>
    (open "../data/Analisis.txt" acciones "r+")
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
        (bind ?VarSemana (read acciones))
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
            (VarSemana ?VarSemana)
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

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Lectura de valores de sectores
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defrule OpenSectores
    =>
    (open "../data/AnalisisSectores.txt" sectores "r+")
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
        (bind ?VarSemana (read sectores))
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
            (VarSemana ?VarSemana)
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


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Lectura de valores de sectores
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defrule OpenCartera
    =>
    (open "../data/Cartera.txt" cartera "r+")
    (assert (LeerDisponibleCartera))
)



(defrule LeerCabeceraCartera
    ?f <- (LeerDisponibleCartera)
    =>
    (retract ?f)
    (read cartera)
    (bind ?Invertible (read cartera))
    (read cartera)

    (assert (SaldoDisponible (Invertible ?Invertible)))
    (assert (SeguirLeyendoCartera))
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Lectura de cartera de valores
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defrule ReadCartera
    ?f <- (SeguirLeyendoCartera)
    =>
    (retract ?f)
    (bind ?Nombre (read cartera))

    (if (neq ?Nombre EOF) then
        (bind ?Acciones (read cartera))
        (read cartera)

        (assert (ValorCartera
            (Nombre ?Nombre)
            (Acciones ?Acciones)
            ;;(ValorAnterior ?ValorAnterior)
        ))
        (assert (SeguirLeyendoCartera))
    )
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Deducción de valores inestables
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

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
        (VarSemana ?VarSemana)
    )

    (test (< ?VarSemana 0))

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
