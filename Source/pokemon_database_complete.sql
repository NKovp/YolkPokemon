-- Complete Pokemon Database Setup Script for PostgreSQL
-- This script creates tables and populates them with sample data
-- 
-- PREREQUISITES:
-- 1. Create database first: CREATE DATABASE pokemon_db;
-- 2. Connect to database: \c pokemon_db;
-- 3. Then run this script: \i pokemon_database_complete.sql

-- Drop tables if they exist (in reverse order due to foreign key constraints)
DROP TABLE IF EXISTS "PokemonMoves";
DROP TABLE IF EXISTS "Pokemon";
DROP TABLE IF EXISTS "Moves";
DROP TABLE IF EXISTS "Elements";
DROP TABLE IF EXISTS "Trainers";

-- Create Trainers table (included for completeness, even though we won't populate it)
CREATE TABLE "Trainers" (
    "Id" SERIAL PRIMARY KEY,
    "Name" VARCHAR(100) NOT NULL,
    "Region" VARCHAR(50),
    "Age" INT,
    "CreatedAt" TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    "Wins" INT DEFAULT 0,
    "Losses" INT DEFAULT 0
);

-- Create Elements table (Pokemon types)
CREATE TABLE "Elements" (
    "Id" SERIAL PRIMARY KEY,
    "Name" VARCHAR(50) NOT NULL UNIQUE
);

-- Create Pokemon table
CREATE TABLE "Pokemon" (
    "Id" SERIAL PRIMARY KEY,
    "Name" VARCHAR(100) NOT NULL,
    "Level" INT NOT NULL CHECK ("Level" > 0 AND "Level" <= 100),
    "TypeId" INT NOT NULL,
    "OwnerId" INT NULL,
    "Health" INT NOT NULL CHECK ("Health" > 0),
    "CaughtAt" TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY ("TypeId") REFERENCES "Elements"("Id"),
    FOREIGN KEY ("OwnerId") REFERENCES "Trainers"("Id")
);

-- Create Moves table
CREATE TABLE "Moves" (
    "Id" SERIAL PRIMARY KEY,
    "Name" VARCHAR(100) NOT NULL,
    "Power" INT NOT NULL CHECK ("Power" >= 0),
    "TypeId" INT NOT NULL,
    FOREIGN KEY ("TypeId") REFERENCES "Elements"("Id")
);

-- Create PokemonMoves junction table
CREATE TABLE "PokemonMoves" (
    "Id" SERIAL PRIMARY KEY,
    "PokemonId" INT NOT NULL,
    "MoveId" INT NOT NULL,
    FOREIGN KEY ("PokemonId") REFERENCES "Pokemon"("Id") ON DELETE CASCADE,
    FOREIGN KEY ("MoveId") REFERENCES "Moves"("Id") ON DELETE CASCADE,
    CONSTRAINT unique_pokemon_move UNIQUE ("PokemonId", "MoveId")
);

-- Reset sequences to ensure proper ID assignment
SELECT setval(pg_get_serial_sequence('"Elements"', 'Id'), 1, false);
SELECT setval(pg_get_serial_sequence('"Pokemon"', 'Id'), 1, false);
SELECT setval(pg_get_serial_sequence('"Moves"', 'Id'), 1, false);
SELECT setval(pg_get_serial_sequence('"PokemonMoves"', 'Id'), 1, false);

-- Insert Elements/Type data
INSERT INTO "Elements" ("Id", "Name") VALUES
(1, 'Fire'),
(2, 'Water'),
(3, 'Grass'),
(4, 'Electric'),
(5, 'Psychic'),
(6, 'Ice'),
(7, 'Dragon'),
(8, 'Dark'),
(9, 'Fighting'),
(10, 'Poison'),
(11, 'Ground'),
(12, 'Flying'),
(13, 'Bug'),
(14, 'Rock'),
(15, 'Ghost'),
(16, 'Steel'),
(17, 'Fairy'),
(18, 'Normal');

-- Insert Pokemon data
INSERT INTO "Pokemon" ("Id", "Name", "Level", "TypeId", "OwnerId", "Health", "CaughtAt") VALUES
-- Fire type Pokemon
(1, 'Charizard', 55, 1, NULL, 78, '2024-01-15 10:30:00'),
(2, 'Arcanine', 42, 1, NULL, 90, '2024-01-20 14:22:00'),
(3, 'Rapidash', 38, 1, NULL, 65, '2024-02-03 09:15:00'),
(4, 'Flareon', 35, 1, NULL, 65, '2024-02-10 16:45:00'),

-- Water type Pokemon
(5, 'Blastoise', 58, 2, NULL, 79, '2024-01-18 11:20:00'),
(6, 'Gyarados', 47, 2, NULL, 95, '2024-01-25 13:30:00'),
(7, 'Lapras', 45, 2, NULL, 130, '2024-02-01 15:10:00'),
(8, 'Vaporeon', 36, 2, NULL, 130, '2024-02-08 12:00:00'),

-- Grass type Pokemon
(9, 'Venusaur', 56, 3, NULL, 80, '2024-01-22 08:45:00'),
(10, 'Exeggutor', 40, 3, NULL, 95, '2024-02-05 17:20:00'),
(11, 'Vileplume', 38, 3, NULL, 75, '2024-02-12 10:30:00'),

-- Electric type Pokemon
(12, 'Pikachu', 25, 4, NULL, 35, '2024-01-10 14:00:00'),
(13, 'Raichu', 42, 4, NULL, 60, '2024-01-28 11:15:00'),
(14, 'Jolteon', 37, 4, NULL, 65, '2024-02-15 13:45:00'),
(15, 'Zapdos', 60, 4, NULL, 90, '2024-03-01 09:30:00'),

-- Psychic type Pokemon
(16, 'Alakazam', 48, 5, NULL, 55, '2024-02-20 16:00:00'),
(17, 'Mewtwo', 70, 5, NULL, 106, '2024-03-05 10:45:00'),
(18, 'Espeon', 39, 5, NULL, 65, '2024-02-25 14:20:00'),

-- Ice type Pokemon
(19, 'Articuno', 60, 6, NULL, 90, '2024-03-02 12:30:00'),
(20, 'Lapras', 44, 6, NULL, 130, '2024-02-28 15:50:00'),

-- Dragon type Pokemon
(21, 'Dragonite', 62, 7, NULL, 91, '2024-03-10 11:00:00'),
(22, 'Dragonair', 45, 7, NULL, 61, '2024-03-08 13:25:00'),

-- Dark type Pokemon
(23, 'Umbreon', 40, 8, NULL, 95, '2024-02-18 17:10:00'),
(24, 'Houndoom', 43, 8, NULL, 75, '2024-03-12 09:40:00'),

-- Fighting type Pokemon
(25, 'Machamp', 50, 9, NULL, 90, '2024-02-22 12:15:00'),
(26, 'Hitmonlee', 38, 9, NULL, 50, '2024-03-15 14:30:00'),

-- Normal type Pokemon
(27, 'Snorlax', 52, 18, NULL, 160, '2024-03-20 10:20:00'),
(28, 'Eevee', 20, 18, NULL, 55, '2024-01-05 16:40:00'),

-- Additional diverse Pokemon
(29, 'Gengar', 45, 15, NULL, 60, '2024-03-18 19:30:00'), -- Ghost
(30, 'Crobat', 48, 10, NULL, 85, '2024-03-22 11:45:00'), -- Poison
(31, 'Golem', 50, 14, NULL, 80, '2024-03-25 14:20:00'), -- Rock
(32, 'Pidgeot', 44, 12, NULL, 83, '2024-03-28 09:15:00'), -- Flying
(33, 'Scyther', 42, 13, NULL, 70, '2024-04-01 16:30:00'), -- Bug
(34, 'Sandslash', 39, 11, NULL, 75, '2024-04-05 13:10:00'), -- Ground
(35, 'Magnezone', 47, 16, NULL, 70, '2024-04-08 10:45:00'), -- Steel
(36, 'Gardevoir', 46, 17, NULL, 68, '2024-04-12 15:20:00'); -- Fairy

-- Insert Moves data
INSERT INTO "Moves" ("Id", "Name", "Power", "TypeId") VALUES
-- Fire moves
(1, 'Flamethrower', 90, 1),
(2, 'Fire Blast', 110, 1),
(3, 'Ember', 40, 1),
(4, 'Fire Punch', 75, 1),
(5, 'Heat Wave', 95, 1),

-- Water moves
(6, 'Surf', 90, 2),
(7, 'Hydro Pump', 110, 2),
(8, 'Water Gun', 40, 2),
(9, 'Bubble Beam', 65, 2),
(10, 'Aqua Tail', 90, 2),

-- Grass moves
(11, 'Solar Beam', 120, 3),
(12, 'Vine Whip', 45, 3),
(13, 'Razor Leaf', 55, 3),
(14, 'Petal Dance', 120, 3),
(15, 'Energy Ball', 90, 3),

-- Electric moves
(16, 'Thunderbolt', 90, 4),
(17, 'Thunder', 110, 4),
(18, 'Thunder Shock', 40, 4),
(19, 'Thunder Wave', 0, 4),
(20, 'Discharge', 80, 4),

-- Psychic moves
(21, 'Psychic', 90, 5),
(22, 'Confusion', 50, 5),
(23, 'Psybeam', 65, 5),
(24, 'Teleport', 0, 5),
(25, 'Future Sight', 120, 5),

-- Ice moves
(26, 'Ice Beam', 90, 6),
(27, 'Blizzard', 110, 6),
(28, 'Powder Snow', 40, 6),
(29, 'Aurora Beam', 65, 6),
(30, 'Ice Punch', 75, 6),

-- Dragon moves
(31, 'Dragon Rage', 40, 7),
(32, 'Dragon Claw', 80, 7),
(33, 'Outrage', 120, 7),
(34, 'Dragon Pulse', 85, 7),

-- Dark moves
(35, 'Dark Pulse', 80, 8),
(36, 'Bite', 60, 8),
(37, 'Crunch', 80, 8),
(38, 'Night Shade', 60, 8),

-- Fighting moves
(39, 'Close Combat', 120, 9),
(40, 'Focus Punch', 150, 9),
(41, 'Karate Chop', 50, 9),
(42, 'Brick Break', 75, 9),

-- Poison moves
(43, 'Poison Jab', 80, 10),
(44, 'Sludge Bomb', 90, 10),
(45, 'Toxic', 0, 10),

-- Ground moves
(46, 'Earthquake', 100, 11),
(47, 'Dig', 80, 11),
(48, 'Earth Power', 90, 11),

-- Flying moves
(49, 'Air Slash', 75, 12),
(50, 'Hurricane', 110, 12),
(51, 'Wing Attack', 60, 12),

-- Bug moves
(52, 'Bug Buzz', 90, 13),
(53, 'X-Scissor', 80, 13),
(54, 'Silver Wind', 60, 13),

-- Rock moves
(55, 'Rock Slide', 75, 14),
(56, 'Stone Edge', 100, 14),
(57, 'Rock Throw', 50, 14),

-- Ghost moves
(58, 'Shadow Ball', 80, 15),
(59, 'Night Shade', 60, 15),
(60, 'Lick', 30, 15),

-- Steel moves
(61, 'Iron Tail', 100, 16),
(62, 'Steel Wing', 70, 16),
(63, 'Flash Cannon', 80, 16),

-- Fairy moves
(64, 'Moonblast', 95, 17),
(65, 'Dazzling Gleam', 80, 17),
(66, 'Fairy Wind', 40, 17),

-- Normal moves
(67, 'Tackle', 40, 18),
(68, 'Body Slam', 85, 18),
(69, 'Hyper Beam', 150, 18),
(70, 'Quick Attack', 40, 18),
(71, 'Slash', 70, 18);

-- Insert PokemonMoves data (linking Pokemon to their moves)
INSERT INTO "PokemonMoves" ("PokemonId", "MoveId") VALUES
-- Charizard moves (Fire/Flying)
(1, 1), -- Flamethrower
(1, 2), -- Fire Blast
(1, 49), -- Air Slash
(1, 68), -- Body Slam

-- Arcanine moves (Fire)
(2, 1), -- Flamethrower
(2, 4), -- Fire Punch
(2, 70), -- Quick Attack
(2, 36), -- Bite

-- Blastoise moves (Water)
(5, 6), -- Surf
(5, 7), -- Hydro Pump
(5, 26), -- Ice Beam
(5, 67), -- Tackle

-- Pikachu moves (Electric)
(12, 16), -- Thunderbolt
(12, 18), -- Thunder Shock
(12, 70), -- Quick Attack
(12, 67), -- Tackle

-- Venusaur moves (Grass/Poison)
(9, 11), -- Solar Beam
(9, 13), -- Razor Leaf
(9, 44), -- Sludge Bomb
(9, 68), -- Body Slam

-- Alakazam moves (Psychic)
(16, 21), -- Psychic
(16, 23), -- Psybeam
(16, 24), -- Teleport
(16, 22), -- Confusion

-- Dragonite moves (Dragon/Flying)
(21, 31), -- Dragon Rage
(21, 32), -- Dragon Claw
(21, 49), -- Air Slash
(21, 69), -- Hyper Beam

-- Gyarados moves (Water/Flying)
(6, 6), -- Surf
(6, 7), -- Hydro Pump
(6, 36), -- Bite
(6, 33), -- Outrage

-- Mewtwo moves (Psychic)
(17, 21), -- Psychic
(17, 69), -- Hyper Beam
(17, 22), -- Confusion
(17, 25), -- Future Sight

-- Machamp moves (Fighting)
(25, 39), -- Close Combat
(25, 40), -- Focus Punch
(25, 42), -- Brick Break
(25, 68), -- Body Slam

-- Gengar moves (Ghost/Poison)
(29, 58), -- Shadow Ball
(29, 44), -- Sludge Bomb
(29, 35), -- Dark Pulse
(29, 60), -- Lick

-- Lapras moves (Water/Ice)
(7, 6), -- Surf
(7, 26), -- Ice Beam
(7, 21), -- Psychic
(7, 68), -- Body Slam

-- Zapdos moves (Electric/Flying)
(15, 16), -- Thunderbolt
(15, 17), -- Thunder
(15, 49), -- Air Slash
(15, 70), -- Quick Attack

-- Umbreon moves (Dark)
(23, 35), -- Dark Pulse
(23, 36), -- Bite
(23, 21), -- Psychic
(23, 67), -- Tackle

-- Snorlax moves (Normal)
(27, 68), -- Body Slam
(27, 69), -- Hyper Beam
(27, 67), -- Tackle
(27, 71), -- Slash

-- Eevee moves (Normal)
(28, 67), -- Tackle
(28, 70), -- Quick Attack
(28, 68), -- Body Slam
(28, 36), -- Bite

-- Additional Pokemon moves
-- Crobat (Poison/Flying)
(30, 43), -- Poison Jab
(30, 49), -- Air Slash
(30, 70), -- Quick Attack
(30, 36), -- Bite

-- Golem (Rock/Ground)
(31, 55), -- Rock Slide
(31, 46), -- Earthquake
(31, 67), -- Tackle
(31, 68), -- Body Slam

-- Pidgeot (Normal/Flying)
(32, 49), -- Air Slash
(32, 51), -- Wing Attack
(32, 70), -- Quick Attack
(32, 67), -- Tackle

-- Scyther (Bug/Flying)
(33, 53), -- X-Scissor
(33, 49), -- Air Slash
(33, 70), -- Quick Attack
(33, 71), -- Slash

-- Magnezone (Electric/Steel)
(35, 16), -- Thunderbolt
(35, 20), -- Discharge
(35, 63), -- Flash Cannon
(35, 61), -- Iron Tail

-- Gardevoir (Psychic/Fairy)
(36, 21), -- Psychic
(36, 64), -- Moonblast
(36, 24), -- Teleport
(36, 65); -- Dazzling Gleam

-- Create some useful views for common queries
CREATE VIEW "PokemonWithTypes" AS
SELECT 
    p."Id",
    p."Name" AS "PokemonName",
    p."Level",
    p."Health",
    e."Name" AS "TypeName",
    p."CaughtAt"
FROM "Pokemon" p
JOIN "Elements" e ON p."TypeId" = e."Id";

CREATE VIEW "PokemonMoveDetails" AS
SELECT 
    p."Name" AS "PokemonName",
    m."Name" AS "MoveName",
    m."Power",
    e."Name" AS "MoveType"
FROM "PokemonMoves" pm
JOIN "Pokemon" p ON pm."PokemonId" = p."Id"
JOIN "Moves" m ON pm."MoveId" = m."Id"
JOIN "Elements" e ON m."TypeId" = e."Id"
ORDER BY p."Name", m."Name";

-- Update sequences to match the highest inserted IDs
SELECT setval(pg_get_serial_sequence('"Elements"', 'Id'), (SELECT MAX("Id") FROM "Elements"));
SELECT setval(pg_get_serial_sequence('"Pokemon"', 'Id'), (SELECT MAX("Id") FROM "Pokemon"));
SELECT setval(pg_get_serial_sequence('"Moves"', 'Id'), (SELECT MAX("Id") FROM "Moves"));
SELECT setval(pg_get_serial_sequence('"PokemonMoves"', 'Id'), (SELECT MAX("Id") FROM "PokemonMoves"));

-- Display summary information
SELECT 'Database Setup Complete!' AS status;
SELECT COUNT(*) AS "Total Elements" FROM "Elements";
SELECT COUNT(*) AS "Total Pokemon" FROM "Pokemon";
SELECT COUNT(*) AS "Total Moves" FROM "Moves";
SELECT COUNT(*) AS "Total Pokemon-Move Relationships" FROM "PokemonMoves";