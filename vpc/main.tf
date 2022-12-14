### VPC ###

resource "aws_vpc" "main" {
  cidr_block           = var.cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name        = "${var.name}-vpc-${var.environment}"
    Environment = var.environment
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name        = "${var.name}-igw-${var.environment}"
    Environment = var.environment
  }
}


resource "aws_subnet" "private" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = element(var.private_subnets, count.index)
  availability_zone = element(var.availability_zones, count.index)
  count             = length(var.private_subnets)

  tags = {
    Name        = "${var.name}-private-subnet-${var.environment}-${format("%03d", count.index+1)}"
    Environment = var.environment
  }
}


resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = element(var.public_subnets, count.index)
  availability_zone       = element(var.availability_zones, count.index)
  count                   = length(var.public_subnets)
  map_public_ip_on_launch = true

  tags = {
    Name        = "${var.name}-public-subnet-${var.environment}-${format("%03d", count.index+1)}"
    Environment = var.environment
  }
}


# public subnet traffic through internet gateway
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name        = "${var.name}-routing-table-public"
    Environment = var.environment
  }
}

resource "aws_route" "public" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.main.id
}

resource "aws_route_table_association" "public" {
  count          = length(var.public_subnets)
  subnet_id      = element(aws_subnet.public.*.id, count.index)
  route_table_id = aws_route_table.public.id
}


# private subnet traffic routed through NAT gateway 
resource "aws_route_table" "private" {
  count  = length(var.private_subnets)
  vpc_id = aws_vpc.main.id

  tags = {
    Name        = "${var.name}-routing-table-private-${format("%03d", count.index+1)}"
    Environment = var.environment
  }
}

resource "aws_route" "private" {
  count                  = length(compact(var.private_subnets))
  route_table_id         = element(aws_route_table.private.*.id, count.index)
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = element(aws_nat_gateway.main.*.id, count.index)
}

resource "aws_route_table_association" "private" {
  count          = length(var.private_subnets)
  subnet_id      = element(aws_subnet.private.*.id, count.index)
  route_table_id = element(aws_route_table.private.*.id, count.index)
}


# Attach NAT gateway to each availibility zone (one private subnet per AZ) for communication with the outside world
resource "aws_nat_gateway" "main" {
  count         = length(var.private_subnets)
  allocation_id = element(aws_eip.nat.*.id, count.index)
  subnet_id     = element(aws_subnet.public.*.id, count.index)
  depends_on    = [aws_internet_gateway.main]

  tags = {
    Name        = "${var.name}-nat-${var.environment}-${format("%03d", count.index+1)}"
    Environment = var.environment
  }
}

# ElasticIP associated to each NAT Gateway
resource "aws_eip" "nat" {
  count = length(var.private_subnets)
  vpc = true

  tags = {
    Name        = "${var.name}-eip-${var.environment}-${format("%03d", count.index+1)}"
    Environment = var.environment
  }
}

### CloudWatch ###
resource "aws_flow_log" "main" {
  iam_role_arn    = aws_iam_role.vpc-flow-logs-role.arn
  log_destination = aws_cloudwatch_log_group.main.arn
  traffic_type    = "ALL"
  vpc_id          = aws_vpc.main.id
}

resource "aws_cloudwatch_log_group" "main" {
  name = "${var.name}-vpc-flow-log-group"
  retention_in_days = "60"
}

resource "aws_iam_role" "vpc-flow-logs-role" {
  name = "${var.name}-vpc-flow-logs-role"
  path = "/custom/vpc/"

  assume_role_policy = jsonencode({
  Version = "2012-10-17",
  Statement = [
    {
      Action = "sts:AssumeRole",
      Effect = "Allow",
      Sid = "",
      Principal = {
        Service = "vpc-flow-logs.amazonaws.com"
      }
    }
  ]
})
}


resource "aws_iam_role_policy" "vpc-flow-logs-policy" {
  name = "${var.name}-vpc-flow-logs-policy"
  role = aws_iam_role.vpc-flow-logs-role.id

  policy = jsonencode({
  Version = "2012-10-17",
  Statement = [
    {
      Action =  [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents",
        "logs:DescribeLogGroups",
        "logs:DescribeLogStreams"
      ],
      Effect = "Allow",
      Resource = "*"
    }
  ]
})
}


// Use VPC peering for DB connection in production!
// Altas mongodb network peering NOT available for free tier M0
// https://www.mongodb.com/docs/atlas/security-vpc-peering/#std-label-vpc-peering
/*
// Note: remove this ressource (mongodbatlas_network_container) if you have already an existing Atlas project with configured VPC peering
resource "mongodbatlas_network_container" "test" {
  project_id       =  <ATLAS_PROJECT_ID>
  atlas_cidr_block =  <ATLAS_VPC_CIDR>
  provider_name    = "AWS"
  region_name      = "eu-central-1"
}

resource "aws_route" "peeraccess" {
  route_table_id            = aws_vpc.main.main_route_table_id
  destination_cidr_block    = var.cidr
  vpc_peering_connection_id = var.mongodbatlas_network_peering_connection_id
  depends_on                = [aws_vpc_peering_connection_accepter.peer]
}

resource "aws_vpc_peering_connection_accepter" "peer" {
  vpc_peering_connection_id = var.mongodbatlas_network_peering_connection_id
  auto_accept               = true
}
*/

