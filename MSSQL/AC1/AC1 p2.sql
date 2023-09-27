--QUESTÃO 1
SELECT COUNT(*) Habilidades_Cadastradas from Habilidade;

--QUESTÃO 2
SELECT c.Nome, COUNT(IDPersonagem) Qtde_Personagens From Classe c INNER JOIN Personagem p ON c.IDClasse = p.IDClasse GROUP BY c.Nome;

--QUESTÃO 3
SELECT r.Nome, COUNT(IDPersonagem) Qtde_Personagens From Raca r LEFT JOIN Personagem p ON r.IDRaca = p.IDRaca GROUP BY r.Nome;


--QUESTÃO 4
SELECT
	c.Nome, AVG(p.Poder) Media_Poder, 
	SUM(p.Poder) Soma_Poder
FROM 
		Classe c INNER JOIN Personagem p
		ON c.IDClasse = p.IDClasse
GROUP BY c.Nome
HAVING AVG(p.Poder) >= 100;

--QUESTÃO 5
SELECT 
	p.Nome AS Nome_Personagem, 
	p.DataNascimento AS Data_Personagem, 
	r.Nome AS Nome_Raca, 
	c.Nome AS Nome_Classe, 
	h.Nome AS Nome_Habilidade
FROM
	Personagem p INNER JOIN Classe c
ON p.IDClasse = c.IDClasse
	INNER JOIN Raca r
ON p.IDRaca = r.IDRaca
	INNER JOIN Habilidade h
ON c.IDHabilidade = h.IDHabilidade;