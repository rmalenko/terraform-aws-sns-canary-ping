module "s3_log_bucket" {
  source                                     = "../modules/s3"
  providers                                  = { aws = aws.aws_main }
  bucket                                     = local.bucket_name_log
  acl                                        = "log-delivery-write"
  force_destroy                              = true
  control_object_ownership                   = true
  object_ownership                           = "ObjectWriter"
  attach_elb_log_delivery_policy             = true
  attach_lb_log_delivery_policy              = true
  attach_access_log_delivery_policy          = true
  attach_deny_insecure_transport_policy      = true
  attach_require_latest_tls_policy           = true
  block_public_acls                          = true
  block_public_policy                        = true
  access_log_delivery_policy_source_accounts = [data.aws_caller_identity.current.account_id]
  access_log_delivery_policy_source_buckets  = ["arn:aws:s3:::${local.bucket_name_log}"]
  tags = merge(local.tags, {
    application = "S3"
    Name        = local.bucket_name_log
  })

  versioning = {
    status     = false
    mfa_delete = false
  }

  lifecycle_rule = [
    {
      id      = local.bucket_name_log
      enabled = true

      filter = {
        prefix = "/"
      }

      # transition = [
      #   {
      #     days          = 30
      #     storage_class = "STANDARD_IA"
      #   },
      #   {
      #     days          = 60
      #     storage_class = "GLACIER"
      #   },
      #   {
      #     days          = 180
      #     storage_class = "DEEP_ARCHIVE"
      #   },
      # ]

      expiration = {
        days                         = 3
        expired_object_delete_marker = true
      }

    },
  ]
}
