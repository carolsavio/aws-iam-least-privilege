# 🔍 Troubleshooting & Refinamento de Políticas IAM
Durante a implementação do princípio de Privilégio Mínimo (Least Privilege), algumas restrições intencionais geraram comportamentos bloqueantes na interface da AWS e no AWS CLI. Abaixo estão os desafios arquiteturais encontrados e como foram solucionados para manter a segurança sem perder a usabilidade.

## 1 - Erro de Validação JSON na Bucket Policy do S3
- **Sintoma:** O console do S3 rejeitou a política com um erro de Syntax Error ao tentar adicionar múltiplas exceções de acesso na condição ArnNotLike.

- **Causa Raiz**: O **AWS IAM Parser** exige conformidade estrita com o padrão JSON. Ao escalar a condição de um único Principal para múltiplos (EC2 Role, EC2 STS Assumed-Role e Admin User), os valores precisam ser obrigatoriamente encapsulados em um Array JSON ([ ]), sem a presença de ***trailing commas*** (vírgulas após o último elemento).

- **Resolução:** Refatoração do bloco de condições para estruturar os ARNs como um Array válido, garantindo a aprovação do parser do IAM e evitando o bloqueio acidental (lockout) do bucket.



## 2 - Falhas de Renderização no Console do EC2
- **Sintoma**: Ao acessar o painel de instâncias EC2, a interface gráfica (GUI) exibia múltiplos banners de erro de permissão (ex: Failed to describe volumes, Failed to describe VPCs).

- **Causa Raiz**: A política inicial do grupo de desenvolvedores foi definida com rigor extremo, permitindo apenas a ação ec2:DescribeInstances. No entanto, o console web da AWS executa chamadas de API secundárias em background para montar visualmente a tela (detalhes de rede, armazenamento e segurança).

- **Resolução**: Ampliação estratégica do escopo de leitura da interface utilizando o curinga ec2:Describe*. Isso resolve os erros visuais no console sem ferir o Privilégio Mínimo, visto que não concede permissões de mutação ou criação de recursos.



## 3 - Conexão do Session Manager (SSM) Bloqueada
- **Sintoma**: O botão de conexão do SSM no console apresentava-se inativo (cinza) e, após habilitado, retornava o erro not authorized to perform: ssm:StartSession.

- **Causa Raiz**: O acesso falhou por dois motivos relacionados a permissões implícitas não documentadas de forma óbvia pela interface gráfica:

A GUI da AWS exige permissões de leitura de status (ssm:GetConnectionStatus, ssm:DescribeInstanceInformation) para habilitar o botão de conexão.

A ação ssm:StartSession via console exige acesso explícito não apenas ao ARN da Instância, mas também ao documento padrão de execução de terminal da AWS (SSM-SessionManagerRunShell).

- **Resolução**: A política do IAM Group foi refatorada em dois statements: um para permissões visuais e de leitura (Read-Only), e outro liberando a ação de StartSession apontando especificamente para a instância alvo e para o ARN do documento de Shell do SSM.



## 4 - Erro Permission Denied em Ações Locais no Linux via SSM
- **Sintoma**: Tentativas de criar arquivos de teste para o S3 (ex: echo > arquivo.txt) diretamente no terminal do SSM resultavam em erro de permissão do sistema operacional.

- **Causa Raiz**: O Session Manager autentica o usuário com o user padrão ssm-user, iniciando a sessão em diretórios protegidos do sistema raiz do Linux (como / ou /usr/bin/). O bloqueio ocorreu na camada de permissões POSIX do sistema operacional (SO), e não nas políticas do AWS IAM.

- **Resolução**: Conscientização sobre os limites de escopo (SO vs. Cloud). O fluxo de testes foi ajustado para navegar até o diretório home do usuário (cd ~) antes da manipulação de arquivos, separando claramente o que é bloqueio de Linux e o que é bloqueio de IAM/S3.