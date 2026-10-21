
LOAD DATA INTO zomato_raw.users_raw
FROM FILES (format = 'CSV', skip_leading_rows = 1,
            uris = ['gs://zomato-replica-pipeline-raw-data/raw/users/*'],
            allow_quoted_newlines = true);

LOAD DATA INTO zomato_raw.food_raw
FROM FILES (format = 'CSV', skip_leading_rows = 1,
            uris = ['gs://zomato-replica-pipeline-raw-data/raw/food/*'],
            allow_quoted_newlines = true);

LOAD DATA INTO zomato_raw.menu_raw
FROM FILES (format = 'CSV', skip_leading_rows = 1,
            uris = ['gs://zomato-replica-pipeline-raw-data/raw/menu/*'],   
            allow_quoted_newlines = true);