select *
from CovidDeaths
where continent is not null
order by 3,4


--select *
--from CovidVaccinations
--order by 3,4


--Select Data that we are going to be using

select Location,date,total_cases,new_cases,total_deaths,population
from CovidDeaths 
where continent is not null
order by 1,2

--Looking at Total cases vs total deaths in the USA
--This shows the likelihood of dying if you contract COVID in USA (you can change states for any country)

select Location,date,total_cases,total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
from CovidDeaths 
where location like '%reece%'
order by 1,2


--Looking at Total cases vs Population 
-- This shows what percentage of population got COVID

select Location,date,total_cases,population, (total_cases/population)*100 as TotalCasesPercentage
from CovidDeaths 
where location like '%reece%'
order by 1,2

--Looking at countries with highest infection rate compared to popuation

select Location,population,max(total_cases) as HighestInfectionCount, max((total_cases/population)*100) as
PercentPopulationInfected
from CovidDeaths 
where continent is not null
group by location,Population
order by PercentPopulationInfected desc


--Showing countries with Highest Death Count per Population

select Location,max(cast(total_deaths as bigint)) as HighestDeathCount
from CovidDeaths 
where continent is not null
group by location
order by HighestDeathCount desc

--Lets break things down by continent
--Showing the continents with the highest death count




--select continent,max(cast(total_deaths as bigint)) as HighestDeathCount
--from CovidDeaths 
--where continent is not null
--group by continent
--order by HighestDeathCount desc


select location,max(cast(total_deaths as bigint)) as HighestDeathCount
from CovidDeaths 
where continent is null
group by location
order by HighestDeathCount desc


--GLOBAL NUMBERS


--Calculating the percentage of deaths per day globally
select date,sum(new_cases) as TotalCases,sum(cast(new_deaths as bigint)) as totalDeaths,sum(cast(new_deaths as bigint))/sum(new_cases)*100 as DeathPercentage
from CovidDeaths 
where continent is not null 
group by date
order by 1,2
--while the total percentage across the timeline is
select sum(new_cases) as TotalCases,sum(cast(new_deaths as bigint)) as totalDeaths,sum(cast(new_deaths as bigint))/sum(new_cases)*100 as DeathPercentage
from CovidDeaths 
where continent is not null 
order by 1,2

--Moving on to the Vaccination Table
select *
from CovidVaccinations

--Joining the 2 tables
select *
from CovidDeaths dea
join CovidVaccinations vac
on dea.location=vac.location 
and dea.date=vac.date

--Looking at total population vs vaccination

select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations
,sum(cast(vac.new_vaccinations as bigint)) over (partition by dea.location order by dea.location,
dea.date) as RollingPeopleVaccinated
from CovidDeaths dea
join CovidVaccinations vac
on dea.location=vac.location 
and dea.date=vac.date
where dea.continent is not null
order by 2,3

--USE CTE
with PopvsVac (Continent,location,date,population,new_vaccinations,RollingPeopleVaccinated) 
as
(
select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations
,sum(cast(vac.new_vaccinations as bigint)) over (partition by dea.location order by dea.location,
dea.date) as RollingPeopleVaccinated
from CovidDeaths dea
join CovidVaccinations vac
on dea.location=vac.location 
and dea.date=vac.date
where dea.continent is not null
)
select *, (RollingPeopleVaccinated/population)*100
from PopvsVac


--Or we can do it with a temp table
--drop table if exists #PercentPopulationVaccinated
--Create table #PercentPopulationVaccinated
--(
--Continent nvarchar(255),
--Location nvarchar(255),
--Date datetime,
--Population numeric,
--New_vaccinations numeric,
--RollingPeopleVaccinated numeric
--)
--Insert into #PercentPopulationVaccinated

--select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations
--,sum(cast(vac.new_vaccinations as bigint)) over (partition by dea.location order by dea.location,
--dea.date) as RollingPeopleVaccinated
--from CovidDeaths dea
--join CovidVaccinations vac
--on dea.location=vac.location 
--and dea.date=vac.date
--where dea.continent is not null


--creating View to store data fro later visualizations

create view PercentPopulationVaccinated as
select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations
,sum(cast(vac.new_vaccinations as bigint)) over (partition by dea.location order by dea.location,
dea.date) as RollingPeopleVaccinated
from CovidDeaths dea
join CovidVaccinations vac
on dea.location=vac.location 
and dea.date=vac.date
where dea.continent is not null
--order by 2,3

select *
from PercentPopulationVaccinated






































