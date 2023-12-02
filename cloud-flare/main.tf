terraform {
  required_providers {
    cloudflare = {
      source = "cloudflare/cloudflare"
      version = "4.20.0"
    }
  }
}
provider "cloudflare" {

  # Cloudflare API credentials configuration
  api_token = "WFLicQq6SxbH-OQsjoNxvHT2PjyabIine_zWt_6t"
}

data "cloudflare_record" "www"{
  zone_id  = "0da42c8d2132a9ddaf714f9e7c920711"
  hostname = "sidharthvijayakumar.fun"
  type = "A"
}