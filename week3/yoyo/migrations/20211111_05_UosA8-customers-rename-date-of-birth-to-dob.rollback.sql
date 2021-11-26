-- customers rename date_of_birth to dob
-- depends: 20211111_04_q2ncH-customers-date-of-birth-set-default-now
ALTER TABLE customers 
    RENAME COLUMN dob TO date_of_birth;
