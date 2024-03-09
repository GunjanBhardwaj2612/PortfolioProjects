--select * from PortfolioProject.dbo.coviddeath
--select * from PortfolioProject.dbo.covidvaccine

--Selecting main columnns we want to look into
select Location, population, date, Total_cases, new_cases, total_deaths , new_deaths from PortfolioProject.dbo.coviddeath
Order by 1,3;

--Looking at total deaths vs Total cases 
Select Location, SUM(new_cases) as total_cases_percounty , Sum(new_deaths) as total_deaths_percountry
from PortfolioProject.dbo.coviddeath
Group by Location
Order by Location;

-- Looking at total death vs population and total cases vs population

Select Location, Population, Total_deaths, Total_cases, (Total_deaths/Population)*100 as Deathvspopulation , (Total_cases/Population)*100 as Casesvspopulation 
from PortfolioProject.dbo.coviddeath
Order by Location, Date

--  Which Countries will have the maximum infection cases
Select Location, SUM(new_cases) as total_cases_percounty  , Sum(new_deaths) as total_deaths_percountry
from PortfolioProject.dbo.coviddeath
Group by Location
Order by total_cases_percounty desc;

-- Which Countries will have the maximum infection rate compared to population

Select Location, MAX(CAST(Total_cases AS INT)) AS Max_infection_count, Max((CAST(Total_cases AS INT )/population))*100 as total_Cases_percountry_perpopulation
from PortfolioProject.dbo.coviddeath
WHERE Continent is not null
Group by Location , population
Order by total_Cases_percountry_perpopulation desc;

-- Which Countries will have the maximum death count

Select Location, MAX(CAST(Total_deaths AS INT)) AS Max_deaths_count
from PortfolioProject.dbo.coviddeath
WHERE Continent is not null
Group by Location , population
Order by Max_deaths_count desc;


--Total death count by continent
Select Continent, MAX(CAST(Total_deaths AS INT)) AS Max_deaths_count
from PortfolioProject.dbo.coviddeath
WHERE Continent is not null
Group by Continent
Order by Max_deaths_count desc;


--Select location, MAX(CAST(Total_deaths AS INT)) AS Max_deaths_count
--from PortfolioProject.dbo.coviddeath
--WHERE Continent is null
--Group by location
--Order by Max_deaths_count desc;

-- Global numbers

Update PortfolioProject.dbo.coviddeath set NEW_CASES = null where NEW_CASES = 0
Update PortfolioProject.dbo.coviddeath set NEW_deaths = null where NEW_deaths = 0



Select date, Sum(new_cases) as total_cases_ondate, Sum(new_deaths) as total_death_ondate , Sum(new_deaths)/Sum(new_cases) * 100 As Global_death_percentageage
From PortfolioProject.dbo.coviddeath
where Continent is not null
Group by date 
Order by date ASC;



-- Total Vaccination vs population

Select Location, date, population, total_vaccinations, (total_vaccinations/population) *100 as percent_vaccinated  
from PortfolioProject.dbo.covidVaccine
Where continent is not null
order by location,date


-- Rolling total of vaccination by date and location

Select Location, date, population, NEW_VACCINATIONS, SUM(CONVERT(BIGINT, new_vaccinations)) over (partition by location ORDER BY LOCATION, DATE) as rolling_vaccination_count
from PortfolioProject.dbo.covidVaccine
Where continent is not null
order by location,date


--Total people vaccinated/ population/Date


--DROP Table if exists PortfolioProject.dbo.#temp_VacVsPopVsDate
IF OBJECT_ID('TempDB.dbo.#temp_VacVsPopVsDate') IS NOT NULL 
 DROP TABLE #temp_VacVsPopVsdate
GO
CREATE TABLE #temp_VacVsPopVsdate
(
Location nvarchar(255), 
population numeric,
new_vaccinations numeric,
date datetime, 
rolling_vaccination_count numeric
)

Insert Into #temp_VacVsPopVsDate
Select Location, population, new_vaccinations, date,SUM(CONVERT(BIGINT, new_vaccinations)) over (partition by location ORDER BY LOCATION, DATE) as rolling_vaccination_count
from PortfolioProject.dbo.covidVaccine Vac
Where continent is not null

Select * , rolling_vaccination_count/population as Vaccinated_Pop_date
 From #temp_VacVsPopVsDate



--Total people vaccinated/ population/county

WITH 
Vaccinated_per_population (Location, date, rolling_vaccination_count , new_vaccinations , population)
AS
(Select Location, population, new_vaccinations, date,SUM(CONVERT(BIGINT, new_vaccinations)) over (partition by location ORDER BY LOCATION, DATE) as rolling_vaccination_count
from PortfolioProject.dbo.covidVaccine Vac
Where continent is not null
)
Select VAC.Location, VAC.Population, (max(rolling_vaccination_count)/VAC.population) As Vaccinated_vs_total 
From PortfolioProject.dbo.covidVaccine as VAC
Join Vaccinated_per_population AS VPP
On VAC.location = VPP.location 
Where continent is not null
Group by VAC.location, VAC.POPULATION
order by VAC.location
	


-- Creating Views for visulaizations 
Create View percentage_vaccinated
As
Select Location, date, population, total_vaccinations, (total_vaccinations/population) *100 as percent_vaccinated  
from PortfolioProject.dbo.covidVaccine
Where continent is not null
