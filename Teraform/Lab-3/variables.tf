# Configure the AWS variable

variable "pOwner" {
  description = "pOwner"
  type        = string
  default     = "Jpo"
}
variable "pProject" {
  description = "pProject"
  type        = string
  default     = "Tera"
}
variable "pEnvironment" {
  description = "pEnvironment"
  type        = string
  default     = "Dev"
}