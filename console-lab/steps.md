# Passo a passo do laboratório via Console AWS.
Para replicar este laborátorio, siga os passos a seguir:

## 1 - Criar o Bucket S3
É preciso começar com o Bucket para ter acesso ao **ARN** dele.

1 - Em Serviço S3 crie o bucket.
2 - Bucket name: meu-bucket-lab
    O bucket **deve** ter um nome único, pois buckets S3 são globais.

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
