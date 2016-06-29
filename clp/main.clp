;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Cargamos por este orden
;;;     Primer lugar
;;;         Datos de templates
;;;     Segundo lugar
;;;         Módulo 0: E/S y deducción valores inestables
;;;     Tercer lugar:
;;;         Módulo 1: Detección de valores peligrosos
;;;     Último lugar:
;;;         Módulo 2: Detector de valores sobrevalorados
;;;         Módulo 3: Detector de valores infravalorados
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



(defrule NextModulo
    (declare (salience -1000))
    ?f <- (Trigger ?num)
    ;; Debe ser un número mayor que el número de módulos
    ;; Hace que esta regla no se ejecute indefinidamente
    (test (< ?num 10))
    =>
    (retract ?f)
    (assert (Trigger (+ ?num 1)))
)

;;; Almacenamiento de hechos auxiliares
(deffacts Aux
    (PrecioDinero 0)
    (GestionPropuestas)
)

(defrule LoadTemplates
    =>
    (load templates.clp)
    (assert (Trigger 0))
)

(defrule LoadModulo0
    (Trigger 0)
    =>
    (load lectura.clp)
)

(defrule LoadModulo1
    (Trigger 1)
    =>
    (load peligrosos.clp)
)

(defrule LoadModulo2
    (Trigger 2)
    =>
    (load sobrevalorados.clp)
)

(defrule LoadModulo3
    (Trigger 2)
    =>
    (load infravalorados.clp)
)

(defrule LoadModulo4
    (Trigger 3)
    =>
    (load propuestas.clp)
)

(defrule LoadModulo5
    (Trigger 4)
    =>
    (load menu.clp)
)
