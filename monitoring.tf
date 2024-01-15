resource "aws_instance" "scylladb-monitoring" {
  ami           = "ami-0905a3c97561e0b69"  # Replace with the desired AMI ID for your region
  instance_type = "m5.2xlarge"             # Replace with the desired instance type
  key_name      = "ricardo-terraform"      # Replace with your EC2 key pair name

  security_groups = [aws_security_group.sg.id]
  subnet_id       = element(aws_subnet.public_subnet.*.id, 0)
  tags = {
    Name = "${var.custom_name}-Monitoring"
  }

  user_data = <<-EOF
                #!/bin/bash
                # Update and install prerequisites
                sudo apt-get update
                sudo apt-get install -y ca-certificates curl gnupg

                # Add Docker's official GPG key
                sudo install -m 0755 -d /etc/apt/keyrings
                curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
                sudo chmod a+r /etc/apt/keyrings/docker.gpg

                # Add Docker repository
                echo \
                  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
                  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
                  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

                # Install Docker packages
                sudo apt-get update
                sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

                # Add 'ubuntu' user to the docker group
                sudo usermod -aG docker ubuntu
                sudo reboot now
                EOF
  # Provisioner to install and run Scylla Monitoring
  provisioner "remote-exec" {
    inline = [
      "sudo systemctl start docker",
      "git clone --branch branch-4.6 https://github.com/scylladb/scylla-monitoring.git", # Add additional run options here
    ]

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file(var.ssh_private_key)
      host        = self.public_ip
    }
  }

  provisioner "file" {
    content     = templatefile("configure_monitoring.sh.tpl", {
      CLUSTER_NAME   = "${var.custom_name}"
      scylla_servers = join("\n", formatlist("  - %s:9180", aws_instance.scylladb.*.private_ip))
      DC_NAME        = "eu-west"
    })
    destination = "/tmp/configure_monitoring.sh"

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file(var.ssh_private_key)
      host        = self.public_ip
    }
  }

  provisioner "remote-exec" {
    inline = [
      "sudo chmod +x /tmp/configure_monitoring.sh",
      "sudo /tmp/configure_monitoring.sh"
    ]

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file(var.ssh_private_key)
      host        = self.public_ip
    }
  }

  provisioner "remote-exec" {
    inline = [
      "cd scylla-monitoring",
      "bash ./start-all.sh -d prometheus_data",
      "echo 'done'", # Add additional run options here
    ]

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file(var.ssh_private_key)
      host        = self.public_ip
    }
  }

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file(var.ssh_private_key)
    host        = self.public_ip
  }
}
