-- 1. Criar a tabela do Log chamada LogFull conforme detalhes descritos. 
-- Tabela: LogFull 
-- IDLogFull int Primary Key Identity not null 
-- Tabela   varchar(255) not null 
-- Operacao varchar(255) not null 
-- Detalhes varchar(1000) not null 
-- DataEvento datetime not null 

CREATE TABLE LogFull (
    IDLogFull int Primary Key Identity not null,
    Tabela varchar(255) not null,
    Operacao varchar(255) not null,
    Detalhes varchar(1000) not null,
    DataEvento datetime not null
);


-- 2. Criar uma Trigger que no momento da inserção do Personagem verifique se a idade é maior ou 
-- igual a 18 anos (verificar através do campo DataNascimento). Caso não seja a operação deve ser 
-- cancelada (rollback).

CREATE OR ALTER TRIGGER trgPersonagemMaiorDeIdade
ON Personagem
AFTER INSERT
AS
BEGIN
    -- Verifica se há alguma linha inserida com menos de 18 anos.
    IF EXISTS (SELECT * FROM inserted WHERE DATEDIFF(year, DataNascimento, GETDATE()) < 18)
    BEGIN
        RAISERROR('Personagem menor de idade', 16, 1)
        ROLLBACK TRANSACTION
    END
END;


-- Falha
INSERT INTO Personagem VALUES ('Magno', 'Feroz', '2015-11-10', 3, 3, 63);
-- Sucesso
INSERT INTO Personagem VALUES ('Magno', 'Raivoso', '1995-11-10', 3, 3, 63);


-- 3. Criar um Trigger para gravar na tabela LogFull as informações referentes a inserção realizada na 
-- tabela Personagem. O campo detalhes deve conter o Nome do Personagem, Nome da Raça, Nome 
-- da Classe e Nome da Habilidade.

CREATE OR ALTER TRIGGER trgInsercaoPersonagem 
ON Personagem
AFTER INSERT
AS
BEGIN
    INSERT INTO LogFull (Tabela, Operacao, Detalhes, DataEvento)
    VALUES ('Personagem', 
            'Insert', 
            (SELECT CONCAT('Nome: ', i.nome, ', Raça: ', r.nome, ', Classe: ', c.nome, ', Habilidade: ', h.nome) 
                FROM inserted i
                JOIN Classe c ON c.IDClasse = i.IDClasse
                JOIN Raca r ON r.IDRaca = i.IDRaca
                JOIN Habilidade h ON h.IDHabilidade = c.IDHabilidade),
            getdate())
END;

-- Exemplo de inserção
INSERT INTO Personagem VALUES ('Ragnar', 'Destruidor', '1925-10-20', 1, 2, 63);
SELECT * FROM LogFull;


-- 4. Existe a possibilidade de criar o item 2 e 3 em uma única Trigger. Se sim, como ela ficaria?
-- Sim! Existe. Segue abaixo:

CREATE OR ALTER TRIGGER trgVerificarIdadeELog
ON Personagem
AFTER INSERT
AS
BEGIN
    IF EXISTS (SELECT 1 FROM inserted WHERE DATEDIFF(YEAR, DataNascimento, GETDATE()) < 18)
    BEGIN
        PRINT 'A idade do personagem deve ser maior ou igual a 18 anos.'
        ROLLBACK
    END
    ELSE
    BEGIN
        INSERT INTO LogFull (Tabela, Operacao, Detalhes, DataEvento)
        SELECT 'Personagem', 'Insert', 
               'Nome: ' + i.Nome + ', Raça: ' + R.Nome + ', Classe: ' + C.Nome + ', Habilidade: ' + H.Nome,
               GETDATE()
        FROM inserted i
        INNER JOIN Raca R ON i.IDRaca = R.IDRaca
        INNER JOIN Classe C ON i.IDClasse = C.IDClasse
        INNER JOIN Habilidade H ON C.IDHabilidade = H.IDHabilidade
    END
END;

-- Exemplo de inserção (idade válida)
INSERT INTO Personagem (Nome, Descricao, DataNascimento, IDRaca, IDClasse, Poder)
VALUES ('Mateus', 'Agil e sagaz', '1990-11-10', 3, 3, 63);
SELECT * FROM LogFull;

-- Exemplo de inserção (idade inválida)
INSERT INTO Personagem (Nome, Descricao, DataNascimento, IDRaca, IDClasse, Poder)
VALUES ('Kaique', 'Sabio e cauteloso', '11-10-2007', 1, 2, 63);
SELECT * FROM LogFull;


-- 5. Criar uma Trigger para gravar na tabela LogFull todas as alterações realizadas na tabela Raça. No 
-- campo Detalhes dever conter o valor antigo e atual do Nome e Origem. 

CREATE OR ALTER TRIGGER trgLogAlteracaoRaca
ON Raca
AFTER UPDATE
AS
BEGIN
    INSERT INTO LogFull (Tabela, Operacao, Detalhes, DataEvento)
    VALUES (
        'Raça',
        'Update',
        'Nome Antigo: ' + (SELECT Nome FROM deleted) + ', Nome Atual: ' + (SELECT Nome FROM inserted) + 
        ', Origem Antiga: ' + (SELECT Origem FROM deleted) + ', Origem Atual: ' + (SELECT Origem FROM inserted),
        GETDATE()
    )
END;

-- Exemplo de alteração
UPDATE Raca SET Nome = 'Orc', Origem = 'Montanhas' WHERE IDRaca = 2;
SELECT * FROM LogFull;


-- 6. Criar uma Trigger para gravar na tabela LogFull todas as exclusões realizadas na tabela Habilidade. 
-- No  campo  Detalhes  deve  conter  o  ID,  Nome  e  o  valor  do  MultiplicadorPoder  que  está  sendo 
-- excluído.
CREATE or ALTER TRIGGER tgrGravaExclusoes
ON Habilidade
AFTER DELETE
AS 
BEGIN
	INSERT INTO LogFull (Tabela, Operacao, Detalhes, DataEvento) 
        VALUES (
            'Habilidade',
            'Delete',
            (SELECT CONCAT('ID: ', CAST(d.IDHabilidade AS VARCHAR),', Nome: ', d.Nome,', MultiplicadorPoder: ', CAST(d.MultiplicadorPoder AS VARCHAR))
            FROM deleted d),
            GETDATE()
        )
END;

-- Exemplo de exclusão
INSERT INTO Habilidade VALUES ('Fogo Sombrio', '5');
DELETE FROM Habilidade WHERE Nome = 'Fogo Sombrio';
SELECT * FROM LogFull;