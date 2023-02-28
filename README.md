# Predicción de atraso de vuelos

Este proyecto consiste en desarrollar una API que permita predecir la probabilidad de atraso de los vuelos que aterrizan o despegan del aeropuerto de Santiago de Chile (SCL), utilizando un modelo de Machine Learning previamente entrenado. También se incluye la automatización del proceso de construcción y despliegue de la API en un servicio cloud.

## Estructura del proyecto

El proyecto está organizado en las siguientes carpetas y archivos:

- `app/`: Contiene el código fuente de la API.
- `data/`: Contiene los datasets utilizados para el entrenamiento y prueba del modelo.
- `terraform/`: Contiene los archivos de configuración de Terraform para la creación de la infraestructura en GCP.
- `test_scripts/`: Contiene el archivo .jmx para la realización de las pruebas de estrés.
- `model/`: Contiene el modelo serializado previamente entrenado.
- `app.py`: Archivo que contiene el código para definir la API.
- `main.tf`: Archivo de configuración principal de Terraform.

## Requisitos previos

Antes de ejecutar este proyecto, es necesario contar con los siguientes requisitos:

- Tener instalado Python 3.
- Tener una cuenta en GCP con los permisos necesarios para crear recursos en el proyecto.
- Tener instalado Terraform en la máquina local.

## Instalación

Para instalar la aplicación, se deben seguir los siguientes pasos:

1. Clonar el repositorio.
2. Instalar las dependencias de Python desde el archivo `requirements.txt`.
3. Configurar las credenciales de GCP en la máquina local.
4. Ejecutar el comando `terraform apply` desde la carpeta `terraform` para crear la infraestructura en GCP.
5. Ejecutar el comando `python app.py` desde la carpeta `app` para levantar la API.

## Ejemplo de entrada

La API espera recibir un objeto JSON con los siguientes campos:

```json
{
  "fecha": "2022-01-01",
  "hora": "08:00",
  "vuelo": "LA1234",
  "origen": "SCL",
  "destino": "LIM",
  "aerolinea": "LATAM",
  "dia": 1,
  "mes": 1,
  "ano": 2022,
  "dianom": "Sabado",
  "tipovuelo": "Internacional",
  "opera": "LATAM Airlines Group",
  "siglaori": "Santiago",
  "siglades": "Lima"
}
```

## Ejemplo de Salida

La API devuelve un objeto JSON con la probabilidad de atraso:

```json
{
      "atraso": 0.3

}
```
## Prueba de Stress
Se ha incluido un archivo .jmx en la carpeta test_scripts para la realización de pruebas de estrés con la herramienta JMeter. Se deben seguir los siguientes pasos para ejecutar las pruebas:

1. Instalar JMeter en la máquina local.
2. Abrir el archivo .jmx en JMeter.
3. Configurar el número de usuarios y la duración de la prueba.
4. Ejecutar la prueba.