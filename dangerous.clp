
(defrule DetectaPeligrosos
    (ValorCartera (Nombre ?Nombre))

    (ValorSociedad
        (Nombre ?Nombre)
        (Perdiendo3 ?Perdiendo3)
        (Perdiendo5 ?Perdiendo5)
        (VarSectorLower-5 ?CondicionVariacion)
    )



    (or
        (and
            (ValorInestable (Nombre ?Nombre))
            (test (eq ?Perdiendo3 true))
        )
        (and
            (test (eq ?Perdiendo5 true))
            (test (eq ?CondicionVariacion true))
        )
    )
    =>

    (assert (ValorPeligroso (Nombre ?Nombre)))
)
