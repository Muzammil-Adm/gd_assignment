resource "aws_vpc" "voting" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "voting-vpc"
  }
}

resource "aws_subnet" "voting_public_a" {
  vpc_id                  = aws_vpc.voting.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true
  tags = { Name = "voting-public-a" }
}

resource "aws_subnet" "voting_public_b" {
  vpc_id                  = aws_vpc.voting.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = true
  tags = { Name = "voting-public-b" }
}

resource "aws_subnet" "voting_private_a" {
  vpc_id            = aws_vpc.voting.id
  cidr_block        = "10.0.3.0/24"
  availability_zone = "us-east-1a"
  tags = { Name = "voting-private-a" }
}

resource "aws_subnet" "voting_private_b" {
  vpc_id            = aws_vpc.voting.id
  cidr_block        = "10.0.4.0/24"
  availability_zone = "us-east-1b"
  tags = { Name = "voting-private-b" }
}

