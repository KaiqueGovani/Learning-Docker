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
)


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
        RAISERROR('Personagem menor de idade', 16, 1);
        ROLLBACK TRANSACTION;
    END
END
;

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
            (SELECT CONCAT('Nome: ', i.nome, ' Raça: ', r.nome, ' Classe: ', c.nome, ' Habilidade: ', h.nome) 
                FROM inserted i
                JOIN Classe c ON c.IDClasse = i.IDClasse
                JOIN Raca r ON r.IDRaca = i.IDRaca
                JOIN Habilidade h ON h.IDHabilidade = c.IDHabilidade),
            getdate())
END;

INSERT INTO Personagem VALUES ('Ragnar', 'Destruidor', '1925-10-20', 1, 2, 63);
SELECT * FROM LogFull;