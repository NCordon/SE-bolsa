

(defrule ImprimeMejoresOpciones
    (ImprimeMenu)

    (Propuesta
        (Tipo ?Tipo)
        (Empresa $?Empresa)
        (RE ?RE)
        (Info ?Info)
    )

    (not (PropuestaImpresa
        (Tipo ?Tipo)
        (Empresa $?Empresa)
    ))

    (not (and (Propuesta (Tipo ?Tipo2) (Empresa $?Empresa2) (RE ?RE2&:(> ?RE2 ?RE)))
         (not (PropuestaImpresa (Tipo ?Tipo2) (Empresa $?Empresa2)))))


    ?f <- (PropuestasImpresas ?NumPropuestas)
    (test (< ?NumPropuestas 5))

    =>

    (bind ?Id (+ ?NumPropuestas 1))

    (assert (PropuestaImpresa
        (Tipo ?Tipo)
        (Empresa $?Empresa)
        (NumPropuesta ?Id)
    ))

    (printout t crlf "################################################")
    (printout t crlf "Propuesta número " ?Id)
    (printout t crlf "  RE: " ?RE)
    (printout t crlf)
    (printout t crlf ?Info)
    (printout t crlf "################################################"  )
    (printout t crlf)
    (retract ?f)
    (assert (PropuestasImpresas ?Id))
)

(defrule ImprimeSaldo
    (declare (salience -75))
    (ImprimeMenu)
    (SaldoDisponible (Invertible ?Invertible))
    =>
    (printout t crlf "Saldo disponible: " ?Invertible)
)


(defrule ImprimeCartera
    (declare (salience -50))
    (ImprimeMenu)
    (ValorCartera (Nombre ?Nombre) (Acciones ?Acciones))
    =>
    (printout t crlf "Tienes " ?Acciones " acciones de " ?Nombre)
)


(defrule Menu
    (declare (salience -100))
    ?menu <- (ImprimeMenu)

    =>

    (printout t crlf)
    (printout t crlf "¿Qué opción de las listadas quieres llevar a cabo: ")
    (printout t crlf "Opción número n                              (n)")
    (printout t crlf "Actualiza cartera                            (c)")
    (printout t crlf "Abortar (no se escribe en cartera)  (otra tecla)")

    ;;;; Leemos la opcion elegida
    (printout t crlf "Introduce tu opcion: ")
    (bind ?Id (read))
    (assert (OpcionElegida ?Id))
    (retract ?menu)
)


;;; Cuando salimos del programa, se actualiza la cartera
(defrule ActualizaCabeceraCartera
    (OpcionElegida c)
    (SaldoDisponible (Invertible ?Invertible))
    =>
    (open "../data/Cartera.txt" writeCartera "w")
    (printout writeCartera "DISPONIBLE" " " ?Invertible " " ?Invertible)
    (assert (SeguirActualizandoCartera))
)


(defrule ActualizaValoresCartera
    (SeguirActualizandoCartera)
    (ValorCartera (Nombre ?Empresa) (Acciones ?NumAcciones))
    (ValorSociedad (Nombre ?Empresa) (Precio ?PrecioAccion))
    =>
    (bind ?ValorAcciones (* ?NumAcciones ?PrecioAccion))
    (printout writeCartera crlf ?Empresa " " ?NumAcciones " " ?ValorAcciones)
)

;;; Cerramos el fichero de cartera
(defrule CierraCartera
    (declare (salience -1000))
    (SeguirActualizandoCartera)
    =>
    (close writeCartera)
)


(defrule ProcesaVentaPeligroso
    (OpcionElegida ?Id)
    (not (OpcionProcesada))

    (PropuestaImpresa
        (Tipo VentaPeligrosos)
        (Empresa ?Empresa)
        (NumPropuesta ?Id))

    (Propuesta
        (Tipo VentaPeligrosos)
        (Empresa ?Empresa)
        (RE ?RE)
        (Info ?Info))

    ?Cartera <- (ValorCartera
        (Nombre ?Empresa)
        (Acciones ?NumAcciones))

    (ValorSociedad (Nombre ?Empresa) (Precio ?PrecioActual))
    ?Saldo <- (SaldoDisponible (Invertible ?Invertible))

    =>

    (modify ?Saldo (Invertible (+ ?Invertible (* ?NumAcciones ?PrecioActual))))
    (retract ?Cartera)
    (assert (OpcionProcesada))
)



(defrule ProcesaVentaSobrevalorados
    (OpcionElegida ?Id)
    (not (OpcionProcesada))

    (PropuestaImpresa
        (Tipo VentaSobrevalorados)
        (Empresa ?Empresa)
        (NumPropuesta ?Id))

    (Propuesta
        (Tipo VentaSobrevalorados)
        (Empresa ?Empresa)
        (RE ?RE)
        (Info ?Info))

    ?Cartera <- (ValorCartera
        (Nombre ?Empresa)
        (Acciones ?NumAcciones))

    (ValorSociedad (Nombre ?Empresa) (Precio ?PrecioActual))
    ?Saldo <- (SaldoDisponible (Invertible ?Invertible))

    =>

    (modify ?Saldo (Invertible (+ ?Invertible (* ?NumAcciones ?PrecioActual))))
    (retract ?Cartera)
    (assert (OpcionProcesada))
)


;;; Regla para comprar valores infravalorados cuando están en cartera
(defrule ProcesaCompraInfravalorados
    (OpcionElegida ?Id)
    (not (OpcionProcesada))

    (PropuestaImpresa
        (Tipo CompraInfravalorados)
        (Empresa ?Empresa)
        (NumPropuesta ?Id))

    (Propuesta
        (Tipo CompraInfravalorados)
        (Empresa ?Empresa)
        (RE ?RE)
        (Info ?Info))

    ?Saldo <- (SaldoDisponible (Invertible ?Invertible))

    (ValorSociedad (Nombre ?Empresa) (Precio ?PrecioActual))

    =>
    ;; Se invierte la mitad del dinero
    (bind ?NumAcciones (integer (/ (/ ?Invertible 2) ?PrecioActual)))
    (bind ?NewValorAcciones (* ?NumAcciones ?PrecioActual))
    (modify ?Saldo (Invertible (- ?Invertible ?NewValorAcciones)))
    (assert (ValorCartera
        (Nombre ?Empresa)
        (Acciones ?NumAcciones)))

    (assert (OpcionProcesada))
)


;;; Regla para cambiar acciones de una empresa por las de otra
(defrule ProcesaMayorRentabilidad
    (OpcionElegida ?Id)
    (not (OpcionProcesada))

    (PropuestaImpresa
        (Tipo MayorRentabilidad)
        (Empresa ?EmpresaActual ?EmpresaNueva)
        (NumPropuesta ?Id))

    (Propuesta
        (Tipo MayorRentabilidad)
        (Empresa ?EmpresaActual ?EmpresaNueva)
        (RE ?RE)
        (Info ?Info))


    ?f <- (ValorCartera
        (Nombre ?EmpresaActual)
        (Acciones ?NumAcciones))

    (ValorSociedad (Nombre ?EmpresaActual) (Precio ?PrecioActual))
    (ValorSociedad (Nombre ?EmpresaNueva) (Precio ?PrecioNueva))
    ?Saldo <- (SaldoDisponible (Invertible ?AntiguoSaldo))

    =>
    (bind ?Invertible (* ?NumAcciones ?PrecioActual))
    (bind ?NumAccionesNueva (integer (/ ?Invertible ?PrecioNueva)))
    (bind ?ValorAccionesNueva (* ?NumAccionesNueva ?PrecioNueva))
    (modify ?Saldo (Invertible (+ ?AntiguoSaldo (- ?Invertible ?ValorAccionesNueva))))
    (assert (ValorCartera
        (Nombre ?EmpresaNueva)
        (Acciones ?NumAccionesNueva)))

    (assert (OpcionProcesada))
    (retract ?f)
)



;;; Regla para unificar valores de cartera cuando tenemos varios paquetes de
;;; acciones de una misma empresa
(defrule UnificaCartera
    ?Cartera1 <- (ValorCartera
        (Nombre ?Empresa)
        (Acciones ?NumAcciones1))

    ?Cartera2 <- (ValorCartera
        (Nombre ?Empresa)
        (Acciones ?NumAcciones2))

    (test (neq ?Cartera1 ?Cartera2))

    =>

    (modify ?Cartera1 (Acciones (+ ?NumAcciones1 ?NumAcciones2)))
    (retract ?Cartera2)
)


;;; Limpiamos las propuestas impresas y no impresas para volver a ejecutar el
;;; módulo de cálculo de propuestas
(defrule LimpiaImpresas
    (declare (salience -900))
    (OpcionProcesada)
    ?impresa <- (PropuestaImpresa (Tipo ?))

    =>
    ;;(printout t crlf "Limpiando impresas")
    (retract ?impresa)

)


(defrule LimpiaPropuestas
    (declare (salience -900))
    (OpcionProcesada)
    ?f <- (Propuesta (Tipo ?))

    =>
    ;;(printout t crlf "Limpiando propuestas")
    (retract ?f)
)


;;; Limpiamos resto de variables, y le decimos al módulo de cálculo de propuestas
;;; que se ejecute
(defrule ReiniciaCalculoPropuestas
    (declare (salience -1000))
    ?elegida <- (OpcionElegida ?Id)
    ?procesada <- (OpcionProcesada)
    ?nimpresas <- (PropuestasImpresas ?)

    =>

    ;;(printout t crlf "Limpiando todo lo demás")
    (retract ?elegida)
    (retract ?procesada)
    (retract ?nimpresas)
    (assert (GestionPropuestas))
)
