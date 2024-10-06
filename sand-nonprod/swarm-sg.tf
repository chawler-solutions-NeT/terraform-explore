resource "aws_security_group" "manager" {
  name        = "swarm-manager-sg"
  description = "Security group for swarm manager"
  vpc_id      = module.vpc_module.vpc_id

  # Allow communication with the worker nodes on Swarm ports
  ingress {
    from_port   = 2377  # Port for Swarm manager communication
    to_port     = 2377
    protocol    = "tcp"
    cidr_blocks = [module.vpc_module.vpc_cidr_block]  
  }

  ingress {
    from_port   = 7946  # Port for Swarm gossip communication
    to_port     = 7946
    protocol    = "tcp"
    cidr_blocks = [module.vpc_module.vpc_cidr_block]  
  }

  ingress {
    from_port   = 4789  # Port for overlay networking
    to_port     = 4789
    protocol    = "udp"
    cidr_blocks = [module.vpc_module.vpc_cidr_block]  
  }

  # Allow SSH access to the manager
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Egress rules allowing all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "worker" {
  name        = "swarm-worker-sg"
  description = "Security group for swarm worker"
  vpc_id      = module.vpc_module.vpc_id

  # Allow communication with the manager on Swarm ports
  ingress {
    from_port   = 2377  # Port for Swarm manager communication
    to_port     = 2377
    protocol    = "tcp"
    cidr_blocks = [module.vpc_module.vpc_cidr_block]
  }

  ingress {
    from_port   = 7946  # Port for Swarm gossip communication
    to_port     = 7946
    protocol    = "tcp"
    cidr_blocks = [module.vpc_module.vpc_cidr_block]
  }

  ingress {
    from_port   = 4789  # Port for overlay networking
    to_port     = 4789
    protocol    = "udp"
    cidr_blocks = [module.vpc_module.vpc_cidr_block]
  }

  # Allow HTTP access to the worker
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow SSH access to the worker
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Egress rules allowing all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}