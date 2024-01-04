resource "aws_dynamodb_table" "{{ table_name }}-dynamodb-table" {
  name           = "{{ table_name }}"
  billing_mode   = "{{ billing_mode}}"
  {% if billing_mode  == "PROVISIONED" %}
  read_capacity  = {{ read_capacity }}
  write_capacity = {{ write_capacity }}
  {% endif %}
  hash_key       = "{{ hash_key }}"
  range_key      = "{{ range_key }}"

  attribute {
    name = "{{ hash_key }}"
    type = "{{ hash_key_type }}"
  }

  attribute {
    name = "{{ range_key }}"
    type = "{{ range_key_type }}"
  }

  server_side_encryption {
    enabled     = {{ server_side_encryption }}
  }

  point_in_time_recovery {
    enabled = {{ point_in_time_recovery }}
  }

  tags = {}
}
