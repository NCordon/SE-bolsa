
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
    (field VarSemana)
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
    (field VarSemana)
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
    (field Invertible)
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

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Template para valores infravalorado
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(deftemplate ValorInfravalorado
    (field Nombre)
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Template para valores sobrevalorados
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(deftemplate ValorSobrevalorado
    (field Nombre)
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Template para propuestas
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(deftemplate Propuesta
    (field Tipo
        (type SYMBOL)
        (allowed-values
            VentaPeligrosos
            CompraInfravalorados
            VentaSobrevalorados
            MayorRentabilidad
        )
    )
    (multifield Empresa (type SYMBOL) (cardinality 1 2))
    (field RE)
    (field Info)
    (field OtraEmpresa)
)
