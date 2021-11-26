-- customers date_of_birth set not null
-- depends: 20211111_02_ucnV3-customers-date-of-birth
ALTER TABLE customers
    ALTER COLUMN date_of_birth SET NOT NULL;
