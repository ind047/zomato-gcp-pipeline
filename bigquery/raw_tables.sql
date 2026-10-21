CREATE OR REPLACE TABLE zomato_raw.menu_raw(
    _idx STRING,
    menu_id STRING,
    r_id STRING,
    f_id STRING,
    cuisine STRING,
    price STRING
);

CREATE OR REPLACE TABLE zomato_raw.restaurants_raw(
    _idx STRING,
    id STRING,
    name STRING,
    city STRING,
    rating STRING,
    rating_count STRING,
    cost STRING,
    cuisine STRING,
    lic_no STRING,
    link STRING,
    address STRING,
    menu STRING
);

CREATE OR REPLACE TABLE zomato_raw.users_raw(
    _idx STRING,
    user_id STRING,
    name STRING,
    email STRING,
    password STRING,
    age STRING,
    gender STRING,
    marital_status STRING,
    occupation STRING,
    monthly_income STRING,
    educational_qualification STRING,
    family_size STRING
);
CREATE OR REPLACE TABLE zomato_raw.food_raw(
    _idx STRING,
    f_id STRING,
    item STRING,
    veg_or_non_veg STRING
);