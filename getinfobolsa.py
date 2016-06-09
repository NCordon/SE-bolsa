#!/usr/bin/env python
# -*- coding: utf-8 -*-

import datetime
import os
import requests
from lxml import html
import json
import re
from alias import empresas
from sectores import sectores
import pandas as pd
from collections import OrderedDict

def to_float(s):
    return float(s.replace(".","").replace(",",".").replace("%",""))


def tag_per(per):
    if per < 12:
        result = 'Bajo'
    else:
        if 12 <= per < 18:
            result = 'Medio'
        else:
            result = 'Alto'

    return result


def tag_rpd(rpd):
    if rpd < 2:
        result = 'Bajo'
    else:
        if 2 <= rpd < 5:
            result = 'Medio'
        else:
            result = 'Alto'

    return result


def price_falling(prices):
    losing = True

    for i in range(1,len(prices)):
        if prices[i-1] < prices[i]:
            losing = False

    return losing


def price_falling_var(vars):
    losing = True

    for i in range(1,len(vars)):
        if vars[i] > 0:
            losing = False

    return losing


def price_variation(today, ancient):
    return (today-ancient)/ancient


def tag_sizes(data):
    result = []

    for s in data:
        if s < 2:
            result += ['PEQUENIA']
        else:
            if 2 <= s < 5:
                result += ['MEDIANA']
            else:
                result += ['GRANDE']

    return result


filas = list(set(empresas.values()))
n = len(filas)
datos = OrderedDict([
    ('price', [None]*n),
    ('var', [None]*n),
    ('capitalization', [None]*n),
    ('per', [None]*n),
    ('rpd', [None]*n),
    ('tag_size', [None]*n),
    ('size', [None]*n),
    ('tag_per', [None]*n),
    ('tag_rpd', [None]*n),
    ('sector', [None]*n),
    ('var5', [None]*n),
    ('losing3', [None]*n),
    ('losing5', [None]*n),
    ('var_sector5', [None]*n),
    ('var_sector_condition', [None]*n),
    ('var_mes', [None]*n),
    ('var_trim', [None]*n),
    ('var_sem', [None]*n),
    ('var_anio', [None]*n),
    ('var_1', [None]*n),
    ('var_2', [None]*n),
    ('var_3', [None]*n),
    ('var_4', [None]*n),
    ('var_5', [None]*n)]
)

data = pd.DataFrame(datos, filas)

filas = list(set(sectores.values()))
n = len(filas)
datos = OrderedDict([
    ('var', [None]*n),
    ('capitalization', [None]*n),
    ('per', [None]*n),
    ('rpd', [None]*n),
    ('size', [None]*n),
    ('var5', [None]*n),
    ('losing3', [None]*n),
    ('losing5', [None]*n),
    ('var_mes', [None]*n),
    ('var_trim', [None]*n),
    ('var_sem', [None]*n),
    ('var_anio', [None]*n),
    ('var_1', [None]*n),
    ('var_2', [None]*n),
    ('var_3', [None]*n),
    ('var_4', [None]*n),
    ('var_5', [None]*n)]
)

sector_data = pd.DataFrame(datos, filas)


""" CÁLCULO DE DATOS DE ACCIONES DE EMPRESAS """
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
        capitalization = link_page.xpath('//table[@id="ctl00_Contenido_tblCapital"]//tr')[1].\
                         getchildren()[1].text
        capitalization = to_float(capitalization)


        script_grafico = link_page.xpath('//script')[-2].text
        ancient = root +\
                  re.search('url: "/aspx/comun/consultaPrecios.*"', script_grafico).\
                  group(0).rsplit()[-1].replace("\"","")

        # Histórico de precios
        history = json.loads(html.fromstring(requests.get(ancient).content).text)["s0:"][-6:]
        history = [u['p'] for u in history]

        alias = empresas[name]


        data['price'][alias] = price
        data['var'][alias] = var
        data['capitalization'][alias] = capitalization

        if alias in sectores:
            data['sector'][alias] = sectores[alias]

        data['losing3'][alias] = price_falling(history[-3:])
        data['losing5'][alias] = price_falling(history)
        data['var_1'][alias] = price_variation(history[5],history[4])
        data['var_2'][alias] = price_variation(history[4],history[3])
        data['var_3'][alias] = price_variation(history[3],history[2])
        data['var_4'][alias] = price_variation(history[2],history[1])
        data['var_5'][alias] = price_variation(history[1],history[0)]


data['size'] = 100*(data['capitalization']/sum(data['capitalization']))
data['tag_size'] = tag_sizes(data['size'])

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
        alias = empresas[name]
        data['per'][alias] = per
        data['rpd'][alias] = rpd
        data['tag_per'][alias] = tag_per(per)
        data['tag_rpd'][alias] = tag_rpd(rpd)


periodos = {
    'semana': 'var5',
    'mes': 'var_mes',
    'trimestre': 'var_trim',
    'semestre': 'var_sem',
    'interanual': 'var_anio'
}

for p in periodos:
    query = "http://www.invertia.com/mercados/bolsa/indices/ibex-35/acciones-"\
            + p + "-ib011ibex35"
    page = html.fromstring(requests.get(query).content)
    rows = page.xpath('//table[@title="Acciones"]//tr')
    # Le quitamos la cabecera
    rows = rows[1:]

    for r in rows:
        cols = r.getchildren()
        name = cols[0].xpath(".//a//text()")[0]

        if name in empresas.keys():
            alias = empresas[name]
            var_periodo = to_float(cols[3].text)
            data[periodos[p]][alias] = var_periodo


data['var_sector5'] = data['var5']

""" CÁLCULO DE DATOS DE SECTORES """

for s in sector_data.index.values:
    current = data[data['sector'] == s]
    count = len(current)
    sector_data['var'][s] = sum(current['var'])/count
    sector_data['capitalization'][s] = sum(current['capitalization'])
    sector_data['per'][s] = sum(current['per'])/count
    sector_data['rpd'][s] = sum(current['rpd'])/count
    sector_data['size'][s] = sum(current['capitalization'])/sum(data['capitalization'])
    sector_data['var5'][s] = sum(current['var5'])/count
    sector_data['var_1'][s] = sum(current['var_1'])/count
    sector_data['var_2'][s] = sum(current['var_2'])/count
    sector_data['var_3'][s] = sum(current['var_3'])/count
    sector_data['var_4'][s] = sum(current['var_4'])/count
    sector_data['var_5'][s] = sum(current['var_5'])/count
    sector_data['losing3'][s] = price_falling_var([
        sector_data['var_1'][s],
        sector_data['var_2'][s],
        sector_data['var_3'][s],
    ])
    sector_data['losing5'][s] = price_falling_var([
        sector_data['var_1'][s],
        sector_data['var_2'][s],
        sector_data['var_3'][s],
        sector_data['var_4'][s],
        sector_data['var_5'][s],
    ])
    sector_data['var_mes'][s] = sum(current['var_mes'])/count
    sector_data['var_trim'][s] = sum(current['var_trim'])/count
    sector_data['var_sem'][s] = sum(current['var_sem'])/count
    sector_data['var_anio'][s] = sum(current['var_anio'])/count


#### Diferencia en variación a 5 días entre una empresa y su sector
for empresa in data.index.values:
    var_sector = sector_data['var5'][data['sector'][empresa]]
    data['var_sector5'][empresa] = data['var5'][empresa] - var_sector

data['var_sector_condition'] = (data['var_sector5']<-5)
