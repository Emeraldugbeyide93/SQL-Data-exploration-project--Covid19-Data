-- Viewing the datasets 

SELECT * 
FROM PortfolioProject..Coviddeaths
ORDER BY 3,4;

SELECT * 
FROM Portfolioproject..Covidvaccinations
ORDER BY 3,4;

-- Select data to be used for analysis

SELECT location, date, total_cases, new_cases, total_deaths, population 
FROM PortfolioProject.dbo.Coviddeaths
ORDER BY 1,2;

-- Viewing Total Cases Vs Total Deaths
-- Shows likelihood of death if covid is contracted in the analyzed countries

SELECT location, date, total_cases, new_cases, total_deaths, (Total_deaths/total_cases)*100 AS "DeathPercentage"
FROM PortfolioProject.dbo.Coviddeaths
ORDER BY 1,2;

-- Exploring specific countries and continents
-- The DeathPercentage shows the likelihood of death if covid is contracted in these countries/continents
SELECT location, date, total_cases, new_cases, total_deaths, (Total_deaths/total_cases)*100 AS "DeathPercentage"
FROM PortfolioProject.dbo.Coviddeaths
WHERE location LIKE '%states%'
ORDER BY 1,2;

SELECT location, date, total_cases, new_cases, total_deaths, (Total_deaths/total_cases)*100 AS "DeathPercentage"
FROM PortfolioProject.dbo.Coviddeaths
WHERE location LIKE '%Africa%'
ORDER BY 1,2;

SELECT location, date, total_cases, new_cases, total_deaths, (Total_deaths/total_cases)*100 AS "DeathPercentage"
FROM PortfolioProject.dbo.Coviddeaths
WHERE location LIKE '%Nigeria%'
ORDER BY 1,2;


-- Total Cases Vs Population
-- Shows what percentage of the population contracted covid

SELECT location, date, total_cases, population, (Total_cases/population)*100 AS "InfectedPopulationPercentage"
FROM PortfolioProject.dbo.Coviddeaths
WHERE location LIKE '%Nigeria%'
ORDER BY 1,2;

-- Indicates countries with the highest infection rates in comparison with the population

SELECT location, population, MAX(total_cases) AS HighestInfectionCount, MAX((Total_cases/population))*100 
AS "InfectedPopulationPercentage"
FROM PortfolioProject..Coviddeaths
WHERE location LIKE '%Nigeria%'
GROUP BY location, population
ORDER BY InfectedPopulationPercentage desc;

SELECT location, population, MAX(total_cases) AS HighestInfectionCount, MAX((Total_cases/population))*100 
AS InfectedPopulationPercentage
FROM PortfolioProject..Coviddeaths
GROUP BY location, population
ORDER BY InfectedPopulationPercentage desc;

-- Showing Countries with Highest Death Count per Population

Select location, MAX(cast(Total_deaths as int)) as TotalDeathCount
From PortfolioProject..CovidDeaths
Where continent is not null 
Group by Location
order by TotalDeathCount desc

-- Breaking things down by continent

-- Continents with the highest death count

Select continent, MAX(cast(Total_deaths as int)) as TotalDeathCount
From PortfolioProject..CovidDeaths
Where continent is not null 
Group by continent
order by TotalDeathCount desc

-- WORKING WITH GLOBAL NUMBERS/COUNTS/FIGURES

Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths,
SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
From PortfolioProject..CovidDeaths
where continent is not null 
order by 1,2

-- This shows the death percentage to be 1.05% of the total_cases worldwide

-- Total Population vs Vaccinations

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
order by 2,3

-- Taking a closer look into Africa as a continent

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null and dea.continent like '%Africa%'
order by 2,3



Select dea.continent,dea.new_cases,dea.location,dea.date, dea.population, vac.new_vaccinations
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null and dea.location like '%Nigeria%'
order by 3,4

Select dea.continent,dea.new_cases,dea.location,dea.date, dea.population, vac.new_vaccinations
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null and dea.location like '%Kingdom%'
order by 3,4

-- Shows Percentage of Population that has recieved at least one Covid Vaccine

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(bigint,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
order by 2,3

-- Using CTE to perform Calculation on Partition By 

With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(bigint,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
)
Select *, (RollingPeopleVaccinated/Population)*100
From PopvsVac

With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(bigint,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null and dea.continent like '%Africa%'
)
Select *, (RollingPeopleVaccinated/Population)*100
From PopvsVac

With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(bigint,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null and dea.location like '%Nigeria%'
)
Select *, (RollingPeopleVaccinated/Population)*100
From PopvsVac

With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(bigint,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null and dea.location like '%Kingdom%'
)
Select *, (RollingPeopleVaccinated/Population)*100
From PopvsVac

-- USING TEMP TABLE INSTEAD OF CTE 

DROP Table if exists #PopulationVaccinatedPercentage
Create Table #PopulationVaccinatedPercentage
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population bigint,
New_vaccinations bigint,
RollingPeopleVaccinated bigint,
)

Insert into #PopulationVaccinatedPercentage
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(bigint,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date

Select *, (RollingPeopleVaccinated/Population)*100
From #PopulationVaccinatedPercentage


-- Creating View to store data for visualizations


DROP View  if exists PopulationVaccinatedPercentage
Create View PopulationVaccinatedPercentage as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(bigint,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date

SELECT * FROM PopulationVaccinatedPercentage


DROP VIEW PercentagevacUK
CREATE VIEW PercentagevacUK as
Select dea.continent,dea.new_cases,dea.location,dea.date, dea.population, vac.new_vaccinations
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null and dea.location like '%Kingdom%'
--order by 3,4


DROP VIEW PercentvacNig
CREATE VIEW PercentvacNig as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(bigint,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null and dea.location like '%Nigeria%'
	
SELECT * FROM PercentvacNig