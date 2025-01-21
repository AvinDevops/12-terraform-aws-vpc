### creating vpc ###
resource "aws_vpc" "main" {
  cidr_block       = var.cidr_block
  instance_tenancy = "default"
  enable_dns_hostnames = var.enable_dns_hostnames

  tags = merge(
    var.common_tags,
    var.vpc_tags,
    {
      Name = local.resource_name
    }
  )
}

### creating igw ###
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = merge(
    var.common_tags,
    var.igw_tags,
    {
      Name = local.resource_name
    }
  )
}

### creating frontend subnet ###
resource "aws_subnet" "frontend" {
  count = length(var.frontend_subnet_cidrs)
  vpc_id     = aws_vpc.main.id
  availability_zone = local.zone_names[count.index]
  map_public_ip_on_launch = true 
  cidr_block = var.frontend_subnet_cidrs[count.index]

  tags = merge (
    var.common_tags,
    var.frontend_subnet_tags,
    {
      Name = "${local.resource_name}-frontend-${local.zone_names[count.index]}"
    }
  )
}

### creating backend subnet ###
resource "aws_subnet" "backend" {
  count = length(var.backend_subnet_cidrs)
  vpc_id = aws_vpc.main.id
  availability_zone = local.zone_names[count.index]
  cidr_block = var.backend_subnet_cidrs[count.index]

  tags = merge(
    var.common_tags,
    var.backend_subnet_tags,
    {
      Name = "${local.resource_name}-backend-${local.zone_names[count.index]}"
    }
  )
}

### creating database subnet ###
resource "aws_subnet" "database" {
  count = length(var.database_subnet_cidrs)
  vpc_id = aws_vpc.main.id
  availability_zone = local.zone_names[count.index]
  cidr_block = var.database_subnet_cidrs[count.index]

  tags = merge(
    var.common_tags,
    var.database_subnet_tags,
    {
      Name = "${local.resource_name}-database-${local.zone_names[count.index]}"
    }
  )
}

### creating db subnet group ###
resource "aws_db_subnet_group" "default" {
  name       = "${local.resource_name}"
  subnet_ids = aws_subnet.database[*].id

  tags = merge(
    var.common_tags,
    var.database_subnet_group_tags,
    {
        Name = "${local.resource_name}"
    }
  )
}

### creating elastic ip ###
resource "aws_eip" "nat" {
  domain = "vpc"
}

### creating nat gateway and associating to eip ###
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id = aws_subnet.frontend[0].id #expense-dev-frontend-us-east-1a

  tags = merge(
    var.common_tags,
    var.nat_gateway_tags,
    {
      Name = local.resource_name #expense-dev
    }
  )
}

### creating route tables ###
## frontend route table ##
resource "aws_route_table" "frontend" {
  vpc_id = aws_vpc.main.id

  tags = merge(
    var.common_tags,
    {
      Name = "${local.resource_name}-frontend"
    }
  )
}

## backend route table ##
resource "aws_route_table" "backend" {
  vpc_id = aws_vpc.main.id

  tags = merge(
    var.common_tags,
    {
      Name = "${local.resource_name}-backend"
    }
  )
}

## database route table ##
resource "aws_route_table" "database" {
  vpc_id = aws_vpc.main.id

  tags = merge(
    var.common_tags,
    {
      Name = "${local.resource_name}-database"
    }
  )
}

### adding routes to route tables ###
resource "aws_route" "frontend" {
  route_table_id = aws_route_table.frontend.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.gw.id
}

resource "aws_route" "backend" {
  route_table_id = aws_route_table.backend.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id = aws_nat_gateway.nat.id
}

resource "aws_route" "database" {
  route_table_id = aws_route_table.database.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id = aws_nat_gateway.nat.id
}

### route table and routes association with subnets ###
resource "aws_route_table_association" "frontend" {
  count = length(var.frontend_subnet_cidrs)
  subnet_id = aws_subnet.frontend[count.index].id
  route_table_id = aws_route_table.frontend.id
}

resource "aws_route_table_association" "backend" {
  count = length(var.backend_subnet_cidrs)
  subnet_id = aws_subnet.backend[count.index].id
  route_table_id = aws_route_table.backend.id
}

resource "aws_route_table_association" "database" {
  count = length(var.database_subnet_cidrs)
  subnet_id = aws_subnet.database[count.index].id
  route_table_id = aws_route_table.database.id
}