resource "aws_cloudfront_distribution" "this" {
  enabled = true
  comment = "CloudFront fronting internal ALB (Zero Trust)"

  origin {
    domain_name = var.internal_alb_dns_name
    origin_id   = "internal-alb"

    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "http-only"
      origin_ssl_protocols   = ["TLSv1.2"]
    }
  }

  default_cache_behavior {
    target_origin_id       = "internal-alb"
    viewer_protocol_policy = "redirect-to-https"

    allowed_methods = ["GET", "HEAD", "OPTIONS", "PUT", "POST", "PATCH", "DELETE"]
    cached_methods  = ["GET", "HEAD"]

    forwarded_values {
        query_string = true

        cookies {
        forward = "all"
        }
    }

    compress = true
  }


  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }

  web_acl_id = var.waf_web_acl_arn

  tags = {
    Project = var.project_name
  }
}
