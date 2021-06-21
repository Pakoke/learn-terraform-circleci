output "Endpoint" {
  value = "http://${module.ecs_cluster.elb_default_dns}/health"
}