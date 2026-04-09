-- =========================================================
-- CLINIC SYSTEM - SCHEMA SETUP + SAMPLE DATA
-- =========================================================

DROP TABLE IF EXISTS expenses;
DROP TABLE IF EXISTS clinic_sales;
DROP TABLE IF EXISTS customer;
DROP TABLE IF EXISTS clinics;

CREATE TABLE clinics (
    cid          VARCHAR(30) PRIMARY KEY,
    clinic_name  VARCHAR(120) NOT NULL,
    city         VARCHAR(60) NOT NULL,
    state        VARCHAR(60) NOT NULL,
    country      VARCHAR(60) NOT NULL
);

CREATE TABLE customer (
    uid     VARCHAR(30) PRIMARY KEY,
    name    VARCHAR(120) NOT NULL,
    mobile  VARCHAR(20) NOT NULL
);

CREATE TABLE clinic_sales (
    oid            VARCHAR(30) PRIMARY KEY,
    uid            VARCHAR(30) NOT NULL,
    cid            VARCHAR(30) NOT NULL,
    amount         DECIMAL(12, 2) NOT NULL CHECK (amount >= 0),
    datetime       TIMESTAMP NOT NULL,
    sales_channel  VARCHAR(60) NOT NULL,
    CONSTRAINT fk_sales_customer FOREIGN KEY (uid) REFERENCES customer(uid),
    CONSTRAINT fk_sales_clinic FOREIGN KEY (cid) REFERENCES clinics(cid)
);

CREATE TABLE expenses (
    eid          VARCHAR(30) PRIMARY KEY,
    cid          VARCHAR(30) NOT NULL,
    description  VARCHAR(120) NOT NULL,
    amount       DECIMAL(12, 2) NOT NULL CHECK (amount >= 0),
    datetime     TIMESTAMP NOT NULL,
    CONSTRAINT fk_expenses_clinic FOREIGN KEY (cid) REFERENCES clinics(cid)
);

CREATE INDEX idx_sales_datetime ON clinic_sales(datetime);
CREATE INDEX idx_sales_cid_datetime ON clinic_sales(cid, datetime);
CREATE INDEX idx_sales_channel ON clinic_sales(sales_channel);
CREATE INDEX idx_expenses_cid_datetime ON expenses(cid, datetime);

-- =========================================================
-- SAMPLE DATA
-- =========================================================

INSERT INTO clinics (cid, clinic_name, city, state, country) VALUES
    ('cnc-0100001', 'XYZ Clinic', 'lorem', 'ipsum', 'dolor'),
    ('cnc-0100002', 'Alpha Care', 'lorem', 'ipsum', 'dolor'),
    ('cnc-0100003', 'City Health', 'amet', 'ipsum', 'dolor'),
    ('cnc-0100004', 'Prime Med', 'amet', 'sit', 'dolor');

INSERT INTO customer (uid, name, mobile) VALUES
    ('bk-09f3e-95hj', 'Jon Doe', '97XXXXXXXX'),
    ('bk-a12dd-77kl', 'Priya Raj', '98XXXXXXXX'),
    ('bk-z88tt-31op', 'Ravi Kumar', '99XXXXXXXX'),
    ('bk-q17lm-65as', 'Nisha Khan', '96XXXXXXXX'),
    ('bk-m41aa-11bb', 'Arun Das', '95XXXXXXXX');

INSERT INTO clinic_sales (oid, uid, cid, amount, datetime, sales_channel) VALUES
    ('ord-00100-00100', 'bk-09f3e-95hj', 'cnc-0100001', 24999.00, TIMESTAMP '2021-09-23 12:03:22', 'sodat'),
    ('ord-00100-00101', 'bk-a12dd-77kl', 'cnc-0100001', 11200.00, TIMESTAMP '2021-10-04 10:15:30', 'online'),
    ('ord-00100-00102', 'bk-z88tt-31op', 'cnc-0100002', 17650.00, TIMESTAMP '2021-10-12 18:20:10', 'walkin'),
    ('ord-00100-00103', 'bk-q17lm-65as', 'cnc-0100002', 9600.00, TIMESTAMP '2021-11-08 09:45:00', 'insurance'),
    ('ord-00100-00104', 'bk-09f3e-95hj', 'cnc-0100003', 15800.00, TIMESTAMP '2021-11-19 16:30:42', 'online'),
    ('ord-00100-00105', 'bk-m41aa-11bb', 'cnc-0100003', 21300.00, TIMESTAMP '2021-12-03 10:12:33', 'walkin'),
    ('ord-00100-00106', 'bk-a12dd-77kl', 'cnc-0100004', 8700.00, TIMESTAMP '2021-12-19 14:11:09', 'online'),
    ('ord-00100-00107', 'bk-z88tt-31op', 'cnc-0100004', 9200.00, TIMESTAMP '2022-01-08 13:07:44', 'insurance'),
    ('ord-00100-00108', 'bk-q17lm-65as', 'cnc-0100001', 10100.00, TIMESTAMP '2022-01-17 11:28:00', 'sodat');

INSERT INTO expenses (eid, cid, description, amount, datetime) VALUES
    ('exp-0100-00100', 'cnc-0100001', 'first-aid supplies', 557.00, TIMESTAMP '2021-09-23 07:36:48'),
    ('exp-0100-00101', 'cnc-0100001', 'electricity', 1200.00, TIMESTAMP '2021-10-31 20:00:00'),
    ('exp-0100-00102', 'cnc-0100002', 'rent', 4500.00, TIMESTAMP '2021-10-31 20:00:00'),
    ('exp-0100-00103', 'cnc-0100002', 'medical consumables', 1800.00, TIMESTAMP '2021-11-30 21:10:00'),
    ('exp-0100-00104', 'cnc-0100003', 'staff salary', 6200.00, TIMESTAMP '2021-11-30 21:10:00'),
    ('exp-0100-00105', 'cnc-0100003', 'maintenance', 1400.00, TIMESTAMP '2021-12-31 19:15:00'),
    ('exp-0100-00106', 'cnc-0100004', 'utilities', 1700.00, TIMESTAMP '2021-12-31 19:15:00'),
    ('exp-0100-00107', 'cnc-0100004', 'rent', 4300.00, TIMESTAMP '2022-01-31 20:20:20'),
    ('exp-0100-00108', 'cnc-0100001', 'staff salary', 5100.00, TIMESTAMP '2022-01-31 20:20:20');
