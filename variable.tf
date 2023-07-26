#name of the cloudrun instance
variable "instance_name" {
    type = string

}
#region where the cloudrun will be deployed
variable "region" {
    type = string
}
#project where clodurun will be deployed
variable "project_id"{
    type = string
}
#name of the container 
variable "container_name"{
    type = string
}
#contianer port where the code is exposed
variable "container_port" {
    type = number
}
# image name
variable "container_image" {
    type= string
}
#container cpu capacity
variable "container_cpu" {
    type = string
}
#container memory capacity 
variable "container_memory" {
    type = string
}
#container concurrency 
variable "container_concurrency" {
    type = number
}
#container timeout in seconds
variable "container_timeout_seconds" {
    type =  number
}
# service account used for the cloudrun instance
variable cloud_run_service_account {
    type = string
}