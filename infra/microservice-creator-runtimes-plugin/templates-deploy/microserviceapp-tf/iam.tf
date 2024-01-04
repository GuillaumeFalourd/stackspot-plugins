resource "aws_iam_role" "microservice_role" {
  name = "${var.microservice_name}-role"

  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Principal" : {
          "Federated" : "arn:aws:iam::${var.account_id}:oidc-provider/oidc.eks.${var.region}.amazonaws.com/id/${element(split("/", data.aws_eks_cluster.stackspot_cluster.identity[0].oidc[0].issuer), length(split("/", data.aws_eks_cluster.stackspot_cluster.identity[0].oidc[0].issuer)) - 1)}"
        },
        "Action" : "sts:AssumeRoleWithWebIdentity",
        "Condition" : {
          "StringEquals" : {
            "oidc.eks.${var.region}.amazonaws.com/id/${element(split("/", data.aws_eks_cluster.stackspot_cluster.identity[0].oidc[0].issuer), length(split("/", data.aws_eks_cluster.stackspot_cluster.identity[0].oidc[0].issuer)) - 1)}:sub" : "system:serviceaccount:${var.namespace}:${var.microservice_name}"
          }
        }
      }
    ]
  })

  tags_all = {}
}

data "aws_iam_policy_document" "microservice_opa_policy" {
  version = "2012-10-17"
  statement {
    effect = "Allow"
    actions = [
      "s3:GetObject",
      "s3:GetBucket*",
      "s3:List*",
      "s3:GetBucketAcl",
      "s3:GetBucketLocation"
    ]
    resources = [
      "arn:aws:s3:::${var.account_id}-policies",
      "arn:aws:s3:::${var.account_id}-policies/*"
    ]
  }
}

resource "aws_iam_policy" "microservice_opa_policy" {
  name   = "${var.microservice_name}-opa-policies-access"
  policy = data.aws_iam_policy_document.microservice_opa_policy.json

  tags_all = {}
}

resource "aws_iam_role_policy_attachment" "microservice_opa_policy" {
  policy_arn = aws_iam_policy.microservice_opa_policy.arn
  role       = aws_iam_role.microservice_role.name
}