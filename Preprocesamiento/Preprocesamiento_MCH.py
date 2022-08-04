#Procesamiento
import pandas as pd
import numpy as np
import datetime as dt
import missingno as msno
import csv

#variables
codigo = {}
num = {}
ciudad = {}
edad = {}
estadocivil = {}
diagnostico = {}
ivsa = {}
anticonceptivo = {}
citologia = {}
codenfermedad = {}

df=pd.read_excel('dataset_v2.xlsx', sheet_name=3)
df.head()

#Valores nulos por columna
missing_values_count  = df.isna().sum()
missing_values_count

#contamos numero de filas
df.shape

#verificamos si tiene valores nulo
df[df.duplicated()]

#codigo-num
for data in df.iterrows():
  codigo[data[1]["codigo"]]=data[1]['codigo']

  try:
    if data[1]["ciudad"] not in ciudad:
      ciudad[data[1]["ciudad"]]=[]
    ciudad[data[1]["ciudad"]].append(data[1]["codigo"])
  except: pass

  try:
    if data[1]["edad"] not in edad:
      edad[data[1]["edad"]]=[]
    edad[data[1]["edad"]].append(data[1]["codigo"])
  except: pass

  try:
    if data[1]["estadocivil"] not in estadocivil:
      estadocivil[data[1]["estadocivil"]]=[]
    estadocivil[data[1]["estadocivil"]].append(data[1]["codigo"])
  except: pass

  try:
    if data[1]["diagnostico"] not in diagnostico:
      diagnostico[data[1]["diagnostico"]]=[]
    diagnostico[data[1]["diagnostico"]].append(data[1]["codigo"])
  except: pass

  try:
    if data[1]["ivsa"] not in ivsa:
      ivsa[data[1]["ivsa"]]=[]
    ivsa[data[1]["ivsa"]].append(data[1]["codigo"])
  except: pass

  try:
    if data[1]["anticoncepcionusoprevio"] not in anticonceptivo:
      anticonceptivo[data[1]["anticoncepcionusoprevio"]]=[]
    anticonceptivo[data[1]["anticoncepcionusoprevio"]].append(data[1]["codigo"])
  except: pass

  try:
    if data[1]["citologiaresultado"] not in citologia:
      citologia[data[1]["citologiaresultado"]]=[]
    citologia[data[1]["citologiaresultado"]].append(data[1]["codigo"])
  except: pass

  try:
    if data[1]["codigoenfermedad"] not in codenfermedad:
      codenfermedad[data[1]["codigoenfermedad"]]=[]
    codenfermedad[data[1]["codigoenfermedad"]].append(data[1]["codigo"])
  except: pass


#********************

#para el codigo
with open('nodos.csv', 'w', newline='', encoding='utf-8-sig') as csvfile:
  writer = csv.writer(csvfile)
  writer.writerow(["Id","Label","Type"])
  for key in codigo:
    writer.writerow([key, codigo[key], "codigo"])

  for key in ciudad:
    writer.writerow([key, key, "ciudad"])

  for key in edad:
    writer.writerow([key, key, "edad"])

  for key in estadocivil:
    writer.writerow([key, key, "estadocivil"])

  for key in diagnostico:
    writer.writerow([key, key, "diagnostico"])

  for key in ivsa:
    writer.writerow([key, key, "ivsa"])

  for key in anticonceptivo:
    writer.writerow([key, key, "anticonceptivo"])

  for key in citologia:
    writer.writerow([key, key, "citologia"])

  for key in codenfermedad:
    writer.writerow([key, key, "codenfermedad"])

#creando los enlaces
#cambiamos los datos
with open('enlaces.csv', 'w', newline='', encoding='utf-8-sig') as csvfile:
  writer = csv.writer(csvfile)
  writer.writerow(["Source","Target","Type", "Weight"])

  #for key, item in codigo.items():
    #writer.writerow([key, item, "Directed","1"])

  for key, item in ciudad.items():
    for i in item:
      writer.writerow([key, i, "Directed","1"])
  
  for key, item in edad.items():
    for i in item:
        writer.writerow([key, i, "Directed","1"])

  for key, item in estadocivil.items():
    for i in item:
      writer.writerow([key, i, "Directed","1"])

  for key, item in diagnostico.items():
    for i in item:
      if(key=='Definitivo'):
        writer.writerow([key, i, "Directed","1"])
      else:
        writer.writerow([key, i, "Directed","0.9"])
  
  for key, item in ivsa.items():
    for i in item:
      writer.writerow([key, i, "Directed","1"])
  
  for key, item in anticonceptivo.items():
    for i in item:
      writer.writerow([key, i, "Directed","1"])

  for key, item in citologia.items():
    for i in item:
      if(key=='negativo'):
        writer.writerow([key, i, "Directed","0.8"])
      else:
        writer.writerow([key, i, "Directed","1"])
  
  for key, item in codenfermedad.items():
    for i in item:
      writer.writerow([key, i, "Directed","1"])

df2=pd.read_csv('enlaces.csv')
df2.groupby(['Target']).size().reset_index(name="contandor")

resultado =[]
for key, item in ciudad.items():
  for i in item:
    resultado.append([key, i, "Directed","1"])
resultado