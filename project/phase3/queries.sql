----------------------------------------------------------------------------------
-------------------------- GDP of countries -------------------------
----------------------------------------------------------------------------------

-- Find countries with highest and lowest avg GDP
DROP VIEW IF EXISTS AvgGDPOverYears CASCADE;
CREATE VIEW AvgGDPOverYears AS
Select countrycode, avg(gdp) as avgGDP
From CountryGDP
where theYear >= 2016 AND theYear <= 2019
Group By countryCode;

DROP VIEW IF EXISTS AvgGDPCountries CASCADE;
CREATE VIEW AvgGDPCountries AS
Select A.countryCode, C.countryName, A.avgGDP
From AvgGDPOverYears A Join Country C ON A.countryCode = C.countryCode;

DROP VIEW IF EXISTS TopHighestGDPCountries CASCADE;
CREATE VIEW TopHighestGDPCountries AS
Select *
From AvgGDPCountries
Order By avgGDP DESC
limit 10;

\echo -------------------- Top 10 countries with highest GDP -------------------- 
\echo
Select *
From TopHighestGDPCountries;
\echo

\echo -------------------- Top 10 countries with lowest GDP -------------------- 
\echo
Select *
From AvgGDPCountries
Order By avgGDP
limit 10;
\echo

-- Find top 10 countries with highest and lowest avg GDPPerCapita
DROP VIEW IF EXISTS AvgGdpPerCapitaOverYears CASCADE;
CREATE VIEW AvgGdpPerCapitaOverYears AS
Select countrycode, avg(gdpPerCapita) as avgGDPPerCapita
From CountryGDP
where theYear >= 2016 AND theYear <= 2019
Group By countryCode;

DROP VIEW IF EXISTS AvgGdpPerCapitaCountries CASCADE;
CREATE VIEW AvgGdpPerCapitaCountries AS
Select A.countryCode, C.countryName, A.avgGDPPerCapita
From AvgGdpPerCapitaOverYears A Join Country C ON A.countrycode = C.countryCode;

DROP VIEW IF EXISTS TopHighestGDPPerCapitaCountries CASCADE;
CREATE VIEW TopHighestGDPPerCapitaCountries AS
Select * From AvgGdpPerCapitaCountries
Order By avgGDPPerCapita DESC
limit 10;

\echo -------------------- Top 10 countries with highest GDP Per Capita -------------------- 
\echo
Select * From TopHighestGDPPerCapitaCountries;
\echo

\echo -------------------- Top 10 countries with lowest GDP Per Capita -------------------- 
\echo
Select * From AvgGdpPerCapitaCountries
Order By avgGDPPerCapita
limit 10;
\echo

----------------------------------------------------------------------------------
---------------------- Employment rate of countries ------------------------------
----------------------------------------------------------------------------------

-- find avg of employment in countries
DROP VIEW IF EXISTS AvgEmploymentRateOverYears CASCADE;
CREATE VIEW AvgEmploymentRateOverYears AS
Select countryCode, avg(employmentRate) AS avgEmploymentRate
From Employment
where theYear >= 2016 AND theYear <= 2019
Group By countryCode;

DROP VIEW IF EXISTS AvgEmploymentRateCountries CASCADE;
CREATE VIEW AvgEmploymentRateCountries AS
Select A.countryCode, C.countryName, A.avgEmploymentRate
From AvgEmploymentRateOverYears A Join Country C ON A.countryCode = C.countryCode;

\echo -------------------- Top 10 countries with highest employment rate -------------------- 
\echo
Select *
From AvgEmploymentRateCountries
Order By avgEmploymentRate DESC
limit 10;

\echo -------------------- Top 10 countries with lowest employment rate -------------------- 
\echo
Select *
From AvgEmploymentRateCountries
Order By avgEmploymentRate
limit 10;



\echo  -------------------------------------------------------------------------------------------------------------------
\echo  ------------------ Investigative Question 1: Effect of Age on Employment and GDP per capita ----------------------- 
\echo  -------------------------------------------------------------------------------------------------------------------
\echo

DROP VIEW IF EXISTS AvgEmploymentInAgeGroupsOverYears CASCADE;
CREATE VIEW AvgEmploymentInAgeGroupsOverYears AS
Select countryCode, ageGroup, avg(employmentByAgeRate) AvgEmploymentByAgeRate
From EmploymentByAge
where theYear >= 2016 AND theYear <= 2019
Group By countryCode, ageGroup; -- This tells us given one specific age group, what percentage of that group are employed.

-- Find age group which has the highest employment rate in countries
DROP VIEW IF EXISTS HighestEmploymentRateOverGroups CASCADE;
CREATE VIEW HighestEmploymentRateOverGroups AS
Select countryCode, max(AvgEmploymentByAgeRate) AS MaxOfAvgEmploymentByAgeRate
From AvgEmploymentInAgeGroupsOverYears
Group By countryCode;

DROP VIEW IF EXISTS GroupWithHighestEmployment CASCADE;
CREATE VIEW GroupWithHighestEmployment AS
Select A.countryCode, A.ageGroup, M.MaxOfAvgEmploymentByAgeRate
From AvgEmploymentInAgeGroupsOverYears A Join HighestEmploymentRateOverGroups M
ON A.countryCode = M.countryCode AND A.AvgEmploymentByAgeRate = M.MaxOfAvgEmploymentByAgeRate;

DROP VIEW IF EXISTS GroupWithHighestEmploymentInCountries CASCADE;
CREATE VIEW GroupWithHighestEmploymentInCountries AS
Select G.countryCode, C.countryName, G.ageGroup, G.MaxOfAvgEmploymentByAgeRate
From GroupWithHighestEmployment G Join country C ON G.countryCode = C.countryCode;

\echo -------------------- Age group with highest employment rate in countries -------------------- 
\echo
Select DISTINCT ageGroup From GroupWithHighestEmploymentInCountries;
\echo

----- Find countries with most employment in the highest age group
DROP VIEW IF EXISTS CountriesWithHighestEmploymentInHighestGroup CASCADE;
CREATE VIEW CountriesWithHighestEmploymentInHighestGroup AS
Select countryCode, countryName, ageGroup, MaxOfAvgEmploymentByAgeRate
From GroupWithHighestEmploymentInCountries
Order By MaxOfAvgEmploymentByAgeRate DESC
limit 10;

\echo -------------------- Top 10 countries with most employment in the highest age group "25_54" -------------------- 
\echo
Select * From CountriesWithHighestEmploymentInHighestGroup;
\echo

----- Find countries with lowest employment in the highest age group
DROP VIEW IF EXISTS CountriesWithLowestEmploymentInHighestGroup CASCADE;
CREATE VIEW CountriesWithLowestEmploymentInHighestGroup AS
Select countryCode, countryName, ageGroup, MaxOfAvgEmploymentByAgeRate
From GroupWithHighestEmploymentInCountries
Order By MaxOfAvgEmploymentByAgeRate
limit 10;

\echo -------------------- Top 10 countries with lowest employment in the highest age group "25_54" -------------------- 
\echo
Select * From CountriesWithLowestEmploymentInHighestGroup;
\echo

-- Find highest employment rate in the oldest age group "55_64"
DROP VIEW IF EXISTS EmploymentInOldAgeGroup CASCADE;
CREATE VIEW EmploymentInOldAgeGroup AS
Select *
From AvgEmploymentInAgeGroupsOverYears
Where ageGroup = '55_64';

DROP VIEW IF EXISTS CountriesWithHighestEmploymentInOldAgeGroup CASCADE;
CREATE VIEW CountriesWithHighestEmploymentInOldAgeGroup AS
Select T.countryCode, C.countryName, T.ageGroup, T.AvgEmploymentByAgeRate
From EmploymentInOldAgeGroup T Join Country C ON T.countryCode = C.countryCode
Order By AvgEmploymentByAgeRate DESC
limit 10;

\echo -------------------- Top 10 countries with highest employment rate in oldest age group "55_64" -------------------- 
\echo 
Select * From CountriesWithHighestEmploymentInOldAgeGroup;
\echo 



\echo  ---------------------------------------------------------------------------------------------------------------------------------- 
\echo  ------------------ Investigative Question 2: Effect of Education on Employment, GDP and GDP per capita ------------------------- 
\echo  ---------------------------------------------------------------------------------------------------------------------------------- 
\echo

DROP VIEW IF EXISTS AvgEmploymentByEducationOverYears CASCADE;
CREATE VIEW AvgEmploymentByEducationOverYears AS
Select countryCode, educationLevel, avg(employmentByEducationRate) AS avgEmploymentByEducationRate
From EmploymentByEducation
where theYear >= 2016 AND theYear <= 2019
Group By countryCode, educationLevel;

-- Find the education level that has the highest employment rate 
DROP VIEW IF EXISTS HighestEmploymentEducationLevel CASCADE;
CREATE VIEW HighestEmploymentEducationLevel AS
Select countryCode, max(avgEmploymentByEducationRate) AS MaxAvgEmploymentByEducationRate
From AvgEmploymentByEducationOverYears
Group By countryCode;

DROP VIEW IF EXISTS EducationLevelWithHighestEmploymentInCountries CASCADE;
CREATE VIEW EducationLevelWithHighestEmploymentInCountries AS
Select H.countryCode, A.educationLevel, H.MaxAvgEmploymentByEducationRate
From HighestEmploymentEducationLevel H Join AvgEmploymentByEducationOverYears A
ON H.countryCode = A.countryCode AND H.MaxAvgEmploymentByEducationRate = A.avgEmploymentByEducationRate;

\echo -------------------- Education level with highest employment rate -------------------- 
\echo 
Select DISTINCT educationLevel From EducationLevelWithHighestEmploymentInCountries;
\echo 

DROP VIEW IF EXISTS CountriesInHighestEmployedEducationLevel CASCADE;
CREATE VIEW CountriesInHighestEmployedEducationLevel AS
Select E.countryCode, C.countryName, E.educationLevel, E.MaxAvgEmploymentByEducationRate
From EducationLevelWithHighestEmploymentInCountries E Join country C ON E.countryCode = C.countryCode;

\echo --------------- Top 10 countries with highest employment rate in education level "POST_SECONDARY" --------------- 
\echo 
Select * From CountriesInHighestEmployedEducationLevel
Order By MaxAvgEmploymentByEducationRate DESC
limit 10;
\echo 

\echo ------------------ Employment in 'Lithuania' ------------------
\echo
Select * from AvgEmploymentRateOverYears where countrycode = 'LTU';

\echo ----------------- Top 10 countries with lowest employment rate in education level "POST_SECONDARY" --------------- 
\echo 
Select * From CountriesInHighestEmployedEducationLevel
Order By MaxAvgEmploymentByEducationRate
limit 10;
\echo 

--- Find standard deviation of employment rate across differnet education levels
DROP VIEW IF EXISTS AvgEmploymentOverAllEducationLevels CASCADE;
CREATE VIEW AvgEmploymentOverAllEducationLevels AS
Select countryCode, avg(avgEmploymentByEducationRate) AS avgOfAllRates
From AvgEmploymentByEducationOverYears
Group By countryCode;

DROP VIEW IF EXISTS EmploymentByEducationWithAvgOfAllRates CASCADE;
CREATE VIEW EmploymentByEducationWithAvgOfAllRates AS
Select A1.countryCode, A1.educationLevel, A1.avgEmploymentByEducationRate, A2.avgOfAllRates 
From AvgEmploymentByEducationOverYears A1 Join AvgEmploymentOverAllEducationLevels A2
ON A1.countryCode = A2.countryCode;

DROP VIEW IF EXISTS EmploymentByEducationWithSquaredDiffOfRates CASCADE;
CREATE VIEW EmploymentByEducationWithSquaredDiffOfRates AS
Select countryCode, educationLevel, avgEmploymentByEducationRate, avgOfAllRates,
(avgEmploymentByEducationRate - avgOfAllRates) ^ 2 AS squaredDiffOfRates
From EmploymentByEducationWithAvgOfAllRates;

DROP VIEW IF EXISTS EmploymentByEducationWithStandardDeviation CASCADE;
CREATE VIEW EmploymentByEducationWithStandardDeviation AS
Select countryCode, |/avg(squaredDiffOfRates) AS ratesStandardDeviation
From EmploymentByEducationWithSquaredDiffOfRates
Group By countryCode;

DROP VIEW IF EXISTS EmploymentByEducationWithAvgAndStandardDeviation CASCADE;
CREATE VIEW EmploymentByEducationWithAvgAndStandardDeviation AS
Select DISTINCT E1.countryCode, E2.avgOfAllRates, E1.ratesStandardDeviation
From EmploymentByEducationWithStandardDeviation E1 Join EmploymentByEducationWithSquaredDiffOfRates E2
ON E1.countryCode = E2.countryCode;

DROP VIEW IF EXISTS EmploymentByEducationWithStandardDeviationInCountries CASCADE;
CREATE VIEW EmploymentByEducationWithStandardDeviationInCountries AS
Select E.countryCode, C.countryName, E.avgOfAllRates, E.ratesStandardDeviation
From EmploymentByEducationWithAvgAndStandardDeviation E Join Country C ON E.countryCode = C.countryCode;

\echo --------------- Top 10 countries with highest standard deviation of employment rate across different education levels --------------- 
\echo 
Select *
From EmploymentByEducationWithStandardDeviationInCountries
Order By ratesStandardDeviation DESC, avgOfAllRates
limit 10;

\echo -------------- Employment by education level in two top countries with highest standard deviation of employment across education levels ---------------- 
\echo 
select * from AvgEmploymentByEducationOverYears where countrycode = 'SVK';
select * from AvgEmploymentByEducationOverYears where countrycode = 'POL';

\echo --------------- Top 10 countries with lowest standard deviation of employment across different education levels ---------------- 
\echo 
Select *
From EmploymentByEducationWithStandardDeviationInCountries
Order By ratesStandardDeviation, avgOfAllRates 
limit 10;

\echo -------------- Employment by education level in three top countries with lowest standard deviation of employment across education levels -------------- 
\echo 
select * from AvgEmploymentByEducationOverYears where countrycode = 'COL';
select * from AvgEmploymentByEducationOverYears where countrycode = 'KOR';
select * from AvgEmploymentByEducationOverYears where countrycode = 'SAU';

\echo --------------- Standard deviation of employment rate across education levels in 10 top countries with highest GDP ---------------
\echo
Select E.countryCode, T.countryName, E.avgOfAllRates, E.ratesStandardDeviation
From EmploymentByEducationWithStandardDeviationInCountries E Join TopHighestGDPCountries T ON E.countryCode = T.countryCode
Order By E.ratesStandardDeviation;

\echo -------------- Employment by education level of high GDP countries with highest and lowest standard deviations -------------- 
\echo 
select * from AvgEmploymentByEducationOverYears where countrycode = 'IDN';
select * from AvgEmploymentByEducationOverYears where countrycode = 'FRA';

\echo ------------- Standard deviation of employment rate across education levels in 10 top countries with highest GDP Per Capita ---------
\echo
Select E.countryCode, T.countryName, E.avgOfAllRates, E.ratesStandardDeviation
From EmploymentByEducationWithStandardDeviationInCountries E Join TopHighestGDPPerCapitaCountries T ON E.countryCode = T.countryCode
Order By E.ratesStandardDeviation;

\echo -------------- Employment by education level of high GDP Per Capita countries with highest and lowest standard deviations -------------- 
\echo 
select * from AvgEmploymentByEducationOverYears where countrycode = 'ISL';
select * from AvgEmploymentByEducationOverYears where countrycode = 'IRL';




\echo  ---------------------------------------------------------------------------------------------------------------------------------- 
\echo  ------------------ Investigative Question 3: Effect of Enterprise Sizes on Employment, GDP and GDP per capita ------------------ 
\echo  ---------------------------------------------------------------------------------------------------------------------------------- 
\echo

-- Find the enterprise sizes with highest number of enterprises
DROP VIEW IF EXISTS AvgNumOfEnterprisesOfDifferentTypesOverYears CASCADE;
CREATE VIEW AvgNumOfEnterprisesOfDifferentTypesOverYears AS
Select countryCode, EnterpriseSize, avg(numEnterprises) AS AvgNumOfEnterprisesWithThisSize
From EmploymentByEnterprise
where theYear >= 2016 AND theYear <= 2019
Group By countryCode, EnterpriseSize;

DROP VIEW IF EXISTS TopEnterpriseSizeOverAllSizes CASCADE;
CREATE VIEW TopEnterpriseSizeOverAllSizes AS
Select countryCode, Max(AvgNumOfEnterprisesWithThisSize) AS MaxAvgNumOfEnterprises
From AvgNumOfEnterprisesOfDifferentTypesOverYears 
Group By countryCode;

DROP VIEW IF EXISTS TopEnterpriseSize CASCADE;
CREATE VIEW TopEnterpriseSize AS
Select T.countryCode, A.EnterpriseSize, T.MaxAvgNumOfEnterprises
From TopEnterpriseSizeOverAllSizes T Join AvgNumOfEnterprisesOfDifferentTypesOverYears A 
ON T.countryCode = A.countryCode AND T.MaxAvgNumOfEnterprises = A.AvgNumOfEnterprisesWithThisSize;

DROP VIEW IF EXISTS TopEnterpriseSizeInCountries CASCADE;
CREATE VIEW TopEnterpriseSizeInCountries AS
Select T.countryCode, C.countryName, T.EnterpriseSize, T.MaxAvgNumOfEnterprises
From TopEnterpriseSize T Join Country C ON T.countryCode = C.countryCode;

\echo -------------------- Enterprise size with highest number of enterprises in countries--------------------
\echo
Select EnterpriseSize, count(countryCode)
From TopEnterpriseSizeInCountries
Group By EnterpriseSize;

\echo ----------------- Top 10 countries with highest number of enterprises of size '1_9_EMPLOYED' -----------------
\echo
Select *
From TopEnterpriseSizeInCountries
Order By MaxAvgNumOfEnterprises DESC
limit 10;

\echo ----------------- Country whose top enterprise size is not '1_9_EMPLOYED' -----------------
\echo
Select *
From TopEnterpriseSizeInCountries
Where EnterpriseSize != '1_9_EMPLOYED';

\echo --------------- Number of enterprises with size '1_9_EMPLOYED' in 10 top countries with highest GDP --------------
\echo
Select T1.countryCode, T2.countryName, T1.EnterpriseSize, T1.MaxAvgNumOfEnterprises
From TopEnterpriseSize T1 Join TopHighestGDPCountries T2 ON T1.countryCode = T2.countryCode
Order By T1.MaxAvgNumOfEnterprises DESC; 

\echo -------------- Number of enterprises with size '1_9_EMPLOYED' in 10 top countries with highest GDPPerCapita ------------
\echo
Select T1.countryCode, T2.countryName, T1.EnterpriseSize, T1.MaxAvgNumOfEnterprises
From TopEnterpriseSize T1 Join TopHighestGDPPerCapitaCountries T2 ON T1.countryCode = T2.countryCode
Order By T1.MaxAvgNumOfEnterprises DESC; 

--- Find the country with the highest number of big enterpises '250MORE_EMPLOYED'
DROP VIEW IF EXISTS BigEnterprises CASCADE;
CREATE VIEW BigEnterprises AS
Select countryCode, enterpriseSize, AvgNumOfEnterprisesWithThisSize
From AvgNumOfEnterprisesOfDifferentTypesOverYears 
where enterpriseSize = '250MORE_EMPLOYED';

DROP VIEW IF EXISTS BigEnterprisesInCountries CASCADE;
CREATE VIEW BigEnterprisesInCountries AS
Select B.countryCode, C.countryName, B.AvgNumOfEnterprisesWithThisSize
From BigEnterprises B Join Country C ON B.countrycode = C.countrycode
Order By B.AvgNumOfEnterprisesWithThisSize DESC
limit 10;

\echo ------------ Top 10 countries with highest number of big enterpises of size '250MORE_EMPLOYED' ------------
\echo
Select * 
From BigEnterprisesInCountries;
