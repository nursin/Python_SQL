-- customers date_of_birth set default now
-- depends: 20211111_03_3lGxb-customers-date-of-birth-set-not-null
ALTER TABLE customers 
    ALTER COLUMN date_of_birth DROP DEFAULT;
