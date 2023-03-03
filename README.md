# Proyecto SRE Challenge -  Implementación de API REST para modelo de predicción de retrasos en vuelos

En este desafío, se nos proporcionó un Jupyter Notebook que contiene el trabajo de un Data Scientist y un ML Engineer. El objetivo del DS era predecir la probabilidad de atraso de los vuelos que aterrizan o despegan del aeropuerto de Santiago de Chile (SCL). Ahora, como SRE Engineer, nuestro desafío consiste en tomar el trabajo del equipo y exponerlo para que sea explotado por un sistema.

## Solución propuesta
Para resolver el problema propuesto, se ha decidido utilizar Flask para crear una API REST que permita exponer el modelo serializado. También se utilizará Google Cloud Platform (GCP) para automatizar el proceso de construcción y despliegue de la API, utilizando uno o varios servicios cloud, incluyendo Storage para guardar el depósito de Cloud Storage donde se almacenará tanto el código de Cloud Function (paquete zip) como el archivo del modelo. Además, se habilitarán las API de Google Cloud necesarias para que el proyecto funcione correctamente.

## Estructura del directorio
```css

├── api/
│   ├── __init__.py
│   ├── app.py
│   ├── models/
│   │   ├── __init__.py
│   │   └── pickle_model.pkl
│   └── requirements.txt
├── .gitignore
├── cloudbuild.yaml
├── data/
│   ├── test.csv
│   ├── train.csv
│   ├── x_test.csv
│   ├── x_train.csv
│   ├── y_test.csv
│   └── y_train.csv
├── main.py
├── README.md
├── scripts/
│   ├── deploy.sh
│   ├── install_terraform.sh
│   ├── terraform.tf
│   ├── terraform.tfstate
│   └── variables.tf
└── .github/workflows/
    ├── deploy.yaml
    └── stress-test.yaml
├── tests/load-test.lua

```

El proyecto está organizado en las siguientes carpetas y archivos:

- api: Contiene el código fuente de la API REST.
- api/app.py: Código de la aplicación Flask.
- api/models: Contiene el modelo serializado.
- api/requirements.txt: Archivo que contiene las dependencias de Python necesarias para la API REST.
- terraform: Contiene el archivo de configuración de Terraform.
- terraform/main.tf: Archivo de configuración principal de Terraform.
- terraform/variables.tf: Archivo de definición de variables de Terraform.
- terraform/provider.tf: Archivo que define el proveedor de la nube.
- cloudbuild.yaml: Archivo de configuración de Cloud Build.
- README.md: Archivo de documentación principal.
- .github/workflows/deploy.yaml: Archivo de configuración de GitHub Actions.
- scripts: Contiene scripts para instalar Terraform y ejecutar los comandos de Terraform.

## Tecnologías utilizadas
- Python 3
- Flask
- Gunicorn
- Docker
- Terraform
- Github Actions
- Google Cloud Platform (GCP)

## Requisitos previos

Antes de ejecutar este proyecto, es necesario contar con los siguientes requisitos:

- Tener instalado Python 3.
- Tener una cuenta en GCP con los permisos necesarios para crear recursos en el proyecto.
- Tener instalado Terraform en la máquina local.

## Paso 1: Preparar el ambiente de desarrollo
1. Clonar el repositorio: git clone https://github.com/xuanox/SRE-Challenge-Options.git
2. Instalar las dependencias: pip install -r api/requirements.txt

## Paso 2: Entrenar y serializar el modelo
1. Abrir el archivo api/train_model.ipynb en Jupyter Notebook.
2. Ejecutar todas las celdas para entrenar el modelo y serializarlo.
3. Se generará el archivo pickle_model.pkl en la carpeta api/models/

# Paso 3: Crear y desplegar la aplicación en GCP
1. Crear un proyecto en GCP.
2. Habilitar las siguientes APIs: Cloud Functions, Cloud Pub/Sub y Container Registry.
3. Crear un depósito de Cloud Storage en el proyecto.
4. Crear una cuenta de servicio con el rol Editor y descargar la clave JSON.
5. Configurar el archivo scripts/variables.tf con las 6. variables necesarias: nombre del proyecto, nombre de la cuenta de servicio y ruta del archivo de clave JSON.
7. Crear la infraestructura ejecutando el script scripts/install_terraform.sh.
8. Desplegar la aplicación ejecutando el script scripts/deploy.sh.

## Paso 5: Automatizar el proceso de construcción y despliegue con Terraform y Github Actions

Para automatizar el proceso de construcción y despliegue de la aplicación, vamos a utilizar Terraform y Github Actions.

###  Configuración de Terraform
Primero, necesitamos configurar Terraform para que pueda crear los recursos necesarios en GCP.

1. En la raíz del proyecto, crearemos un archivo llamado variables.tf con las variables necesarias para configurar la aplicación. Estas variables incluyen el nombre del proyecto de GCP, la región y zona de GCP en la que se desplegarán los recursos, el nombre de la función de Cloud Functions y la ruta al archivo del modelo serializado. 
        ```json
        #variables.tf 

        variable "project_id" {
          description = "ID del proyecto de GCP"
        }

        variable "region" {
          description = "Región donde se desplegarán los recursos de GCP"
        }

        variable "model_bucket_name" {
          description = "Nombre del bucket de Cloud Storage donde se almacenará el modelo serializado"
        }

        variable "model_file_name" {
          description = "Nombre del archivo que contendrá el modelo serializado"
          default     = "pickle_model.pkl"
        }
        variable "model_path" {
          description = "The path to the serialized model file"
          default     = "api/models/pickle_model.pkl"
        }
        variable "github_owner" {
          description = "Propietario del repositorio de GitHub"
        }

        variable "github_repo" {
          description = "Nombre del repositorio de GitHub"
        }

        variable "github_branch" {
          description = "Nombre de la rama del repositorio de GitHub"
        }

        variable "function_name" {
          description = "Nombre de la función de Cloud Functions que se desplegará"
        }
        ```
2. A continuación, crearemos un archivo llamado main.tf con la configuración de los recursos de GCP que necesitamos para desplegar la aplicación. En este caso, necesitamos crear una función de Cloud Functions, un bucket de Cloud Storage para almacenar el modelo serializado y un servicio de Cloud Pub/Sub para recibir las notificaciones de Cloud Build.

``` json

```
Finalmente, debemos configurar Cloud Build para que se despliegue nuestra aplicación cuando haya cambios en el repositorio. Para ello, creamos el archivo cloudbuild.yaml en la raíz del repositorio y añadimos el siguiente código:

````bash
steps:
  # Descargar los archivos del repositorio
  - name: 'gcr.io/cloud-builders/git'
    args: ['clone', '--depth=1', '--branch=$BRANCH_NAME', '--single-branch', 'https://github.com/xuanox/SRE-Challenge-Options.git', '.']

  # Construir el contenedor de la aplicación
  - name: 'gcr.io/cloud-builders/docker'
    args: ['build', '-t', 'gcr.io/$PROJECT_ID/flights-prediction', '.']

  # Subir el contenedor a Container Registry
  - name: 'gcr.io/cloud-builders/docker'
    args: ['push', 'gcr.io/$PROJECT_ID/flights-prediction']

  # Desplegar la aplicación en Cloud Functions
  - name: 'gcr.io/cloud-builders/gcloud'
    args: ['functions', 'deploy', 'flights_prediction', '--region', '$REGION', '--memory', '512MB', '--runtime', 'python39', '--trigger-http', '--update-env-vars', 'MODEL_BUCKET=$MODEL_BUCKET,MODEL_FILE=pickle_model.pkl,PORT=8080', '--set-env-vars', 'GOOGLE_CLOUD_PROJECT=$PROJECT_ID']

  # Notificar la finalización del despliegue a través de Cloud Pub/Sub
  - name: 'gcr.io/cloud-builders/gcloud'
    entrypoint: 'bash'
    args:
      - '-c'
      - |
        echo "Despliegue completado" | gcloud pubsub topics publish $CLOUD_BUILD_TOPIC --attribute=build_id=$BUILD_ID --attribute=commit_sha=$COMMIT_SHA

````
Este archivo define un flujo de trabajo para Cloud Build que incluye los siguientes pasos:

- Descargar los archivos del repositorio.
- Construir el contenedor de la aplicación.
- Subir el contenedor a Container Registry.
- Desplegar la aplicación en Cloud Functions.
- Notificar la finalización del despliegue a través de Cloud Pub/Sub.
- El archivo utiliza variables de entorno que deben definirse en el archivo terraform.tfvars para que Cloud Build pueda realizar el despliegue correctamente.

Una vez que se han configurado todos los recursos de GCP y se han definido los archivos de configuración, podemos ejecutar los siguientes comandos para desplegar la aplicación:

````bash
terraform init
terraform apply
````
Estos comandos crearán los recursos de GCP necesarios y desplegarán la aplicación en Cloud Functions. Una vez que se haya completado el despliegue, Cloud Build notificará la finalización a través de Cloud Pub/Sub y el modelo serializado se almacenará en el bucket de Cloud Storage que hemos creado.

##Paso 4: Probar la aplicación


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
## Paso 5: Realizar pruebas de estrés

Para realizar pruebas de estrés a la aplicación, usaremos la herramienta wrk, que es una herramienta de benchmarking HTTP de código abierto. Con wrk, podemos simular múltiples solicitudes HTTP concurrentes y medir el rendimiento de la aplicación.

Para realizar las pruebas de estrés, seguir estos pasos:

- Instalar wrk en el sistema local.

- Crear un archivo de script de prueba de carga. En este archivo, se define el número de solicitudes y la tasa de solicitudes por segundo.

- Ejecutar el script de prueba de carga con wrk. La salida de wrk incluye estadísticas sobre el rendimiento de la aplicación, como el número de solicitudes por segundo y el tiempo de respuesta promedio.

- Analizar los resultados y ajustar la configuración de la aplicación y del entorno según sea necesario.

## Paso 6: Definir mecanismos ideales para que sólo sistemas autorizados puedan acceder a esta API

Los mecanismos ideales para que sólo sistemas autorizados puedan acceder a esta API son los siguientes:
- Autenticación y autorización: Se puede implementar un sistema de autenticación y autorización para permitir el acceso sólo a sistemas autorizados. Por ejemplo, se puede usar OAuth2 para autenticar a los clientes y JWT para autorizarlos.
- Lista blanca de direcciones IP: Se puede configurar la API para que sólo acepte solicitudes de direcciones IP específicas. De esta manera, sólo los sistemas autorizados que tengan una dirección IP permitida podrán acceder a la API.

Este mecanismo puede agregar cierto nivel de latencia al consumidor, ya que se necesita tiempo para autenticar y autorizar la solicitud antes de que se pueda acceder a la API. Sin embargo, la latencia se puede minimizar utilizando mecanismos de autenticación y autorización eficientes y rápidos tales como:
- OAuth2: permite la autenticación y autorización de aplicaciones de terceros utilizando tokens de acceso en lugar de contraseñas.
- API Keys: un valor secreto que se usa para autenticar y autorizar solicitudes a la API.
- JWT (JSON Web Token): un estándar abierto para la creación de tokens de acceso que pueden ser verificados y confiados.
- Certificados digitales: se utiliza para autenticar y autorizar solicitudes mediante la verificación de un certificado digital emitido por una entidad de certificación confiable.

Estos mecanismos de autenticación y autorización son rápidos y eficientes porque no requieren una interacción adicional con el usuario después de la autenticación inicial y se pueden verificar de manera eficiente en el servidor sin cargar demasiado la red o el procesador.

## Paso 7: Definir SLIs y SLOs

Para medir el rendimiento y la disponibilidad de la aplicación, se pueden definir los siguientes SLIs (Service Level Indicators) y SLOs (Service Level Objectives):

- Tiempo de respuesta promedio de la aplicación (SLI)
- Disponibilidad de la aplicación (SLI) de un 99,99%
- Porcentaje de solicitudes exitosas del 99% (SLO)
- Porcentaje de solicitudes con tiempo de respuesta inferior a un 400ms (SLO) 
- Uso de recursos inferior a 512 MB
- Escalabilidad: La capacidad de la API para manejar un aumento en el número de solicitudes sin afectar el tiempo de respuesta o la tasa de errores. El objetivo podría ser que la API pueda manejar un aumento del 100% en el número de solicitudes sin afectar la calidad del servicio.

Los SLOs deben definirse en función de los requisitos del negocio y la experiencia del usuario. Por ejemplo, un SLO común para una aplicación web es tener una disponibilidad del 99.9% y un tiempo de respuesta promedio inferior a 200 ms.

Estos SLIs y SLOs se definen para garantizar que la API se mantenga en línea con las expectativas del usuario en términos de disponibilidad y calidad del servicio. También permiten medir el rendimiento de la API y proporcionan una base para mejorar la experiencia del usuario en el futuro.

## Conclusiones

En este proyecto, se implementó una aplicación de predicción de retrasos de vuelos utilizando un modelo de aprendizaje automático y una API REST en Cloud Functions de GCP. La aplicación se despliega automáticamente en GCP utilizando Terraform y GitHub Actions, y se almacena en un repositorio de GitHub.

Se realizaron pruebas de estrés con la herramienta wrk para medir el rendimiento de la aplicación y se definieron SLIs y SLOs para medir la disponibilidad
