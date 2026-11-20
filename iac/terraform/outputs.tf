output "ecr_repository_url" {
  description = "URL del repositorio ECR para las imagenes del backend"
  value       = aws_ecr_repository.backend.repository_url
}

output "imagen_parametro" {
  description = "Nombre del parametro SSM que guarda la etiqueta de la imagen desplegada"
  value       = aws_ssm_parameter.imagen_backend.name
}