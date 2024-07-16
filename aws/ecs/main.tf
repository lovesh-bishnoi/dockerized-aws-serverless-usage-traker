# Define the ECS cluster
resource "aws_ecs_cluster" "ecs_cluster" {
  name = "ecs-cluster"
}

# Define the task definition for the server container
resource "aws_ecs_task_definition" "server_task" {
  family                   = "server-task"
  network_mode             = "awsvpc"
  cpu                      = 256
  memory                   = 512
  execution_role_arn       = var.execution_role_arn
  task_role_arn            = var.task_role_arn
  requires_compatibilities = ["FARGATE"]

  container_definitions = jsonencode([
    {
      name        = "server-container"
      image       = "${var.ecr_repository_url}/${var.ecr_server_repo_name}:${var.imageversion}"
      essential   = true
      portMappings = [
        {
          containerPort = 5000
          hostPort      = 5000
        }
      ]
      environment = [
        {
          name  = "USER_TABLE"
          value = var.user_table_name
        },
        {
          name  = "VERSION"
          value = "0.0.1"
        }
      ]
    }
  ])
}

# Define the task definition for the worker container
resource "aws_ecs_task_definition" "worker_task" {
  family                   = "worker-task"
  network_mode             = "awsvpc"
  cpu                      = 256
  memory                   = 512
  execution_role_arn       = var.execution_role_arn
  task_role_arn            = var.task_role_arn
  requires_compatibilities = ["FARGATE"]

  container_definitions = jsonencode([
    {
      name        = "worker-container"
      image       = "${var.ecr_repository_url}/${var.ecr_worker_repo_name}:${var.imageversion}"
      essential   = true
      environment = [
        {
          name  = "USER_TABLE"
          value = var.user_table_name
        },
        {
          name  = "QUEUE_URL"
          value = var.sqs_queue_url
        }
      ]
    }
  ])
}

# Define the ECS service for the server container
resource "aws_ecs_service" "server_service" {
  name            = "server-service"
  cluster         = aws_ecs_cluster.ecs_cluster.id
  task_definition = aws_ecs_task_definition.server_task.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets         = var.subnets
    assign_public_ip = true
    security_groups = var.security_groups
  }
}

# Define the ECS service for the worker container
resource "aws_ecs_service" "worker_service" {
  name            = "worker-service"
  cluster         = aws_ecs_cluster.ecs_cluster.id
  task_definition = aws_ecs_task_definition.worker_task.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets         = var.subnets
    assign_public_ip = true
    security_groups = var.security_groups
  }
}
