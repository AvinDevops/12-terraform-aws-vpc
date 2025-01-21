# output "all_azs" {
#     value = data.aws_availability_zones.available.names
# }

output "vpc_id" {
    value = aws_vpc.main.id
}

output "frontend_subnet_id" {
    value = aws_subnet.frontend[*].id
}

output "backend_subnet_id" {
    value = aws_subnet.backend[*].id

}

output "database_subnet_id" {
    value = aws_subnet.database[*].id
}

output "database_subnet_group_name" {
    value = aws_db_subnet_group.default.name
}