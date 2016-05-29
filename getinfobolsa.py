#!/usr/bin/env python
# -*- coding: utf-8 -*-

import datetime
import os
import requests
from lxml import html
import json
import re


# Queremos extraer el id
# get_locationid = re.compile("[^:]*\:[^:]*$")
# get_location = re.compile("locationId\"\:[^\}]*")



query = "http://www.bolsamadrid.es/esp/aspx/Mercados/Precios.aspx?indice=ESI100000000"
page = html.fromstring(requests.get(query).content)

""" Enlaces a las empresas """
links = page.xpath('//td[@class="DifFlBj"]//@href') + \
              page.xpath('//td[@class="DifFlSb"]//@href')

links = ["http://www.bolsamadrid.es" + l for l in links]

""" Nombres de las empresas """
names = page.xpath('//td[@class="DifFlBj"]//a/text()') + \
            page.xpath('//td[@class="DifFlSb"]//a/text()')


required = ["Precio cierre período ", "Capitalización ", ""]

datos_empresas = []

for i in range(len(names)):
    page = html.fromstring(requests.get( links[i] ).content)
    rows = page.xpath('//table[@id="ctl00_Contenido_tblCapital"]//tr')
    info_name = [ row.getchildren()[0].text for row in rows ]

    for data_name in required:
        try:
            j = info_name.index(data_name)
            data = rows[j].getchildren()[1].text
            datos_empresas += [ names[i] + data ]
        except:
            pass
