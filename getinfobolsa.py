#!/usr/bin/env python
# -*- coding: utf-8 -*-

import datetime
import os
import requests
from lxml import html
import json
import re
from diccionario import empresas

def to_float(s):
    return float(s.replace(".","").replace(",",".").replace("%",""))

# precio   var_ayer   capitalizacion   var_mes   var_tri   var_sem   var_año
data = {}

root = "http://www.bolsamadrid.es"

query = root + "/esp/aspx/Mercados/Precios.aspx?indice=ESI100000000"
page = html.fromstring(requests.get(query).content)
rows = page.xpath('//table[@id="ctl00_Contenido_tblAcciones"]//tr')
# Le quitamos la cabecera
rows = rows[1:]


# Extraemos nombre, precio al cierre, variazacion y capitalizacion
for r in rows:
    cols = r.getchildren()

    name = cols[0].xpath('.//a//text()')[0]
    price = to_float(cols[1].text)
    var = to_float(cols[2].text)


    link_deep = root + cols[0].xpath('.//a//@href')[0]
    link_page = html.fromstring(requests.get(link_deep).content)
    capitalizacion = link_page.xpath('//table[@id="ctl00_Contenido_tblCapital"]//tr')[1].\
                     getchildren()[1].text
    capitalizacion = to_float(capitalizacion)


    # Histórico de un año, por si es necesario
    script_grafico = link_page.xpath('//script')[-2].text
    ancient = root +\
              re.search('url: "/aspx/comun/consultaPrecios.*"', script_grafico).\
              group(0).rsplit()[-1].replace("\"","")


    data[name] = []
    data[name] += [price]
    data[name] += [var]
    data[name] += [capitalizacion]



periodos = ["mes", "trimestre", "semana", "interanual"]

for periodo in periodos:
    query = "http://www.invertia.com/mercados/bolsa/indices/ibex-35/acciones-"\
            + periodo + "-ib011ibex35"
    page = html.fromstring(requests.get(query).content)
    rows = page.xpath('//table[@title="Acciones"]//tr')
    # Le quitamos la cabecera
    rows = rows[1:]

    for r in rows:
        cols = r.getchildren()

        name = cols[0].xpath(".//a//@title")[0]
        if name in empresas.keys():
            variacion_periodo = to_float(cols[3].text)
            data[empresas[name]] += [variacion_periodo]
