select
    customer_id,
    customer_name,
    email,
    age,
    case 
        when age < 25 then 'Gen Z'
        when age >= 25 and age < 40 then 'Millennial'
        when age >= 40 and age < 55 then 'Gen X'
        when age is null then 'Unknown'
        else 'Boomer'
    end as age_segment,
    gender,
    family_size,
    income_band
from {{ref('stg_users')}}  

