# AWS custom vpc module

## Resources created
* vpc
* internet gateway
* attached internet gateway to vpc
* 2 frontend subnets
* 2 backend subnets
* 2 database subnets
* route tables for frontend, backend, database
* added routes igw for frontend, nat for backend and database
* elastic ip
* nat gateway
* vpc peering connection
* added routes for required subnets from requestor to acceptor(dest) and acceptor to requestor(dest)

## Inputs
* project_name(req) : default is expense, type is string
* environment(optional) : default is dev, type is string
* common_tags(optional) : user should provide their related tags, type is map
* cidr_block(optional) : default is 10.0.0.0/16, type is string
* enable_dns_hostname(optional) : default is true, type is bool
* vpc_tags(optional) : user should provide if required, type is map
* igw_tags(optional): user should provide if required, type is map
* frontend_subnet_cidrs(required) : user will provide 2 valid cidrs, type is list
* frontend_subnet_tags(optonal) : user need to give, type is map
* backend_subnet_cidrs(required) : user will provide 2 valid cidrs, type is list
* backend_subnet_tags(optonal) : user need to give, type is map
* database_subnet_cidrs(required) : user will provide 2 valid cidrs, type is list
* database_subnet_tags(optonal) : user need to give, type is map
* nat_gateway_tags(optional) : default is empty, type is map
* is_peering_required(optional) : default is false, type is bool
* acceptor_vpc_id(optional) : default is empty, type is string
* peering_tags(optional) : default is empty, type is map

## Outputs
* vpc_id : print vpc id, type is string
* frontend_subnet_id : prints 2 frontend subnet ids , type is list
* backend_subnet_id : prints 2 backend subnet ids, type is list
* database_subnet_id : prints 2 database subnet ids, type is list