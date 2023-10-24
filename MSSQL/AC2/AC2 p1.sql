--1. Criar uma Stored Procedure que recebe via parâmetro o nome do personagem e retorna (via select) 
--o Nome do Personagem, Ano de Nascimento do Personagem, Nome da Raça, Nome da Classe e Nome da Habilidade.

CREATE OR ALTER PROC spPersonagemDados @nomePersonagem varchar(100) 
AS
BEGIN
    SELECT 
        p.nome as NomePersonagem, 
        YEAR(p.dataNascimento) as AnoNascimento, 
        r.nome as Raça, 
        c.nome as Classe, 
        h.nome as Habilidade
    FROM Personagem p
    JOIN Raca r ON p.IDRaca = r.IDRaca
    JOIN Classe c ON p.IDClasse = c.IDClasse
    JOIN Habilidade h ON c.IDHabilidade = h.IDHabilidade
    WHERE p.nome = @nomePersonagem
END;

EXEC spPersonagemDados 'Odin';


--2. Criar uma Stored Procedure que recebe via parâmetro dois inteiros referentes ao intervalo do ano
--(ano início e ano fim) de nascimento do personagem e retorna via parâmetro de OUTPUT a
--quantidade de personagens que nasceram no intervalo de ano informado via parâmetro.

CREATE OR ALTER PROC spPersonagemIntervaloAno @anoInicio int, @anoFim int, @qtdPersonagens int OUTPUT
AS
BEGIN 
    SELECT @qtdPersonagens = COUNT(*) 
    FROM Personagem
    WHERE YEAR(dataNascimento) BETWEEN @anoInicio AND @anoFim
END;

DECLARE @qtdPersonagens int
EXEC spPersonagemIntervaloAno 1780, 2000, @qtdPersonagens OUTPUT
SELECT @qtdPersonagens as QtdPersonagens;


--3. Criar  uma  Stored  Procedure  para  atualizar  o  valor  do  campo  MultiplicadorPoder  da  tabela 
--Habilidade. Devem ser informados como parâmetros o ID da Habilidade e a quantidade a adicionar 
--ou  subtrair  do  multiplicador.  Deve  ser  utilizado  o  conceito  de  transações  para  evitar  que  a 
--quantidade de pontos fique negativa ou acima de 100 (cem), quando isso ocorrera operação deve 
--ser “desfeita” e uma mensagem de erro personalizada/customizada deve ser exibida.

CREATE OR ALTER PROC spAlterarMultiplicador @IDHabilidade int, @pontosAdicionar int
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION
            UPDATE Habilidade
            SET MultiplicadorPoder = MultiplicadorPoder + @pontosAdicionar
            WHERE IDHabilidade = @IDHabilidade

            IF (SELECT MultiplicadorPoder FROM Habilidade WHERE IDHabilidade = @IDHabilidade) < 0
            BEGIN
                RAISERROR('Multiplicador não pode ser negativo', 16, 1)
            END
            ELSE IF (SELECT MultiplicadorPoder FROM Habilidade WHERE IDHabilidade = @IDHabilidade) > 100
            BEGIN
                RAISERROR('Multiplicador não pode ser maior que 100', 16, 1)
            END

        COMMIT TRANSACTION
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION
        SELECT 'Erro: ' + ERROR_MESSAGE() AS Erro
    END CATCH
END;

EXEC spAlterarMultiplicador 1, -60
SELECT * FROM Habilidade WHERE IDHabilidade = 1


--4. Criar uma Scalar Function que recebe como parâmetro o IDClasse e retorna à quantidade de
--Personagens associados. O parâmetro informado deve ser utilizado para filtrar o resultado. 

CREATE OR ALTER FUNCTION fnQtdPersonagensPorClasse(@IDClasse int)
RETURNS INT
AS
BEGIN
    DECLARE @QtdPersonagem INT
    SELECT @QtdPersonagem = COUNT(*)
    FROM Personagem p
    JOIN Classe c
    ON c.IDClasse = p.IDClasse
    WHERE c.IDClasse = @IDClasse
    GROUP BY c.Nome
    RETURN @QtdPersonagem
END;

SELECT dbo.fnQtdPersonagensPorClasse(1) AS QtdPersonagens;