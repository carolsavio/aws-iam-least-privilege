## Politica customizada para o grupo Developers
```
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "PermitirAcessoViaSSMObrigatorioMFA",
            "Effect": "Allow",
            "Action": "ssm:StartSession",
            "Resource": [
                "arn:aws:ec2:region:account-id:instance/i-xxxxxxxxxxxx",
                "arn:aws:ssm:region:account-id:session/*"
            ],
            "Condition": {
                "BoolIfExists": {
                    "aws:MultiFactorAuthPresent": "true"
                }
            }
        },
        {
            "Sid": "ListarInstanciasNoConsole",
            "Effect": "Allow",
            "Action": "ec2:DescribeInstances",
            "Resource": "*"
        }
    ]
}
```

## Política customizada para o Bucket S3
Bucket Policy (política baseada em recurso).
    Enquanto as outras políticas dizem quem pode entrar, esta aqui diz quem **não** pode de jeito nenhum.
    Ele proíbe todo mundo, exceto a Role configurada.


```
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "DenyDirectAccessToEveryoneExceptEC2RoleAndAdmins",
      "Effect": "Deny",
      "Principal": "*",
      "Action": "s3:*",
      "Resource": [
        "arn:aws:s3:::meu-bucket-lab",
        "arn:aws:s3:::meu-bucket-lab/*"
      ],
      "Condition": {
        "ArnNotLike": {
          "aws:PrincipalArn": 
            "arn:aws:iam::account-id:role/EC2-S3-Role",
            "arn:aws:sts::account-id:assumed-role/EC2-S3-Role/*","arn:aws:iam::account-id:role/RoleDeAdminOuAdminUser"
        }
      }
    }
  ]
}
```

## Política customizada EC2-IAM Role
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
                "arn:aws:s3:::meu-bucket-lab/data/uploads/*",
                "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
            ]
        }
    ]
}
```