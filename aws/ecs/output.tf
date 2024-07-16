output "cluster_id" {
  value = aws_ecs_cluster.ecs_cluster.id
}

output "server_service_name" {
  value = aws_ecs_service.server_service.name
}

output "worker_service_name" {
  value = aws_ecs_service.worker_service.name
}
