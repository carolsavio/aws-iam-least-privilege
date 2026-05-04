
```
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "PermitirAcessoViaSSM",
            "Effect": "Allow",
            "Action": "ssm:StartSession",
            "Resource": [
                "arn:aws:ec2:region:account-id:instance/i-xxxxxxxxxxxx",
                "arn:aws:ssm:region:account-id:session/*"
            ]
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