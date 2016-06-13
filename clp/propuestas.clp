(defrule VentaValoresPeligrosos
    (ValorSociedad
        (Nombre ?Valor)
        (VarMes ?VarMes)
        (Rpd ?Rpd)
        (Sector ?Sector)
    )

    (ValorCartera
        (Nombre ?Valor)
    )

    (ValorPeligroso (Nombre ?Valor))

    (ValorSector
        (Nombre ?Sector)
        (VarMes ?VarSector)
    )

    (test (< (- ?VarMes ?VarSector) -3))
    (test (< ?VarMes 0))

    =>

    (bind ?RE (* 20 ?Rpd))
    (bind ?InfoPropuesta (str-cat "La empresa " ?Valor " es peligrosa porque ha bajado  un "
        (abs ?VarMes)" en el último mes. Además está entrando en tendencia
        bajista respecto a su sector. Según nuestra estimación existe una
        probabilidad no despreciable de que pueda caer al cabo del año un 20%
        aunque produzca " ?Rpd " por dividendos. Perderíamos un " ?RE)
    )

    (assert (Propuesta
        (Tipo VentaPeligrosos)
        (Empresa ?Valor)
        (RE ?RE)
        (Info ?InfoPropuesta)
    ))
)



(defrule CompraValoresInfravalorados
    (ValorSociedad
        (Nombre ?Valor)
        (Per ?PerValor)
        (Sector ?Sector)
        (Rpd ?Rpd)
    )

    (ValorSector
        (Nombre ?Sector)
        (Per ?PerMedio)
    )

    (ValorInfravalorado (Nombre ?Valor))
    (SaldoDisponible (Invertible ?Invertible))

    (test (> ?Invertible 0))

    =>

    (bind ?Revalorizable (/ (* (- ?PerMedio ?PerValor) 100) (* 5 ?PerValor)))
    (bind ?RE (+ ?Revalorizable ?Rpd))
    (bind ?InfoPropuesta (str-cat "La empresa " ?Valor " está infravalorada y seguramente el PER
        tienda al PER medio " ?PerMedio " en 5 años, con lo que sebería revalorizar
        un " ?Revalorizable " a lo que habría que suma un " ?Rpd " de beneficios
        por dividendos")
    )

    (assert (Propuesta
        (Tipo CompraInfravalorados)
        (Empresa ?Valor)
        (RE ?RE)
        (Info ?InfoPropuesta)
    ))
)



(defrule VentaValoresSobrevalorados
    (ValorSociedad
        (Nombre ?Valor)
        (Per ?PerValor)
        (Sector ?Sector)
        (Rpd ?Rpd)
    )

    (ValorCartera
        (Nombre ?Valor)
    )

    (ValorSector
        (Nombre ?Sector)
        (Per ?PerMedio)
    )

    (ValorSobrevalorado (Nombre ?Valor))

    =>

    (bind ?Devaluable (/ (* (- ?PerValor ?PerMedio ) 100) (* 5 ?PerValor)))
    (bind ?RE ( - ?Devaluable ?Rpd))
    (bind ?InfoPropuesta (str-cat "La empresa " ?Valor " está sobrevalorada, ya que seguramente el
        PER tan alto deberá bajar al PER medio del sector en unos 5 años, con lo
        que se debería devaluar un" ?Devaluable "anual, así que aunque se pierda
        el" ?Rpd " de beneficios por dividendos, saldría rentable")
    )

    (assert (Propuesta
        (Tipo VentaSobrevalorados)
        (Empresa ?Valor)
        (RE ?RE)
        (Info ?InfoPropuesta)
    ))
)



(defrule BuscarMayorRentabilidad
    (ValorSociedad
        (Nombre ?Empresa1)
        (Per ?PerEmpresa1)
        (Sector ?Sector1)
        (Rpd ?Rpd1)
    )

    (ValorCartera
        (Nombre ?Empresa2)
    )

    (ValorSociedad
        (Nombre ?Empresa2)
        (Per ?PerEmpresa2)
        (Sector ?Sector2)
        (Rpd ?Rpd2)
    )

    (not (ValorInfravalorado (Nombre ?Empresa2)))
    (not (ValorSobrevalorado (Nombre ?Empresa1)))

    =>

    (bind ?RE ( - ?Rpd1 (+ ?Rpd2  1)))

    ;;; REVISAR
    (bind ?InfoPropuesta (str-cat  ?Empresa1 "debe tener una revalorización acorde
        con la evolución de la bolsa. Por dividendos se espera un " ?RE "%, que
        es más de lo que está dandole " ?Empresa2 ", por eso propongo cambiar los
        valores por los de esta otra. Aunque se pague el 1% del coste del cambio,
        te saldría rentable")
    )

    (assert (Propuesta
        (Tipo MayorRentabilidad)
        (Empresa ?Empresa1 ?Empresa2)
        (RE ?RE)
        (Info ?InfoPropuesta)
    ))
)
