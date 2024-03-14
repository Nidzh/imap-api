job "imap-api" {
  datacenters = ["dc1"]
  type        = "service"
  meta        = {
    "version" = "0.0.5"
  }

  group "imap-api-group" {

    count = 1

     network {
    port "http" {
      static = 3000
      to = 3000
    }
    }

    task "imap-api-task" {

      driver = "docker"

      template {
        data        = <<EOT
        GITHUB_TOKEN={{ with nomadVar "nomad/jobs" }}{{ .GITHUB_TOKEN }}{{ end }}
        GITHUB_USERNAME={{ with nomadVar "nomad/jobs" }}{{ .GITHUB_USERNAME	}}{{ end }}
        EOT
        destination = "secrets/env.sh"
        env         = true
      }

      config {
        image      = "https://ghcr.io/nidzh/imap-api:latest" #  <<< ПУТЬ К КОНТЕЙНЕРУ
        ports      = ["http"]
        force_pull = true
        interactive = true
        auth       = {
          username = "${GITHUB_USERNAME}"
          password = "${GITHUB_TOKEN}"
        }
      }


      resources {
        cpu    = 1000
        memory = 1024
      }
    }
  }
}
