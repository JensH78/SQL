/*
Ermittelt Objektunterschiede zwischen Test- und Live-Datenbank
*/
WITH cte AS(
SELECT CASE WHEN [Test].[Name] <> Live.[Name] THEN 'Name unterschiedlich'
            WHEN [Test].[Date] > [Live].[Date] THEN 'Test aktueller'
            WHEN [Test].[Date] < [Live].[Date] THEN 'Live aktueller'
            WHEN [Test].[Time] <> [Live].[Time] THEN 'Zeit unterschiedlich'
			WHEN [Test].[Version List] <> [Live].[Version List] THEN 'Version unterschiedlich'
			WHEN [Test].[BLOB Size] <> [Live].[BLOB Size] THEN 'Größe unterschiedlich'
			WHEN [Test].[ID] IS NULL THEN 'Objekt in Test nicht vorhanden'
			WHEN [Live].[ID] IS NULL THEN 'Objekt in Live nicht vorhanden'
       END [Unterschied]
     , CASE COALESCE([Live].[Type], [Test].[Type])
	     WHEN 1 THEN 'Table'
		 WHEN 3 THEN 'Report'
		 WHEN 5 THEN 'Codeunit'
		 WHEN 6 THEN 'XML Port'
		 WHEN 7 THEN 'MenuSuite'
	     WHEN 8 THEN 'Page'
		 ELSE CONVERT(NVARCHAR(max), COALESCE([Live].[Type], [Test].[Type]))
	   END [Type]
	 , COALESCE([Live].[ID], [Test].[ID]) [ID]
	 , COALESCE([Live].[Name], [Test].[Name]) [Name]	 
	 , COALESCE([Test].[Name], [Live].[Name]) [Test Name]
	 , CONVERT(NVARCHAR(MAX), [Live].[Date], 104) [Live Date]
	 , CONVERT(NVARCHAR(MAX), [Test].[Date],104) [Test Date]	 
	 , CONVERT(NVARCHAR(MAX), [Live].[Time],108) [Live Time]
	 , CONVERT(NVARCHAR(MAX), [Test].[Time],108) [Test Time]
	 , [Live].[Version List] [Live Version List]
	 , [Test].[Version List] [Test Version List]
	 , [Live].[BLOB Size] [Live BLOB Size]
	 , [Test].[BLOB Size] [Test BLOB Size]
	 , [Live].[Locked By] [Live Locked By]
	 , [Test].[Locked By] [Test Locked By]	 	 	 	 		 
FROM [dsinav_140330].dbo.[Object] [Live]
FULL OUTER JOIN [TEMP_NAV].dbo.[Object] [Test]
ON [Live].[Type] = [Test].[Type] AND
   [Live].[ID] = [Test].[ID]
WHERE ((((
      ([Live].[Type] = [Test].[Type] AND
       [Live].[ID] = [Test].[ID] AND 
	   ([Test].[Date] <> [Live].[Date] OR
	   [Test].[Time] <> [Live].[Time] OR
	   [Test].[Version List] <> [Live].[Version List] OR
	   [Test].[Name] <> [Live].[Name] OR
	   [Test].[BLOB Size] <> [Live].[BLOB Size]))) AND
	   NOT [Live].[Version List] LIKE 'NAPA%')OR
	   ([Test].ID IS NULL) OR
	   ([Live].ID IS NULL))) AND
         ([Live].[Type] > 0 OR [Live].[Type] IS NULL)AND
         ([Test].[Type] > 0 OR [Test].[Type] IS NULL) )

SELECT *
FROM cte
ORDER BY [Unterschied],
         [Type],
         [ID]
