variable "region" {
  default = "us-east-1"
}
variable "dev" {
  default = "developers"
}
variable "dev-users" {
    type= list(string)
    description = "List of usernames"
    default = ["john", "paul","george", "ringo"]
}
variable "qa-users" {
    type= list
    description = "List of usernames"
    default = ["steve","david"]
}