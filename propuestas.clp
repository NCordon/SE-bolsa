(defrule VentaValoresPeligrosos
    (ValorSociedad
        (Nombre ?Valor)
        (VarMes ?VarValor)
        (Rpd ?Rpd)
        (Sector ?Sector)
    )

    (ValorPeligroso (Nombre ?Valor))

    (ValorSector
        (Nombre ?Sector)
        (VarMes ?VarSector)
    )

    (test (< (- ?VarValor ?VarSector) -3))
    (test (< ?ValorMes 0))
    (bind ?RE (* 20 ?Rpd))

    (printout t "La empresa " ?Nombre " es peligrosa porque ha bajado  un "
        (abs ?ValorMes)" en el último mes. Además está entrando en tendencia
        bajista respecto a su sector. Según nuestra estimación existe una
        probabilidad no despreciable de que pueda caer al cabo del año un 20%
        aunque produzca " ?Rpd " por dividendos. Perderíamos un " ?RE)
)


(defrule VentaValoresInfravalorados
    (ValorSociedad
        (Nombre ?Valor)
        (Per ?PerValor)
        (Sector ?Sector)
        (Rpd ?Rpd)
    )

    (ValorSector
        (Sector ?Sector)
        (Per ?PerMedio)
    )

    (ValorInfravalorado (Nombre ?Valor))
    (SaldoDisponible (Invertible ?Invertible))

    (test (> ?Invertible 0))
    (bind ?RE ( + (/ (* (- ?PerMedio ?Per) 100) (* 5 ?Per)) ?Rpd))

    (printout t "La empresa " ?Nombre " está infravalorada y seguramente el PER
        tienda al PER medio " ?PerMedio " en 5 años, con lo que sebería revalorizar
        un " (- ?RE ?Rpd) " más un " ?Rpd " de beneficios por dividendos")
)

;;;(defrule ObtenerValoresRentables

;;;)
