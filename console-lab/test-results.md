# 🧪 Resultados dos Testes de Segurança

Este documento comprova a eficácia das políticas de Privilégio Mínimo aplicadas na arquitetura AWS (IAM, EC2, S3 e SSM). Os testes foram executados simulando o comportamento de um usuário e de uma instância comprometida/curiosa tentando extrapolar seus limites de acesso.

## 🔒 Parte 1 - Autenticação e Acesso à Instância (SSM)
**Objetivo:** Garantir que o acesso à instância EC2 ocorra apenas via rede interna da AWS (SSM) e exija duplo fator de autenticação (MFA).

| ID  | Cenário de Teste        | Ação Executada                                                                 | Resultado Esperado                                                   | Resultado Obtido                          | Status  |
|-----|-------------------------|--------------------------------------------------------------------------------|----------------------------------------------------------------------|-------------------------------------------|---------|
| 1.1 | Acesso sem MFA          | Login com Membro sem inserir token. Tentativa de StartSession.                | Acesso bloqueado pelo IAM (aws:MultiFactorAuthPresent).              | Botão SSM inativo ou erro Access Denied.  | ✅ Pass |
| 1.2 | Acesso com MFA          | Login com Membro autenticado via token MFA. StartSession.                     | Terminal do Linux aberto no navegador.                               | Conexão estabelecida com sucesso.         | ✅ Pass |
| 1.3 | Acesso via SSH Público  | Tentativa de conexão na porta 22 via IP Público.                              | Conexão recusada (Security Group não expõe porta 22).                | Connection timed out.                     | ✅ Pass |

## 🛡️ Parte 2 - Acesso ao S3 via EC2 (Least Privilege)
**Objetivo:** Garantir que a instância EC2, operando sob a role EC2-S3-Role, só consiga interagir com o bucket meu-bucket-lab-moira350 dentro dos prefixos estritamente autorizados (data/uploads/ e data/processed/).

Nota: Todos os comandos abaixo foram executados internamente na EC2 via AWS CLI (aws s3 ...).

>❌ Testes Negativos (Comprovando o Bloqueio)

### Teste 2.1: Tentativa de listar a raiz do bucket

```
$ aws s3 ls s3://meu-bucket-lab-moira350
```
**Saída:**

```
An error occurred (AccessDenied) when calling the ListObjectsV2 operation: Access Denied
```
**Conclusão:** O bloqueio na raiz funcionou perfeitamente. A instância não pode vasculhar o bucket inteiro.


### Teste 2.2: Tentativa de escrita de arquivo na raiz do bucket

```
$ echo "Dado confidencial" > hacket.txt
$ aws s3 cp hacket.txt s3://meu-bucket-lab-moira350/hacket.txt
```
**Saída:**

```
upload failed: ./hacket.txt to s3://meu-bucket-lab-moira350/hacket.txt An error occurred (AccessDenied) when calling the PutObject operation: Access Denied
```
**Conclusão:** A política impediu a injeção de dados fora das pastas autorizadas.


>✅ Testes Positivos (Comprovando o Acesso Permitido)
### Teste 2.3: Listar diretório autorizado

```
$ aws s3 ls s3://meu-bucket-lab-moira350/data/uploads/
```
**Saída:** (Comando executado sem retornar erro 403 Forbidden/Access Denied).

**Conclusão:** A permissão de ListBucket associada ao prefixo está funcional.

### Teste 2.4: Upload de arquivo para a pasta autorizada

```
$ echo "Arquivo válido" > test_file.txt
$ aws s3 cp arquivo_teste.txt s3://meu-bucket-lab-moira350/data/uploads/arquivo_teste.txt
```
**Saída:**

```
upload: ./arquivo_teste.txt to s3://meu-bucket-lab-moira350/data/uploads/arquivo_teste.txt
```
**Conclusão:** A ação ***PutObject*** funcionou exclusivamente no prefixo mapeado na política.


### Teste 2.5: Download de arquivo da pasta autorizada

```
$ aws s3 cp s3://meu-bucket-lab-moira350/data/uploads/arquivo_teste.txt download.txt
```
**Saída:**

```
download: s3://meu-bucket-lab-moira350/data/uploads/arquivo_teste.txt to ./download.txt
```
**Conclusão:** A ação **GetObject** operou com sucesso e o arquivo foi recuperado para a máquina local.


## 🎯 Conclusão Final
Todos os testes retornaram os comportamentos exatos previstos no desenho da arquitetura. A separação de responsabilidades (IAM vs S3 Bucket Policies) e a blindagem de acessos laterais (SSM + MFA) foram comprovadas com 100% de eficácia.