resource "docker_image" "nginx" {
  name         = "nginx:latest"
  keep_locally = true
}

resource "docker_container" "nginx" {
  depends_on = [docker_container.frontend, docker_container.backend]

  image = docker_image.nginx.name
  name  = "coder-${data.coder_workspace.me.owner}-${lower(data.coder_workspace.me.name)}-nginx"

  # entrypoint = ["sh", "-c", replace(coder_agent.nginx.init_script, "/localhost|127\\.0\\.0\\.1/", "host.docker.internal")]
  # env = [
  #   "CODER_AGENT_TOKEN=${coder_agent.nginx.token}",
  # ]

  networks_advanced {
    name = docker_network.private_network.name
  }

  ports {
    internal = 80
    external = data.coder_parameter.nginx_external_port.value
  }

  # Add labels in Docker to keep track of orphan resources.
  labels {
    label = "coder.owner"
    value = data.coder_workspace.me.owner
  }
  labels {
    label = "coder.owner_id"
    value = data.coder_workspace.me.owner_id
  }
  labels {
    label = "coder.workspace_id"
    value = data.coder_workspace.me.id
  }
  labels {
    label = "coder.workspace_name"
    value = data.coder_workspace.me.name
  }

  provisioner "local-exec" {
    working_dir = path.module
    command     = "cp ./nginx/default.dev.conf ./nginx/default.conf"
  }

  provisioner "local-exec" {
    working_dir = path.module
    command     = "sed -i 's/backend/coder-${data.coder_workspace.me.owner}-${lower(data.coder_workspace.me.name)}-workspace/g' ./nginx/default.conf"
  }

  provisioner "local-exec" {
    working_dir = path.module
    command     = "sed -i 's/frontend/coder-${data.coder_workspace.me.owner}-${lower(data.coder_workspace.me.name)}-workspace/g' ./nginx/default.conf"
  }

  provisioner "local-exec" {
    working_dir = path.module
    command     = "docker cp ./nginx/default.conf coder-${data.coder_workspace.me.owner}-${lower(data.coder_workspace.me.name)}-nginx:/etc/nginx/conf.d/default.conf"
  }
}
