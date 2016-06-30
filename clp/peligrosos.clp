
(defrule DetectaPeligrososPerdiendo3
    (ValorCartera (Nombre ?Nombre))

    (ValorSociedad
        (Nombre ?Nombre)
        (Perdiendo3 ?Perdiendo3)
    )

    (not (ValorPeligroso (Nombre ?Nombre)))


    (and
        (ValorInestable (Nombre ?Nombre))
        (test (eq ?Perdiendo3 true))
    )

    =>

    (assert (ValorPeligroso (Nombre ?Nombre)))
)



;;;(defrule DetectaPeligrososPerdiendo5
;;;    (ValorCartera (Nombre ?Nombre))
;;;
;;;    (ValorSociedad
;;;        (Nombre ?Nombre)
;;;        (Perdiendo5 ?Perdiendo5)
;;;        (VarSectorLower-5 ?CondicionVariacion)
;;;    )
;;;
;;;    (not (ValorPeligroso (Nombre ?Nombre)))
;;;
;;;
;;;    (and
;;;        (test (eq ?Perdiendo5 true))
;;;        (test (eq ?CondicionVariacion true))
;;;    )
;;;
;;;    =>
;;;
;;;    (assert (ValorPeligroso (Nombre ?Nombre)))
;;;)
