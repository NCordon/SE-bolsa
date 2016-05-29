;; Ignacio Cordón

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Ejercicio 9: Calculo maximo slots
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(
deftemplate TTT
    (field SSS (type INTEGER))
)

(
deffacts Slots
    (TTT (SSS 45))
    (TTT (SSS 50))
    (TTT (SSS -1))
)


;; Si hay una instancia de TTT para la que no exista otra cuyo valor
;; de SSS sea superior, su valor de SSS es el mayor.
(
defrule CalculaMaximo
    (TTT (SSS ?v1))
    (not
        (exists (TTT (SSS ?v2 & ~?v1))
                (test (> ?v2 ?v1))
        )
    )
    =>
    (printout t "El mayor valor de SSS es " ?v1 crlf)
)
