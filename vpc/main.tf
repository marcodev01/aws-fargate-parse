# VPC with attached internet gateway
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


# private subnet (per availability zone)
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


#  public subnet (per availability zone)
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


# routing tables (public subnet), going through internet gateway
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


# routing tables (private subnet), traffic routed through NAT gateway 
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


# private subnets -> attach NAT gateways for communication with the outside world
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


# ElasticIP associated to nat
resource "aws_eip" "nat" {
  count = length(var.private_subnets)
  vpc = true

  tags = {
    Name        = "${var.name}-eip-${var.environment}-${format("%03d", count.index+1)}"
    Environment = var.environment
  }
}

#CloudWatch
resource "aws_flow_log" "main" {
  iam_role_arn    = aws_iam_role.vpc-flow-logs-role.arn
  log_destination = aws_cloudwatch_log_group.main.arn
  traffic_type    = "ALL"
  vpc_id          = aws_vpc.main.id
}

resource "aws_cloudwatch_log_group" "main" {
  name = "${var.name}-cloudwatch-log-group"
}

resource "aws_iam_role" "vpc-flow-logs-role" {
  name = "${var.name}-vpc-flow-logs-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "vpc-flow-logs.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "vpc-flow-logs-policy" {
  name = "${var.name}-vpc-flow-logs-policy"
  role = aws_iam_role.vpc-flow-logs-role.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents",
        "logs:DescribeLogGroups",
        "logs:DescribeLogStreams"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}

output "id" {
  value = aws_vpc.main.id
}

output "public_subnets" {
  value = aws_subnet.public
}

output "private_subnets" {
  value = aws_subnet.private
}

# altas mongodb
/*
resource "aws_route" "peeraccess" {
  route_table_id            = aws_vpc.primary.main_route_table_id
  destination_cidr_block    = var.atlas_vpc_cidr
  vpc_peering_connection_id = mongodbatlas_network_peering.aws-atlas.connection_id
  depends_on                = [aws_vpc_peering_connection_accepter.peer]
}
*/

/*
resource "aws_vpc_peering_connection_accepter" "peer" {
  vpc_peering_connection_id = mongodbatlas_network_peering.aws-atlas.connection_id
  auto_accept               = true
}
*/
