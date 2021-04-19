output "server_1_public_ip" {
  value = aws_eip.noc_task_eip1.public_ip
}
output "server_2_public_ip" {
  value = aws_eip.noc_task_eip2.public_ip
}
