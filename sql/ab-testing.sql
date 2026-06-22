CREATE SCHEMA ab_testing;

CREATE TABLE ab_testing.ab_test(
    user_id INTEGER,
    group_name VARCHAR(20),
    converted INTEGER,
    device_type VARCHAR(20),
    traffic_source VARCHAR(20),
    order_value NUMERIC(10,2)
);




SELECT * from ab_testing.ab_test
limit 2;


--Overall conversion rate by group



select group_name,
AVG(converted) as converted_rates
from ab_testing.ab_test
group by group_name;



--Conversion rate by device type and group


select group_name,
device_type,
AVG(converted) as converted_rates
from ab_testing.ab_test
group by group_name, device_type 
order by group_name ,device_type ;



--Conversion rate by traffic source and group

select group_name,
traffic_source,
AVG(converted) as converted_rates
from ab_testing.ab_test
group by group_name, traffic_source  
order by group_name ,traffic_source  ;



-- AOV guardrail by group


select count(*)  ,
group_name ,
AVG(order_value)as order_value
from ab_testing.ab_test 
where converted =1
group by group_name
order by group_name ;



























