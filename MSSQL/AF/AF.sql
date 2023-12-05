--Categoria
CREATE TABLE Categoria
(
	IDCategoria int identity primary key,
	Nome varchar(200) not null,
	Descricao varchar(2000) not null
)
GO

CREATE TABLE Game
(
	IDGame int identity primary key,
	Titulo varchar (200) not null,
	Descricao varchar (1000),
	DataLancamento datetime not null,
	Formato varchar (100),
	IDCategoria int REFERENCES Categoria (IDCategoria) not null,
	Valor numeric(18,2) not null
)
GO

CREATE TABLE Jogador
(
	IDJogador int identity primary key,
	Nome varchar (40) not null,
	NickName varchar (10) not null,
	Email varchar (100),
	Senha varchar (20) not null,
	DataNascimento datetime not null,
	IDGame int REFERENCES Game (IDGame) not null
)
GO

CREATE TABLE LogFinal
(
	ID int primary key identity, 
	Tabela varchar(1000), 
	Informacoes varchar(5000),
	DataLog datetime
)
GO

SET DATEFORMAT DMY
--EXEMPLOS DE INSERT
--Categoria
--Select * from Categoria
INSERT INTO Categoria (Nome, Descricao) VALUES ('RPG', 'Role-playing game');
INSERT INTO Categoria (Nome, Descricao) VALUES ('FPS', 'First-person shooter');
INSERT INTO Categoria (Nome, Descricao) VALUES ('MMORPG', 'Massively multiplayer online role-playing game');
INSERT INTO Categoria (Nome, Descricao) VALUES ('MOBA', 'Multiplayer online battle arena');
INSERT INTO Categoria (Nome, Descricao) VALUES ('RTS', 'Real-time strategy');

--Game
--Select * from Game
INSERT INTO Game (Titulo, Descricao, DataLancamento, Formato, IDCategoria, Valor) VALUES ('World of Warcraft', 'WoW', '23-01-2023', 'Online', 1, 125.50);
INSERT INTO Game (Titulo, Descricao, DataLancamento, Formato, IDCategoria, Valor) VALUES ('League of Legends', 'LoL', '23-01-2023', 'Online', 4, 125.50);
INSERT INTO Game (Titulo, Descricao, DataLancamento, Formato, IDCategoria, Valor) VALUES ('Counter-Strike', 'CS', '23-01-2023', 'Online', 2, 125.50);
INSERT INTO Game (Titulo, Descricao, DataLancamento, Formato, IDCategoria, Valor) VALUES ('Age of Empires', 'AoE', '23-01-2023', 'Online', 5, 125.50);
INSERT INTO Game (Titulo, Descricao, DataLancamento, Formato, IDCategoria, Valor) VALUES ('The Witcher', 'TW', '23-01-2023', 'Online', 1, 125.50);

--Jogador
--Select * from Jogador
INSERT INTO Jogador (Nome, NickName, Email, Senha, DataNascimento, IDGame) VALUES ('Cristiano Ronaldo', 'CR7', 'cr7@top.com', 'gol123', '11-02-1992', 1);
INSERT INTO Jogador (Nome, NickName, Email, Senha, DataNascimento, IDGame) VALUES ('Lionel Messi', 'LM10', 'ln@hotmail.com', 'gol123', '11-02-1992', 2);
INSERT INTO Jogador (Nome, NickName, Email, Senha, DataNascimento, IDGame) VALUES ('Gabriel Fallen', 'Fallen', 'Fallen@hotmail.com', 'cs123', '03-05-1980', 3);
INSERT INTO Jogador (Nome, NickName, Email, Senha, DataNascimento, IDGame) VALUES ('Gabriel Tockers', 'Tockers', 'gabs@gmail.com', 'lol123', '03-05-1980', 4);
INSERT INTO Jogador (Nome, NickName, Email, Senha, DataNascimento, IDGame) VALUES ('Gabriel Remy', 'Remy', 'remy@email.com', 'aoe123', '03-05-1980', 5);

--SELECT * FROM LogFinal


GO;

-- Exercício 1
-- Baseado no diagrama ER informado, 
-- qual comando SQL deve ser utilizado para alterar o campo Email da tabela Jogador para varchar(255).

ALTER TABLE Jogador ALTER COLUMN Email varchar(255);


-- Exercício 2
-- Baseado no diagrama ER informado, qual comando SQL deve ser utilizado para atualizar o Valor dos Games
-- concedendo um desconto de 20% nos casos que ele foi lançado entre os anos de 2020 e 2023.

UPDATE Game
SET Valor = Valor * 0.8
WHERE YEAR(DataLancamento) BETWEEN 2020 AND 2023;


-- Exercício 3
-- Baseado no diagrama ER informado, 
-- deve ser criada uma consulta SQL para exibir o Nome e Descrição da tabela Categoria.

SELECT Nome, Descricao FROM Categoria;


-- Exercício 4
-- Baseado no diagrama ER informado, qual comando SQL deve ser utilizado para 
-- exibir o nome da Categoria e o valor médio dos seus Games.

SELECT
    C.Nome,
    AVG(G.Valor)
FROM Categoria C
JOIN Game G
    ON G.IDCategoria = C.IDCategoria
GROUP BY C.Nome;


-- Exercício 5
-- Baseado no diagrama ER informado, qual consulta em SQL para exibir o NickName e Senha do Jogador 
-- e o Título dos Games, quando a senha iniciar em  “123”.

SELECT J.NickName, J.Senha, G.Titulo
FROM Jogador J
JOIN Game G
ON J.IDGame = G.IDGame
WHERE J.Senha LIKE '123%';


-- Exercício 8
-- Baseado no diagrama ER informado, criar um gatilho (trigger) que será responsável por armazenar 
-- na tabela LogFinal todas as atualizações realizadas na tabela Jogador. Na tabela LogFinal, o 
-- campo informações deve conter Nome e Senha antigos e atuais.
-- Importante: Disponibilizar um exemplo de “execução” (operações de insert / update / delete) 
-- para validação da operação e tipo do trigger (gatilho).
GO


CREATE OR ALTER TRIGGER trgJogadorAtualiza
ON Jogador
AFTER UPDATE
AS
BEGIN
    INSERT INTO LogFinal (
        Tabela, 
        Informacoes, 
        Datalog
    )
    SELECT
        'Jogador - Update',
        'Nome Antigo: ' + V.Nome +
        ' Nome Atual: ' + N.Nome +
        ' - Senha Antiga: ' + V.Senha + 
        ' Senha Atual: ' + N.Senha,
        GETDATE()
    FROM Inserted N Join Deleted V
    ON N.IDJogador = V.IDJogador
END;

UPDATE Jogador SET Nome = 'Milton', Senha = 'miltonj' WHERE Nome = 'Cristiano Ronaldo'; 
SELECT * FROM LogFinal;
