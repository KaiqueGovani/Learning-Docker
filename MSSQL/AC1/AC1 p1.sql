DROP TABLE IF EXISTS Personagem;
DROP TABLE IF EXISTS Classe;
DROP TABLE IF EXISTS Habilidade;
DROP TABLE IF EXISTS Raca;

---------------------------------
--Questão 1

CREATE TABLE Raca (
    IDRaca INT IDENTITY PRIMARY KEY,
    Nome VARCHAR(100) NOT NULL,
    Descricao VARCHAR(500) NULL,
    Origem VARCHAR(150) NOT NULL,
    Perdido DATETIME NULL,
);

CREATE TABLE Habilidade (
    IDHabilidade INT IDENTITY PRIMARY KEY,
    Nome VARCHAR(200) NOT NULL,
    MultiplicadorPoder INT NULL
);

CREATE TABLE Classe (
    IDClasse INT IDENTITY PRIMARY KEY,
    Nome VARCHAR(100) NOT NULL,
    Caracteristicas VARCHAR(1000) NULL,
    IDHabilidade INT FOREIGN KEY REFERENCES Habilidade(IDHabilidade) NULL
);

CREATE TABLE Personagem (
    IDPersonagem INT IDENTITY PRIMARY KEY,
    Nome VARCHAR(100) NOT NULL,
    Descricao VARCHAR(500) NULL,
    DataNascimento DATETIME NOT NULL,
	IDRaca INT FOREIGN KEY REFERENCES Raca(IDRaca) NOT NULL,
    IDClasse INT FOREIGN KEY REFERENCES Classe(IDClasse) NOT NULL
);

--Questão 2
ALTER TABLE Personagem ADD Poder INT NOT NULL;
--Questão 3
ALTER TABLE Classe ALTER COLUMN Caracteristicas VARCHAR(500);
--Questão 4
ALTER TABLE Raca DROP COLUMN Perdido;

--Questão 5
INSERT INTO Habilidade values ('Bola de Fogo', '2')
INSERT INTO Habilidade values ('Chuva de Flechas', '2')
INSERT INTO Habilidade values ('Ultra Soco', '2');

INSERT INTO Classe values ('Arqueiro', 'Longo alcance', 2)
INSERT INTO Classe values ('Guerreiro', 'Curto alcance', 3)
INSERT INTO Classe values ('Mago', 'Dano mágico', 1);

INSERT INTO Raca values ('Humano', 'Adaptáveis e versáteis', 'Reinos ou vilas')
INSERT INTO Raca values ('Elfo', 'Graciosos e imortais', 'Florestas')
INSERT INTO Raca values ('Orc', 'Robustos e ferozes', 'Montanhas');

INSERT INTO Personagem values ('Thor', 'Alto e Sábio', '1777-02-13', 1, 3, 55)
INSERT INTO Personagem values ('Freyja', 'Pequena e Agil', '1785-10-01', 2, 1, 37)
INSERT INTO Personagem values ('Odin', 'Forte e Assustador', '1764-09-23', 3, 2, 99);

-- Variações para a tabela Habilidade
INSERT INTO Habilidade VALUES ('Explosão Gélida', '4')
INSERT INTO Habilidade VALUES ('Flecha de Fogo', '3')
INSERT INTO Habilidade VALUES ('Impacto Sísmico', '5');

-- Variações para a tabela Classe
INSERT INTO Classe VALUES ('Cavaleiro', 'Protetor', 4)
INSERT INTO Classe VALUES ('Necromante', 'Magia Negra', 2)
INSERT INTO Classe VALUES ('Ladino', 'Furtivo', 3);

-- Variações para a tabela Raca
INSERT INTO Raca VALUES ('Anão', 'Resistentes', 'Cavernas')
INSERT INTO Raca VALUES ('Fada', 'Encantadoras', 'Florestas')
INSERT INTO Raca VALUES ('Gnomo', 'Engenheiros', 'Subterrâneo');

-- Variações para a tabela Personagem
INSERT INTO Personagem VALUES ('Elena', 'Misteriosa', '1980-07-15', 1, 2, 42)
INSERT INTO Personagem VALUES ('Aragorn', 'Destemido', '1978-03-23', 2, 1, 55)
INSERT INTO Personagem VALUES ('Grommash', 'Feroz', '1985-11-10', 3, 3, 63);




--Questão 6
UPDATE Classe set Caracteristicas = 'Caracteristicas Gerais' where Caracteristicas is null;

--Questão 7
DELETE from Personagem where YEAR(DataNascimento) BETWEEN '1970' and '1990';

--Questão 8
SELECT * from Classe;

--Questão 9
SELECT Nome, DataNascimento, Poder from Personagem where Poder BETWEEN 0 and 75;

--Questão 10
SELECT Nome, Descricao, Origem from Raca where Nome LIKE '%Orc%';