#### Project variables ####
variable "project_name" {
    type = string

}

variable "environment" {
    type = string
}

variable "common_tags" {
    type = map
    default = {}

}

#### vpc variables ####
variable "cidr_block" {
    type = string
    default = "10.0.0.0/16"
}

variable "enable_dns_hostnames" {
    type = bool
    default = true

}

variable "vpc_tags" {
    type = map
    default = {}
}

#### igw variables ####
variable "igw_tags" {
    type = map
    default = {}
}

#### frontend subnet variables ####
variable "frontend_subnet_cidrs" {
    type = list

    validation {
        condition = length(var.frontend_subnet_cidrs) == 2
        error_message = "please enter 2 valid frontend subnet cidrs"
    }
}

variable "frontend_subnet_tags" {
    type = map
    default = {}
}

#### backend subnet variables ####
variable "backend_subnet_cidrs" {
    type = list

    validation {
        condition = length(var.backend_subnet_cidrs) == 2
        error_message = "please enter 2 valid backend subnet cidrs"
    }
}

variable "backend_subnet_tags" {
    type = map
    default = {}
}

#### database subnet variables ####
variable "database_subnet_cidrs" {
    type = list

    validation {
        condition = length(var.database_subnet_cidrs) == 2
        error_message = "please enter 2 valid database subnet cidrs"
    }
}

variable "database_subnet_tags" {
    type = map
    default = {}
}

#### nat gateway variables ####
variable "nat_gateway_tags" {
    type = map
    default = {}
}


#### peering variables ####
variable "is_peering_required" {
    type = bool
    default = false
}

variable "acceptor_vpc_id" {
    type = string
    default = ""
}

variable "vpc_peering_tags" {
    type = map
    default = {}
}