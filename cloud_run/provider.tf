provider "google" {
    #project is useful when terraform import is done
    project = var.project_id 
}