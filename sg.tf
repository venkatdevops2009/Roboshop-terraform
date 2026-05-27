############################################
# FRONTEND SECURITY GROUP
############################################

resource "aws_security_group" "frontend" {

  name        = "frontend-sg"
  description = "Frontend Security Group"

  ingress {
    description = "HTTP"

    from_port = 80
    to_port   = 80
    protocol  = "tcp"

    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS"

    from_port = 443
    to_port   = 443
    protocol  = "tcp"

    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH"

    from_port = 22
    to_port   = 22
    protocol  = "tcp"

    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {

    from_port = 0
    to_port   = 0
    protocol  = "-1"

    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "frontend-sg"
  }
}

############################################
# MONGODB SECURITY GROUP
############################################

resource "aws_security_group" "mongodb" {

  name        = "mongodb-sg"
  description = "MongoDB Security Group"

  ingress {

    description = "MongoDB Access"

    from_port = 27017
    to_port   = 27017
    protocol  = "tcp"

    security_groups = [
      aws_security_group.catalogue.id,
      aws_security_group.user.id
    ]
  }

  ingress {

    description = "SSH"

    from_port = 22
    to_port   = 22
    protocol  = "tcp"

    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {

    from_port = 0
    to_port   = 0
    protocol  = "-1"

    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "mongodb-sg"
  }
}

############################################
# REDIS SECURITY GROUP
############################################

resource "aws_security_group" "redis" {

  name        = "redis-sg"
  description = "Redis Security Group"

  ingress {

    description = "Redis Access"

    from_port = 6379
    to_port   = 6379
    protocol  = "tcp"

    security_groups = [
      aws_security_group.user.id,
      aws_security_group.cart.id,
      aws_security_group.shipping.id
    ]
  }

  ingress {

    description = "SSH"

    from_port = 22
    to_port   = 22
    protocol  = "tcp"

    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {

    from_port = 0
    to_port   = 0
    protocol  = "-1"

    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "redis-sg"
  }
}

############################################
# MYSQL SECURITY GROUP
############################################

resource "aws_security_group" "mysql" {

  name        = "mysql-sg"
  description = "MySQL Security Group"

  ingress {

    description = "MySQL Access"

    from_port = 3306
    to_port   = 3306
    protocol  = "tcp"

    security_groups = [
      aws_security_group.shipping.id
    ]
  }

  ingress {

    description = "SSH"

    from_port = 22
    to_port   = 22
    protocol  = "tcp"

    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {

    from_port = 0
    to_port   = 0
    protocol  = "-1"

    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "mysql-sg"
  }
}

############################################
# RABBITMQ SECURITY GROUP
############################################

resource "aws_security_group" "rabbitmq" {

  name        = "rabbitmq-sg"
  description = "RabbitMQ Security Group"

  ingress {

    description = "RabbitMQ Access"

    from_port = 5672
    to_port   = 5672
    protocol  = "tcp"

    security_groups = [
      aws_security_group.payment.id,
      aws_security_group.dispatch.id
    ]
  }

  ingress {

    description = "SSH"

    from_port = 22
    to_port   = 22
    protocol  = "tcp"

    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {

    from_port = 0
    to_port   = 0
    protocol  = "-1"

    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "rabbitmq-sg"
  }
}

############################################
# APPLICATION SECURITY GROUPS
############################################

resource "aws_security_group" "catalogue" {

  name = "catalogue-sg"

  ingress {

    description = "Catalogue API"

    from_port = 8080
    to_port   = 8080
    protocol  = "tcp"

    security_groups = [
      aws_security_group.frontend.id,
      aws_security_group.cart.id
    ]
  }

  ingress {

    description = "SSH"

    from_port = 22
    to_port   = 22
    protocol  = "tcp"

    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {

    from_port = 0
    to_port   = 0
    protocol  = "-1"

    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "catalogue-sg"
  }
}

resource "aws_security_group" "user" {

  name = "user-sg"

  ingress {

    description = "User API"

    from_port = 8080
    to_port   = 8080
    protocol  = "tcp"

    security_groups = [
      aws_security_group.frontend.id,
      aws_security_group.payment.id
    ]
  }

  ingress {

    description = "SSH"

    from_port = 22
    to_port   = 22
    protocol  = "tcp"

    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {

    from_port = 0
    to_port   = 0
    protocol  = "-1"

    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "user-sg"
  }
}

resource "aws_security_group" "cart" {

  name = "cart-sg"

  ingress {

    description = "Cart API"

    from_port = 8080
    to_port   = 8080
    protocol  = "tcp"

    security_groups = [
      aws_security_group.frontend.id,
      aws_security_group.shipping.id,
      aws_security_group.payment.id

    ]
  }

  ingress {

    description = "SSH"

    from_port = 22
    to_port   = 22
    protocol  = "tcp"

    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {

    from_port = 0
    to_port   = 0
    protocol  = "-1"

    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "cart-sg"
  }
}

resource "aws_security_group" "shipping" {

  name = "shipping-sg"

  ingress {

    description = "Shipping API"

    from_port = 8080
    to_port   = 8080
    protocol  = "tcp"

    security_groups = [
      aws_security_group.frontend.id
    ]
  }

  ingress {

    description = "SSH"

    from_port = 22
    to_port   = 22
    protocol  = "tcp"

    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {

    from_port = 0
    to_port   = 0
    protocol  = "-1"

    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "shipping-sg"
  }
}

resource "aws_security_group" "payment" {

  name = "payment-sg"

  ingress {

    description = "Payment API"

    from_port = 8080
    to_port   = 8080
    protocol  = "tcp"

    security_groups = [
      aws_security_group.frontend.id
    ]
  }

  ingress {

    description = "SSH"

    from_port = 22
    to_port   = 22
    protocol  = "tcp"

    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {

    from_port = 0
    to_port   = 0
    protocol  = "-1"

    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "payment-sg"
  }
}

resource "aws_security_group" "dispatch" {

  name = "dispatch-sg"

  ingress {

    description = "Dispatch API"

    from_port = 8080
    to_port   = 8080
    protocol  = "tcp"

    security_groups = [
      aws_security_group.frontend.id
    ]
  }

  ingress {

    description = "SSH"

    from_port = 22
    to_port   = 22
    protocol  = "tcp"

    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {

    from_port = 0
    to_port   = 0
    protocol  = "-1"

    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "dispatch-sg"
  }
}