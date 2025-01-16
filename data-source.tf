### fetching all availability zones from curent region ###
data "aws_availability_zones" "available" {
  state = "available"
}

### fetching default vpc details ###
data "aws_vpc" "default" {
  default = true
}

### fetching default vpc main route table id ###
data "aws_route_table" "main" {
  vpc_id = data.aws_vpc.default.id
  filter {
    name = "association.main"
    values = ["true"]
  }
}