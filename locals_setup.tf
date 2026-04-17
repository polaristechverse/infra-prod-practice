resource "local_file" "hosts_cfg" {
  content = templatefile("hosts.tpl",
    {
      server1 = aws_instance.JenkinsInstance.0.public_ip
      server2 = aws_instance.JenkinsInstance.1.public_ip
      server3 = aws_instance.JenkinsInstance.2.public_ip
    }
  )
  filename = "invfile"
}
