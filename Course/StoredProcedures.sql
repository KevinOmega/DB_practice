CREATE OR REPLACE PROCEDURE procedure_name( parameter_list)
AS $$
    DECLARE
        -- variable declarations
    BEGIN
        -- procedure body
    END;
$$ LANGUAGE plpgsql;

CREATE TABLE accounts(
    id_account SERIAL PRIMARY KEY,
    account_name VARCHAR(255) NOT NULL,
    balance DECIMAL(10, 2) NOT NULL
)

INSERT INTO accounts (account_name, balance) VALUES ('Alan Cruz', 100.00), ('Jane Smith', 100.00);

SELECT * FROM accounts;

CREATE OR REPLACE PROCEDURE transfer_funds(
    sender_id INT,
    receiver_id INT,
    amount DECIMAL(10, 2)
) 
LANGUAGE plpgsql
AS $$
    BEGIN
        IF (SELECT balance FROM accounts WHERE id_account = sender_id) < amount THEN
            RAISE EXCEPTION 'Insufficient funds';
        END IF;
        UPDATE accounts SET balance = balance - amount WHERE id_account = sender_id;

        UPDATE accounts SET balance = balance + amount WHERE id_account = receiver_id;

        COMMIT;
    END;
$$


CALL transfer_funds(2, 1, 50.00);

-- drop a procedure

DROP PROCEDURE [IF EXISTS] procedure_name(parameter_list)
[CASCADE | RESTRICT];

-- RETURN A VALUE WITH A PROCEDURE

CREATE OR REPLACE PROCEDURE get_number_of_accounts(OUT v_count INT)
AS $$
    BEGIN
        SELECT COUNT(*) INTO v_count FROM accounts;
    END;
$$ LANGUAGE plpgsql;

CALL get_number_of_accounts();