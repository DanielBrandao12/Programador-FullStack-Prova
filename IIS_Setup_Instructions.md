
# Instruções para Configurar IIS e Hospedar Backend ASP Clássico

## 1. Instalar IIS e ASP Clássico

1. Abrir o **Painel de Controle** → Programas → Ativar ou desativar recursos do Windows.  
2. Marcar **Internet Information Services (IIS)**.  
3. Expandir **Serviços de Aplicativo** → marcar **ASP** (ASP Clássico).  
4. Aplicar e aguardar a instalação.  

## 2. Configurar Site no IIS

1. Abrir **Gerenciador do IIS**.  
2. Clicar com o botão direito em **Sites** → **Adicionar site**.  
3. Configurar:
   - Nome do site: `BackendProdutos`
   - Caminho físico: pasta `backend` do projeto
   - Porta: 80 (ou outra disponível)  
4. Confirmar e iniciar o site.  

## 3. Permissões

- Garantir que o **IUSR** e **IIS_IUSRS** tenham permissão de leitura/escrita na pasta do backend.  
- Configurar **pool de aplicativos** para usar **ASP Clássico**.

## 4. Habilitar ASP Clássico no Site

1. Selecionar o site → abrir **Recursos ASP**.  
2. Ativar **Habilitar ASP**.  
3. Configurar **timeout, buffer e script debugging** conforme necessário.  

## 5. Testar o Backend

1. Abrir navegador e acessar a URL do site:  
   http://localhost/BackendProdutos/api/products/index.asp
2. Se aparecer erro de permissões, verificar logs do IIS e ajustar permissões da pasta.  
3. Testar rotas usando Postman ou Insomnia.  

## 6. Configuração do Banco de Dados

- Configurar a **connection string** no arquivo `db.asp`.  
- Executar todos os scripts SQL do repositório para criar tabelas, procedures, triggers e dados de seed.
