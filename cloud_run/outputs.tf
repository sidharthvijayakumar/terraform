output "all-output" {
    value= "${google_cloud_run_service.hello.status[0].*}"
}