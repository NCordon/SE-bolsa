
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Lectura de valores al cierre y cálculo de datos deducidos
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
        (bind ?VarSectorGreater-5 (read acciones))
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
            (VarSectorGreater-5 ?VarSectorGreater-5)
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
;;; Lectura de noticias
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defrule OpenNoticias
    =>
    (open "../data/Noticias.txt" noticias "r+")
    (assert (SeguirLeyendoNoticias))
)

(defrule ReadNoticia
    ?f <- (SeguirLeyendoNoticias)
    =>
    (retract ?f)
    (bind ?Nombre (read noticias))

    (if (neq ?Nombre EOF) then
        (bind ?Calificacion (read noticias))
        (bind ?Antiguedad (read noticias))

        (assert (Noticia
            (Nombre ?Nombre)
            (Calificacion ?Calificacion)
            (Antiguedad ?Antiguedad)
        ))
        (assert (SeguirLeyendoNoticias))
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
        (Nombre ?Nombre)
        (Sector Construccion)
    )

    =>

    (assert (ValorInestable (Nombre ?Nombre)))
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
        (Nombre ?Nombre)
        (Sector Servicios)
    )

    (EconomiaBajando)

    =>

    (assert (ValorInestable (Nombre ?Nombre)))

)


(defrule DesmarcaInestablesNoticias

    (ValorSociedad
        (Nombre ?Nombre)
        (Sector ?Sector)
    )

    ?f <- (ValorInestable (Nombre ?Nombre))

    (or
        (Noticia (Nombre ?Nombre) (Calificacion Buena) (Antiguedad ?Antiguedad))
        (Noticia (Nombre ?Sector) (Calificacion Buena) (Antiguedad ?Antiguedad))
    )

    (test (<= ?Antiguedad 2))

    =>

    (assert (ValorInestable (Nombre ?Nombre)))
    (retract ?f)
)


(defrule MarcaInestablesNoticias

    (ValorSociedad
        (Nombre ?Nombre)
        (Sector ?Sector)
    )

    (or
        (Noticia (Nombre ?Nombre) (Calificacion Mala) (Antiguedad ?Antiguedad))
        (Noticia (Nombre ?Sector) (Calificacion Mala) (Antiguedad ?Antiguedad))
        (Noticia (Nombre General) (Calificacion Mala) (Antiguedad ?Antiguedad))
    )

    (test (<= ?Antiguedad 2))

    =>

    (assert (ValorInestable (Nombre ?Nombre)))
)
