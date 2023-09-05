CREATE TABLE Modelo (
    IDModelo INT NOT NULL PRIMARY KEY IDENTITY,
    Nome VARCHAR(255) NOT NULL,
    Descricao VARCHAR(511),
);

CREATE TABLE Veiculo (
    IDVeiculo INT NOT NULL PRIMARY KEY IDENTITY,
    Proprietario VARCHAR(255) NOT NULL,
    Placa VARCHAR(7) NOT NULL,
    DataCompra DATETIME NULL,
    IDModelo INT NOT NULL  REFERENCES Modelo(IDModelo),
    Valor NUMERIC(18,2) NOT NULL,
   /*  CONSTRAINT FK_Modelo_Veiculo FOREIGN KEY (IDModelo) REFERENCES Modelo(IDModelo),
    CONSTRAINT PK_Veiculo PRIMARY KEY (IDVeiculo);  */
);

SELECT v.IDVeiculo, v.Placa, v.Proprietario, v.Valor, m.Descricao, m.IDModelo, m.Nome FROM Veiculo v
INNER JOIN Modelo m ON m.IDModelo = v.IDModelo;

CREATE TABLE ExemploChaveComposta (
    IDChave1 int not null,
    IDChave2 int not null,
    Nome varchar(100) not null,
    constraint PK_ExemploChaveComposta primary key (IDChave1, IDChave2)
);

ALTER TABLE Modelo ADD NumeroLugares int;
ALTER TABLE Modelo ADD Tipo varchar(100);

ALTER TABLE Modelo ADD CHECK (Tipo in('Sedan', 'Hatch', 'SUV', 'Outros'));

ALTER TABLE Modelo ADD CONSTRAINT DefLugares DEFAULT 5 FOR NumeroLugares;

/* 
Tabela Veiculo
▪ Adicionar Colunas
▪   VouApagar numeric(18,2)
▪   AnoFabricacao int
▪   Cores varchar(10)
▪ Adicionar Consistência
▪   AnoFabricacao como not null
▪ Tamanho da Coluna
▪   Cores para varchar(50)
▪ Excluir coluna
▪   VouApagar
▪ Renomear Coluna
▪   Cores para Cor
*/;

ALTER TABLE Veiculo ADD VouApagar numeric(18,2);
ALTER TABLE Veiculo ADD AnoFabricacao int;
ALTER TABLE Veiculo ADD Cores varchar(10);

ALTER TABLE Veiculo ALTER COLUMN AnoFabricacao int NOT NULL;

ALTER TABLE Veiculo ALTER COLUMN Cores varchar(50);

ALTER TABLE Veiculo DROP COLUMN VouApagar;

EXEC sp_rename 'Veiculo.Cores', 'Cor';