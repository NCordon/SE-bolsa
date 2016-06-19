

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
    (printout t crlf ?Tipo)
    (bind ?Id (+ ?NumPropuestas 1))

    (assert (PropuestaImpresa
        (Tipo ?Tipo)
        (Empresa $?Empresa)
        (NumPropuesta ?Id)
    ))

    (printout t crlf "################################################")
    (printout t crlf "Propuesta número " ?Id)
    (printout t crlf "El rendimiento esperado de esta propuesta es " ?RE)
    (printout t crlf "################################################"  )
    (printout t crlf ?Info)
    (printout t crlf)
    (retract ?f)
    (assert (PropuestasImpresas ?Id))
)


(defrule Menu
    (declare (salience -100))
    (ImprimeMenu)

    =>

    (printout t crlf "¿Qué opción de las listadas quieres llevar a cabo: ")
    (printout t crlf "Opción número x"                      (x)")
    (printout t crlf "Ninguna(fin del programa)    (otra tecla)")

    ;;;; Leemos la opcion elegida
    (printout t crlf "Introduce tu opcion: ")
    (bind ?Id (read))
    (assert (OpcionElegida ?Id))
)


(defrule ProcesaVentaPeligrosos
    (OpcionElegida ?Id)

    (PropuestaImpresa
        (Tipo VentaPeligrosos)
        (Empresa ?Empresa)
        (NumPropuesta ?Id))

    (Propuesta
        (Tipo VentaPeligrosos)
        (Empresa ?Empresa)
        (RE ?RE)
        (Info ?Info))

    ?ValCartera <- (ValorCartera
        (Nombre ?Empresa)
        (Acciones ?NumAcciones))

    (ValorSociedad (Nombre ?Empresa) (Precio ?PrecioActual))
    ?Saldo <- (SaldoDisponible (Invertible ?Invertible))

    =>

    (modify ?Saldo (Invertible (+ ?Invertible (* ?NumAcciones ?PrecioActual))))
    (retract ?ValCartera)
    (assert (OpcionProcesada))
)



(defrule ProcesaVentaSobrevalorados
    (OpcionElegida ?Id)

    (PropuestaImpresa
        (Tipo VentaSobrevalorados)
        (Empresa ?Empresa)
        (NumPropuesta ?Id))

    (Propuesta
        (Tipo VentaSobrevalorados)
        (Empresa ?Empresa)
        (RE ?RE)
        (Info ?Info))

    ?ValCartera <- (ValorCartera
        (Nombre ?Empresa)
        (Acciones ?NumAcciones))

    (ValorSociedad (Nombre ?Empresa) (Precio ?PrecioActual))
    ?Saldo <- (SaldoDisponible (Invertible ?Invertible))

    =>

    (modify ?Saldo (Invertible (+ ?Invertible (* ?NumAcciones ?PrecioActual))))
    (retract ?ValCartera)
    (assert (OpcionProcesada))
)


;;; Regla para comprar valores infravalorados cuando están en cartera
(defrule ProcesaCompraInfravaloradosFueraCartera
    (OpcionElegida ?Id)

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
    (not (ValorCartera (Nombre ?Empresa)))
    (ValorSociedad (Nombre ?Empresa) (Precio ?PrecioActual))
    ?Saldo <- (SaldoDisponible (Invertible ?Invertible))

    =>
    (bind ?NumAcciones (/ ?Invertible ?PrecioActual))
    (modify ?Saldo (Invertible (- ?Invertible (* ?NumAcciones ?PrecioActual))))
    (assert ValorCartera
        (Nombre ?Empresa)
        (Acciones ?NumAcciones)
        (ValorAnterior ?PrecioActual))
    (assert (OpcionProcesada))
)



;;; Regla para comprar valores infravalorados cuando no están en cartera
(defrule ProcesaCompraInfravaloradosDentroCartera
    (OpcionElegida ?Id)

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
    ?Cartera <- (ValorCartera (Nombre ?Empresa))
    (ValorSociedad (Nombre ?Empresa) (Precio ?PrecioActual))
    ?Saldo <- (SaldoDisponible (Invertible ?Invertible))

    =>
    (bind ?NumAcciones (/ ?Invertible ?PrecioActual))
    (modify ?Saldo (Invertible (- ?Invertible (* ?NumAcciones ?PrecioActual))))
    (modify ?Cartera
        (Nombre ?Empresa)
        (Acciones ?NumAcciones)
        (ValorAnterior ?PrecioActual))
    (assert (OpcionProcesada))
)

;;; Limpiamos las propuestas impresas y no impresas para volver a ejecutar el
;;; módulo de cálculo de propuestas
(defrule LimpiaImpresas
    (OpcionProcesada)
    ?impresa <- (PropuestaImpresa (Tipo ?))

    =>
    (printout t crlf "Limpiando impresas")
    (retract ?impresa)

)


(defrule LimpiaPropuestas
    (OpcionProcesada)
    ?f <- (Propuesta (Tipo ?))

    =>
    (printout t crlf "Limpiando propuestas")
    (retract ?f)
)


;;; Limpiamos resto de variables, y le decimos al módulo de cálculo de propuestas
;;; que se ejecute
(defrule ReiniciaCalculoPropuestas
    (declare (salience -1000))
    ?elegida <- (OpcionElegida ?Id)
    ?procesada <- (OpcionProcesada)
    ?menu <- (ImprimeMenu)
    ?nimpresas <- (PropuestasImpresas ?)

    =>

    (printout t crlf "Limpiando todo lo demás")
    (retract ?elegida)
    (retract ?procesada)
    (retract ?menu)
    (retract ?nimpresas)
    (assert (GestionPropuestas))
)
