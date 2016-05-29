;; Ignacio Cordón

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Ejercicio 2: Menu con multiples opciones
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(
deffacts Hechos
    (ImprimeMenu 1)
)

(
defrule Menu
    (ImprimeMenu ?)
    =>
    (printout t crlf "Elige alguna de las siguientes opciones: ")
    (printout t crlf "Primera opcion (1)")
    (printout t crlf "Segunda opcion (2)")
    (printout t crlf "Tercera opcion (3)")
    (printout t crlf "Cuarta opcion  (4)")
    (printout t crlf "Quinta opcion  (5)")
    (printout t crlf "Sexta opcion   (6)")
    (printout t crlf "Septima opcion (7)")
    (printout t crlf "Octava opcion  (8)")

    ;;;; Leemos la opcion elegida
    (printout t crlf "Introduce tu opcion: ")
    (bind ?cod (read))

    (assert (Elegido ?cod))
    (assert (EntradaIncorrecta ?cod))
)

(
defrule CheckEleccion
    ;;;; Comprobamos si la entrada del menu es correcta
    (Elegido ?cod)
    (test (>= ?cod 1))
    (test (<= ?cod 8))
    ?Borrar <- (EntradaIncorrecta ?cod)
    =>
    ;;;; Caso afirmativo, lo indicamos
    (retract ?Borrar)
)

(
defrule EntradaIncorrecta
    ;;;; Si la entrada del menu escogida no era correcta, lo marcamos e
    ;;;; imprimimos el menu para corregirla
    ?ClearIncorrecta <- (EntradaIncorrecta ?cod)
    ?ClearCod <- (Elegido ?cod)
    ?ClearMenu <- (ImprimeMenu ?num)
    =>
    (printout t crlf "La opcion escogida es incorrecta. ")
    (retract ?ClearIncorrecta)
    (retract ?ClearCod)
    (retract ?ClearMenu)
    (bind ?num (+ ?num 1))
    (assert (ImprimeMenu ?num))
)

(
defrule AskForMore
    ;;;; Caso de que la opcion anterior fuese correcta, preguntamos si queremos
    ;;;; seguir escogiendo
    (ImprimeMenu ?num)
    =>
    (printout t crlf "¿Quieres seguir escogiendo? (s/n)")
    (bind ?answer (read))
    (assert (KeepSelecting ?answer))
)

(
defrule ProcesaRespuesta
    ;;;; Si queremos seguir escogiendo, se vuelve a imprimir el menu
    ?ClearGoOn <- (KeepSelecting s)
    (ImprimeMenu ?num)
    =>
    (bind ?num (+ ?num 1))
    (assert (ImprimeMenu ?num))
    (retract ?ClearGoOn)
)
