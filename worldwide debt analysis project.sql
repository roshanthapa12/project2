   -- 1. Find the number of unique countries
  select distinct country_name from debt_dataset
  
   -- 2. Totaling the amount of debt owed by the countries
   select country_name,round(cast(sum(debt)as decimal),0) as total_debt from debt_dataset
   group by 1
   order by 2
   
   -- 3. Country with the highest debt
   select country_name,round(cast(sum(debt)as decimal),0) as total_debt from debt_dataset
   group by 1
   order by 2 desc
   limit 1
   
   -- 4. Average amount of debt across indicators
   select indicator_name,indicator_code,round(avg(debt),2)as avg_debt from debt_dataset
   group by 1,2
   order by 1
   
  -- 5: What is the total amount of debt for each country broken down by 
  -- the type of debt (e.g., bilateral, multilateral, commercial banks)?

   select  country_name, indicator_name, sum(debt) as total_debt from debt_dataset
   where indicator_code in ( 'DT.DIS.MLAT.CD','DT.INT.BLAT.CD','DT.DIS.BLAT.CD','DT.INT.MLAT.CD','DT.DIS.PCBK.CD','DT.INT.PCBK.CD')
   group by 1,2
   order by 1
   
   
   -- 6: What is the ratio of total interest payments to total disbursements for each country?
  with cte as(
   select country_name, sum(case when indicator_code ='DT.DIS.DLXF.CD' then debt else 0 end) as total_disbursement,
						sum(case when indicator_code ='DT.INT.DLXF.CD' then debt else 0 end) as total_interest from debt_dataset
	group by 1
)
  select country_name,
  round(case when  total_disbursement > 0 then total_interest/ total_disbursement * 100 else null end,2) as interest_to_disbursement_ratio 
  from cte
  order by 1
  
  
   --  7: What are the total amounts of different debt indicators (disbursements vs. interest payments) across all countries?
 with cte as( 
     select indicator_code , sum(debt) as total_disbursement from debt_dataset
	 where indicator_code ='DT.DIS.DLXF.CD'
	 group by 1
),
  cte1 as(
       select indicator_code , sum(debt) as total_payment from debt_dataset
	 where indicator_code ='DT.INT.DLXF.CD'
	 group by 1
)
 select (c.total_disbursement-c1.total_payment) as difference from cte c
 cross join cte1 c1 
 
  -- 8:What is the percentage distribution of debt amounts across different indicator codes for each country?
  with cte as(
  select country_name,sum(debt) as total_debt from debt_dataset
  group by 1
),
cte1 as(
	select country_name,indicator_name,sum(debt) as amt from debt_dataset
	group by 1,2
)
 select c1.country_name,c1.indicator_name,round(c1.amt*100/c.total_debt,2) as percentage from cte1 c1
 join cte c on c.country_name=c1.country_name
 order by 1,3
  
  
  
  
  
  
  
  
	 
				

   
   
   
   
   
   
   
   
 
   
   
   
   
   
   
   
   
   
   
   
   
   
    



