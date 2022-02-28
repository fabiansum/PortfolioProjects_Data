/*
Queries used for Tableau Project

*/

-- 1. Global Numbers
Create View NumbersInTotal as
Select SUM(new_cases) as total_cases, SUM((cast(new_deaths as bigint))) as total_deaths, SUM((cast(new_deaths as bigint)))/SUM(New_Cases)*100 as DeathPercentage
From PortfolioProject..CovidDeaths
where continent is not null
order by 1,2


-- 2. Total Death Count Per Continent
Create View TotalDeathCountbyLocation as
Select location, SUM((CAST(new_deaths as bigint))) as TotalDeathCount
From PortfolioProject..CovidDeaths
-- Where location like 'Australia'
Where continent is null
and location not like '%income%'
and location not in ('World', 'European Union', 'International')
Group by location
Order by TotalDeathCount desc

-- 3. Percent Population Infected per Country
-- base
Select location, population, MAX(total_cases) as HighestInfectionCount, MAX((Total_cases/population))*100 as PercentPopulationInfected
From PortfolioProject..CovidDeaths
where location not like '%income%'
and location not in ('World', 'European Union', 'International')
Group by location, population
order by PercentPopulationInfected desc

-- create view
create view PercentPopulationInfectedPCountry as
Select location, population, MAX(total_cases) as HighestInfectionCount, MAX((Total_cases/population))*100 as PercentPopulationInfected
From PortfolioProject..CovidDeaths
where location not like '%income%'
and location not in ('World', 'European Union', 'International')
Group by location, population

-- create view, No NULL version
Create view PercentPopulationInfectedPCountry0 as
Select location,  ISNULL(population, '0') as Population0, ISNULL(HighestInfectionCount, '0') as HighestInfectionCount0, ISNULL(PercentPopulationInfected, '0') as PercentPopulationInfected0
From PortfolioProject..PercentPopulationInfected
order by PercentPopulationInfected0 desc

-- 4. Percent Population Infected Per Country by date
-- base
Select location, population, date, MAX(total_cases) as HighestInfectionCount, MAX((Total_cases/population))*100 as PercentPopulationInfected
From PortfolioProject..CovidDeaths
where location not like '%income%'
and location not in ('World', 'European Union', 'International')
Group by location, population, date
order by PercentPopulationInfected desc

-- create view
Create view PercentPopulationInfected as
Select location, population, date, MAX(total_cases) as HighestInfectionCount, MAX((Total_cases/population))*100 as PercentPopulationInfected
From PortfolioProject..CovidDeaths
where location not like '%income%'
and location not in ('World', 'European Union', 'International')
Group by location, population, date

-- create view, No NULL version
Create view PercentPopulationInfected0 as
Select location, population, date, ISNULL(HighestInfectionCount, '0') as HighestInfectionCount0, ISNULL(PercentPopulationInfected, '0') as PercentPopulationInfected0
From PortfolioProject..PercentPopulationInfected
order by PercentPopulationInfected0 desc




-------


Select dea.continent, dea.location, dea.date, dea.population, MAX(vac.total_vaccinations) as RollingPeopleVaccinated
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
group by dea.continent, dea.location, dea.date, dea.population
order by 1,2,3


-- 5.
Select location, date, population, total_cases, total_deaths
From PortfolioProject..CovidDeaths
where continent is not null
order by 1,2


-- 6.
Create view PercentPeopleVaccinated as
With PopvsVac (continent, location, date, population, New_Vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population,vac.new_vaccinations, 
SUM((Convert(bigint, vac.new_vaccinations))) OVER (Partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
)
Select *, (RollingPeopleVaccinated/Population)*100 as PercentPeopleVaccinated
From PopvsVac
