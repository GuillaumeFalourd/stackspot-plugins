output "aws_sqs_queue_name" {
    {% if queue_type == 'FIFO' %}
    value = "{{queue_name}}.fifo"
    {% else %}
    value = "{{queue_name}}"
    {% endif %}
}

output "aws_sqs_queue_arn" {
    value = aws_sqs_queue.{{queue_name}}.arn
}

output "aws_sqs_queue_url" {
    value = aws_sqs_queue.{{queue_name}}.url
}