```
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "DenyDirectAccessToEveryoneExceptEC2Role",
      "Effect": "Deny",
      "Principal": "*",
      "Action": "s3:*",
      "Resource": [
        "arn:aws:s3:::meu-bucket-lab",
        "arn:aws:s3:::meu-bucket-lab/*"
      ],
      "Condition": {
        "ArnNotLike": {
          "aws:PrincipalArn": "arn:aws:iam::account-id:role/EC2-S3-Role"
        }
      }
    }
  ]
}

```