CREATE TABLE Usuarios (
    Id INT IDENTITY PRIMARY KEY,
    Nome NVARCHAR(100) NOT NULL,
    UserNome NVARCHAR(50) NOT NULL UNIQUE,
    Senha NVARCHAR(100) NOT NULL,
    Token NVARCHAR(100) NULL,
    DataCadastro DATETIME DEFAULT GETDATE()
);


CREATE TABLE Produtos (
    Id INT IDENTITY PRIMARY KEY,
    Nome NVARCHAR(100) NOT NULL,
    Preco DECIMAL(10,2) NOT NULL,
    Quantidade INT NOT NULL,
    DataCadastro DATETIME DEFAULT GETDATE()
);
    

CREATE TABLE ProdutosLog (
    IdLog INT IDENTITY PRIMARY KEY,
    ProdutoId INT NOT NULL,
    Acao NVARCHAR(50),
    DataAcao DATETIME DEFAULT GETDATE(),
    Usuario NVARCHAR(50)
);

INSERT INTO Usuarios (Nome, UserNome, Senha)
VALUES (
    'Administrador do Sistema',
    'admin',
    CONVERT(VARCHAR(40), HASHBYTES('SHA1', 'admin123Teste@2025'), 2) -- senha: admin123
);


INSERT INTO Produtos (Nome, Preco, Quantidade)
VALUES 
    ('Mouse Gamer RGB', 120.00, 15),
    ('Teclado Mecânico', 250.00, 10),
    ('Monitor 24 Full HD', 750.00, 5),
    ('Headset Gamer Surround', 180.00, 12),
    ('Cadeira Gamer Reclinável', 950.00, 3),
    ('Notebook i5 8GB SSD 256GB', 3200.00, 7);


SELECT * FROM Usuarios;
SELECT * FROM Produtos;
SELECT * FROM ProdutosLog;


--Create

CREATE PROCEDURE sp_CriarProduto
    @Nome NVARCHAR(100),
    @Preco DECIMAL(10,2),
    @Quantidade INT
AS
BEGIN
    INSERT INTO Produtos (Nome, Preco, Quantidade)
    VALUES (@Nome, @Preco, @Quantidade)
END
GO

-- READ
CREATE PROCEDURE sp_ListarProdutos
AS
BEGIN
    SELECT * FROM Produtos
END
GO

-- UPDATE
CREATE PROCEDURE sp_AtualizarProduto
    @Id INT,
    @Nome NVARCHAR(100),
    @Preco DECIMAL(10,2),
    @Quantidade INT
AS
BEGIN
    UPDATE Produtos
    SET Nome = @Nome,
        Preco = @Preco,
        Quantidade = @Quantidade
    WHERE Id = @Id
END
GO

-- DELETE
CREATE PROCEDURE sp_DeletarProduto
    @Id INT
AS
BEGIN
    DELETE FROM Produtos WHERE Id = @Id
END
GO


CREATE TRIGGER trg_Produtos_Update
ON Produtos
AFTER UPDATE
AS
BEGIN
    DECLARE @Usuario NVARCHAR(50) = SYSTEM_USER
    INSERT INTO ProdutosLog (ProdutoId, Acao, Usuario)
    SELECT Id, 'UPDATE', @Usuario FROM inserted
END
GO


CREATE TRIGGER trg_Produtos_Delete
ON Produtos
AFTER DELETE
AS
BEGIN
    DECLARE @Usuario NVARCHAR(50) = SYSTEM_USER
    INSERT INTO ProdutosLog (ProdutoId, Acao, Usuario)
    SELECT Id, 'DELETE', @Usuario FROM deleted
END
GO


CREATE FUNCTION fn_GerarToken(@UserNome NVARCHAR(50))
RETURNS NVARCHAR(100)
AS
BEGIN
    DECLARE @Token NVARCHAR(100)
    SET @Token = CONVERT(NVARCHAR(100), HASHBYTES('SHA1', @UserNome + CAST(GETDATE() AS NVARCHAR)), 2)
    RETURN @Token
END
GO
