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
