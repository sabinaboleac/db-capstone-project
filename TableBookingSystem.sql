
DELIMITER //
CREATE PROCEDURE CheckBooking(IN BookingDate date, IN TableNo int)
BEGIN

  DECLARE booking_status VARCHAR(10);
SELECT 
        CASE 
            WHEN COUNT(*) > 0 THEN 'Booked'
            ELSE 'Available'
        END
    INTO booking_status
    FROM Bookings
    WHERE BookingDate = BookingDate AND TableNR = TableNo;
    
    -- Return the booking status
    SELECT booking_status;
    
END//
DELIMITER ;

DELIMITER //

CREATE PROCEDURE AddValidBooking(IN booking_date DATE, IN table_number INT)
BEGIN
    DECLARE booking_count INT;

    START TRANSACTION;

    -- Check if the table is already booked on the given date
    SELECT COUNT(*) INTO booking_count
    FROM Bookings
    WHERE BookingDate = booking_date AND TableNR = table_number;

    -- If the table is already booked, rollback the transaction
    IF booking_count > 0 THEN
        ROLLBACK;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: Table is already booked on this date.';
    ELSE
        -- If the table is available, insert the new booking record
        INSERT INTO Bookings (BookingDate, TableNR)
        VALUES (booking_date, table_number);

        -- Commit the transaction
        COMMIT;
    END IF;
END//
DELIMITER ;

DELIMITER //

CREATE PROCEDURE AddBooking(IN booking_id int, in booking_date date, in table_nr int, in staff_id int, in customer_id int)
BEGIN 

INSERT INTO Bookings(BookingID, BookingDate, TableNR, StaffID, CustomerID) 
VALUES(booking_id,booking_date,table_nr,staff_id,customer_id);
SELECT "New booking added" as Confirmation;
END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE UpdateBooking(in booking_id int, in booking_date date)
BEGIN 
UPDATE Bookings SET BookingDate=booking_date WHERE BookingID=booking_id;
SELECT CONCAT("Booking ",booking_id, " updated") as Confirmation;
END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE CancelBooking(in BookingID int)
BEGIN
DELETE FROM Bookings WHERE BookingID=BookingID;
SELECT CONCAT("booking ", BookingID, " cancelled") As Confirmation;
END//
DELIMITER ;
