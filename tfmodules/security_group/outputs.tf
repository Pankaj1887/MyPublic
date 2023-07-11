output "id" {
    value = aws_saws_security_group.allow_port80.id
}

output "arn" {
    value = aws_security_group.allow_port80.arn
}