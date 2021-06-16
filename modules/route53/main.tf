# resource "aws_route53_zone" "main" {
#   name = "pacoke.info"
# }

# resource "aws_route53_zone" "odilo" {
#   name = "odilo.pacoke.info"

#   tags = {
#     Environment = "dev"
#   }
# }

# resource "aws_route53_record" "odilo-ns" {
#   zone_id = aws_route53_zone.main.zone_id
#   name    = "odilo.pacoke.info"
#   type    = "NS"
#   ttl     = "30"
#   records = aws_route53_zone.odilo.name_servers
# }