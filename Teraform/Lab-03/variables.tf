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
variable "pCidrBlockVPC-1" {
  description = "pCidrBlockVPC"
  type        = string
  default     = "10.0.0.0/16"
}
variable "pCidrBlockVPC-2" {
  description = "pCidrBlockVPC"
  type        = string
  default     = "11.0.0.0/16"
}