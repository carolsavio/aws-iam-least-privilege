```
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "ListarBucket",
            "Effect": "Allow",
            "Action": "s3:ListBucket",
            "Resource": "arn:aws:s3:::meu-bucket-lab",
            "Condition": {
                "StringLike": { "s3:prefix": ["data/processed/*", "data/uploads/*"] }
            }
        },
        {
            "Sid": "LerEscreverObjetos",
            "Effect": "Allow",
            "Action": ["s3:GetObject", "s3:PutObject"],
            "Resource": [
                "arn:aws:s3:::meu-bucket-lab/data/processed/*",
                "arn:aws:s3:::meu-bucket-lab/data/uploads/*"
            ]
        }
    ]
}

```