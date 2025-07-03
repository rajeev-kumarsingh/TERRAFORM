resource "github_repository" "created_from_terraform" {
  name        = "tf-demo-repo"
  description = "Created with terraform"
  visibility  = "public"

}