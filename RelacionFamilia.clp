;; Ignacio Cordón


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Datos del problema
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(
deffacts PersonasFamilia
    (Persona Yolanda M)
    (Persona Chema V)
    (Persona David V)
    (Persona Jose V)
    (Persona Nacho V)
    (Persona Rafa V)
    (Persona Mari M)
    (Persona Joni V)
    (Persona Sergio V)
    (Persona Rafalin V)
    (Persona Pilar M)
    (Persona Pepe V)
    (Persona Pepe2 V)
    (Persona Maria M)
    (Persona Silvia M)
    (Persona Antonio V)
    (Persona Vivi M)
    (Persona Pepe3 V)
    (Persona Claudia M)
    (Persona Martina M)
)
(
deffacts ParentescosFamilia
    (Relacion Yolanda Chema casados)
    (Relacion Mari Rafa casados)
    (Relacion David Chema hijo)
    (Relacion Jose Yolanda hijo)
    (Relacion Nacho Yolanda hijo)
    (Relacion Rafalin Rafa hijo)
    (Relacion Joni Rafa hijo)
    (Relacion Sergio Mari hijo)
    (Relacion Pepe Pilar casados)
    (Relacion Chema Pilar hijo)
    (Relacion Maria Pepe2 casados)
    (Relacion Yolanda Maria hijo)
    (Relacion Mari Maria hijo)
    (Relacion Silvia Pilar hijo)
    (Relacion Silvia Antonio casados)
    (Relacion Vivi Pilar hijo)
    (Relacion Vivi Pepe3 casados)
    (Relacion Claudia Silvia hijo)
    (Relacion Martina Antonio hijo)
)
(
deffacts SexoParentescos
    (Sexo V casados esposo)
    (Sexo M casados esposa)
    (Sexo V hijo hijo)
    (Sexo M hijo hija)
    (Sexo V primo primo)
    (Sexo M primo prima)
    (Sexo V abuelo abuelo)
    (Sexo M abuelo abuela)
    (Sexo V tio tio)
    (Sexo M tio tia)
    (Sexo V cuniado cuniado)
    (Sexo M cuniado cuniada)
    (Sexo V hermano hermano)
    (Sexo M hermano hermana)
    (Sexo V suegro suegro)
    (Sexo M suegro suegra)
)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Regla que establece reciprocidad entre casados
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(
defrule Casados
    (Persona ?n1 ?)
    (Persona ?n2&~n1 ?)
    (Relacion ?n1 ?n2 casados)
    => (assert (Relacion ?n2 ?n1 casados))
)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Regla que calcula los hijos de una persona a partir
;; de los de su esposo/a
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(
defrule Hijos
    (Persona ?n1 ?)
    (Persona ?n2&~?n1 ?)
    (Persona ?n3&~?n2&~?n1 ?)
    (Relacion ?n1 ?n2 casados)
    (Relacion ?n3 ?n1 hijo)
    => (assert (Relacion ?n3 ?n2 hijo))
)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Regla que establece reciprocidad entre hermanos
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(
defrule Hermanos
    (Persona ?n1 ?)
    (Persona ?n2&~?n1 ?)
    (Persona ?n3&~?n2&~?n1 ?)
    (Relacion ?n2 ?n1 hijo)
    (Relacion ?n3 ?n1 hijo)
    => (assert (Relacion ?n2 ?n3 hermano))
)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Regla para el cálculo de los tíos
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(
defrule Tio
    (Persona ?n1 ?)
    (Persona ?n2&~?n1 ?)
    (Persona ?n3&~?n2&~?n1 ?)
    (Relacion ?n1 ?n2 hermano)
    (Relacion ?n3 ?n2 hijo)
    => (assert (Relacion ?n1 ?n3 tio))
)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Regla para el cálculo de los abuelos
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(
defrule Abuelo
    (Persona ?n1 ?)
    (Persona ?n2&~?n1 ?)
    (Persona ?n3&~?n2&~?n1 ?)
    (Relacion ?n1 ?n2 hijo)
    (Relacion ?n2 ?n3 hijo)
    => (assert (Relacion ?n3 ?n1 abuelo))
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Regla para el cálculo de los primos
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(
defrule Primo
    (Persona ?n1 ?)
    (Persona ?n2&~?n1 ?)
    (Persona ?n3&~?n2&~?n1 ?)
    (Relacion ?n1 ?n2 tio)
    (Relacion ?n3 ?n1 hijo)
    => (assert (Relacion ?n3 ?n2 primo))
)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Regla para el cálculo de los suegros
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(
defrule Suegro
    (Persona ?n1 ?)
    (Persona ?n2&~?n1 ?)
    (Persona ?n3&~?n2&~?n1 ?)
    (Relacion ?n1 ?n2 hijo)
    (Relacion ?n1 ?n3 casados)
    => (assert (Relacion ?n2 ?n3 suegro))
)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Regla para el cálculo de los cuniados
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(
defrule Cuniado
    (Persona ?n1 ?)
    (Persona ?n2&~?n1 ?)
    (Persona ?n3&~?n2&~?n1 ?)
    (Relacion ?n1 ?n2 casados)
    (Relacion ?n2 ?n3 hermano)
    => (assert (Relacion ?n1 ?n3 cuniado))
)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Regla para el cálculo de los cuniados políticos
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(
defrule CuniadoExt
    (Persona ?n1 ?)
    (Persona ?n2&~?n1 ?)
    (Persona ?n3&~?n2&~?n1 ?)
    (Persona ?n4&~?n2&~?n1&~n3 ?)
    (Relacion ?n1 ?n2 casados)
    (Relacion ?n2 ?n3 hermano)
    (Relacion ?n4 ?n3 casados)
    => (assert (Relacion ?n1 ?n4 cuniado))
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Regla que duplica ciertas relaciones (tío, abuelo,...)
;; para esposos/as
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(
defrule HerenciaRelaciones
    (Persona ?n1 ?)
    (Persona ?n2&~?n1 ?)
    (Persona ?n3&~?n2&~?n1 ?)
    (Relacion ?n1 ?n2 casados)
    (Relacion ?n2 ?n3 ?rel&~hijo&~hermano&~cuniado)
    => (assert (Relacion ?n1 ?n3 ?rel))
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(
defrule PidePersonas
    =>
    (printout t "Introduce primera persona: ")
    (bind ?n1 (read))
    (printout t "Introduce segunda persona: ")
    (bind ?n2 (read))
    (assert (Resuelve ?n1))
    (assert (Resuelve ?n2))
)
(
defrule ExisteRelacion
    (Persona ?n1 ?s1)
    (Persona ?n2 ?s2)
    ?Borrar1 <- (Resuelve ?n1)
    ?Borrar2 <- (Resuelve ?n2)
    (Relacion ?n1 ?n2 ?relacion)
    (Sexo ?s1 ?relacion ?rel)
    =>
    (printout t ?n1 " es " ?rel " de " ?n2)
    (printout t "" crlf)
    (retract ?Borrar1)
    (retract ?Borrar2)
)
(
defrule NoExisteRelacion
    (Persona ?n1 ?s1)
    (Persona ?n2&~?n1 ?s2)
    ?Borrar1 <- (Resuelve ?n1)
    ?Borrar2 <- (Resuelve ?n2)
    (not (Relacion ?n1 ?n2 ?relacion))
    =>
    (printout t ?n1 " no tiene relación con " ?n2)
    (printout t "" crlf)
    (retract ?Borrar1)
    (retract ?Borrar2)
)
