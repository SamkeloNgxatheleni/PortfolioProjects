Select *
From PortfolioProject ..CovidDeaths
Where continent is not null
Order By 3,4

--Select *
--From PortfolioProject ..CovidVaccination
--Order By 3,4

Select location, date, total_cases, new_cases, total_deaths, population
From PortfolioProject ..CovidDeaths
Where continent is not null
Order By 1,2

Select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From PortfolioProject ..CovidDeaths
Where location like '%south africa%'
and continent is not null
Order By 1,2

Select location, date, population, total_cases, (total_cases/population)*100 as PercentPopulationInfected
From PortfolioProject ..CovidDeaths
Where location like '%south africa%'
and continent is not null
Order By 1,2


Select location, population, MAX(total_cases) as HighestInfectionCount, MAX((total_cases/population))*100 as PercentPopulationInfected
From PortfolioProject ..CovidDeaths
--Where location like '%south africa%'
Group By Location, Population
Order By PercentPopulationInfected desc


Select location, MAX(cast(total_deaths as int)) as TotalDeathCount
From PortfolioProject ..CovidDeaths
--Where location like '%south africa%'
Where continent is not null
Group By Location
Order By TotalDeathCount desc


Select continent, MAX(cast(total_deaths as int)) as TotalDeathCount
From PortfolioProject ..CovidDeaths
--Where location like '%south africa%'
Where continent is not null
Group By continent
Order By TotalDeathCount desc


Select continent, MAX(cast(total_deaths as int)) as TotalDeathCount
From PortfolioProject ..CovidDeaths
--Where location like '%south africa%'
Where continent is not null
Group By continent
Order By TotalDeathCount desc


Select date, SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(new_cases)*100 AS DeathPercentage
From PortfolioProject ..CovidDeaths
--Where location like '%south africa%'
where continent is not null
Group By date
Order By 1,2

Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(new_cases)*100 AS DeathPercentage
From PortfolioProject ..CovidDeaths
--Where location like '%south africa%'
where continent is not null
--Group By date
Order By 1,2


Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(Cast(vac.new_vaccinations as int)) OVER (Partition by dea.location Order by dea.location, dea.date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProject ..CovidDeaths dea
Join PortfolioProject ..CovidVaccinations vac
   On dea.location = vac.location
   and dea.date = vac.date
 Where dea.continent is not null
Order By 2,3


With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(Cast(vac.new_vaccinations as int)) OVER (Partition by dea.location Order by dea.location, dea.date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProject ..CovidDeaths dea
Join PortfolioProject ..CovidVaccinations vac
   On dea.location = vac.location
   and dea.date = vac.date
 Where dea.continent is not null
--Order By 2,3
)
Select *, (RollingPeopleVaccinated/population)*100
From PopvsVac


Drop Table if exists #PercentagePopulationVaccinated
Create Table #PercentagePopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)

Insert into #PercentagePopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(Cast(vac.new_vaccinations as int)) OVER (Partition by dea.location Order by dea.location, dea.date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProject ..CovidDeaths dea
Join PortfolioProject ..CovidVaccinations vac
   On dea.location = vac.location
   and dea.date = vac.date
 --Where dea.continent is not null
--Order By 2,3

Select *, (RollingPeopleVaccinated/population)*100
From #PercentagePopulationVaccinated




Create View PercentagePopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(Cast(vac.new_vaccinations as int)) OVER (Partition by dea.location Order by dea.location, dea.date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProject ..CovidDeaths dea
Join PortfolioProject ..CovidVaccinations vac
   On dea.location = vac.location
   and dea.date = vac.date
 Where dea.continent is not null
--Order By 2,3


Select *
From PercentagePopulationVaccinated
