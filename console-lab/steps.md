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
