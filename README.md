# IaC base 4 AWS
#
# Base IaC - Infra base para subir uma aplicação (client servidor - webapp + database) na AWS

#
## O que é?
Uma infraestrutura base para rodar um serviço web qualquer que usaba uma base de dados.

## O que quer dizer infraestrutura base?
Para mantermos uma aplicação mais um banco de dados ativo, é necessário configurar alguns recursos mínimos necessários e fundamentais.

## O que vamos fazer aqui?
De início vamos usar os seguintes recursos:
0. Criar uma Provider
1. Criar uma VPC (O que é uma VPC?)
2. Criar uma Internet Gateway
3. Criar ou customizar uma tabela de Roteamento de rede.
4. Criar subnets
5. Associar sua subnet a uma tabela de Roteamento
6. Montar sua Security Groups 
7. Criar uma internface de rede (requisito - passo 4)
8. Atribuir uma Elastic IP a sua interface de rede (requisito - passo 9 - Criar uma Instancia EC2 para rodar sua webapp
10. Pensar se usar RDS ou uma instância EC2 com postgres
10.1. O banco de dados vai ridar dentro de uma rede privada
10.2. Só pode ser acessado via rede privada

## Como vamos criar tudo isso?
Vamos usar tecnologias para construir toda esta infraestrutura usando linguagens que fornecem suporte a construção, configuração e manutanção a partir da construção de alguns [[scripts]]. 
### Iremos usar (até agora):
1. Terraform
2. Ansible    

## Iremos tentar usar Molecule
## Iremos usar Packer
## Usaremos docker sempre que possível e necessário
## Iremos customizar nossa container imagem 
## Nossa base é toda GNU/Linux (não sei bem como fazer algumas cosias com windows - mas se for necessário podemos tentar)
## Pretendemos usar EKS
