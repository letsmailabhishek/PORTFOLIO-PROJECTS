--1
create view GlobalNumbers as 
select  sum(new_cases) as total_cases, sum(cast(new_deaths as int)) as total_deaths,  
sum(cast(new_deaths as int))/sum(new_cases)*100 as DeathPercentage
from CovidDeaths
 where continent is not null
 --group by date
--order by 1,2;

--2

create view Country_wise_Deaths as
select location, sum(cast(new_deaths as int)) as TotalDeathCount
from CovidDeaths
where continent is not null
and location not in ('World','European Union', 'International')
group by location
--order by TotalDeathCount desc;

--3

create view PercentPopulationInfected as
select location, population, max(total_cases) as HighestInfectionCount, max((total_cases/population))*100 as PercentPopulationInfected
from CovidDeaths
group by location, population
--order by PercentPopulationInfected desc;

--4

create view PercentPopulationInfected_daywise as
select location, population, date, max(total_cases) as HighestInfectionCount, max((total_cases/population))*100 as PercentPopulationInfected
from CovidDeaths
group by location, population, date
--order by PercentPopulationInfected desc;












select * from 
coviddeaths
where continent is not null
order by 3,4

--select * from 
--CovidVaccinations
--order by 3,4

select location,date,total_cases, new_cases,total_deaths, new_deaths, population
from CovidDeaths
where continent is not null
order by 1,2

--looking at total cases v/s total deaths
--shows likelihood of dying if you contract covid in your coutry

select location,date,total_cases,total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
from CovidDeaths
where location like '%india%' and continent is not null
order by 1,2

--Looking at total cases vs population
--shows what percentage of popuation got covid

select location,date,population, total_cases,total_deaths, (total_cases/population)*100 as InfectionPercentage
from CovidDeaths
where location like '%india%' and  continent is not null
order by 1,2

--looking at countries with highest infection rate compared to population

select location, population, max(total_cases) as HighestInfectionCount,  max((total_cases/population))*100 as InfectionPercentage
from CovidDeaths
where continent is not null
group by location, population
order by  InfectionPercentage desc


--looking for countries showing highest  death counts per population.

select location,  max(cast(total_deaths as int)) as TotalDeathCount
from CovidDeaths
where continent is not null
group by location 
order by  TotalDeathCount desc

--Lets break things by Continent


select continent,  max(cast(total_deaths as int)) as TotalDeathCount
from CovidDeaths
where continent is not null
group by continent 
order by  TotalDeathCount desc


select continent,  max(cast(total_deaths as int)) as TotalDeathCount
from CovidDeaths
where continent is not null
group by continent
order by  TotalDeathCount desc

--Global Numbers

select date, sum(new_cases) as total_cases, sum(cast(new_deaths as int)) as total_deaths,  sum(cast(new_deaths as int))/sum(new_cases)*100 as DeathPercentage
from CovidDeaths
 where continent is not null
 group by date
order by 1,2


--World Numbers


select  sum(new_cases) as total_cases, sum(cast(new_deaths as int)) as total_deaths,  sum(cast(new_deaths as int))/sum(new_cases)*100 as DeathPercentage
from CovidDeaths
 where continent is not null
order by 1,2


SELECT * from covidvaccinations;


--Looking at total Population vs  Vaccination

With PopvsVac (Continent, location, date, population, new_vaccinations, RollingPeopleVaccinated)
as
(
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations ,
sum(convert(bigint, vac.new_vaccinations )) over (partition by dea.location order by dea.location, dea.date) 
as RollingPeopleVaccinated
--,(RollingPeopleVaccinated/population)*100
from portfolioProject..coviddeaths as dea
join portfolioProject..CovidVaccinations as vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
--order by 2,3
)
select *, (RollingPeopleVaccinated/population)*100 as PercentagePeopleVaccinated
from PopvsVac


--Temp Table

drop table if exists #PercentagePopulationVaccinated

create table #PercentagePopulationVaccinated
(continent nvarchar (255),
location nvarchar (255),
Date datetime,
Population numeric,
new_vaccinated numeric,
RollingPeopleVaccinated numeric)

insert into #PercentagePopulationVaccinated

select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations ,
sum(convert(bigint, vac.new_vaccinations )) over (partition by dea.location order by dea.location, dea.date) 
as RollingPeopleVaccinated
--,(RollingPeopleVaccinated/population)*100
from portfolioProject..coviddeaths as dea
join portfolioProject..CovidVaccinations as vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
--order by 2,3

select *, (RollingPeopleVaccinated/population)*100 as percentage_of_population_vaccinated
from #PercentagePopulationVaccinated

--Creating view
create view PercentPopulationVaccinated as
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations ,
sum(convert(bigint, vac.new_vaccinations )) over (partition by dea.location order by dea.location, dea.date) 
as RollingPeopleVaccinated
--,(RollingPeopleVaccinated/population)*100
from portfolioProject..coviddeaths as dea
join portfolioProject..CovidVaccinations as vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
--order by 2,3

select * from PercentPopulationVaccinated;