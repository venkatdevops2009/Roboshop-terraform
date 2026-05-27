############################################
# MONGODB
############################################

resource "aws_instance" "mongodb" {

  ami           = "ami-0220d79f3f480ecf5"
  instance_type = "t3.micro"

  vpc_security_group_ids = [
    aws_security_group.mongodb.id
  ]

  user_data = file("${path.module}/scripts/mongodb.sh")

  tags = {
    Name = "mongodb"
  }
}

############################################
# REDIS
############################################

resource "aws_instance" "redis" {

  ami           = "ami-0220d79f3f480ecf5"
  instance_type = "t3.micro"

  vpc_security_group_ids = [
    aws_security_group.redis.id
  ]

  user_data = file("${path.module}/scripts/redis.sh")

  tags = {
    Name = "redis"
  }
}

############################################
# MYSQL
############################################

resource "aws_instance" "mysql" {

  ami           = "ami-0220d79f3f480ecf5"
  instance_type = "t3.micro"

  vpc_security_group_ids = [
    aws_security_group.mysql.id
  ]

  user_data = file("${path.module}/scripts/mysql.sh")

  tags = {
    Name = "mysql"
  }
} 

############################################
# RABBITMQ
############################################

resource "aws_instance" "rabbitmq" {

  ami           = "ami-0220d79f3f480ecf5"
  instance_type = "t3.micro"

  vpc_security_group_ids = [
    aws_security_group.rabbitmq.id
  ]

  user_data = file("${path.module}/scripts/rabbitmq.sh")

  tags = {
    Name = "rabbitmq"
  }
}

############################################
# CATALOGUE
############################################

resource "aws_instance" "catalogue" {

  ami           = "ami-0220d79f3f480ecf5"
  instance_type = "t3.micro"

  vpc_security_group_ids = [
    aws_security_group.catalogue.id
  ]

  user_data = templatefile(
    "${path.module}/scripts/catalogue.sh",
    {
      MONGO_IP = aws_instance.mongodb.private_ip
    }
  )

  depends_on = [
    aws_instance.mongodb
  ]

  tags = {
    Name = "catalogue"
  }
}

############################################
# USER
############################################

resource "aws_instance" "user" {

  ami           = "ami-0220d79f3f480ecf5"
  instance_type = "t3.micro"

  vpc_security_group_ids = [
    aws_security_group.user.id
  ]

  user_data = templatefile(
    "${path.module}/scripts/user.sh",
    {
      MONGO_IP = aws_instance.mongodb.private_ip
      REDIS_IP = aws_instance.redis.private_ip
    }
  )

  depends_on = [
    aws_instance.mongodb,
    aws_instance.redis
  ]

  tags = {
    Name = "user"
  }
}

############################################
# CART
############################################

resource "aws_instance" "cart" {

  ami           = "ami-0220d79f3f480ecf5"
  instance_type = "t3.micro"

  vpc_security_group_ids = [
    aws_security_group.cart.id
  ]

  user_data = templatefile(
    "${path.module}/scripts/cart.sh",
    {
      REDIS_IP     = aws_instance.redis.private_ip
      USER_IP      = aws_instance.user.private_ip
      CATALOGUE_IP = aws_instance.catalogue.private_ip
    }
  )

  depends_on = [
    aws_instance.redis,
    aws_instance.user,
    aws_instance.catalogue
  ]

  tags = {
    Name = "cart"
  }
}

############################################
# SHIPPING
############################################

resource "aws_instance" "shipping" {

  ami           = "ami-0220d79f3f480ecf5"
  instance_type = "t3.micro"
  instance_market_options {
    market_type = "spot"
  }

  vpc_security_group_ids = [
    aws_security_group.shipping.id
  ]

  user_data = templatefile(
    "${path.module}/scripts/shipping.sh",
    {
      MYSQL_IP = aws_instance.mysql.private_ip
      CART_IP  = aws_instance.cart.private_ip
    }
  )

  depends_on = [
    aws_instance.mysql,
    aws_instance.cart
  ]

  tags = {
    Name = "shipping"
  }
}

############################################
# PAYMENT
############################################

resource "aws_instance" "payment" {

  ami           = "ami-0220d79f3f480ecf5"
  instance_type = "t3.micro"
  instance_market_options {
    market_type = "spot"
  }

  vpc_security_group_ids = [
    aws_security_group.payment.id
  ]

  user_data = templatefile(
    "${path.module}/scripts/payment.sh",
    {
      RABBITMQ_IP = aws_instance.rabbitmq.private_ip
      CART_IP     = aws_instance.cart.private_ip
      USER_IP     = aws_instance.user.private_ip
    }
  )

  depends_on = [
    aws_instance.rabbitmq,
    aws_instance.cart,
    aws_instance.user
  ]

  tags = {
    Name = "payment"
  }
}

############################################
# DISPATCH
############################################

resource "aws_instance" "dispatch" {

  ami           = "ami-0220d79f3f480ecf5"
  instance_type = "t3.micro"

  vpc_security_group_ids = [
    aws_security_group.dispatch.id
  ]

  user_data = templatefile(
    "${path.module}/scripts/dispatch.sh",
    {
      RABBITMQ_IP = aws_instance.rabbitmq.private_ip
    }
  )

  depends_on = [
    aws_instance.rabbitmq
  ]

  tags = {
    Name = "dispatch"
  }
}

############################################
# FRONTEND
############################################

resource "aws_instance" "frontend" {

  ami           = "ami-0220d79f3f480ecf5"
  instance_type = "t3.micro"
  instance_market_options {
    market_type = "spot"
  }

  vpc_security_group_ids = [
    aws_security_group.frontend.id
  ]

  user_data = templatefile(
    "${path.module}/scripts/frontend.sh",
    {
      CATALOGUE_IP = aws_instance.catalogue.private_ip
      USER_IP      = aws_instance.user.private_ip
      CART_IP      = aws_instance.cart.private_ip
      SHIPPING_IP  = aws_instance.shipping.private_ip
      PAYMENT_IP   = aws_instance.payment.private_ip
    }
  )

  depends_on = [
    aws_instance.catalogue,
    aws_instance.user,
    aws_instance.cart,
    aws_instance.shipping,
    aws_instance.payment
  ]

  tags = {
    Name = "frontend"
  }
} 