# -*- coding: utf-8 -*-
################ Importacion de librerias ##################
import random
import sys
import os
################ Definicion de variables globales ###########
NUMERO_CONJUNTOS = 0
ID_ARCHIVO = 0
PRUEBAS = ['secuencia({0},{1})','reverse_doble({0},{1})','primer_elemento({0},{1})','ultimo_elemento({0},{1})','reflexividad({0},{1})','transitividad({0},{1})','antisimetria({0},{1})']#,'orden_recursivo_grado_n({0})']
COMANDOS = ['java -jar Mars_cache.jar seleccion.asm pa input/CP_{0}.txt output/OP_I_{1}.txt','java -jar Mars_cache.jar mezcla.asm pa input/CP_{0}.txt output/OP_I_{1}.txt']
################ Definicion de funciones ####################

#Funcion que toma un archivo de texto con un conjunto
#y lo carga en una lista
#input:  Sin entrada
#output: Una lista de elementos enteros


#Funcion que verifica una propiedad de una lista o conjunto ordenada con la relacion binaria <=:
#Propiedad: a[i] <= a[i+1] con i = 0,1,2,...,n
#input: un conjunto de elementos enteros
#output:  un boolean de verificacion
def secuencia(lista,n):
    if lista:
        for i in range(0,n-1):
            if lista[i]>lista[i+1]:
                return False
        return True
    else:
        return True


#Funcion que verifica una propiedad de una lista:
#Propiedad: reverse(reverse(conjunto))
#input: un conjunto de elementos enteros
#output:  un boolean de verificacion
def reverse_doble(lista,n):
    if lista:
        copia = lista
        copia.reverse()
        copia.reverse()
        for i in range(0,n):
            if lista[i] != lista[i]:
                return False
        return True
    else:
        return True



#Funcion que verifica una propiedad de una lista o conjunto ordenada con la relacion binaria <=:
#Propiedad: priper elemento-> Si A es un conjunto totalmente ordenado se dice
#			que n es el primer elemento o elemento minimo de A.
#			Condiciones: n pertenece al conjunto A
#						 Para todo elemento m que pertenece al conjunto A entonces n <= m
#input: un conjunto de elementos enteros
#output:  un boolean de verificacion
def primer_elemento(lista,n):
    if lista:
        p = lista[0]
    	for m in range(1,n):
    		if p > lista[m]:
    			return False
    	return True
    else:
        return True


#Funcion que verifica una propiedad de una lista o conjunto ordenada con la relacion binaria <=:
#Propiedad: ultimo elemnto-> Si A es un conjunto totalmente ordenado se dice
#           que n es el ultimo elemento o el elemento maximo de A.
#           Condiciones: n pertenece al conjunto A
#                        Para todo elemento m que pertenece al conjunto A entonces n>=m
#input: un conjunto de elementos enteros
#output: un boolean de verificacion
def ultimo_elemento(lista,n):
    if lista:
        u= lista[n-1]
        for i in xrange(n-2,-1,-1):
            m = lista[i]
            if u < m:
                return False
        return True
    else:
        return True

#Funcion que verifica una propiedad de una lista:
#Propiedad: reflexividad-> Para todo elemento a que pertenezca al conjunto A, el par ordenado (a,a) pertenece a la relacion binaria R.
#			Tengase en cuenta que debe cumplirse para todos los elementos del conjunto sin excepcion, si esta propiedad solo se da en algunos casos la relación no es reflexiva:
#			No existe ningún elemento a en A, para el que el par ordenado (a,a) no pertenezca a la relación R. Puede verse que estas dos afirmaciones son iguales.
#input: un conjunto de elementos enteros
#output:  un boolean de verificacion
def reflexividad(lista,n):
    if lista:
        lista_prima = lista
        for i  in range(0,n):
            if lista_prima[i] != lista[i]:
                return False
        return True
    else:
        return True

#Funcion que verifica una propiedad de un conjunto ordenado:
#Propiedad: transitividad-> dado los elementos a, b, c del conjunto, si a está relacionado con b y b está relacionado con c, entonces a está relacionado con c
#input: un conjunto de elementos enteros
#output:  un boolean de verificacion
def transitividad(lista,n):
    if lista:

        if n >= 3:
            p = random.randint(0, n-3)
            a = lista[p]
            b = lista[p+1]
            c = lista[p+2]
            if a<=c and b<=c:
                if a<=c:
                    return True
                else:
                    return False
        else:
            return False
    else:
        return True



#Funcion que verifica una propiedad de un conjunto ordenado:
#Propiedad: antisimetría-> Para todo a, b que pertenece al conjunto A se cumple que si, (a<=b)&(b<=a) entonces (a = b)
#input: un conjunto de elementos enteros
#output:  un boolean de verificacion
def antisimetria(lista,n):
    if lista:
        for i  in range(0,n-1):
            a = lista[i]
            b = lista [i+1]
            if a>b and b>a:
                return False
        return True
    else:
        return True

#Funcion que se encarga de verificar si se cumple la propiedad de ordenamiento recursivo
#input: lista -> lista de elementos
#       n -> orden del ordenamiento
#output: un boolean de verificacion
def orden_recursivo_grado_n(lista):
    return True



#Funcion que genera una cantidad x de archivos de entrada aleatorios con n numero de entrada
#input: min -> minimo número en la lista
#       max -> máximo número en la lista
#       n -> cantidad de numeros aleatorios por archivo
#output:  sin salida
def generar_entrada(min,max,n):
    comando = 'mkdir -p input'
    os.system(comando)
    comando = 'rm input/*'
    os.system(comando)
    nombre = 'input/CP_{0}.txt'.format(ID_ARCHIVO)
    out = open(nombre,'w')
    for i in range (0,n):
        r = random.randint(min,max)
        out.write(str(r)+'\n')
    out.close()

##Esta funcion solo es provisoria para reemplazar la lectura del archivo en mips
def leer_entrada(archivo):
    L =[]
    file = open(archivo,'r')
    for linea in file:
        L.append(int(linea))
    file.close()
    return L



############### Bloque Principal ################
if len(sys.argv) == 5:
    #print sys.argv
    if int(sys.argv[1]) > 0:
        if int(sys.argv[2]) <= int(sys.argv[3]):
            if int(sys.argv[4]) >= 0:
                os.system('clear all')
                os.system('mkdir -p output')
                os.system('rm output/*')
                ############ Obtencion de parametros ###################
                TOTAL_PRUEBAS = int(sys.argv[1])
                MIN = int(sys.argv[2])
                MAX = int(sys.argv[3])
                N = int(sys.argv[4])
                ########### Inicio de pruebas ###############
                ID_ARCHIVO = 0 ##Reiniciar Identificadores de archivos
                for i in range(0,TOTAL_PRUEBAS):
                    ########### Generar Caso de Prueba ##############
                    generar_entrada(MIN,MAX,N)
                    ########## Cargar Caso de Prueba Creado Recien ################
                    L = leer_entrada('input/CP_{0}.txt'.format(ID_ARCHIVO))
                    print 'Lista: {0}'.format(ID_ARCHIVO)
                    ################# APLICAR ORDENAMIENTO ##############
                    ## ITERATIVO ##
                    os.system(COMANDOS[1].format(ID_ARCHIVO,ID_ARCHIVO))

                    ## RECURSIVO ##
                    L.sort()

                    ################# Testing de Propiedades ###########
                    #L = []
                    for test in PRUEBAS:
                        if eval(test.format(L,N)):
                            print 'Éxito en prueba: {0}'.format(test)
                        else:
                            print 'Fallo en prueba: {0}'.format(test)
                    ID_ARCHIVO = ID_ARCHIVO + 1 #Incrementar identificador de Caso de Prueba
            else:
                print 'Tamaño de la lista debe ser mayor que 0'
        else:
            print 'Número mínimo de elementos en la lista debe ser menor o igual al número máximo de elementos en la lista\n'
    else:
        print 'Número de pruebas a generar debe ser mayor que 0\n'
else:
    print 'Faltan o sobran argumentos\n\t ./test [CANTIDAD_PRUEBAS?A_GENERAR] [MIN_ELEMENTO_LISTA] [MAX_ELEMENTO_LISTA] [TAMAÑO_LISTA]\n'
