# variable "context" {
#   type = any
#   default = {
#     enabled             = true
#     namespace           = null
#     tenant              = null
#     environment         = null
#     stage               = null
#     name                = null
#     delimiter           = null
#     attributes          = []
#     tags                = {}
#     additional_tag_map  = {}
#     regex_replace_chars = null
#     label_order         = []
#     id_length_limit     = null
#     label_key_case      = null
#     label_value_case    = null
#     descriptor_formats  = {}
#     # Note: we have to use [] instead of null for unset lists due to
#     # https://github.com/hashicorp/terraform/issues/28137
#     # which was not fixed until Terraform 1.0.0,
#     # but we want the default to be all the labels in `label_order`
#     # and we want users to be able to prevent all tag generation
#     # by setting `labels_as_tags` to `[]`, so we need
#     # a different sentinel to indicate "default"
#     labels_as_tags = ["unset"]
#   }
#   description = <<-EOT
#     Single object for setting entire context at once.
#     See description of individual variables for details.
#     Leave string and numeric variables as `null` to use default value.
#     Individual variable settings (non-null) override settings in context object,
#     except for attributes, tags, and additional_tag_map, which are merged.
#   EOT

#   validation {
#     condition     = lookup(var.context, "label_key_case", null) == null ? true : contains(["lower", "title", "upper"], var.context["label_key_case"])
#     error_message = "Allowed values: `lower`, `title`, `upper`."
#   }

#   validation {
#     condition     = lookup(var.context, "label_value_case", null) == null ? true : contains(["lower", "title", "upper", "none"], var.context["label_value_case"])
#     error_message = "Allowed values: `lower`, `title`, `upper`, `none`."
#   }
# }

# variable "profile_main" {
#   type        = string
#   description = "AWS user main profile to use S3"
# }

# variable "profile_prod_v2" {
#   type        = string
#   description = "AWS user access profile"
# }

# # variable "allowed_account_ids" {
# #   type        = string
# #   description = "Only these AWS Account IDs may be operated on by this template"
# # }

# variable "us_east_1" {
#   description = "US East (N. Virginia)"
#   type        = string
#   default     = 127311923021
# }

# variable "us_east_2" {
#   description = "US East (Ohio)US East (Ohio)"
#   type        = string
#   default     = 033677994240
# }

# variable "us_west_1" {
#   description = "US West (N. California)"
#   type        = string
#   default     = 027434742980
# }

# variable "us_west_2" {
#   description = "US West (Oregon)"
#   type        = string
#   default     = 797873946194
# }

# variable "af_south_1" {
#   description = "Africa (Cape Town)"
#   type        = string
#   default     = 098369216593
# }

# variable "ca_central_1" {
#   description = "Canada (Central)"
#   type        = string
#   default     = 985666609251
# }

# variable "eu_central_1" {
#   description = "Europe (Frankfurt)"
#   type        = string
#   default     = 054676820928
# }

# variable "eu_west_1" {
#   description = "Europe (Ireland)"
#   type        = string
#   default     = 156460612806
# }

# variable "eu_west_2" {
#   description = "Europe (London)"
#   type        = string
#   default     = 652711504416
# }

# variable "eu_south_1" {
#   description = "Europe (Milan)"
#   type        = string
#   default     = 635631232127
# }

# variable "eu_west_3" {
#   description = "Europe (Paris)"
#   type        = string
#   default     = 009996457667
# }

# variable "eu_north_1" {
#   description = "Europe (Stockholm)"
#   type        = string
#   default     = 897822967062
# }

# variable "ap_east_1" {
#   description = "Asia Pacific (Hong Kong)"
#   type        = string
#   default     = 754344448648
# }

# variable "ap_northeast_1" {
#   description = "Asia Pacific (Tokyo)"
#   type        = string
#   default     = 582318560864
# }

# variable "ap_northeast_2" {
#   description = "Asia Pacific (Seoul)"
#   type        = string
#   default     = "600734575887"
# }

# variable "ap_northeast_3" {
#   description = "Asia Pacific (Osaka)"
#   type        = string
#   default     = 383597477331
# }

# variable "ap_southeast_1" {
#   description = "Asia Pacific (Singapore)"
#   type        = string
#   default     = 114774131450
# }

# variable "ap_southeast_2" {
#   description = "Asia Pacific (Sydney)"
#   type        = string
#   default     = 783225319266
# }

# variable "ap_south_1" {
#   description = "Asia Pacific (Mumbai)"
#   type        = string
#   default     = 718504428378
# }

# variable "me_south_1" {
#   description = "Middle East (Bahrain)"
#   type        = string
#   default     = 076674570225
# }

# variable "sa_east_1" {
#   description = "South America (São Paulo)"
#   type        = string
#   default     = 507241528517
# }


# # variable "email" {
# #   type        = string
# #   description = "E-mail address"
# # }

# # variable "domain" {
# #   type        = string
# #   description = "Domain name public zone"
# # }

# # variable "domain_private" {
# #   type        = string
# #   description = "Domain name private zone"
# # }

variable "aws_region" {
  type        = string
  description = "AWS region"
}

# variable "subnet_id" {
#   type        = string
#   description = "rafinita-subn-bast"
#   default     = "subnet-01d90b223698b052a"
# }