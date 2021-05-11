-- Ugyfel
INSERT INTO ugyfel VALUES ('Ugyfel1', 'Cim1', 6666666, 'Kapcs1');
INSERT INTO ugyfel VALUES ('Ugyfel2', 'Cim2', 7777777, 'Kapcs2');
INSERT INTO ugyfel VALUES ('Ugyfel3', 'Cim3', 8888888, 'Kapcs3');

-- Helyszin
INSERT INTO helyszin VALUES ('PH', 'Piros ház', 'Piros u. 1.', 1111111);
INSERT INTO helyszin VALUES ('FH', 'Fehér ház', 'Washington u. 1.', 2222222);
INSERT INTO helyszin VALUES ('ZH', 'Zöld ház', 'Zöld u. 1.', 3333333);

-- Oktato
INSERT INTO oktato VALUES ('GJ', 'Gipsz Jakab', 'I');
INSERT INTO oktato VALUES ('NB', 'Nagy Béla', 'N');
INSERT INTO oktato VALUES ('KJ', 'Kiss János', 'N');
INSERT INTO oktato VALUES ('VD', 'Vad Dalma', 'I');

-- Tanfolyam_tipus
INSERT INTO tanfolyam_tipus VALUES ('CST', 'Cégek stratégiai Tervezése', 5, 10, 30000, 'GJ');
INSERT INTO tanfolyam_tipus VALUES ('EXS', 'Exportáljunk a sikerért', 5, 10, 40000, 'VD');
INSERT INTO tanfolyam_tipus VALUES ('STS', 'Stratégiai tervezés', 5, 10, 25000, 'GJ');
INSERT INTO tanfolyam_tipus VALUES ('KZS', 'Közszereplés', 5, 10, 50000, 'VD');

-- Tanfolyam_tipus_arvaltozas
INSERT INTO tanfolyam_tipus_arvaltozas VALUES (1, 'CST', TO_DATE('2018.02.01', 'YYYY.MM.DD'), 35000);
INSERT INTO tanfolyam_tipus_arvaltozas VALUES (2, 'EXS', TO_DATE('2018.02.01', 'YYYY.MM.DD'), 45000);
INSERT INTO tanfolyam_tipus_arvaltozas VALUES (3, 'STS', TO_DATE('2018.02.01', 'YYYY.MM.DD'), 30000);

-- Tanfolyam
INSERT INTO tanfolyam VALUES ('CSTJAN1', 'CST', TO_DATE('2018.01.15', 'YYYY.MM.DD'), TO_DATE('2018.01.19', 'YYYY.MM.DD'), 'PH');
INSERT INTO tanfolyam VALUES ('CSTJAN2', 'CST', TO_DATE('2018.01.20', 'YYYY.MM.DD'), TO_DATE('2018.01.24', 'YYYY.MM.DD'), 'PH');
INSERT INTO tanfolyam VALUES ('CSTFEB1', 'CST', TO_DATE('2018.02.15', 'YYYY.MM.DD'), TO_DATE('2018.02.19', 'YYYY.MM.DD'), 'PH');
INSERT INTO tanfolyam VALUES ('EXSJAN1', 'EXS', TO_DATE('2018.01.15', 'YYYY.MM.DD'), TO_DATE('2018.01.19', 'YYYY.MM.DD'), 'ZH');
INSERT INTO tanfolyam VALUES ('EXSFEB1', 'EXS', TO_DATE('2018.02.15', 'YYYY.MM.DD'), TO_DATE('2018.02.19', 'YYYY.MM.DD'), 'ZH');
INSERT INTO tanfolyam VALUES ('STSJAN1', 'STS', TO_DATE('2018.01.20', 'YYYY.MM.DD'), TO_DATE('2018.01.24', 'YYYY.MM.DD'), 'FH');
INSERT INTO tanfolyam VALUES ('STSFEB1', 'STS', TO_DATE('2018.02.20', 'YYYY.MM.DD'), TO_DATE('2018.02.24', 'YYYY.MM.DD'), 'FH');
INSERT INTO tanfolyam VALUES ('KZSFEB1', 'KZS', TO_DATE('2018.02.10', 'YYYY.MM.DD'), TO_DATE('2018.02.14', 'YYYY.MM.DD'), 'ZH');

-- Oktato_kijeloles
INSERT INTO oktato_kijeloles VALUES('CSTJAN1', 'GJ');
INSERT INTO oktato_kijeloles VALUES('CSTJAN2', 'NB');
INSERT INTO oktato_kijeloles VALUES('CSTFEB1', 'KJ');
INSERT INTO oktato_kijeloles VALUES('EXSJAN1', 'VD');
INSERT INTO oktato_kijeloles VALUES('EXSFEB1', 'NB');
INSERT INTO oktato_kijeloles VALUES('STSJAN1', 'GJ');
INSERT INTO oktato_kijeloles VALUES('STSFEB1', 'NB');
INSERT INTO oktato_kijeloles VALUES('KZSFEB1', 'VD');

-- Foglalas
INSERT INTO foglalas VALUES(1, 'Ugyfel1', 'CSTJAN1', TO_DATE('2017.12.20', 'YYYY.MM.DD'), 'Lakatos Jakab', 'Megerositett');
INSERT INTO foglalas VALUES(2, 'Ugyfel1', 'CSTJAN1', TO_DATE('2017.12.20', 'YYYY.MM.DD'), 'Lakatos Andrea', 'Megerositett');
INSERT INTO foglalas VALUES(3, 'Ugyfel1', 'CSTJAN1', TO_DATE('2017.12.20', 'YYYY.MM.DD'), 'Lakatos Elek', 'Megerositett');
INSERT INTO foglalas VALUES(4, 'Ugyfel1', 'CSTJAN1', TO_DATE('2017.12.20', 'YYYY.MM.DD'), 'Lakatos Tibor', 'Megerositett');
INSERT INTO foglalas VALUES(5, 'Ugyfel1', 'CSTJAN1', TO_DATE('2017.12.20', 'YYYY.MM.DD'), 'Lakatos Gergely', 'Megerositett');
INSERT INTO foglalas VALUES(6, 'Ugyfel2', 'CSTJAN1', TO_DATE('2017.12.21', 'YYYY.MM.DD'), 'Kiss Jakab', 'Megerositett');
INSERT INTO foglalas VALUES(7, 'Ugyfel2', 'CSTJAN1', TO_DATE('2017.12.21', 'YYYY.MM.DD'), 'Kiss Andrea', 'Megerositett');
INSERT INTO foglalas VALUES(8, 'Ugyfel2', 'CSTJAN1', TO_DATE('2017.12.21', 'YYYY.MM.DD'), 'Kiss Elek', 'Megerositett');
INSERT INTO foglalas VALUES(9, 'Ugyfel2', 'CSTJAN1', TO_DATE('2017.12.21', 'YYYY.MM.DD'), 'Kiss Tibor', 'Megerositett');
INSERT INTO foglalas VALUES(10, 'Ugyfel2', 'CSTJAN1', TO_DATE('2017.12.21', 'YYYY.MM.DD'), 'Kiss Gergely', 'Megerositett');
INSERT INTO foglalas VALUES(11, 'Ugyfel3', 'CSTJAN1', TO_DATE('2017.12.22', 'YYYY.MM.DD'), 'Nagy Jakab', 'Megerositett + Készenlét');
INSERT INTO foglalas VALUES(12, 'Ugyfel3', 'CSTJAN1', TO_DATE('2017.12.22', 'YYYY.MM.DD'), 'Nagy Andrea', 'Megerositett + Készenlét');

INSERT INTO foglalas VALUES(13, 'Ugyfel2', 'CSTJAN2', TO_DATE('2017.12.10', 'YYYY.MM.DD'), 'Kiss Gizi', 'Megerositett');
INSERT INTO foglalas VALUES(14, 'Ugyfel2', 'CSTJAN2', TO_DATE('2017.12.10', 'YYYY.MM.DD'), 'Kiss Alma', 'Megerositett');
INSERT INTO foglalas VALUES(15, 'Ugyfel2', 'CSTJAN2', TO_DATE('2017.12.10', 'YYYY.MM.DD'), 'Kiss Viola', 'Megerositett');
INSERT INTO foglalas VALUES(16, 'Ugyfel2', 'CSTJAN2', TO_DATE('2017.12.10', 'YYYY.MM.DD'), 'Kiss Endre', 'Megerositett');
INSERT INTO foglalas VALUES(17, 'Ugyfel2', 'CSTJAN2', TO_DATE('2017.12.10', 'YYYY.MM.DD'), 'Kiss Dalma', 'Megerositett');

INSERT INTO foglalas VALUES(18, 'Ugyfel3', 'CSTFEB1', TO_DATE('2017.12.15', 'YYYY.MM.DD'), 'Nagy Alma', 'Megerositett');
INSERT INTO foglalas VALUES(19, 'Ugyfel3', 'CSTFEB1', TO_DATE('2017.12.15', 'YYYY.MM.DD'), 'Nagy Gergely', 'Megerositett');
INSERT INTO foglalas VALUES(20, 'Ugyfel3', 'CSTFEB1', TO_DATE('2017.12.15', 'YYYY.MM.DD'), 'Nagy Tibor', 'Megerositett');
INSERT INTO foglalas VALUES(21, 'Ugyfel3', 'CSTFEB1', TO_DATE('2017.12.15', 'YYYY.MM.DD'), 'Nagy Elek', 'Megerositett');
INSERT INTO foglalas VALUES(22, 'Ugyfel3', 'CSTFEB1', TO_DATE('2017.12.15', 'YYYY.MM.DD'), 'Nagy Endre', 'Megerositett');

INSERT INTO foglalas VALUES(23, 'Ugyfel1', 'EXSJAN1', TO_DATE('2017.12.18', 'YYYY.MM.DD'), 'Lakatos Alma', 'Megerositett');
INSERT INTO foglalas VALUES(24, 'Ugyfel1', 'EXSJAN1', TO_DATE('2017.12.18', 'YYYY.MM.DD'), 'Lakatos Endre', 'Megerositett');
INSERT INTO foglalas VALUES(25, 'Ugyfel1', 'EXSJAN1', TO_DATE('2017.12.18', 'YYYY.MM.DD'), 'Lakatos Viola', 'Megerositett');
INSERT INTO foglalas VALUES(26, 'Ugyfel1', 'EXSJAN1', TO_DATE('2017.12.18', 'YYYY.MM.DD'), 'Lakatos Attila', 'Megerositett');
INSERT INTO foglalas VALUES(27, 'Ugyfel1', 'EXSJAN1', TO_DATE('2017.12.18', 'YYYY.MM.DD'), 'Lakatos Imre', 'Megerositett');
INSERT INTO foglalas VALUES(28, 'Ugyfel1', 'EXSJAN1', TO_DATE('2017.12.18', 'YYYY.MM.DD'), 'Lakatos Ambrus', 'Megerositett');

INSERT INTO foglalas VALUES(29, 'Ugyfel2', 'EXSFEB1', TO_DATE('2017.12.28', 'YYYY.MM.DD'), 'Kiss Gizi', 'Megerositett');
INSERT INTO foglalas VALUES(30, 'Ugyfel2', 'EXSFEB1', TO_DATE('2017.12.28', 'YYYY.MM.DD'), 'Kiss Endre', 'Megerositett');
INSERT INTO foglalas VALUES(31, 'Ugyfel2', 'EXSFEB1', TO_DATE('2017.12.28', 'YYYY.MM.DD'), 'Kiss Dalma', 'Megerositett');
INSERT INTO foglalas VALUES(32, 'Ugyfel2', 'EXSFEB1', TO_DATE('2017.12.28', 'YYYY.MM.DD'), 'Kiss Jakab', 'Megerositett');
INSERT INTO foglalas VALUES(33, 'Ugyfel2', 'EXSFEB1', TO_DATE('2017.12.28', 'YYYY.MM.DD'), 'Kiss Ambrus', 'Megerositett');

INSERT INTO foglalas VALUES(34, 'Ugyfel3', 'STSJAN1', TO_DATE('2017.12.20', 'YYYY.MM.DD'), 'Nagy Gergely', 'Megerositett');
INSERT INTO foglalas VALUES(35, 'Ugyfel3', 'STSJAN1', TO_DATE('2017.12.20', 'YYYY.MM.DD'), 'Nagy Elek', 'Megerositett');
INSERT INTO foglalas VALUES(36, 'Ugyfel3', 'STSJAN1', TO_DATE('2017.12.20', 'YYYY.MM.DD'), 'Nagy Gizi', 'Megerositett');
INSERT INTO foglalas VALUES(37, 'Ugyfel3', 'STSJAN1', TO_DATE('2017.12.20', 'YYYY.MM.DD'), 'Nagy Tibor', 'Megerositett');
INSERT INTO foglalas VALUES(38, 'Ugyfel3', 'STSJAN1', TO_DATE('2017.12.20', 'YYYY.MM.DD'), 'Nagy Lajos', 'Megerositett');
INSERT INTO foglalas VALUES(39, 'Ugyfel3', 'STSJAN1', TO_DATE('2017.12.20', 'YYYY.MM.DD'), 'Nagy Imre', 'Megerositett');

INSERT INTO foglalas VALUES(40, 'Ugyfel1', 'STSFEB1', TO_DATE('2017.12.22', 'YYYY.MM.DD'), 'Lakatos Andrea', 'Megerositett');
INSERT INTO foglalas VALUES(41, 'Ugyfel1', 'STSFEB1', TO_DATE('2017.12.22', 'YYYY.MM.DD'), 'Lakatos Imre', 'Megerositett');
INSERT INTO foglalas VALUES(42, 'Ugyfel1', 'STSFEB1', TO_DATE('2017.12.22', 'YYYY.MM.DD'), 'Lakatos Gergely', 'Megerositett');
INSERT INTO foglalas VALUES(43, 'Ugyfel2', 'STSFEB1', TO_DATE('2017.12.21', 'YYYY.MM.DD'), 'Kiss Gergely', 'Ideiglenes');
INSERT INTO foglalas VALUES(44, 'Ugyfel2', 'STSFEB1', TO_DATE('2017.12.21', 'YYYY.MM.DD'), 'Kiss Elek', 'Ideiglenes');
INSERT INTO foglalas VALUES(45, 'Ugyfel2', 'STSFEB1', TO_DATE('2017.12.21', 'YYYY.MM.DD'), 'Kiss Andrea', 'Ideiglenes');

INSERT INTO foglalas VALUES(46, 'Ugyfel2', 'KZSFEB1', TO_DATE('2017.12.12', 'YYYY.MM.DD'), 'Kiss Andrea', 'Megerositett');
INSERT INTO foglalas VALUES(47, 'Ugyfel2', 'KZSFEB1', TO_DATE('2017.12.12', 'YYYY.MM.DD'), 'Kiss Elek', 'Megerositett');
INSERT INTO foglalas VALUES(48, 'Ugyfel2', 'KZSFEB1', TO_DATE('2017.12.12', 'YYYY.MM.DD'), 'Kiss Gergely', 'Megerositett');
INSERT INTO foglalas VALUES(49, 'Ugyfel1', 'KZSFEB1', TO_DATE('2017.12.23', 'YYYY.MM.DD'), 'Lakatos Andrea', 'Megerositett');
INSERT INTO foglalas VALUES(50, 'Ugyfel1', 'KZSFEB1', TO_DATE('2017.12.23', 'YYYY.MM.DD'), 'Lakatos Endre', 'Megerositett');
INSERT INTO foglalas VALUES(51, 'Ugyfel1', 'KZSFEB1', TO_DATE('2017.12.23', 'YYYY.MM.DD'), 'Lakatos Elek', 'Megerositett');

-- Tanfolyam_ertekeles
INSERT INTO tanfolyam_ertekeles VALUES(1, 'CSTJAN1', 'Cegismeretek', 8, 4.25);
INSERT INTO tanfolyam_ertekeles VALUES(2, 'CSTJAN1', 'Cegjog', 6, 4.5);
INSERT INTO tanfolyam_ertekeles VALUES(3, 'CSTJAN2', 'Cegismeretek', 5, 4.8);
INSERT INTO tanfolyam_ertekeles VALUES(4, 'CSTJAN2', 'Cegjog', 5, 4.2);
