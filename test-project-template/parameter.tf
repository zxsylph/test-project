locals {
  workspace_path     = "test-project"
  workspace_git_repo = "https://github.com/zxsylph/test-project.git"
}

data "coder_parameter" "workspace_git_branch" {
  name        = "Workspace Git Branch"
  default     = "dev"
  description = "Git branch for Workspace"
  type        = "string"
  mutable     = true
}

data "coder_parameter" "workspace_git_clone" {
  name        = "Workspace Git Clone Command"
  default     = <<-EOT
    if [ ! -d ~/${local.workspace_path} ]; then
      git clone -b ${data.coder_parameter.frontend-git-branch.value} ${local.workspace_git_repo} ~/${local.workspace_path}
    fi
  EOT
  description = "Command to clone git"
  type        = "string"
  mutable     = true
}

data "coder_parameter" "frontend_run_command" {
  name        = "Frontend Run Command"
  default     = ""
  description = "Command to run when start container"
  type        = "string"
  mutable     = true
}

data "coder_parameter" "backend_run_command" {
  name        = "Backend Run Command"
  default     = ""
  description = "Command to run when start container"
  type        = "string"
  mutable     = true
}

data "coder_parameter" "nginx_external_port" {
  name        = "Nginx External Port"
  default     = "8001"
  description = "Port that exponse on host"
  type        = "number"
  mutable     = true
}
