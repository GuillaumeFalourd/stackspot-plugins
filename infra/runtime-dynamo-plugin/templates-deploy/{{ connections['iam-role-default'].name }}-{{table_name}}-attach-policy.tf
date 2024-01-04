resource "aws_iam_policy" "{{ connections['iam-role-default'].name }}_{{table_name}}_policy" {
  name        = "{{ connections['iam-role-default'].name }}_{{table_name}}"
  path        = "/"
  description = "{{ connections['iam-role-default'].name }}_{{table_name}}_policy"

  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "ListAndDescribe",
            "Effect": "Allow",
            "Action": [
                "dynamodb:List*",
                "dynamodb:DescribeReservedCapacity*",
                "dynamodb:DescribeLimits",
                "dynamodb:DescribeTimeToLive"
            ],
            "Resource": "*"
        },
        {
            "Sid": "SpecificTable",
            "Effect": "Allow",
            "Action": [
                "dynamodb:BatchGet*",
                "dynamodb:DescribeStream",
                "dynamodb:DescribeTable",
                "dynamodb:Get*",
                "dynamodb:Query",
                "dynamodb:Scan",
                {% if access_type == "write" %}
                "dynamodb:BatchWrite*",
                "dynamodb:Delete*",
                "dynamodb:Update*",
                "dynamodb:PutItem"
                {% endif %}
            ],
            "Resource": "arn:aws:dynamodb:{{ region }}:${data.aws_caller_identity.{{ connections['iam-role-default'].name }}_{{table_name}}.id}:table/{{table_name}}"
        }
    ]})
}

resource "aws_iam_role_policy_attachment" "{{ connections['iam-role-default'].name }}_{{table_name}}_attachment" {
  role       = "{{ connections['iam-role-default'].name }}"
  policy_arn = aws_iam_policy.{{ connections['iam-role-default'].name }}_{{table_name}}_policy.arn
}
