

(defrule ImprimeMejoresOpciones
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

    (not (and (Propuesta (Tipo ?Tipo) (Empresa $?Empresa2) (RE ?RE2&:(> ?RE2 ?RE)))
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
    (printout t crlf "El rendimiento esperado de esta propuesta es " ?RE)
    (printout t crlf "################################################"  )
    (printout t crlf ?Info)
    (printout t crlf)
    (retract ?f)
    (assert (PropuestasImpresas ?Id))
)


(defrule Menu
      (ImprimeMenu ?)
      =>
      (printout t crlf "¿Qué opción de las listadas quieres llevar a cabo: ")
      (printout t crlf "Primera opcion      (1)")
      (printout t crlf "Segunda opcion      (2)")
      (printout t crlf "Tercera opcion      (3)")
      (printout t crlf "Cuarta opcion       (4)")
      (printout t crlf "Quinta opcion       (5)")
      (printout t crlf "Ninguna    (otra tecla)")

      ;;;; Leemos la opcion elegida
      (printout t crlf "Introduce tu opcion: ")
      (bind ?Id (read))
      (assert (OpcionElegida ?Id))
      (assert (EntradaIncorrecta ?Id))
)


(defrule ProcesaPeligrosos
    ;;;; Si queremos seguir escogiendo, se vuelve a imprimir el menu
    (OpcionElegida ?Id)

    (Propuesta
        (Tipo VentaPeligrosos)
        (Empresa ?Empresa)
        (RE ?RE)
        (Info ?Info)
        (Impresa SI))
    =>
    (if (eq ?Tipo MayorRentabilidad) then
        (PropuestaImpresa
            (Empresa ?Empresa1 ?Empresa2)
            (NumPropuesta ?Id))
    else
        (PropuestaImpresa
            (Empresa ?Empresa)
            (NumPropuesta ?Id))
    )


    (swith ?Tipo
        (case VentaPeligrosos then
            ?ValCartera <- (ValorCartera
                    (Nombre ?Empresa)
                    (Acciones ?NumAcciones))
            (ValorSociedad (Nombre ?Empresa) (Precio ?PrecioActual))

            ?Saldo <- (SaldoDisponible (Disponible ?Disponible))
            (modify (?Saldo (+ ?Disponible (* ?NumAcciones ?PrecioActual))))
            (retract ?ValCartera)

        ;;(case CompraInfravalorados)
        ;;(case VentaSobrevalorados)
        ;;(case MayorRentabilidad)
        )
    )
)
