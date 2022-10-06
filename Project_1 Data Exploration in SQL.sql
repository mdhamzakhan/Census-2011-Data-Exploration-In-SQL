-- Overviewing Data
Select * from table1
select *  from table2

---Number of rows in our dataset
select count(literacy) from table1 --640
select count(population) from table2 --640
 
-- population of India
select sum(population) from table2 --1210854977

-- average growth in population
select AVG(growth)*100 from table1 --0.1924 or 19.24%

-- average growth % by states
select state, avg(growth)*100 as avg_growth_by_states from table1 group by state

-- average sex ratio by states
select state, round((avg(sex_ratio)),0) as avg_sexratio_by_states from table1 group by state

--- top 3 states by literacy 
select top 3 state from table1 order by literacy desc

-- states starting with vowels
select state from table1 where LOWER(state) like 'a%' or LOWER(state) like 'e%'or LOWER(state) like 'i%' or LOWER(state) like 'u%' or LOWER(state) like 'o%'group by state

--joining table
select * from table1 t1 join table2 t2 on t1.District= t2.District
select t1.*, t2.Area_km2,t2.Population
from table1 t1 join table2 t2 on t1.District= t2.District

--number of males and females
with cte as  (
	select t1.District,t1.State ,t2.Population, round(((t2.Population*Sex_Ratio)/2000),0) as females
	from table1 t1 join table2 t2 on t1.District= t2.District) 
select state, District,females, cte.population-females malex from cte

-- state wise literate people
select t1.state, sum(round(t2.Population*t1.Literacy,0)) literate_people
from table1 t1 join table2 t2 on t1.District= t2.District
group by t1.state

-- population in previous Census state wise
select sum(t.previous_population) prv_pop, SUM(t.cr_pop) cr_pop  from 
(select t2.State, sum(round(t2.Population/(1+t1.growth),0)) previous_population, sum(t2.population) as cr_pop
from table1 t1 join table2 t2 on t1.District= t2.District
group by t2.State) t

-- poulation density state and total average

select state, district, Population/Area_km2 as population_density
from  table2 t2 

select state, avg(Population/Area_km2)
from  table2 t2 
group by state

-- previous census area density, district , state and total average
select (t2.Population/(1+t1.Growth))/t2.Area_km2
from table1 t1 join table2 t2 on t1.District= t2.District

select t2.State, avg((t2.Population/(1+t1.Growth))/t2.Area_km2)
from table1 t1 join table2 t2 on t1.District= t2.District
group by t2.State

-- top 3 district in each stae by literacy

select *
from 
	(select *, row_number() over(partition by state order by literacy desc) as rn 
	from table1) sq
where sq.rn <4


