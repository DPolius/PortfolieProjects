-- Cleaned the SIM_Customers table
SELECT 
  c.[CustomerKey] AS CustomerKey,
  --,[GeographyKey]
  --,[CustomerAlternateKey]
  --,[Title]
  c.[FirstName] AS FirstName, 
  -- ,[MiddleName]
  c.[LastName] AS LastName, 
  c.FirstName + ' ' + c.LastName AS FullName,
  --,[NameStyle]
  --,[BirthDate]
  --,[MaritalStatus]
  --,[Suffix]
  CASE c.Gender WHEN 'M' THEN 'Male' WHEN 'F' THEN 'Female' END AS Gender, 
  --,[EmailAddress]
  --,[YearlyIncome]
  --,[TotalChildren]
  --,[NumberChildrenAtHome]
  --,[EnglishEducation]
  --,[SpanishEducation]
  --,[FrenchEducation]
  --,[EnglishOccupation]
  --,[SpanishOccupation]
  --,[FrenchOccupation]
  --,[HouseOwnerFlag]
  --,[NumberCarsOwned]
  --,[AddressLine1]
  --,[AddressLine2]
  --,[Phone]
  c.[DateFirstPurchase] AS DateFirstPurchased, 
  --,[CommuteDistance]
  g.City AS CustomerCity 
FROM 
  [AdventureWorksDW2022].[dbo].[DimCustomer] AS c 
  LEFT JOIN DimGeography AS g ON g.GeographyKey = c.GeographyKey 
ORDER BY 
  CustomerKey -- Ordered List by Customer Key
