
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Template para valores de las acciones al cierre de mercados
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(deftemplate ValorSociedad
    (field Nombre)
    (field Precio)
    (field Variacion)
    (field Capitalizacion)
    (field Per)
    (field Rpd)
    (field Tamanio)
    (field PorcentajeIbex)
    (field EtiquetaPer)
    (field EtiquetaRpd)
    (field Sector)
    (field VarPrecio5)
    (field Perdiendo3)
    (field Perdiendo5)
    (field VarSector5)
    (field VarSectorLower-5)
    (field VarMes)
    (field VarTrimestre)
    (field VarSemestre)
    (field VarAnio)
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Template para valores del estado de los sectores
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(deftemplate ValorSector
    (field Nombre)
    (field Variacion)
    (field Capitalizacion)
    (field Per)
    (field Rpd)
    (field Tamanio)
    (field VarPrecio5)
    (field Perdiendo3)
    (field Perdiendo5)
    (field VarMes)
    (field VarTrimestre)
    (field VarSemestre)
    (field VarAnio)
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Template para valores inestables
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(deftemplate ValorInestable
    (field Nombre)
)



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Template para saldo disponible
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(deftemplate SaldoDisponible
    (field MinDisponible)
    (field MaxDisponible)
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Template para valores de la cartera
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(deftemplate ValorCartera
    (field Nombre)
    (field Acciones)
    (field ValorAnterior)
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Template para valores peligrosos
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(deftemplate ValorPeligroso
    (field Nombre)
)
