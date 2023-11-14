-- 1. Realizar INSERT em Fabricante somente entre os dias 1 - 20.
-- Caso contrário, cancela a operação

CREATE OR ALTER TRIGGER tgrInsertFabricante
ON Fabricante
AFTER INSERT
AS
BEGIN
    DECLARE @Hoje int
    SET @Hoje DAY(getdate())
    IF @Hoje > 20
    begin
        RAISERROR('Cadastro de fabricante somente antes do dia 20', 10, 1)
        ROLLBACK
    end
END
go

-- 2. Criar um gatilho (trigger) que realize a gravação de todas INCLUSÕES de Veiculos
--  

CREATE OR ALTER TABLE TRIGGER tgrLogInsertVeiculo
ON Veiculo 
AFTER INSERT
AS
BEGIN
    INSERT INTO LogInfo (Tabela, Informacores, DataLog) VALUES
    ('Veiculo', 'Inclusão de veiculo', getdate())
END
go

SET DATEFORMAT dmy

insert into veiculo values ('Pedro bial', 'PEB0X1212', getdate(), 1, 50000, 2023, 'verde');

-- 3. Criar um gatilho (trigger) que realize a gravação de todas ATUALIZAÇÕES de
-- Veiculos em uma tabela de log (LogInfo) 

CREATE OR ALTER TRIGGER tgrLogUpdateVeiculo
ON Veiculo
AFTER UPDATE
BEGIN
    INSERT INTO LogInfo (Tabela, Informacores, DataLog) VALUES
    ('Veiculo', 'Atualização de veiculo', getdate())
END
