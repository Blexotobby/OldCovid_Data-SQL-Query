SELECT *
FROM PortfolioProjectt2..CovidDeaths

SELECT *
FROM PortfolioProjectt2..CovidVaccinations

-- SELECT THE NEEDED Columns
SELECT location, date,total_tests,total_cases,population
FROM PortfolioProjectt2..CovidDeaths
ORDER BY 1,2

-- DETERMINE DEATHPERCENTAGE
SELECT Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS DeathPrecentage
FROM PortfolioProjectt2..CovidDeaths
ORDER BY 1,2

--DETERMINE DEATHPRECENTAGE OF SPECFIC LOCATION
SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS DeathPrecentage
FROM PortfolioProjectt2..CovidDeaths
WHERE location='Nigeria'
ORDER BY 1,2


-- DETERMINE THE AFFECTEDPOPULATION PRECENTAGE
SELECT location,date,total_cases, population, (total_cases/population)*100 AS AFFECTED_POPULATION_PRECENTAGE
FROM PortfolioProjectt2..CovidDeaths
ORDER BY 1,2


-- DETERMINE THE AFFECTEDPOPULATION PRECENTAGE FOR SPECFIC LOCATION
SELECT location,date,total_cases, population, (total_cases/population)*100 AS AFFECTED_POPULATION_PRECENTAGE
FROM PortfolioProjectt2..CovidDeaths
WHERE location='Nigeria'
ORDER BY 1,2

-- DETERMINE COUNTRY WITH HIGHEST INFECTION RATE COMPARED WITH POPULATION
SELECT location,  population, MAX(total_cases) AS HighestInfectionCount, MAX(total_cases/population)*100 As PrecentPopulationInfected
FROM PortfolioProjectt2..CovidDeaths
GROUP BY location,population 
Order BY PrecentPopulationInfected DESC


-- -- Showing Countries with highest Death count per population
SELECT location,MAX(total_deaths) AS Highest_DEath_Counts
FROM PortfolioProjectt2..CovidDeaths
WHERE continent IS  NOT NULL
GROUP BY location
ORDER BY Highest_DEath_Counts DESC

-- -- Showing Contient with highest Death count per population
SELECT continent,MAX(total_deaths) AS Highest_DEath_Counts
FROM PortfolioProjectt2..CovidDeaths
WHERE continent IS  NOT NULL
GROUP BY continent
ORDER BY Highest_DEath_Counts DESC

--GLOBAL NUMBERS
Select  SUM(CAST(new_cases AS int)) As Total_cases, SUM(CAST(new_deaths AS int)) AS Total_Deaths,
(SUM(CAST(new_deaths As int ))/SUM(CAST(new_cases AS int)))*100 AS DeathPrecentage
FROM PortfolioProjectt2..CovidDeaths
WHERE continent IS NOT NULL

--- Toatal Population VS vaccination
SELECT dea.continent,dea.location,dea.date,dea.population,vac.total_vaccinations
FROM PortfolioProjectt2..CovidDeaths AS dea
JOIN PortfolioProjectt2..CovidVaccinations AS vac
	ON dea.continent=vac.continent
	AND dea.date=vac.date
	WHERE dea.continent IS NOT NULL
	ORDER BY 2,3

	--tottal population VS Vacination showing vacciantion progression 
	SELECT dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
	SUM(CAST(vac.new_vaccinations AS int)) OVER(PARTITION  BY dea.location ORDER BY dea.location, dea.date ) AS RollingVaccinations
FROM PortfolioProjectt2..CovidDeaths AS dea
JOIN PortfolioProjectt2..CovidVaccinations AS vac
	ON dea.continent=vac.continent
	AND dea.date=vac.date
	WHERE dea.continent IS NOT NULL
	ORDER BY 2,3


	--Creating TEmp Table
	DROP TABLE if EXISTs #PopulatedVaccinated
	Create TABLE #PopulatedVaccinated
	(
		continent nvarchar(255),
		location nvarchar (255),
		date datetime,
		population int,
		new_vaccination int,
		RollingVaccination int
	)

	
	INSert INTO #PopulatedVaccinated
	SELECT dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
	SUM(CAST(vac.new_vaccinations AS int)) OVER(PARTITION  BY dea.location ORDER BY dea.location, dea.date ) 
	AS RollingVaccinations
FROM PortfolioProjectt2..CovidDeaths AS dea
JOIN PortfolioProjectt2..CovidVaccinations AS vac
	ON dea.continent=vac.continent
	AND dea.date=vac.date
	WHERE dea.continent IS NOT NULL
	ORDER BY 2,3

	SELECT *, (RollingVaccination/population)*100 AS RollingVaccinationPrecentage
	FROM #PopulatedVaccinated

	--Cerate view for later visulation
	CREATE VIEW RollingVaccinationPrecentage
	AS
		SELECT dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
	SUM(CAST(vac.new_vaccinations AS int)) OVER(PARTITION  BY dea.location ORDER BY dea.location, dea.date ) 
	AS RollingVaccinations
FROM PortfolioProjectt2..CovidDeaths AS dea
JOIN PortfolioProjectt2..CovidVaccinations AS vac
	ON dea.continent=vac.continent
	AND dea.date=vac.date
	WHERE dea.continent IS NOT NULL

	SELECT *
	FROM RollingVaccinationPrecentage






