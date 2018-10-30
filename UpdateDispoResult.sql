/*
DSI   19.09.18  JH  Neue Artikel hinzugefügt (CRQ18000308)
DSI   05.10.18  JH  Korrektur an der Aufbereitung der Daten, damit Artikel mit Nullbestand angezeigt werden (CRQ18000308)
DSI   30.10.18  JH  Korrektur bei einem Join für Lagerbestand (CRQ18000405)
*/

USE [dsinav_140330]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

--CREATE TABLE DispoResult (
--[EK Artikelnr] NCHAR(20) COLLATE Latin1_General_100_CS_AS,
--[Baugruppe] NCHAR(20) COLLATE Latin1_General_100_CS_AS,
--[Baugruppe 2] NCHAR(20) COLLATE Latin1_General_100_CS_AS,
--[Periode] DATETIME,
--[Kreditornr] NCHAR(20) COLLATE Latin1_General_100_CS_AS,
--[Kreditorname] NCHAR(50) COLLATE Latin1_General_100_CS_AS,
--[Menge] DECIMAL(38,20),
--[Art] NCHAR(100) COLLATE Latin1_General_100_CS_AS,
--[Beschreibung] NCHAR(50) COLLATE Latin1_General_100_CS_AS,
--[Artikelkategoriencode] NCHAR(20) COLLATE Latin1_General_100_CS_AS,
--[AlterSicherheitsbestand] DECIMAL(38,20),
--[DurchschnVerbrauch12M] DECIMAL(38,20),
--[WBZ] NCHAR(10) COLLATE Latin1_General_100_CS_AS,
--[WBZinTagen] INT,
--[NeuerSicherheitsbestand] DECIMAL(38,20),
--[MengeInRahmen] DECIMAL(38,20),
--[Lagerbestand] DECIMAL(38,20)
--)

DELETE FROM DispoResult

CREATE TABLE #Periods(
  Period DATETIME
)

CREATE TABLE #ResultLines
(        
    [Type] NCHAR(100) COLLATE Latin1_General_100_CS_AS,
	[EK Artikelnr] NCHAR(20) COLLATE Latin1_General_100_CS_AS,
	[Kreditornr] NCHAR(20) COLLATE Latin1_General_100_CS_AS,
	[Year] INT,
	[Month] INT,
	[Quantity] DECIMAL(38,20),

);

CREATE TABLE #Baugruppen
(
   [Main Item] NCHAR(20) COLLATE Latin1_General_100_CS_AS,
   [Baugruppe] NCHAR(20) COLLATE Latin1_General_100_CS_AS,
   [Baugruppe2] NCHAR(20) COLLATE Latin1_General_100_CS_AS,
   [Lagerortfilter] NCHAR(20) COLLATE Latin1_General_100_CS_AS
)

INSERT INTO #Periods
SELECT DATEADD(m,0,CONVERT(DATETIME,N'01.'+CONVERT(VARCHAR(MAX),DATEPART(mm,GETDATE()))+N'.'+CONVERT(VARCHAR(MAX),DATEPART(yyyy,GETDATE()))))
UNION ALL
SELECT DATEADD(m,1,CONVERT(DATETIME,N'01.'+CONVERT(VARCHAR(MAX),DATEPART(mm,GETDATE()))+N'.'+CONVERT(VARCHAR(MAX),DATEPART(yyyy,GETDATE()))))
UNION ALL
SELECT DATEADD(m,2,CONVERT(DATETIME,N'01.'+CONVERT(VARCHAR(MAX),DATEPART(mm,GETDATE()))+N'.'+CONVERT(VARCHAR(MAX),DATEPART(yyyy,GETDATE()))))
UNION ALL
SELECT DATEADD(m,3,CONVERT(DATETIME,N'01.'+CONVERT(VARCHAR(MAX),DATEPART(mm,GETDATE()))+N'.'+CONVERT(VARCHAR(MAX),DATEPART(yyyy,GETDATE()))))
UNION ALL
SELECT DATEADD(m,4,CONVERT(DATETIME,N'01.'+CONVERT(VARCHAR(MAX),DATEPART(mm,GETDATE()))+N'.'+CONVERT(VARCHAR(MAX),DATEPART(yyyy,GETDATE()))))
UNION ALL
SELECT DATEADD(m,5,CONVERT(DATETIME,N'01.'+CONVERT(VARCHAR(MAX),DATEPART(mm,GETDATE()))+N'.'+CONVERT(VARCHAR(MAX),DATEPART(yyyy,GETDATE()))))
UNION ALL
SELECT DATEADD(m,6,CONVERT(DATETIME,N'01.'+CONVERT(VARCHAR(MAX),DATEPART(mm,GETDATE()))+N'.'+CONVERT(VARCHAR(MAX),DATEPART(yyyy,GETDATE()))))
UNION ALL
SELECT DATEADD(m,7,CONVERT(DATETIME,N'01.'+CONVERT(VARCHAR(MAX),DATEPART(mm,GETDATE()))+N'.'+CONVERT(VARCHAR(MAX),DATEPART(yyyy,GETDATE()))))
UNION ALL
SELECT DATEADD(m,8,CONVERT(DATETIME,N'01.'+CONVERT(VARCHAR(MAX),DATEPART(mm,GETDATE()))+N'.'+CONVERT(VARCHAR(MAX),DATEPART(yyyy,GETDATE()))))
UNION ALL
SELECT DATEADD(m,9,CONVERT(DATETIME,N'01.'+CONVERT(VARCHAR(MAX),DATEPART(mm,GETDATE()))+N'.'+CONVERT(VARCHAR(MAX),DATEPART(yyyy,GETDATE()))))
UNION ALL
SELECT DATEADD(m,10,CONVERT(DATETIME,N'01.'+CONVERT(VARCHAR(MAX),DATEPART(mm,GETDATE()))+N'.'+CONVERT(VARCHAR(MAX),DATEPART(yyyy,GETDATE()))))
UNION ALL
SELECT DATEADD(m,11,CONVERT(DATETIME,N'01.'+CONVERT(VARCHAR(MAX),DATEPART(mm,GETDATE()))+N'.'+CONVERT(VARCHAR(MAX),DATEPART(yyyy,GETDATE()))))
UNION ALL
SELECT DATEADD(m,12,CONVERT(DATETIME,N'01.'+CONVERT(VARCHAR(MAX),DATEPART(mm,GETDATE()))+N'.'+CONVERT(VARCHAR(MAX),DATEPART(yyyy,GETDATE()))))

--Artikel, die betrachtet werden sollen
INSERT INTO #Baugruppen SELECT N'027717.8' [Main Item], N'028435.0' [Baugruppe], '' [Baugruppe 2], 'DSI,FREMD,EK-KONSI' [Lagerortfilter]
INSERT INTO #Baugruppen SELECT N'610397' [Main Item], N'910482' [Baugruppe], '' [Baugruppe 2], 'DSI,FREMD,EK-KONSI' [Lagerortfilter]
INSERT INTO #Baugruppen SELECT N'026363.7' [Main Item], N'026363.7' [Baugruppe], '' [Baugruppe 2], 'DSI' [Lagerortfilter]
INSERT INTO #Baugruppen SELECT N'026693.7' [Main Item], N'026693.7' [Baugruppe], '' [Baugruppe 2], 'DSI' [Lagerortfilter]
INSERT INTO #Baugruppen SELECT N'026694.8' [Main Item], N'026694.8' [Baugruppe], '' [Baugruppe 2], 'DSI' [Lagerortfilter]
INSERT INTO #Baugruppen SELECT N'611070' [Main Item], N'611070' [Baugruppe], '' [Baugruppe 2], 'DSI' [Lagerortfilter]
INSERT INTO #Baugruppen SELECT N'026367.0' [Main Item], N'026367.0' [Baugruppe], '' [Baugruppe 2], 'DSI' [Lagerortfilter]
INSERT INTO #Baugruppen SELECT N'026364.8' [Main Item], N'026364.8' [Baugruppe], '' [Baugruppe 2], 'DSI' [Lagerortfilter]
INSERT INTO #Baugruppen SELECT N'026365.9' [Main Item], N'026365.9' [Baugruppe], '' [Baugruppe 2], 'DSI' [Lagerortfilter]
INSERT INTO #Baugruppen SELECT N'026237.2' [Main Item], N'026237.2' [Baugruppe], '' [Baugruppe 2], 'DSI' [Lagerortfilter]
--Flach. Dreikant
INSERT INTO #Baugruppen SELECT N'028092.9' [Main Item], N'910480' [Baugruppe], '' [Baugruppe 2], 'DSI,FREMD,EK-KONSI' [Lagerortfilter]
INSERT INTO #Baugruppen SELECT N'028193.0' [Main Item], N'910481' [Baugruppe], '' [Baugruppe 2], 'DSI,FREMD,EK-KONSI' [Lagerortfilter]
INSERT INTO #Baugruppen SELECT N'610468' [Main Item], N'910681' [Baugruppe], '910740' [Baugruppe 2], 'DSI,FREMD,EK-KONSI' [Lagerortfilter]
INSERT INTO #Baugruppen SELECT N'610116' [Main Item], N'610116' [Baugruppe], '' [Baugruppe 2], 'DSI' [Lagerortfilter]
INSERT INTO #Baugruppen SELECT N'025130.6' [Main Item], N'025130.6' [Baugruppe], '' [Baugruppe 2], 'DSI' [Lagerortfilter]
INSERT INTO #Baugruppen SELECT N'552478.3' [Main Item], N'552478.3' [Baugruppe], '' [Baugruppe 2], 'DSI' [Lagerortfilter]
INSERT INTO #Baugruppen SELECT N'551082.4' [Main Item], N'551082.4' [Baugruppe], '' [Baugruppe 2], 'DSI' [Lagerortfilter]
INSERT INTO #Baugruppen SELECT N'610012' [Main Item], N'610012' [Baugruppe], '' [Baugruppe 2], 'DSI' [Lagerortfilter]
INSERT INTO #Baugruppen SELECT N'610011' [Main Item], N'610011' [Baugruppe], '' [Baugruppe 2], 'DSI' [Lagerortfilter]
INSERT INTO #Baugruppen SELECT N'552468.4' [Main Item], N'552468.4' [Baugruppe], '' [Baugruppe 2], 'DSI' [Lagerortfilter]
INSERT INTO #Baugruppen SELECT N'551083.5' [Main Item], N'551083.5' [Baugruppe], '' [Baugruppe 2], 'DSI' [Lagerortfilter]
INSERT INTO #Baugruppen SELECT N'552591.6' [Main Item], N'552591.6' [Baugruppe], '' [Baugruppe 2], 'DSI' [Lagerortfilter]
INSERT INTO #Baugruppen SELECT N'611592' [Main Item], N'611592' [Baugruppe], '' [Baugruppe 2], 'DSI' [Lagerortfilter]
--US Draft
INSERT INTO #Baugruppen SELECT N'610342' [Main Item], N'910402' [Baugruppe], '' [Baugruppe 2], 'DSI,FREMD,EK-KONSI' [Lagerortfilter]
INSERT INTO #Baugruppen SELECT N'026703.6' [Main Item], N'026703.6' [Baugruppe], '' [Baugruppe 2], 'DSI' [Lagerortfilter]
INSERT INTO #Baugruppen SELECT N'611154' [Main Item], N'611154' [Baugruppe], '' [Baugruppe 2], 'DSI' [Lagerortfilter]
INSERT INTO #Baugruppen SELECT N'611060' [Main Item], N'611060' [Baugruppe], '' [Baugruppe 2], 'DSI' [Lagerortfilter]
INSERT INTO #Baugruppen SELECT N'026708.0' [Main Item], N'026708.0' [Baugruppe], '' [Baugruppe 2], 'DSI' [Lagerortfilter]
INSERT INTO #Baugruppen SELECT N'554352.7' [Main Item], N'554352.7' [Baugruppe], '' [Baugruppe 2], 'DSI' [Lagerortfilter]
INSERT INTO #Baugruppen SELECT N'026709.1' [Main Item], N'026709.1' [Baugruppe], '' [Baugruppe 2], 'DSI' [Lagerortfilter]
INSERT INTO #Baugruppen SELECT N'026705.8' [Main Item], N'026705.8' [Baugruppe], '' [Baugruppe 2], 'DSI' [Lagerortfilter]
INSERT INTO #Baugruppen SELECT N'610552' [Main Item], N'610552' [Baugruppe], '' [Baugruppe 2], 'DSI' [Lagerortfilter]
INSERT INTO #Baugruppen SELECT N'611056' [Main Item], N'611056' [Baugruppe], '' [Baugruppe 2], 'DSI' [Lagerortfilter]
--Zusaetzlich
--INSERT INTO #Baugruppen SELECT N'026842.2' [Main Item], N'910632' [Baugruppe], '' [Baugruppe 2], 'DSI,FREMD,EK-KONSI' [Lagerortfilter]
--INSERT INTO #Baugruppen SELECT N'028303.0' [Main Item], N'910479' [Baugruppe], '' [Baugruppe 2], 'DSI,FREMD,EK-KONSI' [Lagerortfilter]
--INSERT INTO #Baugruppen SELECT N'610771' [Main Item], N'910682' [Baugruppe], '' [Baugruppe 2], 'DSI,FREMD,EK-KONSI' [Lagerortfilter]
INSERT INTO #Baugruppen SELECT N'610772' [Main Item], N'610772' [Baugruppe], '' [Baugruppe 2], 'DSI,FREMD,EK-KONSI' [Lagerortfilter]
--INSERT INTO #Baugruppen SELECT N'610809' [Main Item], N'610809' [Baugruppe], '' [Baugruppe 2], 'DSI,FREMD,EK-KONSI' [Lagerortfilter]
--INSERT INTO #Baugruppen SELECT N'610150' [Main Item], N'910680' [Baugruppe], '' [Baugruppe 2], 'DSI,FREMD,EK-KONSI' [Lagerortfilter]
INSERT INTO #Baugruppen SELECT N'610783' [Main Item], N'610783' [Baugruppe], '' [Baugruppe 2], 'DSI,FREMD,EK-KONSI' [Lagerortfilter]

--Sonstige 
INSERT INTO #Baugruppen SELECT N'610264' [Main Item], N'610264' [Baugruppe], '' [Baugruppe 2], 'DSI,FREMD,EK-KONSI' [Lagerortfilter]
INSERT INTO #Baugruppen SELECT N'611596' [Main Item], N'611596' [Baugruppe], '' [Baugruppe 2], 'DSI,FREMD,EK-KONSI' [Lagerortfilter]
INSERT INTO #Baugruppen SELECT N'027532.1' [Main Item], N'027532.1' [Baugruppe], '' [Baugruppe 2], 'DSI,FREMD,EK-KONSI' [Lagerortfilter]
INSERT INTO #Baugruppen SELECT N'611183' [Main Item], N'611183' [Baugruppe], '' [Baugruppe 2], 'DSI,FREMD,EK-KONSI' [Lagerortfilter]
INSERT INTO #Baugruppen SELECT N'611182' [Main Item], N'611182' [Baugruppe], '' [Baugruppe 2], 'DSI,FREMD,EK-KONSI' [Lagerortfilter]
INSERT INTO #Baugruppen SELECT N'027530.8' [Main Item], N'027530.8' [Baugruppe], '' [Baugruppe 2], 'DSI,FREMD,EK-KONSI' [Lagerortfilter]
INSERT INTO #Baugruppen SELECT N'553066.8' [Main Item], N'553066.8' [Baugruppe], '' [Baugruppe 2], 'DSI,FREMD,EK-KONSI' [Lagerortfilter]
INSERT INTO #Baugruppen SELECT N'611020' [Main Item], N'611020' [Baugruppe], '' [Baugruppe 2], 'DSI,FREMD,EK-KONSI' [Lagerortfilter]
INSERT INTO #Baugruppen SELECT N'611720' [Main Item], N'611720' [Baugruppe], '' [Baugruppe 2], 'DSI,FREMD,EK-KONSI' [Lagerortfilter]
INSERT INTO #Baugruppen SELECT N'610504' [Main Item], N'610504' [Baugruppe], '' [Baugruppe 2], 'DSI,FREMD,EK-KONSI' [Lagerortfilter]
INSERT INTO #Baugruppen SELECT N'555226.1' [Main Item], N'555226.1' [Baugruppe], '' [Baugruppe 2], 'DSI,FREMD,EK-KONSI' [Lagerortfilter]
INSERT INTO #Baugruppen SELECT N'610769' [Main Item], N'610769' [Baugruppe], '' [Baugruppe 2], 'DSI,FREMD,EK-KONSI' [Lagerortfilter]
INSERT INTO #Baugruppen SELECT N'553045.9' [Main Item], N'553045.9' [Baugruppe], '' [Baugruppe 2], 'DSI,FREMD,EK-KONSI' [Lagerortfilter]
INSERT INTO #Baugruppen SELECT N'611206' [Main Item], N'611206' [Baugruppe], '' [Baugruppe 2], 'DSI,FREMD,EK-KONSI' [Lagerortfilter]
INSERT INTO #Baugruppen SELECT N'610670' [Main Item], N'610670' [Baugruppe], '' [Baugruppe 2], 'DSI,FREMD,EK-KONSI' [Lagerortfilter]
INSERT INTO #Baugruppen SELECT N'610770' [Main Item], N'610770' [Baugruppe], '' [Baugruppe 2], 'DSI,FREMD,EK-KONSI' [Lagerortfilter]
INSERT INTO #Baugruppen SELECT N'610488' [Main Item], N'610488' [Baugruppe], '' [Baugruppe 2], 'DSI,FREMD,EK-KONSI' [Lagerortfilter]
INSERT INTO #Baugruppen SELECT N'026238.3' [Main Item], N'026238.3' [Baugruppe], '' [Baugruppe 2], 'DSI,FREMD,EK-KONSI' [Lagerortfilter]
INSERT INTO #Baugruppen SELECT N'610257' [Main Item], N'610257' [Baugruppe], '' [Baugruppe 2], 'DSI,FREMD,EK-KONSI' [Lagerortfilter]
INSERT INTO #Baugruppen SELECT N'610150' [Main Item], N'910680' [Baugruppe], '' [Baugruppe 2], 'DSI,FREMD,EK-KONSI' [Lagerortfilter]
INSERT INTO #Baugruppen SELECT N'028494.4' [Main Item], N'028494.4' [Baugruppe], '' [Baugruppe 2], 'DSI,FREMD,EK-KONSI' [Lagerortfilter]
INSERT INTO #Baugruppen SELECT N'550043.1' [Main Item], N'550043.1' [Baugruppe], '' [Baugruppe 2], 'DSI,FREMD,EK-KONSI' [Lagerortfilter]
INSERT INTO #Baugruppen SELECT N'027733.2' [Main Item], N'027733.2' [Baugruppe], '' [Baugruppe 2], 'DSI,FREMD,EK-KONSI' [Lagerortfilter]
INSERT INTO #Baugruppen SELECT N'026842.2' [Main Item], N'910632' [Baugruppe], '' [Baugruppe 2], 'DSI,FREMD,EK-KONSI' [Lagerortfilter]
INSERT INTO #Baugruppen SELECT N'610771' [Main Item], N'910682' [Baugruppe], '' [Baugruppe 2], 'DSI,FREMD,EK-KONSI' [Lagerortfilter]
INSERT INTO #Baugruppen SELECT N'610809' [Main Item], N'610809' [Baugruppe], '' [Baugruppe 2], 'DSI,FREMD,EK-KONSI' [Lagerortfilter]
INSERT INTO #Baugruppen SELECT N'028303.0' [Main Item], N'910479' [Baugruppe], '' [Baugruppe 2], 'DSI,FREMD,EK-KONSI' [Lagerortfilter]
INSERT INTO #Baugruppen SELECT N'611187' [Main Item], N'611187' [Baugruppe], '' [Baugruppe 2], 'DSI,FREMD,EK-KONSI' [Lagerortfilter]
INSERT INTO #Baugruppen SELECT N'611207' [Main Item], N'611207' [Baugruppe], '' [Baugruppe 2], 'DSI,FREMD,EK-KONSI' [Lagerortfilter]
INSERT INTO #Baugruppen SELECT N'027535.2' [Main Item], N'027535.2' [Baugruppe], '' [Baugruppe 2], 'DSI,FREMD,EK-KONSI' [Lagerortfilter]
INSERT INTO #Baugruppen SELECT N'552623.5' [Main Item], N'552623.5' [Baugruppe], '' [Baugruppe 2], 'DSI,FREMD,EK-KONSI' [Lagerortfilter]
INSERT INTO #Baugruppen SELECT N'610553' [Main Item], N'610553' [Baugruppe], '' [Baugruppe 2], 'DSI,FREMD,EK-KONSI' [Lagerortfilter]
INSERT INTO #Baugruppen SELECT N'550074.8' [Main Item], N'550074.8' [Baugruppe], '' [Baugruppe 2], 'DSI,FREMD,EK-KONSI' [Lagerortfilter]
INSERT INTO #Baugruppen SELECT N'550073.7' [Main Item], N'550073.7' [Baugruppe], '' [Baugruppe 2], 'DSI,FREMD,EK-KONSI' [Lagerortfilter]
INSERT INTO #Baugruppen SELECT N'026993.1' [Main Item], N'026993.1' [Baugruppe], '' [Baugruppe 2], 'DSI,FREMD,EK-KONSI' [Lagerortfilter]
INSERT INTO #Baugruppen SELECT N'550029.7' [Main Item], N'550029.7' [Baugruppe], '' [Baugruppe 2], 'DSI,FREMD,EK-KONSI' [Lagerortfilter]
INSERT INTO #Baugruppen SELECT N'610127' [Main Item], N'610127' [Baugruppe], '' [Baugruppe 2], 'DSI,FREMD,EK-KONSI' [Lagerortfilter]
INSERT INTO #Baugruppen SELECT N'611186' [Main Item], N'611186' [Baugruppe], '' [Baugruppe 2], 'DSI,FREMD,EK-KONSI' [Lagerortfilter]
INSERT INTO #Baugruppen SELECT N'027609.1' [Main Item], N'027609.1' [Baugruppe], '' [Baugruppe 2], 'DSI,FREMD,EK-KONSI' [Lagerortfilter]

--Einkaufsteile
INSERT INTO #Baugruppen SELECT N'910629' [Main Item], N'910629' [Baugruppe], '' [Baugruppe 2], 'DSI' [Lagerortfilter]
INSERT INTO #Baugruppen SELECT N'611149' [Main Item], N'611149' [Baugruppe], '' [Baugruppe 2], 'DSI' [Lagerortfilter]
INSERT INTO #Baugruppen SELECT N'611288' [Main Item], N'611288' [Baugruppe], '' [Baugruppe 2], 'DSI' [Lagerortfilter]
INSERT INTO #Baugruppen SELECT N'910549' [Main Item], N'910549' [Baugruppe], '' [Baugruppe 2], 'DSI' [Lagerortfilter]
INSERT INTO #Baugruppen SELECT N'910464' [Main Item], N'910464' [Baugruppe], '' [Baugruppe 2], 'DSI' [Lagerortfilter]
INSERT INTO #Baugruppen SELECT N'910545' [Main Item], N'910545' [Baugruppe], '' [Baugruppe 2], 'DSI' [Lagerortfilter]
INSERT INTO #Baugruppen SELECT N'910570' [Main Item], N'910570' [Baugruppe], '' [Baugruppe 2], 'DSI' [Lagerortfilter]
INSERT INTO #Baugruppen SELECT N'910712' [Main Item], N'910712' [Baugruppe], '' [Baugruppe 2], 'DSI' [Lagerortfilter]
INSERT INTO #Baugruppen SELECT N'910550' [Main Item], N'910550' [Baugruppe], '' [Baugruppe 2], 'DSI' [Lagerortfilter]
INSERT INTO #Baugruppen SELECT N'026815.8' [Main Item], N'026815.8' [Baugruppe], '' [Baugruppe 2], 'DSI' [Lagerortfilter]
INSERT INTO #Baugruppen SELECT N'910610' [Main Item], N'910610' [Baugruppe], '' [Baugruppe 2], 'DSI' [Lagerortfilter]
INSERT INTO #Baugruppen SELECT N'910546' [Main Item], N'910546' [Baugruppe], '' [Baugruppe 2], 'DSI' [Lagerortfilter]
INSERT INTO #Baugruppen SELECT N'910548' [Main Item], N'910548' [Baugruppe], '' [Baugruppe 2], 'DSI' [Lagerortfilter]
INSERT INTO #Baugruppen SELECT N'910562' [Main Item], N'910562' [Baugruppe], '' [Baugruppe 2], 'DSI' [Lagerortfilter]
INSERT INTO #Baugruppen SELECT N'025521.1' [Main Item], N'025521.1' [Baugruppe], '' [Baugruppe 2], 'DSI' [Lagerortfilter]
INSERT INTO #Baugruppen SELECT N'611062' [Main Item], N'611062' [Baugruppe], '' [Baugruppe 2], 'DSI' [Lagerortfilter]
INSERT INTO #Baugruppen SELECT N'550426.8' [Main Item], N'550426.8' [Baugruppe], '' [Baugruppe 2], 'DSI' [Lagerortfilter]
INSERT INTO #Baugruppen SELECT N'550425.7' [Main Item], N'550425.7' [Baugruppe], '' [Baugruppe 2], 'DSI' [Lagerortfilter]
INSERT INTO #Baugruppen SELECT N'026820.2' [Main Item], N'026820.2' [Baugruppe], '' [Baugruppe 2], 'DSI' [Lagerortfilter]
INSERT INTO #Baugruppen SELECT N'026817.1' [Main Item], N'026817.1' [Baugruppe], '' [Baugruppe 2], 'DSI' [Lagerortfilter]
INSERT INTO #Baugruppen SELECT N'910126' [Main Item], N'910126' [Baugruppe], '' [Baugruppe 2], 'DSI' [Lagerortfilter]
INSERT INTO #Baugruppen SELECT N'910555' [Main Item], N'910555' [Baugruppe], '' [Baugruppe 2], 'DSI' [Lagerortfilter]
INSERT INTO #Baugruppen SELECT N'910554' [Main Item], N'910554' [Baugruppe], '' [Baugruppe 2], 'DSI' [Lagerortfilter]
INSERT INTO #Baugruppen SELECT N'910553' [Main Item], N'910553' [Baugruppe], '' [Baugruppe 2], 'DSI' [Lagerortfilter]
INSERT INTO #Baugruppen SELECT N'910551' [Main Item], N'910551' [Baugruppe], '' [Baugruppe 2], 'DSI' [Lagerortfilter]
INSERT INTO #Baugruppen SELECT N'910552' [Main Item], N'910552' [Baugruppe], '' [Baugruppe 2], 'DSI' [Lagerortfilter]
INSERT INTO #Baugruppen SELECT N'611326' [Main Item], N'611326' [Baugruppe], '' [Baugruppe 2], 'DSI' [Lagerortfilter]
INSERT INTO #Baugruppen SELECT N'611063' [Main Item], N'611063' [Baugruppe], '' [Baugruppe 2], 'DSI' [Lagerortfilter]
INSERT INTO #Baugruppen SELECT N'910392' [Main Item], N'910392' [Baugruppe], '' [Baugruppe 2], 'DSI' [Lagerortfilter]
INSERT INTO #Baugruppen SELECT N'910544' [Main Item], N'910544' [Baugruppe], '' [Baugruppe 2], 'DSI' [Lagerortfilter]
INSERT INTO #Baugruppen SELECT N'910547' [Main Item], N'910547' [Baugruppe], '' [Baugruppe 2], 'DSI' [Lagerortfilter];

--Lagerbestand ueber Artikelposten
WITH Inventory AS (
SELECT N'Lagerbestand' [Type]     
	 , COALESCE(#Baugruppen.[Main Item],[Item No_]) [Item No_]
	 , [Location Code]
	 , '' [Kreditornr]
	 , YEAR(GETDATE()) [Year]
	 , MONTH(GETDATE()) [Month]
     , SUM([Quantity]) [Quantity]
FROM #Baugruppen WITH (READUNCOMMITTED)
LEFT OUTER JOIN dbo.[DSI-Getraenkearmaturen$Item Ledger Entry] 
ON [Item No_] = #Baugruppen.[Baugruppe] OR
   [Item No_] = #Baugruppen.[Baugruppe2] OR
   [Item No_] = #Baugruppen.[Main Item]
GROUP BY [Item No_],
         [Main Item],
         [Location Code])

--Lagerbestandszeilen einfuegen
INSERT INTO #ResultLines
SELECT 'Lagerbestand' [Type]     
	 , COALESCE(#Baugruppen.[Main Item],[Item No_]) [Item No_]	 
	 , '' [Kreditornr]
	 , YEAR(GETDATE()) [Year]
	 , MONTH(GETDATE()) [Month]
     , SUM(COALESCE([Quantity],0)) [Quantity]
FROM #Baugruppen
LEFT OUTER JOIN Inventory
ON [#Baugruppen].[Main Item] = Inventory.[Item No_]
WHERE [Location Code] IN (SELECT [nstr] FROM dbo.[Charlist_to_table](#Baugruppen.Lagerortfilter,','))
GROUP BY [Item No_],
         [Main Item];

--Rahmenbestellung
WITH Abruf AS (
SELECT 'Abruf' [Type]
     , [No_] [Item No_]	 
	 , [Buy-from Vendor No_] [Kreditornr]	      
     , SUM([Outstanding Quantity]) [Quantity]
FROM dbo.[DSI-Getraenkearmaturen$Purchase Line] PurchaseLine WITH (READUNCOMMITTED)
WHERE PurchaseLine.[Document Type] = 1 AND
      PurchaseLine.[Type] = 2 AND
	  PurchaseLine.[Blanket Order Line No_] <> 0 AND
	  PurchaseLine.[Blanket Order No_] <> ''
	  AND PurchaseLine.[No_] IN (SELECT [Main Item] FROM [#Baugruppen])
GROUP BY [No_]       
	   , [Buy-from Vendor No_]        
HAVING SUM([Outstanding Quantity]) <> 0)

INSERT INTO #ResultLines
SELECT 'Rahmenbestellung' [Type]
     , PurchaseLine.[No_] [Item No_]	 
	 , PurchaseLine.[Buy-from Vendor No_] [Kreditornr]	 
     , YEAR(GETDATE()) [Year]
	 , MONTH(GETDATE()) [Month]	 
     , SUM(PurchaseLine.[Outstanding Quantity]) - COALESCE(MAX(Abruf.[Quantity]),0) [Quantity]	 
FROM dbo.[DSI-Getraenkearmaturen$Purchase Line] PurchaseLine WITH (READUNCOMMITTED)
LEFT OUTER JOIN Abruf
ON PurchaseLine.[No_] = Abruf.[Item No_] AND
   PurchaseLine.[Buy-from Vendor No_] = Abruf.Kreditornr
WHERE PurchaseLine.[Document Type] = 4 AND
      PurchaseLine.[Type] = 2	  
	  AND PurchaseLine.[No_] IN (SELECT [Main Item] FROM [#Baugruppen])
GROUP BY [No_]       
	   , [Buy-from Vendor No_]        
HAVING SUM([Outstanding Quantity]) - COALESCE(MAX(Abruf.[Quantity]),0) <> 0


--Zugang ueber Bestellzeilen mit zugesagtem Lieferdatum
INSERT INTO #ResultLines
SELECT 'Zugang' [Type]
     , [No_] [Item No_]	 
	 , [Buy-from Vendor No_] [Kreditornr]	 
     , YEAR([Promised Receipt Date]) [Year]
	 , MONTH([Promised Receipt Date]) [Month]
     , SUM([Outstanding Quantity]) [Quantity]
FROM dbo.[DSI-Getraenkearmaturen$Purchase Line] PurchaseLine WITH (READUNCOMMITTED)
WHERE PurchaseLine.[Document Type] = 1 AND
      PurchaseLine.[Type] = 2 AND
	  PurchaseLine.[Promised Receipt Date] <> '1753-01-01 00:00:00.000' AND
	  PurchaseLine.[No_] IN (SELECT [Main Item] FROM #Baugruppen)
GROUP BY [No_]
       --, [Location Code]
	   , [Buy-from Vendor No_] 
       , YEAR([Promised Receipt Date])
	   , MONTH([Promised Receipt Date])
HAVING SUM([Outstanding Quantity]) <> 0

--Geplanter Zugang ueber Bestellzeilen ohne zugesagtem Lieferdatum
INSERT INTO #ResultLines
SELECT N'Gepl. Zugang' [Type]
     , [No_] [Item No_]	 
	 , [Buy-from Vendor No_] [Kreditornr]
     , YEAR([Expected Receipt Date]) [Year]
	 , MONTH([Expected Receipt Date]) [Month]
     , SUM([Outstanding Quantity]) [Quantity]
FROM dbo.[DSI-Getraenkearmaturen$Purchase Line] PurchaseLine WITH (READUNCOMMITTED)
WHERE PurchaseLine.[Document Type] = 1 AND
      PurchaseLine.[Type] = 2 AND
	  PurchaseLine.[Promised Receipt Date] = '1753-01-01 00:00:00.000' AND
	  PurchaseLine.[No_] IN (SELECT [Main Item] FROM #Baugruppen)
GROUP BY [No_]
       --, [Location Code]
	   , [Buy-from Vendor No_] 
       , YEAR([Expected Receipt Date])
	   , MONTH([Expected Receipt Date])
HAVING SUM([Outstanding Quantity]) <> 0

--Verbrauch über Komponentenzeilen (Nur auf Lagerort DSI)
INSERT INTO #ResultLines
SELECT N'Verbrauch' [Type]
     , COALESCE(#Baugruppen.[Main Item],[Item No_]) [Item No_]     	 
	 , '' [Kreditornr]
     , YEAR([Posting Date]) [Year]
	 , MONTH([Posting Date]) [Month]
     , -SUM([Quantity]) [Quantity]
FROM dbo.[DSI-Getraenkearmaturen$Item Ledger Entry] ILE WITH (READUNCOMMITTED)
LEFT OUTER JOIN #Baugruppen
ON ILE.[Item No_] = #Baugruppen.Baugruppe OR
   ILE.[Item No_] = #Baugruppen.Baugruppe2
WHERE [Entry Type] = 5 AND
      [Location Code] = 'DSI' AND
      ([Item No_] IN (SELECT [Baugruppe] FROM #Baugruppen) OR
	   [Item No_] IN (SELECT [Baugruppe2] FROM #Baugruppen))
GROUP BY [Item No_]
       , #Baugruppen.[Main Item]
       , [Location Code]
       , YEAR([Posting Date])
	   , MONTH([Posting Date])

--Abgang über Komponentenzeilen (Nur auf Lagerort DSI)
INSERT INTO #ResultLines
SELECT N'Abgang' [Type]
     , COALESCE(#Baugruppen.[Main Item],[Item No_]) [Item No_]	 
	 --, [Location Code]
	 , '' [Kreditornr]
     , YEAR([Due Date]) [Year]
	 , MONTH([Due Date]) [Month]
	 , -SUM([Remaining Quantity]) [Quantity]
FROM dbo.[DSI-Getraenkearmaturen$Prod_ Order Component] ProdComponent WITH (READUNCOMMITTED)
LEFT OUTER JOIN #Baugruppen
ON ProdComponent.[Item No_] = #Baugruppen.Baugruppe OR
   ProdComponent.[Item No_] = #Baugruppen.Baugruppe2
WHERE [Status] IN (1,2,3) AND
      [Location Code] = 'DSI' AND
      ([Item No_] IN (SELECT [Baugruppe] FROM #Baugruppen) OR
	   [Item No_] IN (SELECT [Baugruppe2] FROM #Baugruppen))
GROUP BY [Item No_]
       , #Baugruppen.[Main Item]
       --, [Location Code]
       , YEAR([Due Date])
	   , MONTH([Due Date])
HAVING SUM([Remaining Quantity]) > 0

;WITH SumUpInventory AS (
SELECT 'LagerbestandSaldo' [Type]
      , [EK Artikelnr]     
	  ,	'' [Kreditornr]
      , [Year]
	 , [Month]      
      ,SUM([Quantity]) [Quantity]      
  FROM #ResultLines
  where NOT [Type] IN ('Verbrauch','Rahmenbestellung')      
  GROUP BY [EK Artikelnr]
          ,[Year]
          ,[Month])

INSERT INTO #ResultLines
SELECT N'Lager' [Type]
      , myView.[EK Artikelnr]     
	  ,	'' [Kreditornr]
      , myView.[Year]
	 , myView.[Month]      
      ,SUM(myView2.[Quantity]) [Quantity]      	 
FROM SumUpInventory myView
INNER JOIN SumUpInventory myView2
ON myView.[EK Artikelnr] = myView2.[EK Artikelnr] AND
   CONVERT(DATETIME,N'01.'+CONVERT(NVARCHAR(MAX),myView2.[Month])+N'.'+CONVERT(NVARCHAR(MAX),myView2.[Year])) <= 
   CONVERT(DATETIME,N'01.'+CONVERT(NVARCHAR(MAX),myView.[Month])+N'.'+CONVERT(NVARCHAR(MAX),myView.[Year]))
WHERE CONVERT(DATETIME,N'01.'+CONVERT(NVARCHAR(MAX),myView.[Month])+N'.'+CONVERT(NVARCHAR(MAX),myView.[Year])) >= '01.10.2017'      
GROUP BY myView.[EK Artikelnr]
       , myView.[Year]
	   , myView.[Month];

WITH AllItemsPerios AS(
SELECT DISTINCT [EK Artikelnr]
     , #Periods.Period
FROM #ResultLines
CROSS JOIN #Periods)

INSERT INTO #ResultLines
SELECT N'Lager' [Type]
     , AllItemsPerios.[EK Artikelnr]
	 , '' [Kreditornr]
     , YEAR(AllItemsPerios.[Period]) [Year]
	 , MONTH(AllItemsPerios.[Period]) [Month]
     , (SELECT TOP 1 SaveResult.[Quantity]
	   FROM #ResultLines SaveResult
	   WHERE SaveResult.[EK Artikelnr] = AllItemsPerios.[EK Artikelnr] AND
	         SaveResult.[Type] = 'Lager' AND
			 CONVERT(DATETIME,N'01.'+CONVERT(NVARCHAR(MAX),SaveResult.[Month])+N'.'+CONVERT(NVARCHAR(MAX),SaveResult.[Year])) < AllItemsPerios.[Period]
	   ORDER BY CONVERT(DATETIME,N'01.'+CONVERT(NVARCHAR(MAX),SaveResult.[Month])+N'.'+CONVERT(NVARCHAR(MAX),SaveResult.[Year])) DESC 
	   ) [Quantiy]
FROM AllItemsPerios
LEFT OUTER JOIN #ResultLines Result
ON AllItemsPerios.[EK Artikelnr] = Result.[EK Artikelnr] AND
   YEAR(AllItemsPerios.Period) = Result.[Year] AND
   MONTH(AllItemsPerios.Period) = Result.[Month]
WHERE Result.[EK Artikelnr] IS NULL
ORDER BY AllItemsPerios.[EK Artikelnr],
         AllItemsPerios.[Period]
;

WITH AvgConsumption AS (
SELECT [Item No_]     
	 , -ROUND((SUM([Quantity]) / 12),0) [Avg_ Consumption 12M]
FROM dbo.[DSI-Getraenkearmaturen$Item Ledger Entry] WITH (READUNCOMMITTED)
WHERE [Entry Type] IN (5,1) AND
      DATEDIFF(month,[Posting Date],getdate()) <= 12 AND
	  DATEDIFF(month,[Posting Date],getdate()) > 0 	  
GROUP BY [Item No_]
)
, BlanketLines AS (
SELECT [EK Artikelnr]
     , [Kreditornr]
	 , SUM([Quantity]) [Menge]
FROM #ResultLines
WHERE [Type] = 'Rahmenbestellung'
GROUP BY [EK Artikelnr],
         [Kreditornr])
, Inventory AS (
SELECT [EK Artikelnr]     
	 , SUM([Quantity]) [Menge]
FROM #ResultLines
WHERE [Type] = 'Lagerbestand'
GROUP BY [EK Artikelnr])
, LeadTime AS (
SELECT Item.[No_]
     , Item.[Description]
	 , Item.[Item Category Code]
	 , Item.[Safety Stock Quantity]
	 , REPLACE(REPLACE(REPLACE(REPLACE(Item.[Lead Time Calculation],'','M'),'','T'),'','W'),'','J') [WBZ]
	 , CASE 
	     WHEN (CHARINDEX('',Item.[Lead Time Calculation]) > 0) THEN REPLACE(Item.[Lead Time Calculation],'','') * 30
		 WHEN (CHARINDEX('',Item.[Lead Time Calculation]) > 0) THEN REPLACE(Item.[Lead Time Calculation],'','') * 360
		 WHEN (CHARINDEX('',Item.[Lead Time Calculation]) > 0) THEN REPLACE(Item.[Lead Time Calculation],'','') * 7
		 WHEN (CHARINDEX('',Item.[Lead Time Calculation]) > 0) THEN REPLACE(Item.[Lead Time Calculation],'','')
		ELSE 0
	   END [WBZinTagen]
FROM dbo.[DSI-Getraenkearmaturen$Item] Item WITH (READUNCOMMITTED)
)

INSERT INTO [DispoResult]
SELECT [MainLine].[EK Artikelnr] 
     , #Baugruppen.Baugruppe
     , CONVERT(DATETIME,N'01.'+CONVERT(NVARCHAR(MAX),MainLine.[Month])+N'.'+CONVERT(NVARCHAR(MAX),MainLine.[Year])) [Periode]
	 
	 , [MainLine].[Kreditornr]
	 , COALESCE(Kreditor.[Name], '') [Kreditorname]
	 , [MainLine].[Quantity] [Menge]
	 , [MainLine].[Type] [Art]
     , LeadTime.[Description] [Beschreibung]
	 , LeadTime.[Item Category Code] [Artikelkategoriencode]
	 , COALESCE(LeadTime.[Safety Stock Quantity],0) [AlterSicherheitsbestand]
	 , COALESCE([Avg_ Consumption 12M],0) [DurchschnVerbrauch12M]
	 , [LeadTime].[WBZ]
 	 , [LeadTime].[WBZinTagen]	 	 
	 ,CASE 
	    WHEN LeadTime.[Item Category Code] = '010' AND [Avg_ Consumption 12M] > 1000 THEN COALESCE([Avg_ Consumption 12M],0)
		WHEN LeadTime.[Item Category Code] IN ('011','012','013','020','021','022','190','211') AND [LeadTime].[WBZinTagen] <= 90 THEN COALESCE([Avg_ Consumption 12M],0)
		WHEN LeadTime.[Item Category Code] IN ('011','012','013','020','021','022','190','211') AND [LeadTime].[WBZinTagen] > 90 THEN 2 * COALESCE([Avg_ Consumption 12M],0)
		ELSE 0
      END [NeuerSicherheitsbestand]
     , COALESCE(BlanketLines.Menge, 0) [MengeInRahmen]
	 , COALESCE(Inventory.Menge, 0) [Lagerbestand]
	 , #Baugruppen.Baugruppe2
FROM #ResultLines [MainLine]
INNER JOIN LeadTime
ON [MainLine].[EK Artikelnr] = LeadTime.[No_]
LEFT OUTER JOIN AvgConsumption
ON AvgConsumption.[Item No_] = [MainLine].[EK Artikelnr]
LEFT OUTER JOIN dbo.[DSI-Getraenkearmaturen$Vendor] Kreditor
ON [MainLine].[Kreditornr] = Kreditor.[No_]
INNER JOIN #Baugruppen
ON [MainLine].[EK Artikelnr] = #Baugruppen.[Main Item]
LEFT OUTER JOIN BlanketLines
ON [MainLine].[EK Artikelnr] = BlanketLines.[EK Artikelnr] AND
   [MainLine].[Kreditornr] = BlanketLines.Kreditornr
LEFT OUTER JOIN Inventory
ON [MainLine].[EK Artikelnr] = Inventory.[EK Artikelnr]

--Lagereinträge löschen, die nicht benötigt werden
DELETE FROM [DispoResult]
WHERE [Periode] < DATEADD(m,0,CONVERT(DATETIME,N'01.'+CONVERT(VARCHAR(MAX),DATEPART(mm,GETDATE()))+N'.'+CONVERT(VARCHAR(MAX),DATEPART(yyyy,GETDATE())))) AND
      [Art] = 'Lager'

DROP TABLE #ResultLines
DROP TABLE #Baugruppen
DROP TABLE #Periods