Select *
From CovidDeaths
order by 3,4

Select Location, date, total_cases, new_cases, total_deaths, population
From CovidDeaths
order by 1,2

-- How many people who've gotten COVID died?

Select Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From CovidDeaths
order by 1,2

-- Observation: In March 28th, 2020, we see that roughly 3.7% of the infected in Afghanistan died.
-- Shows chance of dying if someone gets COVID in their country.

Select Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From CovidDeaths
Where Location like '%states%'
order by 1,2

-- How much of the US population is infected?

Select Location, date, total_cases, population, (total_cases/population)*100 as InfectionRate
From CovidDeaths
Where Location like '%states%'
order by 1,2

-- What countries have the highest infection rates?

Select Location, MAX(total_cases) as max_cases, population, max((total_cases/population)*100) as MaxInfectionRate
From CovidDeaths
Group by Location, population
order by 4 desc

-- Observation: Andorra, Montenegro, and Czechia have the highest infection rates.

-- What countries have the highest death counts?

Select Location, max(total_deaths) as TotalDeathCount
From CovidDeaths
Where continent is not null
Group by Location
order by TotalDeathCount desc

-- Observation: The US, Brazil, and Mexico have the highest death counts.

-- Which continents have the highest death counts?

Select location, max(total_deaths) as TotalDeathCount
From CovidDeaths
Where continent is null
Group by location
order by TotalDeathCount desc

-- When was this data taken?

Select max(date) as EndDate, min(date) StartDate
From CovidDeaths

-- Data from 01/01/2020 to 04/30/2021

-- Global numbers

Select date, sum(new_cases) as cases, sum(new_deaths) as deaths, sum(new_deaths)/sum(new_cases)*100 as DeathPercentage
From CovidDeaths
Where continent is not null
Group by date
order by 1,2

Select sum(new_cases) as cases, sum(new_deaths) as deaths, sum(new_deaths)/sum(new_cases)*100 as DeathPercentage
From CovidDeaths
Where continent is not null
order by 1,2

-- Joining tables

-- How much of a country's population is vaccinated?

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(new_vaccinations) over (Partition by dea.Location order by dea.location,
dea.date) as RollingPeopleVaccinated
From CovidDeaths dea
Join CovidVaccinations vac
    On dea.location = vac.location
    and dea.date = vac.date
where dea.continent is not null
order by 2,3

-- CTE

With PopVac (Continent, Location, Date, Population, New_Vacccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(new_vaccinations) over (Partition by dea.Location order by dea.location,
dea.date) as RollingPeopleVaccinated
From CovidDeaths dea
Join CovidVaccinations vac
    On dea.location = vac.location
    and dea.date = vac.date
where dea.continent is not null
)
Select *, (RollingPeopleVaccinated/Population)*100 PercentVacc
From PopVac
Where location like '%states%'

-- Observation: From January 15-19, 2021, roughly 1.65% of the US population was vaccinated.

-- Temp Table

Drop table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population NUMERIC,
New_vaccinations NUMERIC,
RollingPeopleVaccinated NUMERIC
)

Insert into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(new_vaccinations) over (Partition by dea.Location order by dea.location,
dea.date) as RollingPeopleVaccinated
From CovidDeaths dea
Join CovidVaccinations vac
    On dea.location = vac.location
    and dea.date = vac.date
where dea.continent is not null

Select *, (RollingPeopleVaccinated/Population)*100 PercentVacc
From #PercentPopulationVaccinated

-- View

Create VIEW PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(new_vaccinations) over (Partition by dea.Location order by dea.location,
dea.date) as RollingPeopleVaccinated
From CovidDeaths dea
Join CovidVaccinations vac
    On dea.location = vac.location
    and dea.date = vac.date
where dea.continent is not null

Select *
From PercentPopulationVaccinated