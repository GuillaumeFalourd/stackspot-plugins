output "aws_dynamo_conn_table_arn" {
    value = aws_dynamodb_table.{{ table_name }}-dynamodb-table.arn
}

output "aws_dynamo_conn_table_name" {
    value = aws_dynamodb_table.{{ table_name }}-dynamodb-table.id
}