----select *
--from PortfolioProject..CovidVaccinations
--order by 3,4
--select *
--from PortfolioProject..CovidDeaths
--order by 3,4
 
 --Select data which we are going to be using-

 select Location, date, total_cases, new_cases, total_deaths, population
 from PortfolioProject..CovidDeaths 
 order by 1,2

 
 --Looking as Total cases vs Total deaths

 Select location,date,total_cases,total_deaths, (total_deaths/total_cases) 
 from PortfolioProject..CovidDeaths
 order by 1,2

 --To get percentage

 Select location,date,total_cases,total_deaths, (total_deaths/total_cases)*100 
 from PortfolioProject..CovidDeaths
 order by 1,2

 --Looking at Total cases vs Population of a particular location
 
 Select location,date,total_cases,total_deaths, (total_deaths/total_cases)*100 
 from PortfolioProject..CovidDeaths
 where location like '%states%'
 order by 1,2

 --Looking at countries with Highest Infection rate compared to  Population

     Select Location, population,max(total_cases) as HighestInfectionCount,max((total_cases/population))*100 as PercentPopulationInfected
     from PortfolioProject..CovidDeaths 
     --where Location like'%india%'
     Group by location, Population
     order by PercentPopulationInfected desc

 --Showing countries with Highest death count per population

      Select location,max(cast(Total_deaths as int)) as TotalDeathCount
	 from PortfolioProject..CovidDeaths
	 where continent is not null
	 group by location
	 order by TotalDeathCount desc

--Let's break things down by continent

	 Select continent,max(cast(Total_deaths as int)) as TotalDeathCount
	 from PortfolioProject..CovidDeaths
	 where continent is not null
	 group by continent
	 order by TotalDeathCount desc

	  Select location,max(cast(Total_deaths as int)) as TotalDeathCount
	 from PortfolioProject..CovidDeaths
	 where continent is not null
	 group by location
	 order by TotalDeathCount desc

 -- Global numbers

	  select sum(new_cases) as total_cases , sum(cast(new_deaths as int)) as total_deaths, 
	  sum(cast(new_deaths as int))/sum(new_cases)*100 as DeathPercentage
	  from PortfolioProject..CovidDeaths
	  where continent is not null
	 -- group by date 
	  order by 1,2
	  
--Looking at Total population vs vaccination

with PopvsVac (Continent,location, date, population,new_vaccinations,RollingPeopleVaccinated)
as
(
	 select dea.continent,dea.location,  dea.date,dea.population, vac.new_vaccinations,sum(convert(int,new_vaccinations)) over (Partition by dea.location
	 order by dea.location, dea.date) as RollingPeopleVaccinated --(RollingPeopleVaccinated/ Population)*100
	 from PortfolioProject..CovidDeaths dea
	 join PortfolioProject..CovidVaccinations vac
	 on dea.location=vac.location
	 and dea.date=vac.date
	 where dea.continent is not null 
	-- order by 2,3
	)
	select *,(RollingPeopleVaccinated/Population)*100 as Percentage
	from popvsvac

--Temp Table

	drop table if exists #PercentPopulationVaccinated
	create table #PercentPopulationVaccinated
	(
	Continent nvarchar(255),
	Location nvarchar(255),
	date datetime,
	Population numeric,
	new_vaccinations numeric,
	RollingPeopleVaccinated numeric
	)

	insert into #PercentPopulationVaccinated
	select dea.continent,dea.location,dea.date,dea.population, vac.new_vaccinations, sum(convert(int, new_vaccinations))over (partition by dea.location
	order by dea.location,dea.date) as RollingPeopleVaccinated
	from PortfolioProject..CovidDeaths dea
	join PortfolioProject..CovidVaccinations vac
	on dea.location=vac.location
	and dea.date=vac.date
	--where dea.continent is not null


	select  *,(RollingPeopleVaccinated/population)*100
	from #PercentPopulationVaccinated


-- Creating views to store data for later visualization
	Create View PercentPopulationVaccinated as
	select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,sum(convert(int,new_vaccinations))over (partition by dea.location 
	order by dea.location,dea.date) as RollingPeopleVaccinated
	from PortfolioProject..CovidDeaths dea
	join PortfolioProject..CovidVaccinations vac
	on dea.location=vac.location
	and dea.date=vac.date 
	where dea.continent is not null

	select *
	from PercentPopulationVaccinated

--2nd view
	create view TotalDeathCount as
	Select continent,max(cast(Total_deaths as int)) as TotalDeathCount
	 from PortfolioProject..CovidDeaths
	 where continent is not null
	 group by continent
	 order by TotalDeathCount descc