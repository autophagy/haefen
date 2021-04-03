variable "zone_id" {
  type = string
}

resource "cloudflare_record" "haefen" {
  zone_id = var.zone_id
  name = "autophagy.io"
  value = aws_s3_bucket.haefen.website_endpoint
  type = "CNAME"
  proxied = true
}
