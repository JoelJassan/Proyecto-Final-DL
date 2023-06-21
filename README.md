# Proyecto Final Diseño Logico

---

**Table of Contents**

- [Proyecto](#proyecto)
- [Consideraciones](#consideraciones)
- [Formateador de codigo](#formateador-de-codigo)
- [Forma de uso](#forma-de-uso)

## Proyecto

Implementar en VHDL un sistema de transmisión serial asíncrono capaz de mandar datos desde un
celular a través de un módulo bluetooth HC-05. Cada dato consiste en un carácter que identifica la
activación o desactivación de 4 luces. El sistema debe ser capaz de visualizar el estado de las
lámparas en un display LCD 2x16 y de activar o desactivar 4 leds representativos. Implementar el
diseño lógico y el testbench correspondiente.

Sugerencia: utilizar alguna aplicación de arduino destinada al control de luces.

## Consideraciones

El archivo .gitignore incluye todas las extensiones que genera Quartus 2, ModelSim y GHDL en su ejecucion y compilacion.

- Para ejecutar en FPGA
  Se necesita crear un proyecto en Quartus 2. El .gitignore admite archivos ".qar"
  Sobre ese proyecto agregar todos los archivos, considerando la entidad de mayor jerarquía.

- Para simulacion en GtkWave
  Es necesario tener las herramientas GHDL y GtkWave instaladas. Para distribuciones debian de linux basta con ejecutar los siguientes comandos:
  'sudo apt-get install GHDL'
  'sudo apt-get install gtkwave'
  Con esto bastaria para poder usar los comandos de @makefile

- Para simulacion en modelsim (en caso de no usar GtkWave)
  Se debe generar el proyecto desde modelsim, e ir agregando los archivos .vhd

## Formateador de codigo

VHDL Formatter
El proyecto tiene un "settings.json" integrado, por lo que deberia funcionar con este. De igual forma,
se deja la configuracion usada

En settings.json:

```
"vhdl.formatter.align.function": true,
"vhdl.formatter.case.keyword": "LowerCase",
"vhdl.formatter.case.typename": "LowerCase",
"vhdl.formatter.align.procedure": true,
"vhdl.formatter.align.port": true,
"vhdl.formatter.align.generic": true,
"vhdl.formatter.align.all": true,
"settingsSync.ignoredSettings": [
    "vhdl.formatter.align.all"
]
```
> Nota: al final del proyecto tuve que desactivar el formateador, porque deformaba lo que se escribe en pantalla. Si ocurre esto, basta con poner     `"editor.formatOnSave": false,`


## Forma de Uso

Se espera la siguiente estructura de proyecto:

```
DIRECTORIO_DEL_PROYECTO
|- components
|   |- archivos individuales (sin dependencias)
|
|- fpga
|   |- todos los archivos y directorios generados en Quartus II al crear un proyecto
|
|- main
|   |- archivo principal (del que se quiere hacer testbench)
|
|- source
|   |- archivos que tengan dependencias de los componentes
|
|- testbench
|   |- archivos de testbench
|
.gitignore
LICENSE.txt
makefile
README.md
```

Se estableceran las instrucciones para el uso del makefile con comandos make.

Previo a ejecutar un proyecto personal, se debe ingresar al makefile y configurar los siguientes parametros:

- `MAIN_FILE`: archivo a evaluar en testbench
- `TIME` : tiempo total de la simulacion

> Nota 1: puede que necesite cambiar el nombre de los directorios en la etiqueta #directorios del makefile (linea 1).
> Nota 2: makefile espera que el archivo de testbench tenga el mismo nombre que su archivo fuente. En caso de que sea distinto, reemplazar SRC_FILE en las lineas de makefile correspondientes.

Para realizar un proyecto personal, desde su compilacion hasta la visualizacion en GtkView, ejecutar:

- `make`: ejecuta los comandos 1, 2 y 3 (leer make all).

- `make all`: ejecuta los comandos a continuacion, en una unica instruccion:

1. `make compile`: compila los archivos de los directorios CMP_DIR, SRC_DIR, MAIN_DIR y TB_DIR. Necesariamente en ese orden
2. `make execute`: ejecuta el testbench correspondiente a SRC_FILE.
3. `make run`: corre el testbench correspondiente a TB_FILE, generando un archivo .vcd ejecutable.
4. `make view`: ejecuta el archivo .vcd a traves de GtkWave, permitiendo visualizar las formas de onda.

> Nota: si estos comandos se ejecutan en orden incorrecto, es probable que se obtenga un error. Para revertir esto, ejecutar 'make clean' y volver al paso '1.'.

- `make vcd`: genera un archivo temporal .vcd para eliminarse al hacer make clean (leer make clean)

- `make clean`: elimina los archivos .vcd y .cf generados.

# Licencia

Este código tiene licencia MIT. Ver [LICENSE.txt]().
