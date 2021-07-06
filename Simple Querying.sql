--Solution-1
With LoginInfo AS
(SELECT DISTINCT Security_Logins_Log.Login FROM Security_Logins_Log WHERE Security_Logins_Log.Logon_Date < '2017-01-01'
EXCEPT
SELECT DISTINCT Security_Logins_Log.Login FROM Security_Logins_Log WHERE Security_Logins_Log.Logon_Date >= '2017-01-01')
SELECT Security_Logins.Login AS "User Login", Security_Logins.Full_Name AS "User Name", Security_Logins.Phone_Number AS "User Phone"
FROM LoginInfo
INNER JOIN
Security_Logins ON Security_Logins.Id = LoginInfo.Login;
--Solution-2
SELECT Company_Descriptions.Company_Name AS "Company Name" FROM Company_Descriptions
INNER JOIN Company_Jobs ON Company_Jobs.Company = Company_Descriptions.Company
INNER JOIN Applicant_Job_Applications ON Applicant_Job_Applications.Job = Company_Jobs.Id
WHERE Company_Descriptions.LanguageID = 'EN'
GROUP BY Company_Descriptions.Company_Name
HAVING COUNT(Applicant_Job_Applications.Applicant) >= 10;
--Solution-3
SELECT TOP 1 WITH TIES Security_Logins.Full_Name AS "Full Name", Applicant_Profiles.Current_Salary AS "Current Salary", Applicant_Profiles.Currency AS "Currency"
FROM Applicant_Profiles
INNER JOIN Security_Logins ON Applicant_Profiles.Login = Security_Logins.Id
ORDER BY DENSE_RANK() 
OVER(PARTITION BY Applicant_Profiles.Currency ORDER BY Applicant_Profiles.Current_Salary DESC);
--Solution-4
SELECT Company_Descriptions.Company_Name AS "Company Name", COUNT(Company_Jobs_Descriptions.Job) AS "#Jobs Posted" FROM Company_Jobs_Descriptions
FULL OUTER JOIN Company_Jobs ON Company_Jobs_Descriptions.Job = Company_Jobs.Id
FULL OUTER JOIN Company_Descriptions ON Company_Jobs.Company = Company_Descriptions.Company
WHERE Company_Descriptions.LanguageID = 'EN' GROUP BY Company_Descriptions.Company_Name
ORDER BY [#Jobs Posted] DESC;
--Solution-5
WITH JobNumber AS (SELECT Company_Descriptions.Company_Name AS "Company Name", COUNT(Company_Jobs_Descriptions.Job) AS "Jobs_Posted" FROM Company_Jobs_Descriptions
FULL OUTER JOIN Company_Jobs ON Company_Jobs_Descriptions.Job = Company_Jobs.Id
FULL OUTER JOIN Company_Descriptions ON Company_Jobs.Company = Company_Descriptions.Company
WHERE Company_Descriptions.LanguageID = 'EN' GROUP BY Company_Descriptions.Company_Name)
SELECT 'Client without Posted Jobs:', SUM(CASE WHEN JobNumber.Jobs_Posted = 0 THEN 1 END) FROM JobNumber
UNION
SELECT 'Client with Posted Jobs:', SUM(CASE WHEN JobNumber.Jobs_Posted >= 1 THEN 1 END) FROM JobNumber;