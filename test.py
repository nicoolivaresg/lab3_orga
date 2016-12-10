# -*- coding: utf-8 -*-
################ Importacion de librerias ##################
import random
import sys
import os
################ Definicion de variables globales ###########
NUMERO_CONJUNTOS = 0
ID_ARCHIVO = 0
PRUEBAS = ['secuencia({0},{1})','reverse_doble({0},{1})','primer_elemento({0},{1})','ultimo_elemento({0},{1})','reflexividad({0},{1})','transitividad({0},{1})','antisimetria({0},{1})','orden_orden({0},{1},{2})']
COMANDOS = ['java -jar Mars_cache.jar seleccion_testing.asm pa input/CP_{0}.txt output/OP_{1}_{2}.txt','java -jar Mars_cache.jar mezcla_testing.asm pa input/CP_{0}.txt output/OP_{1}_{2}.txt']
################ Definicion de funciones ####################
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
            if lista_prima[i] > lista[i]:
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
            if lista[0]> lista[1]:
                return False
            else:
                return True
    else:
        return True



#Funcion que verifica una propiedad de un conjunto ordenado:
#Propiedad: antisimetría-> Para todo a, b que pertenece al conjunto A se cumple que si, (a<=b)&(b<=a) entonces (a = b)
#input: un conjunto de elementos enteros
#output:  un boolean de verificacion
def antisimetria(lista,n):
    if lista:
        contador=0
        for i in range(0,n):
            a =lista[i]
            for j in range(0,n):
                b=lista[j]
                if a<=b and b<=a:
                    contador = contador+1
        if contador < n:
            return False
        else:
            return True
    else:
        return True

#Funcion que se encarga de verificar si se cumple la propiedad de ordenamiento recursivo
#input: lista_ordenada -> lista de elementos ya ordendada
#       id -> identificacion de archivo
#       algoritmo -> nombre de algoritmo
#output: un boolean de verificacion
def orden_orden(lista_ordenada,id, algoritmo):
    try:
        entrada = 'output/OP_{0}_{1}.txt'.format(algoritmo,id)
        salida = 'output/OP_{0}_orden_orden_{1}.txt'.format(algoritmo,id)
        comando = 'java -jar Mars_cache.jar {0}.asm pa {1} {2}'.format(algoritmo,entrada,salida)
        os.system(comando)
        L = leer_entrada(salida)
        if len(L)!= len(lista_ordenada):
            return False
        for i in range(0,len(L)):
            if L[i] != lista_ordenada[i]:
                return False
        return True
    except Exception as e:
        raise
    return True



#Funcion que genera una cantidad x de archivos de entrada aleatorios con n numero de entrada
#input: min -> minimo número en la lista
#       max -> máximo número en la lista
#       n -> cantidad de numeros aleatorios por archivo
#output:  sin salida
def generar_entrada(min,max,n,id):
    comando = 'mkdir -p input'
    os.system(comando)
    nombre = 'input/CP_{0}.txt'.format(id)
    out = open(nombre,'w')
    for i in range (0,n):
        r = random.randint(min,max)
        out.write(str(r)+'\n')
    out.close()

#Esta funcion se encarga de leer un archivo de texto
#con el formato de la entrada o salida y cargarla sobre una lista de Python
#Entrada: archivo-> Nombre de archivo(ruta)
#Salida: L-> Lista con los valores que estaban en el archivo
def leer_entrada(archivo):
    L =[]
    file = open(archivo,'r')
    for linea in file:
        try:
            L.append(int(linea))
        except Exception as e:
            raise
    file.close()
    return L

#Esta funcion se encarga de ejecutar todo el conjunto de pruebas sobre todos los programas
#Entrada:
#Salida: Boolean si todos los programas pasaron las pruebas
def testing(num_pruebas, min,max,n):
    for i in range(0,num_pruebas):
        ########### Generar Caso de Prueba ##############
        print "\nGenerando caso de prueba, revisar input/"
        generar_entrada(min,max,n,i)
        print 'CASO DE PRUEBA: {0}'.format(i)
        for j in range(0,len(COMANDOS)):
            ################# TESTING ##############
            algoritmo = COMANDOS[j].split()[3].split(".")[0]
            print "\nOrdenando con {0}... Espere...".format(algoritmo)
            print "Entrada: {0}".format("input/CP_{0}.txt".format(i))
            try:
                os.system(COMANDOS[j].format(i,algoritmo,i))
                print "Salida: {0}".format('output/OP_{0}_{1}.txt'.format(algoritmo,i))
                pass
            except Exception as e:
                print "Error en ejecución de ordenamiento {0}".format(algoritmo)
                exit()
            ########## Cargar útlimo Caso de Prueba creado ################
            try:
                L = leer_entrada('output/OP_{0}_{1}.txt'.format(algoritmo,i))
                pass
            except Exception as e:
                print "Error en la lectura de archivo de {0} ya ordendado ".format(algoritmo)
                exit()

            #################### PRUEBAS selection_sort ########################
            print "\nIniciando testing sobre {0}".format(algoritmo)
            for test in PRUEBAS:
                if test.split("(")[0] == 'orden_orden':
                    print "Prueba de sort(sort)... Espere..."
                    try:
                        resultado_test = orden_orden(L,i,algoritmo)
                        pass
                    except Exception as e:
                        print "Error en durante ejecución de prueba {0}".format(test.split("(")[0])
                        exit()
                else:
                    try:
                        resultado_test = eval(test.format(L,n))
                        pass
                    except Exception as e:
                        print "Error en durante ejecución de prueba {0}".format(test.split("(")[0])
                        exit()

                if resultado_test:
                    print 'Éxito en prueba: {0}'.format(test.split("(")[0])
                    resultado_test=False
                else:
                    print 'Fallo en prueba: {0}'.format(test.split("(")[0])
                    print 'CASO FALLIDO'
                    print L
                    exit()
    return True

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
                if (testing(TOTAL_PRUEBAS,MIN,MAX,N)):
                    print '\n\tPruebas realizadas con éxito\n\n'
            else:
                print 'Tamaño de la lista debe ser mayor que 0'
        else:
            print 'Número mínimo de elementos en la lista debe ser menor o igual al número máximo de elementos en la lista\n'
    else:
        print 'Número de pruebas a generar debe ser mayor que 0\n'
else:
    print 'Faltan o sobran argumentos\n\t ./test [CANTIDAD_PRUEBAS?A_GENERAR] [MIN_ELEMENTO_LISTA] [MAX_ELEMENTO_LISTA] [TAMAÑO_LISTA]\n'
