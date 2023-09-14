USE Treinamento_TSQL

DROP TABLE IF EXISTS Vendas

CREATE TABLE Vendas (
	Id_Venda INT IDENTITY(1,1) NOT NULL,
	Id_Loja INT NOT NULL,	
	Dt_Venda DATETIME NOT NULL,
	Vl_Venda NUMERIC(9,2) NOT NULL,
	Id_Cliente INT NOT NULL,
	CONSTRAINT PK_Vendas PRIMARY KEY(Id_Venda)
)

INSERT INTO Vendas (Id_Loja, Dt_Venda, Vl_Venda, Id_Cliente)
VALUES
	(1, '20180101', 100.00, 1),
	(1, '20180226', 50.00, 1),
	(1, '20180315', 200.00, 1),
	(1, '20180420', 400.00, 1),
	(1, '20180531', 250.00, 1),
	(1, '20190302', 250.00, 1),
	(1, '20190624', 250.00, 1),
	(1, '20200816', 250.00, 1),
	(1, '20210919', 750.00, 1),
	(1, '20211005', 750.00, 1),
	(1, '20180101', 100.00, 2),
	(1, '20180226', 50.00, 2),
	(1, '20180315', 200.00, 2),
	(1, '20180420', 400.00, 2),
	(1, '20180531', 250.00, 2),
	(1, '20190302', 250.00, 2),
	(1, '20190624', 250.00, 2),
	(1, '20200816', 250.00, 2),
	(1, '20210919', 750.00, 2),
	(1, '20211005', 750.00, 2),
	(2, '20180101', 100.00, 1),
	(2, '20180226', 50.00, 1),
	(2, '20180315', 200.00, 1),
	(2, '20180420', 400.00, 1),
	(2, '20180531', 250.00, 1),
	(2, '20190302', 250.00, 1),
	(2, '20190624', 250.00, 1),
	(2, '20200816', 250.00, 1),
	(2, '20210919', 750.00, 1),
	(2, '20211005', 750.00, 1),
	(2, '20180101', 100.00, 2),
	(2, '20180226', 50.00, 2),
	(2, '20180315', 200.00, 2),
	(2, '20180420', 400.00, 2),
	(2, '20180531', 250.00, 2),
	(2, '20190302', 250.00, 2),
	(2, '20190624', 250.00, 2),
	(2, '20200816', 250.00, 2),
	(2, '20210919', 750.00, 2),
	(2, '20211005', 750.00, 2)

SELECT * 
FROM Vendas
GO