;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Cargamos por este orden
;;;     Datos de templates
;;;     Módulo 0: E/S y deducción valores inestables
;;;     Módulo 1: Detección de valores peligrosos
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



(defrule LoadModules
    =>
    (load templates.clp)
    (load inout.clp)
    (load peligrosos.clp)
    (load infravalorados.clp)
;;; (load sobrevalorados.clp)
)
