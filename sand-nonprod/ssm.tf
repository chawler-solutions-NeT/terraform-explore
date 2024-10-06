# resource "aws_ssm_parameter" "swarm_manager_token" {
#   name  = "/swarm/manager/token"
#   type  = "String"
#   value = ""
#   depends_on = [ aws_launch_template.manager_launch_template,  ]
# }

# resource "aws_ssm_parameter" "swarm_worker_token" {
#   name  = "/swarm/worker/token"
#   type  = "String"
#   value = ""
# }
