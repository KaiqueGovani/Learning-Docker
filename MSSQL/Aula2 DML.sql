INSERT INTO Modelo (Nome, NumeroLugares, Tipo) VALUES
    ('HB20s', 5, 'Sedan'),
    ('Onix', 5, 'Hatch'),
    ('Porsche Spyder', 2, 'Outros');

INSERT INTO Modelo VALUES
    ('TCross', 'Carro Legal', 5, 'SUV');  

INSERT INTO Modelo VALUES
    ('Gol G3', null, 5, 'Hatch');

--Vai dar Erro -> Esportivo não é um tipo válido
INSERT INTO Modelo VALUES
    ('Mercedes AMG', 'Topzera', 5, 'Esportivo');

set dateformat dmy;

INSERT INTO Veiculo (Proprietario, Placa, IDModelo, Valor, AnoFabricacao, DataCompra) VALUES
    ('Anna Clara', 'ANN2A18', 6, 60000, 2015, '28-10-2013');

INSERT INTO Veiculo VALUES
    ('Bernarndo', 'BEH1A08', '10-08-2020 15:59:29', 1, 40000, 2020, 'Branco'); 


