locals {
  ingress_rule1 = [
    {
      port        = 22
      description = "port for SSH"
    },
    {
      port        = 80
      description = "port for HTTP"
    },
    {
      port        = 443
      description = "port for HTTPS"
    },
    {
      port        = 8443
      description = "port for secure HTTPS"
    }
  ]
  ingress_rule2 = [
    {
      port        = 22
      description = "port for SSH"
    },
    {
      port        = 8080
      description = "port for Jenins & Tomcat"
    },
    {
      port        = 5600
      description = "port for Custom Java Application"
    }
  ]
  ingress_rule3 = [
    {
      port        = 22
      description = "port for SSH"
    },
    {
      port        = 3306
      description = "port for MYSQL"
    },
    {
      port        = 1443
      description = "port for MSSQL"
    }
  ]
}