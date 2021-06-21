# resource "aws_ecs_service" "odilo-ngnix" {
#   name            = "odilo-ngnix"
#   cluster         = aws_ecs_cluster.cluster.id
#   task_definition = aws_ecs_task_definition.web_server.arn
#   desired_count   = 2
#   iam_role        = aws_iam_role.ecs_service_role.arn
#   depends_on      = [aws_iam_role.ecs_service_role, aws_lb.front_end, aws_lb_target_group.tg_ecs]

# #   ordered_placement_strategy {
# #     type  = "binpack"
# #     field = "cpu"
# #   }

#   load_balancer {
#     target_group_arn = aws_lb_target_group.tg_ecs.arn
#     container_name   = "odilo-ngnix"
#     container_port   = 80
#   }

#   placement_constraints {
#     type       = "memberOf"
#     expression = "attribute:ecs.availability-zone in [${var.region}a, ${var.region}b, ${var.region}c]"
#   }
# }