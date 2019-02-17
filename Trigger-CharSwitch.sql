-- Log some debugging information
DROP TABLE IF EXISTS TERPO_debug_log;
<<<<<<< HEAD
CREATE TABLE TERPO_debug_log(objectId bigint, playerId TEXT, oldSlot TEXT, newSlot TEXT, lastSwitch integer);

-- Used to store the playerId and the old and new slots for the player that means to switch characters
DROP TABLE IF EXISTS TERPO_switches;
CREATE TABLE TERPO_switches(objectId bigint, playerId TEXT, oldSlot TEXT, newSlot TEXT, lastSwitch integer);

-- The trigger that fires whenever the mod inserts a row with the name MC_BP_TERPO_C.PlayerId
-- and the last newSlot recorded in TERPO_switches != newSlot
DROP TRIGGER IF EXISTS TERPO_char_switch;
CREATE TRIGGER TERPO_char_switch AFTER INSERT ON properties
WHEN NEW.name = 'MC_BP_TERPO_C.passToDB' AND ((SELECT newSlot FROM TERPO_switches WHERE objectId = NEW.object_id) != (SELECT CHAR((INSTR('0123456789ABCDEF', SUBSTR(QUOTE(NEW.value),353,1)) - 1) * 16 + INSTR('0123456789ABCDEF', SUBSTR(QUOTE(NEW.value),354,1)) - 1) FROM properties WHERE object_id = NEW.object_id AND name = 'MC_BP_TERPO_C.passToDB') OR (SELECT newSlot FROM TERPO_switches WHERE objectId = NEW.object_id) IS NULL)
BEGIN
	-- Remove any pre-existing TERPO_switches
	DELETE FROM TERPO_switches WHERE objectId = NEW.object_id;
	
	-- Insert a row with objectId, playerId, newSlot and oldSlot into TERPO_switches
	INSERT INTO TERPO_switches (objectId, playerId, oldSlot, newSlot, lastSwitch)
	VALUES (
		-- objectId
		(SELECT object_id FROM properties WHERE object_id = NEW.object_id AND name = 'MC_BP_TERPO_C.passToDB'),
		-- playerId (byte 165 to 198 of value BLOB)
		(SELECT CHAR((INSTR('0123456789ABCDEF', SUBSTR(QUOTE(NEW.value),165,1)) - 1) * 16 + INSTR('0123456789ABCDEF', SUBSTR(QUOTE(NEW.value),166,1)) - 1) || CHAR((INSTR('0123456789ABCDEF', SUBSTR(QUOTE(NEW.value),167,1)) - 1) * 16 + INSTR('0123456789ABCDEF', SUBSTR(QUOTE(NEW.value),168,1)) - 1) || CHAR((INSTR('0123456789ABCDEF', SUBSTR(QUOTE(NEW.value),169,1)) - 1) * 16 + INSTR('0123456789ABCDEF', SUBSTR(QUOTE(NEW.value),170,1)) - 1) || CHAR((INSTR('0123456789ABCDEF', SUBSTR(QUOTE(NEW.value),171,1)) - 1) * 16 + INSTR('0123456789ABCDEF', SUBSTR(QUOTE(NEW.value),172,1)) - 1) || CHAR((INSTR('0123456789ABCDEF', SUBSTR(QUOTE(NEW.value),173,1)) - 1) * 16 + INSTR('0123456789ABCDEF', SUBSTR(QUOTE(NEW.value),174,1)) - 1) || CHAR((INSTR('0123456789ABCDEF', SUBSTR(QUOTE(NEW.value),175,1)) - 1) * 16 + INSTR('0123456789ABCDEF', SUBSTR(QUOTE(NEW.value),176,1)) - 1) || CHAR((INSTR('0123456789ABCDEF', SUBSTR(QUOTE(NEW.value),177,1)) - 1) * 16 + INSTR('0123456789ABCDEF', SUBSTR(QUOTE(NEW.value),178,1)) - 1) || CHAR((INSTR('0123456789ABCDEF', SUBSTR(QUOTE(NEW.value),179,1)) - 1) * 16 + INSTR('0123456789ABCDEF', SUBSTR(QUOTE(NEW.value),180,1)) - 1) || CHAR((INSTR('0123456789ABCDEF', SUBSTR(QUOTE(NEW.value),181,1)) - 1) * 16 + INSTR('0123456789ABCDEF', SUBSTR(QUOTE(NEW.value),182,1)) - 1) || CHAR((INSTR('0123456789ABCDEF', SUBSTR(QUOTE(NEW.value),183,1)) - 1) * 16 + INSTR('0123456789ABCDEF', SUBSTR(QUOTE(NEW.value),184,1)) - 1) || CHAR((INSTR('0123456789ABCDEF', SUBSTR(QUOTE(NEW.value),185,1)) - 1) * 16 + INSTR('0123456789ABCDEF', SUBSTR(QUOTE(NEW.value),186,1)) - 1) || CHAR((INSTR('0123456789ABCDEF', SUBSTR(QUOTE(NEW.value),187,1)) - 1) * 16 + INSTR('0123456789ABCDEF', SUBSTR(QUOTE(NEW.value),188,1)) - 1) || CHAR((INSTR('0123456789ABCDEF', SUBSTR(QUOTE(NEW.value),189,1)) - 1) * 16 + INSTR('0123456789ABCDEF', SUBSTR(QUOTE(NEW.value),190,1)) - 1) || CHAR((INSTR('0123456789ABCDEF', SUBSTR(QUOTE(NEW.value),191,1)) - 1) * 16 + INSTR('0123456789ABCDEF', SUBSTR(QUOTE(NEW.value),192,1)) - 1) || CHAR((INSTR('0123456789ABCDEF', SUBSTR(QUOTE(NEW.value),193,1)) - 1) * 16 + INSTR('0123456789ABCDEF', SUBSTR(QUOTE(NEW.value),194,1)) - 1) || CHAR((INSTR('0123456789ABCDEF', SUBSTR(QUOTE(NEW.value),195,1)) - 1) * 16 + INSTR('0123456789ABCDEF', SUBSTR(QUOTE(NEW.value),196,1)) - 1) || CHAR((INSTR('0123456789ABCDEF', SUBSTR(QUOTE(NEW.value),197,1)) - 1) * 16 + INSTR('0123456789ABCDEF', SUBSTR(QUOTE(NEW.value),198,1)) - 1) FROM properties WHERE object_id = NEW.object_id AND name = 'MC_BP_TERPO_C.passToDB'),
		-- oldSlot (byte 509 and 510 of value BLOB)
		(SELECT CHAR((INSTR('0123456789ABCDEF', SUBSTR(QUOTE(NEW.value),509,1)) - 1) * 16 + INSTR('0123456789ABCDEF', SUBSTR(QUOTE(NEW.value),510,1)) - 1) FROM properties WHERE object_id = NEW.object_id AND name = 'MC_BP_TERPO_C.passToDB'),
		-- newSlot (byte 353 and 354 of value BLOB)
		(SELECT CHAR((INSTR('0123456789ABCDEF', SUBSTR(QUOTE(NEW.value),353,1)) - 1) * 16 + INSTR('0123456789ABCDEF', SUBSTR(QUOTE(NEW.value),354,1)) - 1) FROM properties WHERE object_id = NEW.object_id AND name = 'MC_BP_TERPO_C.passToDB'),
		-- lastSwitch
		strftime('%s','now')
	);
	-- log all the values for debugging
	INSERT INTO TERPO_debug_log SELECT * FROM TERPO_switches WHERE objectId = NEW.object_id;

	-- append the old slot number to the row with playerId w/o any slot number
	UPDATE characters
	SET playerId = (SELECT playerId FROM TERPO_switches WHERE objectId = NEW.object_id) || (SELECT oldSlot FROM TERPO_switches WHERE objectId = NEW.object_id)	-- Set playerId = playerId + old slot
	WHERE playerId = (SELECT playerId FROM TERPO_switches WHERE objectId = NEW.object_id);																		-- Where playerId == playerId

	-- cut the slot number off the row with playerId with the new number
	UPDATE characters
	SET playerId = (SELECT playerId FROM TERPO_switches WHERE objectId = NEW.object_id)																				-- Set playerId = playerId
	WHERE playerId = (SELECT playerId FROM TERPO_switches WHERE objectId = NEW.object_id) || (SELECT newSlot FROM TERPO_switches WHERE objectId = NEW.object_id);	-- Where playerId == playerId + new slot
=======
CREATE TABLE TERPO_debug_log(playerId TEXT, oldSlot TEXT, newSlot TEXT, lastSwitch integer);

-- Used to store the playerId and the old and new slots for the player that means to switch characters
DROP TABLE IF EXISTS TERPO_switches;
CREATE TABLE TERPO_switches(id integer, playerId TEXT, oldSlot TEXT, newSlot TEXT, lastSwitch integer);
INSERT INTO TERPO_switches VALUES(0, NULL, NULL, NULL, NULL);

-- The trigger that fires whenever the mod inserts a row with the name MC_BP_TERPO_C.passToDB
-- and not both the last newSlot and playerId are the same as those last recorded in TERPO_switches
DROP TRIGGER IF EXISTS TERPO_char_switch;
CREATE TRIGGER TERPO_char_switch AFTER INSERT ON properties
WHEN NEW.name = 'MC_BP_TERPO_C.passToDB' AND (NOT ((SELECT playerId FROM TERPO_switches WHERE id = 0) = (SELECT CHAR((INSTR('0123456789ABCDEF', SUBSTR(QUOTE(NEW.value),165,1)) - 1) * 16 + INSTR('0123456789ABCDEF', SUBSTR(QUOTE(NEW.value),166,1)) - 1) || CHAR((INSTR('0123456789ABCDEF', SUBSTR(QUOTE(NEW.value),167,1)) - 1) * 16 + INSTR('0123456789ABCDEF', SUBSTR(QUOTE(NEW.value),168,1)) - 1) || CHAR((INSTR('0123456789ABCDEF', SUBSTR(QUOTE(NEW.value),169,1)) - 1) * 16 + INSTR('0123456789ABCDEF', SUBSTR(QUOTE(NEW.value),170,1)) - 1) || CHAR((INSTR('0123456789ABCDEF', SUBSTR(QUOTE(NEW.value),171,1)) - 1) * 16 + INSTR('0123456789ABCDEF', SUBSTR(QUOTE(NEW.value),172,1)) - 1) || CHAR((INSTR('0123456789ABCDEF', SUBSTR(QUOTE(NEW.value),173,1)) - 1) * 16 + INSTR('0123456789ABCDEF', SUBSTR(QUOTE(NEW.value),174,1)) - 1) || CHAR((INSTR('0123456789ABCDEF', SUBSTR(QUOTE(NEW.value),175,1)) - 1) * 16 + INSTR('0123456789ABCDEF', SUBSTR(QUOTE(NEW.value),176,1)) - 1) || CHAR((INSTR('0123456789ABCDEF', SUBSTR(QUOTE(NEW.value),177,1)) - 1) * 16 + INSTR('0123456789ABCDEF', SUBSTR(QUOTE(NEW.value),178,1)) - 1) || CHAR((INSTR('0123456789ABCDEF', SUBSTR(QUOTE(NEW.value),179,1)) - 1) * 16 + INSTR('0123456789ABCDEF', SUBSTR(QUOTE(NEW.value),180,1)) - 1) || CHAR((INSTR('0123456789ABCDEF', SUBSTR(QUOTE(NEW.value),181,1)) - 1) * 16 + INSTR('0123456789ABCDEF', SUBSTR(QUOTE(NEW.value),182,1)) - 1) || CHAR((INSTR('0123456789ABCDEF', SUBSTR(QUOTE(NEW.value),183,1)) - 1) * 16 + INSTR('0123456789ABCDEF', SUBSTR(QUOTE(NEW.value),184,1)) - 1) || CHAR((INSTR('0123456789ABCDEF', SUBSTR(QUOTE(NEW.value),185,1)) - 1) * 16 + INSTR('0123456789ABCDEF', SUBSTR(QUOTE(NEW.value),186,1)) - 1) || CHAR((INSTR('0123456789ABCDEF', SUBSTR(QUOTE(NEW.value),187,1)) - 1) * 16 + INSTR('0123456789ABCDEF', SUBSTR(QUOTE(NEW.value),188,1)) - 1) || CHAR((INSTR('0123456789ABCDEF', SUBSTR(QUOTE(NEW.value),189,1)) - 1) * 16 + INSTR('0123456789ABCDEF', SUBSTR(QUOTE(NEW.value),190,1)) - 1) || CHAR((INSTR('0123456789ABCDEF', SUBSTR(QUOTE(NEW.value),191,1)) - 1) * 16 + INSTR('0123456789ABCDEF', SUBSTR(QUOTE(NEW.value),192,1)) - 1) || CHAR((INSTR('0123456789ABCDEF', SUBSTR(QUOTE(NEW.value),193,1)) - 1) * 16 + INSTR('0123456789ABCDEF', SUBSTR(QUOTE(NEW.value),194,1)) - 1) || CHAR((INSTR('0123456789ABCDEF', SUBSTR(QUOTE(NEW.value),195,1)) - 1) * 16 + INSTR('0123456789ABCDEF', SUBSTR(QUOTE(NEW.value),196,1)) - 1) || CHAR((INSTR('0123456789ABCDEF', SUBSTR(QUOTE(NEW.value),197,1)) - 1) * 16 + INSTR('0123456789ABCDEF', SUBSTR(QUOTE(NEW.value),198,1)) - 1) FROM properties WHERE name = 'MC_BP_TERPO_C.passToDB') AND (SELECT newSlot FROM TERPO_switches WHERE id = 0) = (SELECT CHAR((INSTR('0123456789ABCDEF', SUBSTR(QUOTE(NEW.value),509,1)) - 1) * 16 + INSTR('0123456789ABCDEF', SUBSTR(QUOTE(NEW.value),510,1)) - 1) FROM properties WHERE name = 'MC_BP_TERPO_C.passToDB')) AND (SELECT CHAR((INSTR('0123456789ABCDEF', SUBSTR(QUOTE(NEW.value),509,1)) - 1) * 16 + INSTR('0123456789ABCDEF', SUBSTR(QUOTE(NEW.value),510,1)) - 1) FROM properties WHERE name = 'MC_BP_TERPO_C.passToDB') NOT NULL OR (SELECT playerId FROM TERPO_switches WHERE id = 0) IS NULL)
BEGIN
	-- Update TERPO_switches with playerId, oldSlot, newSlot and the current timestamp
	UPDATE TERPO_switches SET 
		-- playerId (byte 165 to 198 of value BLOB)
		playerId = (SELECT CHAR((INSTR('0123456789ABCDEF', SUBSTR(QUOTE(NEW.value),165,1)) - 1) * 16 + INSTR('0123456789ABCDEF', SUBSTR(QUOTE(NEW.value),166,1)) - 1) || CHAR((INSTR('0123456789ABCDEF', SUBSTR(QUOTE(NEW.value),167,1)) - 1) * 16 + INSTR('0123456789ABCDEF', SUBSTR(QUOTE(NEW.value),168,1)) - 1) || CHAR((INSTR('0123456789ABCDEF', SUBSTR(QUOTE(NEW.value),169,1)) - 1) * 16 + INSTR('0123456789ABCDEF', SUBSTR(QUOTE(NEW.value),170,1)) - 1) || CHAR((INSTR('0123456789ABCDEF', SUBSTR(QUOTE(NEW.value),171,1)) - 1) * 16 + INSTR('0123456789ABCDEF', SUBSTR(QUOTE(NEW.value),172,1)) - 1) || CHAR((INSTR('0123456789ABCDEF', SUBSTR(QUOTE(NEW.value),173,1)) - 1) * 16 + INSTR('0123456789ABCDEF', SUBSTR(QUOTE(NEW.value),174,1)) - 1) || CHAR((INSTR('0123456789ABCDEF', SUBSTR(QUOTE(NEW.value),175,1)) - 1) * 16 + INSTR('0123456789ABCDEF', SUBSTR(QUOTE(NEW.value),176,1)) - 1) || CHAR((INSTR('0123456789ABCDEF', SUBSTR(QUOTE(NEW.value),177,1)) - 1) * 16 + INSTR('0123456789ABCDEF', SUBSTR(QUOTE(NEW.value),178,1)) - 1) || CHAR((INSTR('0123456789ABCDEF', SUBSTR(QUOTE(NEW.value),179,1)) - 1) * 16 + INSTR('0123456789ABCDEF', SUBSTR(QUOTE(NEW.value),180,1)) - 1) || CHAR((INSTR('0123456789ABCDEF', SUBSTR(QUOTE(NEW.value),181,1)) - 1) * 16 + INSTR('0123456789ABCDEF', SUBSTR(QUOTE(NEW.value),182,1)) - 1) || CHAR((INSTR('0123456789ABCDEF', SUBSTR(QUOTE(NEW.value),183,1)) - 1) * 16 + INSTR('0123456789ABCDEF', SUBSTR(QUOTE(NEW.value),184,1)) - 1) || CHAR((INSTR('0123456789ABCDEF', SUBSTR(QUOTE(NEW.value),185,1)) - 1) * 16 + INSTR('0123456789ABCDEF', SUBSTR(QUOTE(NEW.value),186,1)) - 1) || CHAR((INSTR('0123456789ABCDEF', SUBSTR(QUOTE(NEW.value),187,1)) - 1) * 16 + INSTR('0123456789ABCDEF', SUBSTR(QUOTE(NEW.value),188,1)) - 1) || CHAR((INSTR('0123456789ABCDEF', SUBSTR(QUOTE(NEW.value),189,1)) - 1) * 16 + INSTR('0123456789ABCDEF', SUBSTR(QUOTE(NEW.value),190,1)) - 1) || CHAR((INSTR('0123456789ABCDEF', SUBSTR(QUOTE(NEW.value),191,1)) - 1) * 16 + INSTR('0123456789ABCDEF', SUBSTR(QUOTE(NEW.value),192,1)) - 1) || CHAR((INSTR('0123456789ABCDEF', SUBSTR(QUOTE(NEW.value),193,1)) - 1) * 16 + INSTR('0123456789ABCDEF', SUBSTR(QUOTE(NEW.value),194,1)) - 1) || CHAR((INSTR('0123456789ABCDEF', SUBSTR(QUOTE(NEW.value),195,1)) - 1) * 16 + INSTR('0123456789ABCDEF', SUBSTR(QUOTE(NEW.value),196,1)) - 1) || CHAR((INSTR('0123456789ABCDEF', SUBSTR(QUOTE(NEW.value),197,1)) - 1) * 16 + INSTR('0123456789ABCDEF', SUBSTR(QUOTE(NEW.value),198,1)) - 1) FROM properties WHERE name = 'MC_BP_TERPO_C.passToDB'),
		-- oldSlot (byte 353 and 354 of value BLOB)
		oldSlot = (SELECT CHAR((INSTR('0123456789ABCDEF', SUBSTR(QUOTE(NEW.value),353,1)) - 1) * 16 + INSTR('0123456789ABCDEF', SUBSTR(QUOTE(NEW.value),354,1)) - 1) FROM properties WHERE name = 'MC_BP_TERPO_C.passToDB'),
		-- newSlot (byte 509 and 510 of value BLOB)
		newSlot = (SELECT CHAR((INSTR('0123456789ABCDEF', SUBSTR(QUOTE(NEW.value),509,1)) - 1) * 16 + INSTR('0123456789ABCDEF', SUBSTR(QUOTE(NEW.value),510,1)) - 1) FROM properties WHERE name = 'MC_BP_TERPO_C.passToDB'),
		-- lastSwitch
		lastSwitch = strftime('%s','now')
	WHERE id = 0;

	-- remove the row that had been utilized to pass the variables
	DELETE FROM properties WHERE name = 'MC_BP_TERPO_C.passToDB';

	-- log all the values for debugging
	INSERT INTO TERPO_debug_log SELECT playerId, oldSlot, newSlot, lastSwitch FROM TERPO_switches WHERE id = 0;

	-- append the old slot number to the row with playerId w/o any slot number
	UPDATE characters
	-- Set playerId = playerId + old slot
	SET playerId = (SELECT playerId FROM TERPO_switches WHERE id = 0) || (SELECT oldSlot FROM TERPO_switches WHERE id = 0)
	-- Where playerId == playerId
	WHERE playerId = (SELECT playerId FROM TERPO_switches WHERE id = 0);

	-- cut the slot number off the row with playerId with the new number
	UPDATE characters
	-- Set playerId = playerId
	SET playerId = (SELECT playerId FROM TERPO_switches WHERE id = 0)
	-- Where playerId == playerId + new slot
	WHERE playerId = (SELECT playerId FROM TERPO_switches WHERE id = 0) || (SELECT newSlot FROM TERPO_switches WHERE id = 0);
END;

-- Trigger to remove duplicates
DROP TRIGGER IF EXISTS TERPO_cleanup;
CREATE TRIGGER TERPO_cleanup AFTER INSERT ON properties
WHEN NEW.name = 'MC_BP_TERPO_C.passToDB' AND ((SELECT playerId FROM TERPO_switches WHERE id = 0) = (SELECT CHAR((INSTR('0123456789ABCDEF', SUBSTR(QUOTE(NEW.value),165,1)) - 1) * 16 + INSTR('0123456789ABCDEF', SUBSTR(QUOTE(NEW.value),166,1)) - 1) || CHAR((INSTR('0123456789ABCDEF', SUBSTR(QUOTE(NEW.value),167,1)) - 1) * 16 + INSTR('0123456789ABCDEF', SUBSTR(QUOTE(NEW.value),168,1)) - 1) || CHAR((INSTR('0123456789ABCDEF', SUBSTR(QUOTE(NEW.value),169,1)) - 1) * 16 + INSTR('0123456789ABCDEF', SUBSTR(QUOTE(NEW.value),170,1)) - 1) || CHAR((INSTR('0123456789ABCDEF', SUBSTR(QUOTE(NEW.value),171,1)) - 1) * 16 + INSTR('0123456789ABCDEF', SUBSTR(QUOTE(NEW.value),172,1)) - 1) || CHAR((INSTR('0123456789ABCDEF', SUBSTR(QUOTE(NEW.value),173,1)) - 1) * 16 + INSTR('0123456789ABCDEF', SUBSTR(QUOTE(NEW.value),174,1)) - 1) || CHAR((INSTR('0123456789ABCDEF', SUBSTR(QUOTE(NEW.value),175,1)) - 1) * 16 + INSTR('0123456789ABCDEF', SUBSTR(QUOTE(NEW.value),176,1)) - 1) || CHAR((INSTR('0123456789ABCDEF', SUBSTR(QUOTE(NEW.value),177,1)) - 1) * 16 + INSTR('0123456789ABCDEF', SUBSTR(QUOTE(NEW.value),178,1)) - 1) || CHAR((INSTR('0123456789ABCDEF', SUBSTR(QUOTE(NEW.value),179,1)) - 1) * 16 + INSTR('0123456789ABCDEF', SUBSTR(QUOTE(NEW.value),180,1)) - 1) || CHAR((INSTR('0123456789ABCDEF', SUBSTR(QUOTE(NEW.value),181,1)) - 1) * 16 + INSTR('0123456789ABCDEF', SUBSTR(QUOTE(NEW.value),182,1)) - 1) || CHAR((INSTR('0123456789ABCDEF', SUBSTR(QUOTE(NEW.value),183,1)) - 1) * 16 + INSTR('0123456789ABCDEF', SUBSTR(QUOTE(NEW.value),184,1)) - 1) || CHAR((INSTR('0123456789ABCDEF', SUBSTR(QUOTE(NEW.value),185,1)) - 1) * 16 + INSTR('0123456789ABCDEF', SUBSTR(QUOTE(NEW.value),186,1)) - 1) || CHAR((INSTR('0123456789ABCDEF', SUBSTR(QUOTE(NEW.value),187,1)) - 1) * 16 + INSTR('0123456789ABCDEF', SUBSTR(QUOTE(NEW.value),188,1)) - 1) || CHAR((INSTR('0123456789ABCDEF', SUBSTR(QUOTE(NEW.value),189,1)) - 1) * 16 + INSTR('0123456789ABCDEF', SUBSTR(QUOTE(NEW.value),190,1)) - 1) || CHAR((INSTR('0123456789ABCDEF', SUBSTR(QUOTE(NEW.value),191,1)) - 1) * 16 + INSTR('0123456789ABCDEF', SUBSTR(QUOTE(NEW.value),192,1)) - 1) || CHAR((INSTR('0123456789ABCDEF', SUBSTR(QUOTE(NEW.value),193,1)) - 1) * 16 + INSTR('0123456789ABCDEF', SUBSTR(QUOTE(NEW.value),194,1)) - 1) || CHAR((INSTR('0123456789ABCDEF', SUBSTR(QUOTE(NEW.value),195,1)) - 1) * 16 + INSTR('0123456789ABCDEF', SUBSTR(QUOTE(NEW.value),196,1)) - 1) || CHAR((INSTR('0123456789ABCDEF', SUBSTR(QUOTE(NEW.value),197,1)) - 1) * 16 + INSTR('0123456789ABCDEF', SUBSTR(QUOTE(NEW.value),198,1)) - 1) FROM properties WHERE name = 'MC_BP_TERPO_C.passToDB') AND (SELECT newSlot FROM TERPO_switches WHERE id = 0) = (SELECT CHAR((INSTR('0123456789ABCDEF', SUBSTR(QUOTE(NEW.value),509,1)) - 1) * 16 + INSTR('0123456789ABCDEF', SUBSTR(QUOTE(NEW.value),510,1)) - 1) FROM properties WHERE name = 'MC_BP_TERPO_C.passToDB') OR (SELECT CHAR((INSTR('0123456789ABCDEF', SUBSTR(QUOTE(NEW.value),509,1)) - 1) * 16 + INSTR('0123456789ABCDEF', SUBSTR(QUOTE(NEW.value),510,1)) - 1) FROM properties WHERE name = 'MC_BP_TERPO_C.passToDB') IS NULL)
BEGIN
	-- remove the row that had been utilized to pass the variables
	DELETE FROM properties WHERE name = 'MC_BP_TERPO_C.passToDB';
	-- log all the values for debugging
	INSERT INTO TERPO_debug_log(playerId, oldSlot, newSlot, lastSwitch) VALUES('Duplicate Entry removed', 0, 0, strftime('%s','now'));
>>>>>>> development
END;