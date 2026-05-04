# Passo a passo do laboratório via Console AWS.
Para replicar este laborátorio, siga os passos a seguir:

## 1 - Criar o Bucket S3
É preciso começar com o Bucket para ter acesso ao **ARN** dele.

1 - Em Serviço S3 crie o bucket.
2 - Bucket name(escolha um nome descritivo e único): meu-bucket-lab-moira350
    O bucket **deve** ter um nome único, pois buckets S3 são globais. O meu foi uma escolha pessoal para este lab.

3 - Block Public Access settings: Mantenha a opção **Block all public access** marcada. 

4 - Vá até o final e clique em **Create bucket**.

5 - Clique no bucket recém-criado, vá na aba ***Permissions***, role até Bucket policy e clique em Edit.

6 - Cole o JSON com as políticas personalizadas necessárias (não se esqueça de trocar **account-id** e colocar o **ARN** do seu usuário administrador atual para não perder o acesso!). 
**Clique em Save changes.**

---
## 2 - IAM Role da EC2
Aqui é o momento de criar a identidade que a máquina vai assumir.

1 - Serviço IAM, clique em Roles -> **Create role**

2 - Em **Trusted entity Type**: Escolha AWS Service.

3 - **Use case**: Selecione **EC2** -> Next.

4 - Na tela de **èrmissions** -> **Add permissions** e pesquise por:
    `AmazonSSMManagedInstanceCore`, selecione ela -> Next.

5 - Adicione um nome a esta Role, no meu caso utilizei `EC2-S3-Role`. -> Criar Role.

6 - Encontre a role na lisya e acesse ela. Na aba **Permissions** novamente **Add permissions** -> **Create inline policy**.

7 - Clice na aba **JSON** e cole a politica em JSON criada.

8 - Finalize com um nome, nesse caso usei `AcessoS3Customizado`e -> **Create policy**.

---
## 3 - A Intância EC2
Com a role pronta, hora de subir a máquina para os testes.

1 - Em Serviços EC2 -> **Launch instances**

2 - **Name**: minha-instancia-lab

3 - **Amazon Machine Image (AMI)**: O Amazon Linux 2023 (já vem com o Agente do SSM instalado por padrão, poupando trabalho).

4 - **Instance type**: (Escolha qualquer uma que seja elegível ao nível gratuito). No meu caso, utilizei **t3.micro**.

5 - Key pair (login): Escolha **Proceed without a key pair** no menu suspenso. (Já que a utilizalção será através de SSM, não há necessidade de chaves SSH).

6 - Network settings: Você pode deixar o padrão (VPC default), e não precisa abrir a porta 22 (SSH) no Security Group. O SSM funciona apenas com o tráfego de saída (outbound) para a internet.

7 - Expanda a seção Advanced details. Em IAM instance profile, selecione a EC2-S3-Role que você criou no Passo 2.

8 - Clique em Launch instance.

9 - Vá para a tela de instâncias, aguarde ela ficar com o status Running e copie o Instance ID (começa com i-xxxxxxxxxxxx). Você vai precisar dele no próximo passo.

---
## 4 - O IAM Group
Criação do grupo dos desenvolvedores e atrelar a política do SSM a ele.

1 - No serviço IAM, -> **Policies** -> **Create policy**.

2 - Na aba JSON e cole a Group Policy.
    **Atenção:** Substitua region, account-id e i-xxxxxxxxxxxx pelos dados reais da sua conta e da EC2 criada no Passo 3.

3 - Next -> Dê o nome para essa politica, no meu caso utilizei `Acesso-SSM-Devs`.

4 - Ainda no IAM -> **User groups** -> **Create group**.

5 - User group name: `Desenvolvedores`. (escolha pessoal do projeto)

6 - Em **Attach permissions policies**, pesquise pela política criada anteriormente, no meu caso `Acesso-SSM-Devs` -> Clique em **Create group**.

---
## 5 - O IAM User e o MFA
Por fim, criação do usuário e testes de validação de segurança.

1 - No IAM, clique em **Users** -> **Create user**.

2 - User name(nome do membro novo): `dev-user`.
    Como dito anteriormente, `dev-user` foi uma escolha pessoal para este lab.

3 - Marque a opção **Provide user access to the AWS Management Console** (para ele conseguir logar e testar).

4 - Escolha **I want to create an IAM user**, crie uma senha customizada (ou gerada automaticamente) e clique em Next.

5 - Na tela de permissões, escolha Add user to group e selecione o grupo Desenvolvedores. Clique em Next e depois Create user.

6 - **Ativando o MFA**: Para que o usuário consiga de fato acessar a EC2 (por conta da política que exige MFA), acesse a conta com as credenciais desse novo usuário `dev-user`.

7 - No canto superior direito, clique no nome de usuário e vá em Security credentials.

8 - Em Multi-factor authentication (MFA), clique em Assign MFA device.
    Siga as instruções na tela usando um aplicativo como Google Authenticator ou Authy no seu celular.

Agora, tudo pronto para os testes!