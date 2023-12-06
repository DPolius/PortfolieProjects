-- Initial inspection of imported data for quality assurance

SELECT *
FROM DBO.CovidDeaths
ORDER BY 3,4

--SELECT *
--FROM DBO.CovidVaccinations
--ORDER BY 3,4

-- Data cleaning: changing numerical data to be used in calculations from nvarchar to float

ALTER TABLE dbo.CovidDeaths
ALTER COLUMN total_cases float

ALTER TABLE dbo.CovidDeaths
ALTER COLUMN total_deaths floatv

ALTER TABLE dbo.CovidDeaths
ALTER COLUMN total_cases_per_million float

ALTER TABLE dbo.CovidVaccinations
ALTER COLUMN new_vaccinations float


-- Select that will be used (optional)

SELECT location, date, total_cases, new_cases, total_deaths, population
FROM DBO.CovidDeaths
ORDER BY 1,2

-- Looking at Total Cases vs Total deaths 
-- Showing likelihood of dying if you contract covid in the US
SELECT location, date, total_cases, total_deaths, (total_deaths/ total_cases)*100 AS death_percentage
FROM DBO.CovidDeaths 
WHERE location like '%states%' 
ORDER BY death_percentage DESC


-- Total cases vs Population
-- Percentage of population infected with covid in the US

SELECT location, date, total_cases, population, (total_cases/ population)*100 AS infected_pop
FROM DBO.CovidDeaths
WHERE location like '%states%' 
ORDER BY infected_pop DESC 


-- Comparing countries with highest infection rates with population
SELECT continent, location, MAX(total_cases) AS highest_infection_count, population, MAX((total_cases/ population))*100 AS infected_pop
FROM DBO.CovidDeaths
WHERE continent IS NOT NULL
GROUP BY population, location, continent
ORDER BY infected_pop DESC 

-- Countries with highest death count per population

SELECT continent, location, MAX(total_deaths) AS total_death_count
FROM DBO.CovidDeaths
WHERE continent IS NOT NULL
GROUP BY population, location, continent
ORDER BY total_death_count DESC


-- BREAK DOWN OF DEATH COUNT BY CONTINENT 

SELECT continent, MAX(total_deaths) AS total_death_count
FROM DBO.CovidDeaths
WHERE continent IS NOT NULL
GROUP BY continent
ORDER BY total_death_count DESC

-- GLOBAL NUMBERS 

/*SELECT SUM(new_cases) AS total_cases, SUM(new_deaths) AS total_deaths, total_deaths/total_cases*100 AS percentage_death
FROM dbo.CovidDeaths  
WHERE continent IS NOT NULL
ORDER BY 1,2*/


-- Total population vs Vaccination

SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
FROM CovidDeaths AS dea
JOIN CovidVaccinations AS vac
ON dea.location = vac.location
AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
ORDER BY 1, 2


SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(new_vaccinations) OVER (partition by dea.location, dea.date) AS people_vaccinated
FROM CovidDeaths AS dea
JOIN CovidVaccinations AS vac
ON dea.location = vac.location
AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
ORDER BY 1, 2

-- USING CTE

WITH pop_vs_vacc (continent, location, date, population,new_vaccinations, people_vaccinated) AS 
(
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(new_vaccinations) OVER (partition by dea.location, dea.date) AS people_vaccinated
FROM CovidDeaths AS dea
JOIN CovidVaccinations AS vac
ON dea.location = vac.location
AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
)

SELECT *, (people_vaccinated/population)* 100 AS percentage_vaxxed
FROM pop_vs_vacc
ORDER BY percentage_vaxxed


-- Creating view to store data for later visualizations 

CREATE VIEW pop_vs_vacc AS

SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(new_vaccinations) OVER (partition by dea.location, dea.date) AS people_vaccinated
FROM CovidDeaths AS dea
JOIN CovidVaccinations AS vac
ON dea.location = vac.location
AND dea.date = vac.date
WHERE dea.continent IS NOT NULL

-- USING THE VIEW FOR QUERIES
--COMPARING VACCINATION NUMBERS BY CONTINENT AND LOCATION
SELECT continent, location, AVG(new_vaccinations) AS avg_vaccination, AVG(people_vaccinated) AS avg_vaccinated
FROM pop_vs_vacc
GROUP BY continent, location
ORDER BY avg_vaccinated DESC