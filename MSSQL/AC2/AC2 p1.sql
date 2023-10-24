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
SELECT @qtdPersonagens;