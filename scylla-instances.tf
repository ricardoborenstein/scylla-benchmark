resource "aws_instance" "scylladb" {
  count           = 3
  ami             = "ami-0905a3c97561e0b69" # Replace with your desired AMI
  instance_type   = "r5d.4xlarge"
  key_name        = "ricardo-terraform"     # Replace with your EC2 key pair name

  subnet_id       = element(aws_subnet.public_subnet.*.id, count.index)  # Assign to a subnet within the VPC
  security_groups = [aws_security_group.sg.id]  # Replace with your VPC security group ID

  tags = {
    Name = "${var.custom_name}-ScyllaDBInstance-${count.index}"
  }

  # Provisioner to install Scylla and its dependencies
  provisioner "remote-exec" {
    inline = [
      "sudo mkdir -p /etc/apt/keyrings",
      "sudo gpg --homedir /tmp --no-default-keyring --keyring /etc/apt/keyrings/scylladb.gpg --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys d0a112e067426ab2",
      "sudo wget -O /etc/apt/sources.list.d/scylla.list http://downloads.scylladb.com/deb/debian/scylla-5.4.list",
      "sudo apt-get update",
      "sudo apt-get install -y openjdk-11-jre-headless",
      "sudo update-java-alternatives --jre-headless -s java-1.11.0-openjdk-amd64",
      "sudo apt-get update",
      "sudo apt-get install -y scylla"
    ]

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file(var.ssh_private_key)
      host        = self.public_ip
    }
  }

  # Provisioner to configure Scylla
  provisioner "remote-exec" {
    inline = [
      "sudo scylla_setup --disks /dev/nvme2n1,/dev/nvme1n1 --online-discard 1 --nic ens5 --io-setup 1 --no-fstrim-setup --no-rsyslog-setup || true"
    ]

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file(var.ssh_private_key)
      host        = self.public_ip
    }
  }

  # Transfer and execute the configuration script
  provisioner "file" {
    content = templatefile("./configure_scylla.sh.tpl", {
      cluster_name   = var.custom_name,
      seed_ip        = aws_instance.scylladb[0].private_ip,
      listen_address = self.private_ip,
      rpc_address    = self.private_ip
    })
    destination = "/home/ubuntu/configure_scylla.sh"

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file(var.ssh_private_key)
      host        = self.public_ip
    }
  }

  provisioner "remote-exec" {
    inline = [
      "sudo chmod +x /home/ubuntu/configure_scylla.sh",
      "sudo /home/ubuntu/configure_scylla.sh"
    ]

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file(var.ssh_private_key)
      host        = self.public_ip
    }
  }
}

output "scylla_ips" {
  value = join(",", aws_instance.scylladb.*.private_ip)
}
