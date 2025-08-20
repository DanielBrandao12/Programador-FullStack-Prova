
# Sistema de Produtos - Backend ASP Clássico + Frontend HTML/JS

## Descrição do Projeto
Sistema simples de cadastro e gerenciamento de produtos com autenticação de usuários.  
Backend em **ASP Clássico** com **SQL Server** e frontend em **HTML/JS**.  
Inclui: CRUD de produtos, login de usuários, filtros e ordenação de produtos.

## Pré-requisitos

- VS Code (ou outro editor de código)  
- SQL Server  
- Postman (para testar API)  
- IIS (Internet Information Services) com ASP clássico habilitado  
- Navegador moderno para o frontend  

## Passo a passo para rodar o backend

1. Baixar o repositório do projeto.  
2. Copiar a pasta **backend** para o diretório do IIS, normalmente:
   C:\inetpub\wwwroot\
3. Configurar um site no IIS apontando para a pasta **backend**.  
4. Habilitar ASP clássico no IIS.  
5. Configurar a **connection string** no arquivo `db.asp`.  
6. Abrir o SQL Server e criar o banco de dados executando os scripts SQL que estão no repositório (incluindo DDL, DML, procedures, triggers e função).  

## Rodando o frontend

1. Abrir a pasta **frontend**.  
2. Abrir o arquivo `index.html` diretamente no navegador.  

> Certifique-se de que o backend esteja rodando no IIS e acessível para que o frontend consiga se comunicar com a API.

## Testando a API

- Importar a coleção Postman ou Insomnia que acompanha o repositório.  
- Testar as rotas de login, cadastro de usuários e CRUD de produtos.  

## Observações

- O sistema usa SHA1 + SALT para criptografia de senhas.  
- Os logs de atualização e exclusão de produtos são gerados automaticamente em `ProdutosLog` via triggers.  
- O token de autenticação é gerado pela função `fn_GerarToken` no SQL Server.
