resource "aws_route53_record" "frontend" {
  zone_id = "Z0353101YWAUTK0SB32S"
  name    = "piridishop.shop"
  type    = "A"
  ttl     = 1
  records = [aws_instance.frontend.public_ip]
}