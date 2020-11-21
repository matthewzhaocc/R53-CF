terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

resource "random_string" "oid" {
  length  = 8
  special = false
}
locals {
  origin_id = random_string.oid.result
}
resource "aws_cloudfront_distribution" "R53CDNDistribution" {
  origin {
    domain_name = var.Record_Value
    origin_id   = local.origin_id
  }

  enabled             = true
  is_ipv6_enabled     = true
  comment             = "Provisioned by R53CDN"
  default_root_object = var.Default_Root_Object
  aliases             = [var.Record_Name]
  default_cache_behavior {
    allowed_methods        = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods         = ["GET", "HEAD"]
    target_origin_id       = local.origin_id
    viewer_protocol_policy = "allow-all"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
    forwarded_values {
      query_string = true
      cookies {
        forward = "all"
      }
    }
  }

  price_class = "PriceClass_200"
  restrictions {
    geo_restriction {
      restriction_type = "blacklist"
      locations        = []
    }
  }
  tags = {
    Provisioned_By = "R53CDN"
  }
  viewer_certificate {
    acm_certificate_arn = var.ACM_ARN
  }

}

resource "aws_route53_record" "Web_record" {
    zone_id = aws_route53_zone 
}