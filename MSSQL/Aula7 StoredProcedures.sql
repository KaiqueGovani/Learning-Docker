CREATE OR ALTER PROCEDURE spPrimeiraProc
as
BEGIN
    SELECT 'Minha primeira proc' Texto
END;

EXEC spPrimeiraProc;

CREATE OR ALTER PROCEDURE spSegundaProc @novaCor VARCHAR(1000), @id INT
AS
BEGIN 
    update Veiculo SET Cor = @novaCor WHERE IDVeiculo = @id
END;

CREATE OR ALTER PROCEDURE spAddFabricante
    @nome VARCHAR(200),
    @cidade VARCHAR(150),
    @estado VARCHAR(10),
    @descricao VARCHAR(500) = NULL
AS
BEGIN
    INSERT INTO Fabricante 
        (nome, cidade, estado, descricao) 
    VALUES (@nome, @cidade, @estado, @descricao)
END;

