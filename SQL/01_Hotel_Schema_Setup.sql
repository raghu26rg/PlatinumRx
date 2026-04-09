-- =========================================================
-- HOTEL SYSTEM - SCHEMA SETUP + SAMPLE DATA
-- =========================================================
-- Updated to match the provided table design exactly:
-- 1) users
-- 2) bookings
-- 3) booking_commercials
-- 4) items

DROP TABLE IF EXISTS booking_commercials;
DROP TABLE IF EXISTS bookings;
DROP TABLE IF EXISTS items;
DROP TABLE IF EXISTS users;

CREATE TABLE users (
    user_id          VARCHAR(30) PRIMARY KEY,
    name             VARCHAR(100) NOT NULL,
    phone_number     VARCHAR(20) NOT NULL,
    mail_id          VARCHAR(150) UNIQUE,
    billing_address  VARCHAR(255)
);

CREATE TABLE items (
    item_id    VARCHAR(30) PRIMARY KEY,
    item_name  VARCHAR(100) NOT NULL,
    item_rate  DECIMAL(10, 2) NOT NULL CHECK (item_rate >= 0)
);

CREATE TABLE bookings (
    booking_id     VARCHAR(30) PRIMARY KEY,
    booking_date   TIMESTAMP NOT NULL,
    room_no        VARCHAR(30) NOT NULL,
    user_id        VARCHAR(30) NOT NULL,
    CONSTRAINT fk_bookings_user FOREIGN KEY (user_id) REFERENCES users(user_id)
);

CREATE TABLE booking_commercials (
    id             VARCHAR(30) PRIMARY KEY,
    booking_id     VARCHAR(30) NOT NULL,
    bill_id        VARCHAR(30) NOT NULL,
    bill_date      TIMESTAMP NOT NULL,
    item_id        VARCHAR(30) NOT NULL,
    item_quantity  DECIMAL(10, 2) NOT NULL CHECK (item_quantity >= 0),
    CONSTRAINT fk_bc_booking FOREIGN KEY (booking_id) REFERENCES bookings(booking_id),
    CONSTRAINT fk_bc_item FOREIGN KEY (item_id) REFERENCES items(item_id)
);

-- Indexes for faster date + join analytics.
CREATE INDEX idx_bookings_user_date ON bookings(user_id, booking_date);
CREATE INDEX idx_bookings_date ON bookings(booking_date);
CREATE INDEX idx_bc_bill_date ON booking_commercials(bill_date);
CREATE INDEX idx_bc_booking ON booking_commercials(booking_id);
CREATE INDEX idx_bc_item ON booking_commercials(item_id);

-- =========================================================
-- SAMPLE DATA
-- =========================================================

INSERT INTO users (user_id, name, phone_number, mail_id, billing_address) VALUES
    ('usr-a12b-78x1', 'John Doe', '97XXXXXXXX', 'john.doe@example.com', 'XX, Street Y, ABC City'),
    ('usr-b34c-45y2', 'Priya Nair', '98XXXXXXXX', 'priya.nair@example.com', '14, Lake View, Bengaluru'),
    ('usr-c56d-23z3', 'Rohit Sharma', '99XXXXXXXX', 'rohit.sharma@example.com', '22, MG Road, Mumbai'),
    ('usr-d78e-67k4', 'Aisha Khan', '96XXXXXXXX', 'aisha.khan@example.com', '11, Park Street, Kolkata');

INSERT INTO items (item_id, item_name, item_rate) VALUES
    ('itm-a9e8-q8fu', 'Tawa Paratha', 18.00),
    ('itm-a07vh-aer8', 'Mix Veg', 89.00),
    ('itm-w978-23u4', 'Paneer Butter Masala', 210.00),
    ('itm-k38x-81p2', 'Cold Coffee', 120.00),
    ('itm-m12n-55r7', 'Mineral Water', 25.00);

INSERT INTO bookings (booking_id, booking_date, room_no, user_id) VALUES
    ('bk-09f3e-95hj', TIMESTAMP '2021-09-23 07:36:48', 'rm-bhf9-aerjn', 'usr-a12b-78x1'),
    ('bk-q034-qf40', TIMESTAMP '2021-10-04 11:20:15', 'rm-cdf7-kp21', 'usr-a12b-78x1'),
    ('bk-r228-ab11', TIMESTAMP '2021-10-12 18:05:10', 'rm-zx22-lm99', 'usr-b34c-45y2'),
    ('bk-t671-cc21', TIMESTAMP '2021-11-08 09:45:00', 'rm-vb71-tt54', 'usr-c56d-23z3'),
    ('bk-p882-dd32', TIMESTAMP '2021-11-19 16:30:42', 'rm-jk55-aa10', 'usr-d78e-67k4'),
    ('bk-m441-ee76', TIMESTAMP '2021-12-03 10:12:33', 'rm-jk55-aa10', 'usr-b34c-45y2');

INSERT INTO booking_commercials (id, booking_id, bill_id, bill_date, item_id, item_quantity) VALUES
    ('q34r-3q4o8-q34u', 'bk-09f3e-95hj', 'bl-0a87y-q340', TIMESTAMP '2021-09-23 12:03:22', 'itm-a9e8-q8fu', 3.00),
    ('q3o4-ahf32-o2u4', 'bk-09f3e-95hj', 'bl-0a87y-q340', TIMESTAMP '2021-09-23 12:03:22', 'itm-a07vh-aer8', 1.00),
    ('134lr-oyfo8-3qk4', 'bk-q034-qf40', 'bl-34qhd-r7h8', TIMESTAMP '2021-10-04 12:05:37', 'itm-w978-23u4', 0.50),
    ('34qj-k3q4h-q34k', 'bk-q034-qf40', 'bl-34qhd-r7h8', TIMESTAMP '2021-10-04 12:05:37', 'itm-k38x-81p2', 2.00),
    ('11ae-zx77-9la2', 'bk-r228-ab11', 'bl-98gtr-4r2d', TIMESTAMP '2021-10-12 20:15:50', 'itm-w978-23u4', 3.00),
    ('66pp-yt17-0bc3', 'bk-r228-ab11', 'bl-98gtr-4r2d', TIMESTAMP '2021-10-12 20:15:50', 'itm-m12n-55r7', 5.00),
    ('88as-kk00-1mn9', 'bk-t671-cc21', 'bl-t7h2-pp01', TIMESTAMP '2021-11-08 13:10:20', 'itm-a07vh-aer8', 4.00),
    ('90cd-kk01-2mn0', 'bk-t671-cc21', 'bl-t7h2-pp01', TIMESTAMP '2021-11-08 13:10:20', 'itm-w978-23u4', 2.00),
    ('22fg-ll22-3op1', 'bk-p882-dd32', 'bl-u9k4-mm88', TIMESTAMP '2021-11-19 19:00:00', 'itm-k38x-81p2', 8.00),
    ('33gh-ll23-4op2', 'bk-p882-dd32', 'bl-u9k4-mm88', TIMESTAMP '2021-11-19 19:00:00', 'itm-m12n-55r7', 4.00),
    ('44ij-mm24-5qr3', 'bk-m441-ee76', 'bl-j8h3-dd72', TIMESTAMP '2021-12-03 14:30:00', 'itm-a9e8-q8fu', 6.00);
