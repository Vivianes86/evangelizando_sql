----------------------------------------------------------------------------------
---------------------------------- DICAS EXTRAS ----------------------------------
----------------------------------------------------------------------------------


----------------------------------------------------------------------------------
-- MICROSOFT DOCS: LINKS �TEIS
----------------------------------------------------------------------------------
-- REFER�NCIAS:
-- Editions and supported features of SQL Server 2022:
-- https://learn.microsoft.com/en-us/sql/sql-server/editions-and-components-of-sql-server-2022?view=sql-server-ver16

-- Data types (Transact-SQL)
-- https://learn.microsoft.com/en-us/sql/t-sql/data-types/data-types-transact-sql?view=sql-server-ver16
----------------------------------------------------------------------------------


----------------------------------------------------------------------------------
-- EVENTOS PELO BRASIL - SQL SATURDAY
----------------------------------------------------------------------------------
-- https://sqlsaturday.com/

-- Event Date: 21 October 2023
-- SQL Saturday Belo Horizonte 2023 (#1063)
-- https://sqlsaturday.com/2023-10-21-sqlsaturday1063/

-- Event Date: 28 October 2023
-- SQL Saturday Vit�ria 2023 (#1065)
-- https://sqlsaturday.com/2023-10-28-sqlsaturday1065/

-- Event Date: 25 November 2023
-- SQL Saturday Sao Paulo 2023 (#1067)
-- https://sqlsaturday.com/2023-11-25-sqlsaturday1067/
----------------------------------------------------------------------------------


----------------------------------------------------------------------------------
-- CURSO GRATUITO: "50 Dicas e Atalhos SSMS (SQL Server Management Studio)
----------------------------------------------------------------------------------
-- AUTOR: Luiz Lima
-- REFER�NCIA:
-- https://cursos.powertuning.com.br/course/50-dicas-e-atalhos-ssms

-- Exemplos:
-- DICA 1: CTRL + F -> Localizar "Linkedin"
-- DICA 2: F3 -> Pr�xima ocorr�ncia
-- DICA 3: SHIFT + F3 -> Ocorr�ncia anterior
-- DICA 4: CTRL + H -> Substituir "Linkedin" por "Instagram"
-- DICA 5: CTRL + Z -> Desfazer a substitui��o anterior
-- DICA 6: F8 -> Exibir o "Object Explorer"
-- DICA 7: Arrastar do Object Explorer: Nome Tabela / Colunas da Tabela "Traces..Queries_Profile"

USE Traces

SELECT 
	[TextData], [NTUserName], [HostName], [ApplicationName], [LoginName], [SPID], 
	[Duration], [StartTime], [EndTime], [ServerName], [Reads], [Writes], [CPU], [DataBaseName], [RowCounts]
FROM [dbo].[Queries_Profile]
----------------------------------------------------------------------------------


----------------------------------------------------------------------------------
-- ARTIGOS LINKEDIN: ENZO DELCOMPARE
----------------------------------------------------------------------------------
-- REFER�NCIAS:
-- Perfil Enzo:
-- https://www.linkedin.com/in/enzodelcompare/

-- Explorando os Comandos SQL: DDL, DQL, DML, DCL e TCL
-- https://www.linkedin.com/pulse/explorando-os-comandos-sql-ddl-dql-dml-dcl-e-tcl-enzo-delcompare

-- Explorando os Comandos SQL: DDL
-- https://www.linkedin.com/pulse/explorando-os-comandos-sql-ddl-enzo-delcompare
----------------------------------------------------------------------------------


----------------------------------------------------------------------------------
-- ERROS COMUNS: OBJETOS INEXISTENTES OU J� EXISTENTES!
----------------------------------------------------------------------------------
USE Traces

-- ERRO 1: Dropar algo que n�o existe!
DROP TABLE tabelaNaoExiste

/*
Msg 3701, Level 11, State 5, Line 56
Cannot drop the table 'tabelaNaoExiste', because it does not exist or you do not have permission.
*/

-- ERRO 2: Criar algo que j� existe!
CREATE TABLE [Log_Counter] (
	ID INT,
	LOG VARCHAR(100)
)

/*
Msg 2714, Level 16, State 6, Line 64
There is already an object named 'Log_Counter' in the database.
*/


----------------------------------------------------------------------------------
-- DICA: DROP IF EXISTS x OBJECT_ID
----------------------------------------------------------------------------------
-- VALIDAR A VERS�O DO SQL SERVER:
SELECT @@VERSION

/*
Microsoft SQL Server 2019 (RTM) - 15.0.2000.5 (X64)   
Sep 24 2019 13:48:23   Copyright (C) 2019 Microsoft Corporation  
Developer Edition (64-bit) on Windows 10 Pro 10.0 <X64> (Build 19045: ) 
*/

-- DICA 1: DROP IF EXISTS (A partir do SQL Server 2016)
-- Refer�ncia: https://learn.microsoft.com/pt-br/sql/t-sql/statements/drop-table-transact-sql?view=sql-server-ver16#syntax

DROP TABLE IF EXISTS testeIdentity

CREATE TABLE testeIdentity (
	ID INT,
	NOME VARCHAR(100)
)

-- DICA 2: DROP COM OBJECT_ID

-- OBJECT_ID: Retorna o ID do objeto no banco de dados, caso contr�rio, retorna NULL.
-- Refer�ncia: https://learn.microsoft.com/pt-br/sql/t-sql/functions/object-id-transact-sql?view=sql-server-ver16

-- Retorna o ID do objeto
SELECT OBJECT_ID('testeIdentity')

-- Retorna NULL:
SELECT OBJECT_ID('testeIdentityNaoExiste')

SELECT *
FROM sys.objects
WHERE object_id = OBJECT_ID('testeIdentity')

-- UTILIZANDO O "OBJECT_ID"
IF(OBJECT_ID('testeIdentity') IS NOT NULL) 
	DROP TABLE testeIdentity

CREATE TABLE testeIdentity (
	ID INT,
	NOME VARCHAR(100)
)


----------------------------------------------------------------------------------
-- D�VIDA: � poss�vel alterar uma coluna j� existente na tabela e incluir um IDENTITY?
----------------------------------------------------------------------------------
/*
-- Refer�ncia: https://stackoverflow.com/questions/1049210/adding-an-identity-to-an-existing-column

You can't alter the existing columns for identity. You have 2 options: 

1) Create a new table with identity & drop the existing table
2) Create a new column with identity & drop the existing column
*/

USE Traces

DROP TABLE IF EXISTS testeIdentity

CREATE TABLE testeIdentity (
	ID INT,
	NOME VARCHAR(100)
)

-- EXECUTAR O "ALT + F1" PARA MOSTRAR QUE A TABELA N�O POSSUI IDENTITY
SELECT * FROM testeIdentity

-- ALTERAR A COLUNA: N�O � POSS�VEL!
ALTER TABLE testeIdentity
ALTER COLUMN ID INT IDENTITY(1,1)

/*
Msg 156, Level 15, State 1, Line 75
Incorrect syntax near the keyword 'IDENTITY'.
*/

-- ADICIONAR UMA NOVA COLUNA: � POSS�VEL!
ALTER TABLE testeIdentity
ADD ID2 INT IDENTITY(1,1)

-- EXECUTAR O "ALT + F1" PARA MOSTRAR QUE AGORA A TABELA POSSUI IDENTITY NA COLUNA "ID2"
SELECT * FROM testeIdentity


----------------------------------------------------------------------------------
-- D�VIDA: � poss�vel criar uma Foreign Key (FK) entre duas databases distintas?
----------------------------------------------------------------------------------

-- CRIANDO UMA FOREIGN KEY NA MESMA DATABASE:
USE Teste

DROP TABLE IF EXISTS teste2
DROP TABLE IF EXISTS teste1

CREATE TABLE teste1 (
	ID INT IDENTITY(1,1) PRIMARY KEY,
	NOME VARCHAR(100)
)

CREATE TABLE teste2 (
	ID INT IDENTITY(1,1) PRIMARY KEY,
	ID_TESTE1 INT,
	NOME VARCHAR(100)
)

ALTER TABLE teste2
ADD CONSTRAINT FK_teste2_ID_TESTE1
FOREIGN KEY(ID_TESTE1)
REFERENCES teste1(ID)

-- EXECUTAR O "ALT + F1" E MOSTRAR A DEFINI��O DAS TABELAS:
-- teste1
-- teste2

-- TENTAR DROPAR A TABELA
DROP TABLE IF EXISTS teste1

/*
Msg 3726, Level 16, State 1, Line 176
Could not drop object 'teste1' because it is referenced by a FOREIGN KEY constraint.
*/

-- CRIANDO UMA FOREIGN KEY EM OUTRA DATABASE:
USE Traces

DROP TABLE IF EXISTS teste3

CREATE TABLE teste3 (
	ID INT IDENTITY(1,1) PRIMARY KEY,
	ID_TESTE1 INT,
	NOME VARCHAR(100)
)

-- Tabela inexistente
SELECT * FROM dbo.teste1

/*
Msg 208, Level 16, State 1, Line 218
Invalid object name 'dbo.teste1'.
*/

-- Fazendo o select na tabela da outra database
SELECT * FROM Teste.dbo.teste1

-- Tentando criar a FK...
ALTER TABLE teste3
ADD CONSTRAINT FK_teste3_ID_TESTE1
FOREIGN KEY(ID_TESTE1)
REFERENCES Teste.dbo.teste1(ID)

/*
Msg 1763, Level 16, State 0, Line 173
Cross-database foreign key references are not supported. Foreign key 'Teste.dbo.teste1'.
Msg 1750, Level 16, State 1, Line 173
Could not create constraint or index. See previous errors.
*/


----------------------------------------------------------------------------------
-- DICA: Import�ncia da Foreign Key para evitar dados inconsistentes!
----------------------------------------------------------------------------------
USE Traces

DROP TABLE IF EXISTS Produto
DROP TABLE IF EXISTS Marca

CREATE TABLE Marca (
	ID INT IDENTITY(1,1) PRIMARY KEY,
	NOME VARCHAR(100)
)

CREATE TABLE Produto (
	ID INT IDENTITY(1,1) PRIMARY KEY,
	ID_MARCA INT,
	NOME VARCHAR(100)
)

ALTER TABLE Produto
ADD CONSTRAINT FK_Produto_ID_MARCA
FOREIGN KEY(ID_MARCA)
REFERENCES Marca(ID)

-- INSERIR UM REGISTRO EM CADA TABELA
INSERT INTO Marca (NOME)
VALUES('Apple')

SELECT * FROM Marca

INSERT INTO Produto (ID_MARCA, NOME)
VALUES(1, 'Iphone')

SELECT * FROM Produto

-- OBS: MOSTRAR O DATABASE DIAGRAM (SELECIONAR AS TABELAS: PRODUTO, MARCAR E QUERIES_PROFILE)

-- TENTAR INSERIR REGISTRO INVALIDO
INSERT INTO Produto (ID_MARCA, NOME)
VALUES(2, 'Aiphone')

/*
Msg 547, Level 16, State 0, Line 277
The INSERT statement conflicted with the FOREIGN KEY constraint "FK_Produto_ID_MARCA". The conflict occurred in database "Traces", table "dbo.Marca", column 'ID'.
The statement has been terminated.
*/

-- ALT + F1 -> MOSTRAR QUE EXISTE A CONSTRAINT
-- Produto

-- DROPAR A CONSTRAINT
ALTER TABLE Produto
DROP CONSTRAINT FK_Produto_ID_MARCA

-- ALT + F1 -> MOSTRAR QUE N�O EXISTE MAIS A CONSTRAINT
-- Produto

-- TENTAR INSERIR REGISTRO INVALIDO
INSERT INTO Produto (ID_MARCA, NOME)
VALUES(2, 'Aiphone')

SELECT * FROM Marca
SELECT * FROM Produto

-- D�vida: "Ah Luiz, mas qual o problema de n�o ter uma FK e ter registros inv�lidos???"
-- OBS 1: A linha do produto "Yphone" n�o ser� retornada!
-- OBS 2: Quando gera um erro no INSERT, o IDENTITY � incrementado mesmo assim!
SELECT * FROM Marca
SELECT * FROM Produto

SELECT 
	P.ID AS ID_PRODUTO, 
	P.NOME AS NOME_PRODUTO,
	M.ID AS ID_MARCA,
	M.NOME AS NOME_MARCA
FROM Produto P
JOIN Marca M ON P.ID_MARCA = M.ID


----------------------------------------------------------------------------------
-- DICA: SELECT INTO - TABELAS DE "BKP"
----------------------------------------------------------------------------------
USE Traces

SELECT * 
FROM Produto

-- Cria a tabela de "BKP"
-- OBS 1: Tomar cuidado se a tabela for muito grande e tiver muitos registros!
-- OBS 2: Lembrar de excluir essas tabelas de "BKP" ap�s algum tempo para n�o deixar "lixo" no banco de dados!
DROP TABLE IF EXISTS Produto_BKP

SELECT *
INTO Produto_BKP
FROM Produto

-- Valida a Tabela de "BKP"
SELECT * FROM Produto

SELECT * FROM Produto_BKP


----------------------------------------------------------------------------------
-- D�VIDA: DIFEREN�A ENTRE BEGIN x BEGIN TRAN
----------------------------------------------------------------------------------
USE Traces

-- BEGIN -> UTILIZADO PARA INICIAR UM BLOCO DE C�DIGO.
-- BEGIN TRAN -> UTILZADO PARA INICIAR UMA TRANSA��O.

-- BEGIN - UTILIZA��O:
DECLARE @VALOR INT = 1

IF (@VALOR = 1)
BEGIN 
	SELECT 'O VALOR � IGUAL A 1!'
END

-- VALIDA A QUANTIDADE DE TRANSA��ES ABERTAS
Select @@TRANCOUNT

-- BEGIN TRAN - UTILIZA��O
BEGIN TRAN
	UPDATE Produto
	SET NOME = 'Hahaha'

	-- VALIDA A QUANTIDADE DE TRANSA��ES ABERTAS
	Select @@TRANCOUNT

	SELECT * FROM Produto

-- ROLLBACK
-- COMMIT

SELECT * FROM Produto

-- VALIDA A QUANTIDADE DE TRANSA��ES ABERTAS
Select @@TRANCOUNT


----------------------------------------------------------------------------------
-- PROCEDURE: sp_whoisactive

-- AUTOR: Adam Machanic
-- OBJETIVO: Retorna diversas informa��es de tudo que est� em execu��o 
-- no banco de dados naquele momento (como se fosse uma foto da execu��o do banco de dados).

-- REFER�NCIAS:
-- https://whoisactive.com/
-- https://github.com/amachanic/sp_whoisactive/releases
----------------------------------------------------------------------------------
-- Como executar a procedure "sp_whoisactive"?
-- DICA: Criar na database "master"!!! Mostrar no Object Explorer as procedures da base "master" e "Traces"!
USE master
EXEC sp_whoisactive

-- DEVER DE CASA:
-- D�vida: "Mas Luiz, como assim a procedure vai ser executada na base Traces mesmo sem ela estar criada l�???"
-- Refer�ncia: https://luizlima.net/dicas-t-sql-qual-impacto-de-utilizar-o-prefixo-sp_-no-nome-de-uma-procedure/
USE Traces
EXEC sp_whoisactive
----------------------------------------------------------------------------------


----------------------------------------------------------------------------------
-- D�VIDA: TRANSA��ES IMPL�CITAS X EXPL�CITAS
----------------------------------------------------------------------------------
-- TRANSA��ES IMPL�CITAS
UPDATE Produto
SET NOME = 'Hahaha'

-- TRANSA��ES EXPL�CITAS
BEGIN TRAN
	UPDATE Produto
	SET NOME = 'Hahaha'

-- ROLLBACK
-- COMMIT


----------------------------------------------------------------------------------
-- DEMO: TESTE LOCKS!
----------------------------------------------------------------------------------
USE Traces

DROP TABLE IF EXISTS Teste_Lock

CREATE TABLE Teste_Lock (
	ID INT IDENTITY(1,1) PRIMARY KEY,
	NOME VARCHAR(100)
)

INSERT INTO Teste_Lock
VALUES('Teste Lock')

SELECT * FROM Teste_Lock

-- ABRIR TR�S NOVAS QUERIES E EXECUTAR OS C�DIGOS ABAIXO:
-- QUERY 1
BEGIN TRAN
	UPDATE Teste_Lock
	SET NOME = 'Teste Begin Tran'
-- ROLLBACK

-- QUERY 2
SELECT * FROM Teste_Lock

-- QUERY 3 - COMENTAR SOBRE "LEITURA SUJA" - 
SELECT * FROM Teste_Lock WITH(NOLOCK)

-- OBS: N�VEIS DE ISOLAMENTO (READ COMMITED, READ UNCOMMITED, ...):
-- REFER�NCIAS:
-- https://diegonogare.net/2013/01/transaction-isolation-level-voc-est-usando-certo/
-- https://www.tiagoneves.net/blog/isolation-level-no-sql-server/

-- EXECUTAR A PROCEDURE "sp_whoisactive"
EXEC sp_whoisactive





----------------------------------------------------------------------------------
------------------------------------ AULA 04 -------------------------------------
----------------------------------------------------------------------------------


----------------------------------------------------------------------------------
-- HACKER RANK - SITE PARA PRATICAR SQL SERVER DE FORMA ONLINE, SEM PRECISAR INSTALAR NADA!!!
-- https://www.hackerrank.com/

-- Refer�ncias:
-- Youtube Luiz Lima: SQL Na Pr�tica - Hacker Rank - Basic Select
-- https://www.youtube.com/watch?v=SRqsQrOFO-E

-- Blog Luiz Lima: Dicas T-SQL � Site com Exerc�cios SQL
-- https://luizlima.net/dicas-t-sql-site-com-exercicios-sql/
----------------------------------------------------------------------------------


----------------------------------------------------------------------------------
-- CRIA A TABELA CLIENTE QUE SER� UTILIZADA NOS SCRIPTS

USE Treinamento_TSQL

DROP TABLE IF EXISTS [dbo].[Cliente]

CREATE TABLE [dbo].[Cliente] (
	Id_Cliente INT IDENTITY(1,1) NOT NULL,
	Nm_Cliente VARCHAR(100) NOT NULL,
	Dt_Nascimento DATE NOT NULL
)

INSERT INTO [dbo].[Cliente] (Nm_Cliente, Dt_Nascimento)
VALUES
	('Wallace Camargo', '19801015'),
	('Luiz Lima', '19890922'),
	('�talo Mesquita', '19881201'),
	('Raphael Amorim', '19900118'),
	('Enzo Delcompare', '19820524')

--	EXEMPLO 1:
SELECT * 
FROM [dbo].[Cliente]

---------------------------------------------------------------------------------------------------------------
--	MULTIPART NAMES -> "four-part name�:

--	SINTAXE:
--	SELECT [colunas] 
--	FROM [ServerName].[DatabaseName].[SchemaName].[ObjectName]

--	Refer�ncias:
--	https://docs.microsoft.com/en-us/sql/t-sql/language-elements/transact-sql-syntax-conventions-transact-sql?view=sql-server-ver15#multipart-names
--	https://www.mssqltips.com/sqlservertip/1095/sql-server-four-part-naming/
---------------------------------------------------------------------------------------------------------------
--	EXEMPLO 1:

USE Treinamento_TSQL
GO

--	four-part object name -> other instance (Linked Server)
SELECT * 
FROM [DESKTOP-LUIZLIM].[Treinamento_TSQL].[dbo].[Cliente]

--	three-part object name -> other database
SELECT * 
FROM [Traces].[dbo].[Cliente]

SELECT * 
FROM [Treinamento_TSQL].[dbo].[Cliente]

SELECT * 
FROM [Traces]..[Cliente]

--	two-part object name -> schema-qualified
SELECT * 
FROM [dbo].[Cliente]

--	one-part object name -> object only
SELECT * 
FROM [Cliente]
GO


----------------------------------------------------------------------------------
-- Introdu��o as consultas (SELECT)
----------------------------------------------------------------------------------

/*
-- Refer�ncia: https://www.linkedin.com/pulse/explorando-os-comandos-sql-ddl-dql-dml-dcl-e-tcl-enzo-delcompare/

Comandos DQL (Data Query Language)

Os comandos DQL s�o usados para consultar dados em um banco de dados. 
Eles permitem recuperar informa��es espec�ficas de uma ou v�rias tabelas. 

Essa � a ordem que ESCREVEMOS as queries:

1)	SELECT:   Usado para selecionar dados de uma tabela.
2)	FROM:     Especifica a tabela da qual voc� deseja selecionar dados.
3)	WHERE:    Define crit�rios para filtrar os resultados.
4)	GROUP BY: Agrupa os resultados com base em uma ou mais colunas.
5)	HAVING:   Define condi��es para grupos criados pelo GROUP BY.
6)	ORDER BY: Classifica os resultados em ordem crescente ou decrescente.


Essa � a ordem que a query � ANALISADA pela SQL Server:

OBS: Repare que o SELECT n�o � o primeiro comando a ser analisado!!!

1)	FROM
2)	WHERE
3)	GROUP BY
4)	HAVING
5)	SELECT
6)	ORDER BY
*/
---------------------------------------------------------------------------------------------------------------


----------------------------------------------------------------------------------
-- Sua primeira consulta - Executando uma Query � Passo a Passo
----------------------------------------------------------------------------------
USE Treinamento_TSQL

SELECT * 
FROM Vendas

-- Estrutura de uma query - Exemplo
SELECT Id_Loja, YEAR(Dt_Venda) AS Nr_Ano, COUNT(*) AS Qt_Vendas, SUM(Vl_Venda) AS Vl_Total
FROM Vendas
WHERE Id_Cliente = 1
GROUP BY Id_Loja, YEAR(Dt_Venda)
HAVING COUNT(*) > 1
ORDER BY Id_Loja, Nr_Ano


--	1) FROM	-> Consulta as linhas da tabela �Vendas�.
--	(40 rows affected)
SELECT * 
FROM Vendas


--	2) WHERE -> Filtra apenas as linhas onde a coluna �Id_Cliente� � igual a 1.
--	(20 rows affected)
SELECT * 
FROM Vendas
WHERE Id_Cliente = 1


--	3) GROUP BY -> Agrupa o resultado anterior por �Id_Loja� e �ano da venda�.
--	
--	3.1
--	(20 rows affected)
SELECT Id_Loja, YEAR(Dt_Venda) AS Nr_Ano
FROM Vendas
WHERE Id_Cliente = 1

--	3.2
--	(8 rows affected)
SELECT Id_Loja, YEAR(Dt_Venda) AS Nr_Ano, SUM(Vl_Venda) AS Vl_Total, COUNT(*) AS Qt_Vendas
FROM Vendas
WHERE Id_Cliente = 1
GROUP BY Id_Loja, YEAR(Dt_Venda)


--	4) HAVING -> Filtra somente os grupos (�Id_Loja� e �ano da venda�) que possuem mais de uma venda (COUNT(*) > 1).
--	OBS: Aqui vai eliminar o ano de 2020, pois s� teve uma venda no GROUP BY!
-- (6 rows affected)
SELECT Id_Loja, YEAR(Dt_Venda) AS Nr_Ano, SUM(Vl_Venda) AS Vl_Total, COUNT(*) AS Qt_Vendas
FROM Vendas
WHERE Id_Cliente = 1
GROUP BY Id_Loja, YEAR(Dt_Venda)
HAVING COUNT(*) > 1


--	5) SELECT -> Retorna o �Id_Loja�, �ano da venda�, a soma do valor total e a quantidade de vendas (COUNT(*)).
-- (6 rows affected)
SELECT Id_Loja, YEAR(Dt_Venda) AS Nr_Ano, SUM(Vl_Venda) AS Vl_Total, COUNT(*) AS Qt_Vendas
FROM Vendas
WHERE Id_Cliente = 1
GROUP BY Id_Loja, YEAR(Dt_Venda)
HAVING COUNT(*) > 1


--	6) ORDER BY -> Retorna o resultado final ordenado por �Id_Loja� e �ano da venda�.
--	(6 rows affected)

--	ANO - CRESCENTE
SELECT Id_Loja, YEAR(Dt_Venda) AS Nr_Ano, SUM(Vl_Venda) AS Vl_Total, COUNT(*) AS Qt_Vendas
FROM Vendas
WHERE Id_Cliente = 1
GROUP BY Id_Loja, YEAR(Dt_Venda)
HAVING COUNT(*) > 1
ORDER BY Id_Loja, Nr_Ano

--	ANO - DECRESCENTE
SELECT Id_Loja, YEAR(Dt_Venda) AS Nr_Ano, SUM(Vl_Venda) AS Vl_Total, COUNT(*) AS Qt_Vendas 
FROM Vendas
WHERE Id_Cliente = 1
GROUP BY Id_Loja, YEAR(Dt_Venda)
HAVING COUNT(*) > 1
ORDER BY Id_Loja, Nr_Ano DESC

--	VALOR - DECRESCENTE
SELECT Id_Loja, YEAR(Dt_Venda) AS Nr_Ano, SUM(Vl_Venda) AS Vl_Total, COUNT(*) AS Qt_Vendas 
FROM Vendas
WHERE Id_Cliente = 1
GROUP BY Id_Loja, YEAR(Dt_Venda)
HAVING COUNT(*) > 1
ORDER BY Id_Loja, Vl_Total DESC


----------------------------------------------------------------------------------
-- Aplicar filtros � Where
----------------------------------------------------------------------------------
SELECT *
FROM Vendas
WHERE Id_Cliente = 1

-- OBS: EVITAR USAR FUN��ES NO WHERE, PODE CAUSAR PROBLEMAS DE PERFORMANCE
SELECT * 
FROM Vendas
WHERE 
	Id_Cliente = 1
	AND YEAR(Dt_Venda) >= 2021
	
SELECT * 
FROM Vendas
WHERE 
	Id_Cliente = 1
	AND Dt_Venda >= '20210101'

-- IN
SELECT * 
FROM Vendas
WHERE 
	Id_Cliente = 1
	AND YEAR(Dt_Venda) IN (2019,2021)

-- NOT IN
SELECT * 
FROM Vendas
WHERE 
	Id_Cliente = 1
	AND YEAR(Dt_Venda) NOT IN (2020)
ORDER BY Dt_Venda

-- BETWEEN
SELECT * 
FROM Vendas
WHERE 
	Id_Cliente = 1
	AND YEAR(Dt_Venda) BETWEEN 2020 AND 2021

SELECT * 
FROM Vendas
WHERE 
	Id_Cliente = 1
	AND Dt_Venda BETWEEN '20200101' AND '20220101'


-- LEMBRA DA ORDEM DE AVALIA�AO DA QUERY?
/*
1)	FROM
2)	WHERE
3)	GROUP BY
4)	HAVING
5)	SELECT
6)	ORDER BY
*/

SELECT Id_Loja, Id_Cliente, MONTH(Dt_Venda) AS Mes, Vl_Venda
FROM Vendas
WHERE Mes = 1
ORDER BY Mes

/*
Msg 207, Level 16, State 1, Line 739
Invalid column name 'Mes'.
*/

SELECT Id_Loja, Id_Cliente, MONTH(Dt_Venda) AS Mes, Vl_Venda
FROM Vendas
WHERE MONTH(Dt_Venda) = 1
ORDER BY Mes


---------------------------------------------------------------------------------------------------------------
--	GROUP BY E HAVING - SER� ABORDADO NA PR�XIMA AULA 05:
---------------------------------------------------------------------------------------------------------------
--	REFER�NCIAS:

--	Fun��es de Agrega��o
--	https://docs.microsoft.com/pt-br/sql/t-sql/functions/aggregate-functions-transact-sql?view=sql-server-ver15

--	SUM
--	https://docs.microsoft.com/pt-br/sql/t-sql/functions/sum-transact-sql?view=sql-server-ver15

--	COUNT
--	https://docs.microsoft.com/pt-br/sql/t-sql/functions/count-transact-sql?view=sql-server-ver15

--	AVG
--	https://docs.microsoft.com/pt-br/sql/t-sql/functions/avg-transact-sql?view=sql-server-ver15

--	MIN
--	https://docs.microsoft.com/pt-br/sql/t-sql/functions/min-transact-sql?view=sql-server-ver15

--	MAX
--	https://docs.microsoft.com/pt-br/sql/t-sql/functions/max-transact-sql?view=sql-server-ver15

--	HAVING
--	https://learn.microsoft.com/pt-br/sql/t-sql/queries/select-having-transact-sql?view=sql-server-ver16
---------------------------------------------------------------------------------------------------------------


----------------------------------------------------------------------------------
-- Ordenar dados � order by (use com modera��o)
----------------------------------------------------------------------------------
-- POR LOJA E VALOR DA VENDA
SELECT *
FROM Vendas
ORDER BY Id_Loja, Vl_Venda DESC

-- POR DATA DA VENDA
SELECT *
FROM Vendas
ORDER BY Dt_Venda

-- USANDO A POSI��O - DATA DA VENDA
SELECT *
FROM Vendas
ORDER BY 3 DESC

-- USANDO A POSI��O - VALOR DA VENDA
SELECT *
FROM Vendas
ORDER BY 4 DESC

-- USANDO EXPRESS�O
SELECT *
FROM Vendas
ORDER BY DAY(Dt_Venda) DESC


---------------------------------------------------------------------------------------------------------------
--	B�NUS: OPTION � INCLUINDO ALGUMAS OP��ES:
---------------------------------------------------------------------------------------------------------------
--	MAXDOP: Limita a quantidade de processadores que a query pode utilizar.
--	RECOMPILE: Cria um novo plano de execu��o para a query a cada execu��o.
---------------------------------------------------------------------------------------------------------------
--	EXEMPLO 1:
SELECT *
FROM Cliente
ORDER BY Nm_Cliente
OPTION (MAXDOP 1, RECOMPILE)


---------------------------------------------------------------------------------------------------------------
--	Preced�ncia e Operadores / Teste de condi��es
---------------------------------------------------------------------------------------------------------------

/*
Ordem de Preced�ncia (1 � o n�vel MAIS ALTO e 8 � o n�vel MAIS BAIXO):

	1) () (Par�nteses)
	2) * (Multiplica��o), / (Divis�o), % (M�dulo)
	3) + (Positivo), � (Negativo), + (Adi��o), + (Concatena��o), � (Subtra��o)
	4) =, >, <, >=, <=, <>, !=, !>, !< (Operadores de Compara��o)
	5) NOT
	6) AND
	7) BETWEEN, IN, LIKE, OR
	8) = (Atribui��o)

Observa��es:
-> Quando uma express�o complexa tiver v�rios operadores, a preced�ncia de operador determinar� a sequ�ncia de opera��es. 
-> A ordem de execu��o pode afetar o valor resultante significativamente.
-> Quando dois operadores em uma express�o tiverem o mesmo n�vel de preced�ncia, 
   eles ser�o avaliados da ESQUERDA para a DIREITA em sua posi��o na express�o.
-> Se uma express�o tiver par�nteses aninhados, a express�o mais aninhada ser� avaliada primeiro. 
*/

--	EXEMPLO 1 - PAR�NTESES E MULTIPLICA��O:

SELECT 5 * (2 + 3)

SELECT 5 * 2 + 3

SELECT 5 + 2 * 3

SELECT 5 + (5 + (2 * 2)) + 2 * 10

SELECT 5 / 2

SELECT 5 / 2.0


--	EXEMPLO 2 - OPERADORES NO MESMO N�VEL:

SELECT 10 * 5 / 2

SELECT 10 / 5 * 2


--	EXEMPLO 3 - OPERADORES DE COMPARA��O:
SELECT * 
FROM Vendas
WHERE
	Id_Loja = 2
	AND Vl_Venda > 500

SELECT * 
FROM Vendas
WHERE
	Id_Loja = 2
	AND Vl_Venda > 100 + 50 * 2

--	OR:
SELECT * 
FROM Vendas
WHERE
	Id_Loja = 1
	OR Vl_Venda > 500


----------------------------------------------------------------------------------
-- Tratando nulos
----------------------------------------------------------------------------------
-- NULL <> '' (vazio ou branco)

USE Treinamento_TSQL

DROP TABLE IF EXISTS TesteNull

CREATE TABLE TesteNull (
	ID INT IDENTITY(1,1) NOT NULL,
	Nome VARCHAR(100) NOT NULL,
	DataNascimento DATE NULL
)

INSERT INTO TesteNull
VALUES
	('Wallace Camargo', '19801015'),
	('Luiz Lima', NULL),
	('�talo Mesquita', '19881201'),
	('Raphael Amorim', NULL),
	('Enzo Delcompare', '19820524')

SELECT * FROM TesteNull

-- EXEMPLO 1 - WHERE:
SELECT * 
FROM TesteNull
WHERE
	DataNascimento = NULL

SELECT * 
FROM TesteNull
WHERE
	DataNascimento IS NULL

SELECT * 
FROM TesteNull
WHERE
	DataNascimento IS NOT NULL


-- EXEMPLO 2 - IF:

-- VARIAVEL NULL
DECLARE @TESTE_ID INT 

SELECT @TESTE_ID

IF(@TESTE_ID = 1)
BEGIN
	SELECT 'SIM'
END
ELSE
BEGIN
	SELECT 'N�O'
END
GO

-- VARIAVEL NOT NULL
DECLARE @TESTE_ID INT = 1 

SELECT @TESTE_ID

IF(@TESTE_ID = 1)
BEGIN
	SELECT 'SIM'
END
ELSE
BEGIN
	SELECT 'N�O'
END
GO

-- EXEMPLO 3 - CONCATENAR STRINGS:
-- VARIAVEL NULL
DECLARE @NOME VARCHAR(50), @SOBRENOME VARCHAR(50)

SELECT @NOME = 'LUIZ'

SELECT @NOME, @SOBRENOME

SELECT 'O SEU NOME COMPLETO �: ' + @NOME + ' ' + @SOBRENOME
GO

-- COMO RESOLVER??? RESPOSTA: ISNULL()
DECLARE @NOME VARCHAR(50), @SOBRENOME VARCHAR(50)

SELECT @NOME = 'LUIZ'

SELECT @NOME, @SOBRENOME

SELECT 'O SEU NOME COMPLETO �: ' + ISNULL(@NOME,'') + ' ' + ISNULL(@SOBRENOME,'')
GO


-- VARIAVEL NOT NULL
DECLARE @NOME VARCHAR(50), @SOBRENOME VARCHAR(50)

SELECT 
	@NOME = 'LUIZ', 
	@SOBRENOME = 'LIMA'

SELECT @NOME, @SOBRENOME

SELECT 'O SEU NOME COMPLETO �: ' + @NOME + ' ' + @SOBRENOME
GO


-- ANSI_NULLS:
-- Dicas de T-SQL � Cuidado com LOOP, vari�vel NULL e ANSI_NULLS
-- REFER�NCIA: https://luizlima.net/dicas-de-t-sql-cuidado-com-loop-variavel-null-e-ansi-nulls/

----------------------------------------------------------------------------------
-- Convers�o de dados
----------------------------------------------------------------------------------
-- CONVERS�O IMPL�CITA - TIPOS DE DADOS

-- Implicit and explicit conversion
-- OBS: Mostrar a tabela de convers�es
-- REFER�NCIA: https://learn.microsoft.com/en-us/sql/t-sql/data-types/data-type-conversion-database-engine?view=sql-server-ver16#implicit-and-explicit-conversion

SELECT 1 + 1

SELECT '1' + 1

SELECT '1' + '1'

SELECT 'Luiz' + 1

/*
Msg 245, Level 16, State 1, Line 931
Conversion failed when converting the varchar value 'Luiz' to data type int.
*/


-- CONVERS�O IMPL�CITA - PLANO DE EXECU��O - CUIDADO!!!
-- OBS: HABILITAR O PLANO DE EXECU��O E VALIDAR O PREDICATE!
DECLARE @Id_Loja INT = 1

SELECT * 
FROM Vendas
WHERE Id_Loja = @Id_Loja

GO

DECLARE @Id_Loja CHAR = '1'

SELECT * 
FROM Vendas
WHERE Id_Loja = @Id_Loja


-- CONVERS�O EXPL�CITA
-- FUN��ES: CAST E CONVERT
-- REFER�NCIA:
-- https://learn.microsoft.com/pt-br/sql/t-sql/functions/cast-and-convert-transact-sql?view=sql-server-ver16

-- EXEMPLO 1 - CAST:
DECLARE @VALOR_ENTRADA CHAR(2)

SELECT @VALOR_ENTRADA = '08'

SELECT CAST(@VALOR_ENTRADA AS INT)
GO

-- EXEMPLO 2 - CAST COM ERRO:
DECLARE @VALOR_ENTRADA CHAR(2)

SELECT @VALOR_ENTRADA = 'LV'

SELECT CAST(@VALOR_ENTRADA AS INT)
GO
/*
Msg 245, Level 16, State 1, Line 1069
Conversion failed when converting the varchar value 'LV' to data type int.

*/

-- EXEMPLO 3 - TRY_CAST:
DECLARE @VALOR_ENTRADA CHAR(2)

SELECT @VALOR_ENTRADA = 'LV'

SELECT TRY_CAST(@VALOR_ENTRADA AS INT)
GO

-- EXEMPLO 4 - CONVERT:
DECLARE @DATAHORA DATETIME

SELECT @DATAHORA = GETDATE()

SELECT
	@DATAHORA AS DATAHORA,
	CONVERT(VARCHAR(20),@DATAHORA,101),
	CONVERT(VARCHAR(20),@DATAHORA,1),
	CONVERT(VARCHAR(20),@DATAHORA,103),
	CONVERT(VARCHAR(20),@DATAHORA,120),
	CONVERT(VARCHAR(10),@DATAHORA,120),
	CONVERT(VARCHAR(20),@DATAHORA,120)

GO

----------------------------------------------------------------------------------
-- Teste Kahoot
----------------------------------------------------------------------------------
-- REFER�NCIA:
-- https://kahoot.it/