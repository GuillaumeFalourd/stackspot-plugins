data "aws_iam_policy_document" "{{queue_name}}_queue_policy" {
  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["events.amazonaws.com"]
    }
    actions = [
      "sqs:SendMessage"
    ]
    resources = [aws_sqs_queue.{{queue_name}}.arn]
  }
  statement {
    effect = "Allow"
    principals {
      type        = "AWS"
      identifiers = ["{{ connections['iam-role-default'].arn }}"]
    }
    actions = [
      "sqs:ReceiveMessage",
      "sqs:GetQueueAttributes",
      "sqs:GetQueueUrl",
      "sqs:DeleteMessage"
    ]
    resources = [aws_sqs_queue.{{queue_name}}.arn]
  }
}

resource "aws_sqs_queue_policy" "{{queue_name}}_policy" {
  queue_url = aws_sqs_queue.{{queue_name}}.id
  policy    = data.aws_iam_policy_document.{{queue_name}}_queue_policy.json
}

resource "aws_sqs_queue" "{{queue_name}}" {
  {% if queue_type == 'FIFO' %}
  name                        = "{{queue_name}}.fifo"
  fifo_queue                  = true
  content_based_deduplication = true
  {% else %}
  name                        = "{{queue_name}}"
  {% endif %}
  visibility_timeout_seconds  = {{ visibility_timeout_seconds }}
  sqs_managed_sse_enabled     = false
  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.{{queue_name}}_deadletter.arn
    maxReceiveCount     = {{ max_receive_count }}
  })
}

resource "aws_sqs_queue" "{{queue_name}}_deadletter" {
  {% if queue_type == 'FIFO' %}
  name                        = "{{queue_name}}-deadletter-queue.fifo"
  fifo_queue                  = true
  content_based_deduplication = true
  {% else %}
  name                        = "{{queue_name}}-deadletter-queue"
  {% endif %}
  sqs_managed_sse_enabled     = false
}