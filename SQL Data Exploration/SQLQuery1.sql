Select *
From PortfolioProject..CovidDeaths
where continent is not null
order by 3,4

--Select *
--From PortfolioProject..CovidVaccinations
--order by 3,4

-- Select Data that we are going to be using

Select Location, date, total_cases, new_cases, total_deaths, population
From PortfolioProject..CovidDeaths
where continent is not null
order by 1,2

-- looking at total cases vs total deaths
-- shows likelihood of dying if you contract covid in your country
Select Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From PortfolioProject..CovidDeaths
Where location like '%Indonesia%'
and continent is not null
order by 1,2

-- looking at Total Cases vs Population
-- shows what percentage of population got covid

Select Location, date, population, total_cases, (total_cases/population)*100 as PopulationInfectedPercentage
From PortfolioProject..CovidDeaths
-- Where location like '%Indonesia%'
order by 1,2

-- Looking at countries with Highest Infection Rate compared to population
Select location, population, MAX(total_cases) as HighestInfectionCount, MAX((total_cases/population))*100 as PopulationInfectedPercentage
From PortfolioProject..CovidDeaths
Group by location, population
order by PopulationInfectedPercentage desc

-- showing Countries with the highest death count per population
Select location, MAX((cast(total_deaths as int))) AS TotalDeathCount
From PortfolioProject..CovidDeaths
where continent is not null
Group by location
order by TotalDeathCount desc

-- showing location with the highest death count per population
Select location, MAX((cast(total_deaths as int))) AS TotalDeathCount
From PortfolioProject..CovidDeaths
where continent is null
and location not like '%income%'
Group by location
order by TotalDeathCount desc

-- LETS's BREAK THINGS DOWN BY CONTINENT

-- showing continent with highest deat count per population

Select continent, MAX((cast(total_deaths as int))) AS TotalDeathCount
From PortfolioProject..CovidDeaths
where continent is not null
Group by continent
order by TotalDeathCount desc

-- Looking at conntinent with Highest Infection Rate compared to population
Select continent, MAX(total_cases) as HighestInfectionCount, MAX((total_cases/population))*100 as PopulationInfectedPercentage
From PortfolioProject..CovidDeaths
where continent is not null
Group by continent
order by PopulationInfectedPercentage desc

-- showing continent with the highest death count per population
Select continent, MAX((cast(total_deaths as int))) AS TotalDeathCount
From PortfolioProject..CovidDeaths
where continent is not null
Group by continent
order by TotalDeathCount desc


-- GLOBAL NUMBERS

Select date, sum(new_cases) as SumNewCases, SUM((CAST(new_deaths as int))) as SumNewDeath, SUM((CAST(new_deaths as int)))/sum(new_cases) * 100 as DeathPercentage
From PortfolioProject..CovidDeaths
where continent is not null
group by date
order by 1,2

Select *
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date

-- Looking at Total Population vs Vaccinations
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
SUM((CAST(vac.new_vaccinations as bigint))) OVER (Partition by dea.location Order by dea.location, dea.Date) as RollingPeopleVaccinated
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
order by 2,3

-- USE CTE

With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVacinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(bigint, vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location, dea.Date) as RollingPeopleVaccinated
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 2,3
)
Select *, (RollingPeopleVacinated/Population)*100
From PopvsVac

-- TEMP TABLE

DROP Table if exists #PopulationVaccinatedPercentage
Create Table #PopulationVaccinatedPercentage
(
Continent nvarchar(255),
location nvarchar(255),
date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)

Insert into #PopulationVaccinatedPercentage
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(bigint, vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location, dea.Date) as RollingPeopleVaccinated
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
--where dea.continent is not null

Select *, (RollingPeopleVaccinated/Population)*100
From #PopulationVaccinatedPercentage


--CREATING VIEW

Create View PopulationVaccinatedPercentage as 
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(bigint, vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location, dea.Date) as RollingPeopleVaccinated
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null

Select *
From PopulationVaccinatedPercentage



