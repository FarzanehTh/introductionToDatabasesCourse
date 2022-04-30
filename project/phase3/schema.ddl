DROP SCHEMA IF EXISTS ProjectSchema CASCADE;
CREATE SCHEMA ProjectSchema;
SET SEARCH_PATH TO ProjectSchema;

------------------------------ Custom domains ------------------------------
-- The employment rate for a given age group is measured as the number of employed people of
-- a given age as a percentage of the total number of people in that same age group.
-- An AgeGroup can be one of the ranges:
-- '15 to 24 years old'(those just entering the labour market following education)
-- '25 to 54 years old'(those in their prime working lives)
-- '55 to 64 years old'(those passing the peak of their career and approaching retirement)
create domain AgeGroup as varchar(10)
default NULL
check (value in ('15_24', '25_54', '55_64'));

-- An EducationLevel can be one of the ranges:
-- 'POST_SECONDARY': post seconday education,
-- 'UPPER_SECONDARY': grade 10, 11, 12 of seconday school,
-- 'LOWER_SECONDARY': any grade below grade 10 of seconday school
create domain EducationLevel as varchar(20)
default NULL
check (value in ('POST_SECONDARY', 'UPPER_SECONDARY', 'LOWER_SECONDARY'));

-- Enterprises with fewer than 10 employees which is shown by “1_9_EMPLOYED”.
-- Enterprises with 10 to 49 employees which is shown by “10_49_EMPLOYED”.
-- Enterprises with 50 to 249 employees which is shown by “50_249_EMPLOYED”.
-- Enterprises with more than 250 employees which is shown by “250More_EMPLOYED”.
create domain EnterpriseSize as varchar(20)
default NULL
check (value in ('1_9_EMPLOYED', '10_19_EMPLOYED', '20_49_EMPLOYED', '50_249_EMPLOYED', '250MORE_EMPLOYED'));


------------------------------ Tables ------------------------------
-- A country.
-- countryCode is the code by which a country is referred to.
CREATE TABLE Country (
	countryCode varchar(3) NOT NULL,
    countryName varchar(100) NOT NULL,
	PRIMARY KEY (countryCode)
);

-- A country's GDP in a specific year.
-- countryCode is the code by which a country is referred to,
-- theYear is the year in which the gdp and gdpPerCapita rates were measured,
-- gdp is the yearly income obtained through the production of goods and services
-- in a country in million of US dollars, and the gdpPerCapita is the gdp divided
-- by the country’s population.
CREATE TABLE CountryGDP (
	countryCode varchar(3) NOT NULL,
    theYear INTEGER NOT NULL,
    gdp FLOAT NOT NULL,
    gdpPerCapita FLOAT,
	PRIMARY KEY (countryCode, theYear),
    FOREIGN KEY (countryCode) REFERENCES Country(countryCode)
);

-- The employment rate.
-- The countryCode is the code by which a country is referred to,
-- theYear is the year in which the employment rate was measured,
-- employmentRate is the ratio of the number of people who are employed and have a
-- job with respect to the total number of available labour resources in a country.
CREATE TABLE Employment (
	countryCode varchar(3) NOT NULL,
    theYear INTEGER NOT NULL,
    employmentRate FLOAT NOT NULL,
    PRIMARY KEY (countryCode, theYear),
	FOREIGN KEY (countryCode) REFERENCES Country(countryCode)
);

-- The employment rate by age.
-- The countryCode is the code by which a country is referred to,
-- theYear is the year in which the employment by age rate was measured,
-- ageGroup should be an AgeGroup defined above.
-- employmentByAgeRate is the measure of the number of employed people of a given age
-- as a percentage of the total number of people in that same age group.
CREATE TABLE EmploymentByAge (
	countryCode varchar(3) NOT NULL,
    theYear INTEGER NOT NULL,
    ageGroup AgeGroup NOT NULL,
    employmentByAgeRate FLOAT NOT NULL,
    PRIMARY KEY (countryCode, theYear, ageGroup),
	FOREIGN KEY (countryCode) REFERENCES Country(countryCode)
);

-- The employment rate by education.
-- The countryCode is the code by which a country is referred to,
-- theYear is the year in which the employment by education rate was measured,
-- educationLevel should be an EducationLevel defined above and is the education
-- level for which the employment rate has been calculated. The employmentByEducationRate
-- is the percentage of the number of people with a certain education level in the total
-- population in working age.
CREATE TABLE EmploymentByEducation (
	countryCode varchar(3) NOT NULL,
    theYear INTEGER NOT NULL,
    educationLevel EducationLevel NOT NULL,
    employmentByEducationRate FLOAT NOT NULL,
    PRIMARY KEY (countryCode, theYear, educationLevel),
	FOREIGN KEY (countryCode) REFERENCES Country(countryCode)
);

-- The employment rate by enterprise sizes.
-- The countryCode is the code by which a country is referred to,
-- theYear is the year in which the employment rate by enterprise size was measured,
-- enterpriseSize is a EnterpriseSize defined above.
-- numEnterprises is the number of enterprises with a specific size in this country.
CREATE TABLE EmploymentByEnterprise (
	countryCode varchar(3) NOT NULL,
    theYear INTEGER NOT NULL,
    enterpriseSize EnterpriseSize NOT NULL,
    numEnterprises FLOAT NOT NULL,
    PRIMARY KEY (countryCode, theYear, enterpriseSize),
	FOREIGN KEY (countryCode) REFERENCES Country(countryCode)
);