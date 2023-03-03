#!/bin/bash

# Definir variables
PROJECT_ID="my-project"
REGION="us-central1"
FUNCTION_NAME="my-function"
MODEL_BUCKET_NAME="${PROJECT_ID}-model-bucket"
IMAGE_NAME="gcr.io/${PROJECT_ID}/${FUNCTION_NAME}"

# Crear bucket de Cloud Storage
gsutil ls "gs://${MODEL_BUCKET_NAME}" >/dev/null 2>&1 || gsutil mb -l "${REGION}" "gs://${MODEL_BUCKET_NAME}"

# Construir imagen de Docker
docker build -t "${IMAGE_NAME}" .

# Subir imagen a Google Container Registry
docker push "${IMAGE_NAME}"

# Desplegar función en Cloud Functions
gcloud functions deploy "${FUNCTION_NAME}" \
  --region "${REGION}" \
  --entry-point predict \
  --runtime python39 \
  --memory 128MB \
  --trigger-http \
  --allow-unauthenticated \
  --set-env-vars "MODEL_BUCKET_NAME=${MODEL_BUCKET_NAME}" \
  --set-env-vars "MODEL_FILENAME=pickle_model.pkl" \
  --set-env-vars "MODEL_PATH=/tmp/${MODEL_FILENAME}" \
  --set-env-vars "MODEL_URL=https://storage.googleapis.com/${MODEL_BUCKET_NAME}/${MODEL_FILENAME}" \
  --timeout 60 \
  --image "${IMAGE_NAME}"

echo "Listo!"