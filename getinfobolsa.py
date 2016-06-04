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


def tag_per(per):
    result = 'Alto'

    if per < 12:
        result = 'Bajo'
    else:
        if 12 <= per < 18:
            result = 'Medio'

    return result


def tag_rpd(rpd):
    result = 'Alto'

    if rpd < 2:
        result = 'Bajo'
    else:
        if 2 <= rpd < 5:
            result = 'Medio'

    return result

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

    if name in empresas.keys():
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


        data[empresas[name]] = [price, var, capitalizacion]


query = "http://www.eleconomista.es/indice/IBEX-35/resumen"
page = html.fromstring(requests.get(query).content)
rows = page.xpath('//table[@class="tablalista"]//tr')
# Le quitamos la cabecera
rows = rows[2:-1]

for r in rows:
    cols = r.getchildren()
    name = cols[0].xpath('.//a//text()')[0]

    if name in empresas.keys():
        per = to_float(cols[7].text)
        rpd = to_float(cols[8].text)
        data[empresas[name]] += [per,rpd,tag_per(per), tag_rpd(rpd)]





periodos = ["semana", "mes", "trimestre", "semestre", "interanual"]

for periodo in periodos:
    query = "http://www.invertia.com/mercados/bolsa/indices/ibex-35/acciones-"\
            + periodo + "-ib011ibex35"
    page = html.fromstring(requests.get(query).content)
    rows = page.xpath('//table[@title="Acciones"]//tr')
    # Le quitamos la cabecera
    rows = rows[1:]

    for r in rows:
        cols = r.getchildren()
        name = cols[0].xpath(".//a//text()")[0]

        if name in empresas.keys():
            variacion_periodo = to_float(cols[3].text)
            data[empresas[name]] += [variacion_periodo]
