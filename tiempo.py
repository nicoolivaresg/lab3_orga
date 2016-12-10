# -*- coding: utf-8 -*-
################ Importacion de librerias ##################
import random
import sys
import os
from time import time
################ Definicion de variables globales ###########
comando = 'java -jar Mars_cache.jar mezcla_testing.asm pa prueba_cache.txt salidaIter.txt'
tiempo_inicial = time()
os.system(comando)
tiempo_final = time()
print 'Tiempo es : {0}'.format(tiempo_final-tiempo_inicial)
