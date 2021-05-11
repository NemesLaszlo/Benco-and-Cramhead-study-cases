-- Vevo
INSERT INTO vevo VALUES (1,'Vevő1','Budapest','111111','A',11000,'Körzet1',1,'Kulcs a lábtörlő alatt');
INSERT INTO vevo VALUES (2,'Vevő2','Debrecen','222222','A',12000,'Körzet1',1,'Balra az első ajtó az udvarban');
INSERT INTO vevo VALUES (3,'Vevő3','Miskolc','333333','B',13000,'Körzet1',2,'');
INSERT INTO vevo VALUES (4,'Vevő4','Szeged','444444','B',14000,'Körzet1',2,'Legalsó csengő');
INSERT INTO vevo VALUES (5,'Vevő5','Eger','555555','B',15000,'Körzet1',2,'');

-- Utalas
INSERT INTO utalas VALUES (1,1,10000);
INSERT INTO utalas VALUES (2,2,12000);
INSERT INTO utalas VALUES (3,3,14000);
INSERT INTO utalas VALUES (4,4,10000);
INSERT INTO utalas VALUES (5,5,13000);

-- Vasarloi_rendeles
INSERT INTO vasarloi_rendeles VALUES (1,1,TO_DATE('2019.01.23', 'YYYY.MM.DD'));
INSERT INTO vasarloi_rendeles VALUES (2,2,TO_DATE('2019.01.23', 'YYYY.MM.DD'));
INSERT INTO vasarloi_rendeles VALUES (3,3,TO_DATE('2019.01.23', 'YYYY.MM.DD'));
INSERT INTO vasarloi_rendeles VALUES (3,4,TO_DATE('2019.01.24', 'YYYY.MM.DD'));
INSERT INTO vasarloi_rendeles VALUES (4,5,TO_DATE('2019.01.24', 'YYYY.MM.DD'));
INSERT INTO vasarloi_rendeles VALUES (4,6,TO_DATE('2019.01.24', 'YYYY.MM.DD'));

-- Szamla (netto,afa,brutto)
INSERT INTO szamla VALUES (1,4321,TO_DATE('2019.01.26', 'YYYY.MM.DD'),TO_DATE('2019.01.26', 'YYYY.MM.DD'),8400,2268,10668);
INSERT INTO szamla VALUES (2,4322,TO_DATE('2019.01.26', 'YYYY.MM.DD'),TO_DATE('2019.01.26', 'YYYY.MM.DD'),7100,1917,9017);
INSERT INTO szamla VALUES (3,4323,TO_DATE('2019.01.26', 'YYYY.MM.DD'),TO_DATE('2019.01.26', 'YYYY.MM.DD'),8250,2227.5,10477.5);
INSERT INTO szamla VALUES (4,4324,TO_DATE('2019.01.27', 'YYYY.MM.DD'),TO_DATE('2019.01.27', 'YYYY.MM.DD'),13860,3742.2,17602.2);
INSERT INTO szamla VALUES (5,4325,TO_DATE('2019.01.27', 'YYYY.MM.DD'),TO_DATE('2019.01.27', 'YYYY.MM.DD'),12870,3474.9,16344.9);
INSERT INTO szamla VALUES (6,4326,TO_DATE('2019.01.27', 'YYYY.MM.DD'),TO_DATE('2019.01.27', 'YYYY.MM.DD'),7250,1957.5,9207.5);
-- Termekosztaly
INSERT INTO termekosztaly VALUES ('Konzerv',1);
INSERT INTO termekosztaly VALUES ('Üdítő',2);
INSERT INTO termekosztaly VALUES ('Egyéb',3);

-- Termek
INSERT INTO termek VALUES (1,'Almalé','liter',200,190,180,170,160,'Üdítő');
INSERT INTO termek VALUES (2,'Megylé','liter',250,240,230,220,210,'Üdítő');
INSERT INTO termek VALUES (3,'Babkonzerv','doboz',350,340,330,320,310,'Konzerv');
INSERT INTO termek VALUES (4,'Kukorica','doboz',150,140,130,120,110,'Konzerv');
INSERT INTO termek VALUES (5,'Cukor','kg',200,190,180,170,160,'Egyéb');
INSERT INTO termek VALUES (6,'Rizs','kg',400,390,380,370,360,'Egyéb');

-- Vasarloi_rendeles_sor
INSERT INTO vasarloi_rendeles_sor VALUES (1,1,10);
INSERT INTO vasarloi_rendeles_sor VALUES (1,2,20);
INSERT INTO vasarloi_rendeles_sor VALUES (1,3,5);
INSERT INTO vasarloi_rendeles_sor VALUES (2,1,10);
INSERT INTO vasarloi_rendeles_sor VALUES (2,5,14);
INSERT INTO vasarloi_rendeles_sor VALUES (2,3,5);
INSERT INTO vasarloi_rendeles_sor VALUES (2,4,6);
INSERT INTO vasarloi_rendeles_sor VALUES (3,1,10);
INSERT INTO vasarloi_rendeles_sor VALUES (3,5,14);
INSERT INTO vasarloi_rendeles_sor VALUES (3,3,5);
INSERT INTO vasarloi_rendeles_sor VALUES (3,6,6);
INSERT INTO vasarloi_rendeles_sor VALUES (4,1,12);
INSERT INTO vasarloi_rendeles_sor VALUES (4,5,11);
INSERT INTO vasarloi_rendeles_sor VALUES (4,2,20);
INSERT INTO vasarloi_rendeles_sor VALUES (4,4,16);
INSERT INTO vasarloi_rendeles_sor VALUES (4,6,8);
INSERT INTO vasarloi_rendeles_sor VALUES (5,1,11);
INSERT INTO vasarloi_rendeles_sor VALUES (5,3,17);
INSERT INTO vasarloi_rendeles_sor VALUES (5,6,5);
INSERT INTO vasarloi_rendeles_sor VALUES (5,4,26);
INSERT INTO vasarloi_rendeles_sor VALUES (6,2,10);
INSERT INTO vasarloi_rendeles_sor VALUES (6,5,14);
INSERT INTO vasarloi_rendeles_sor VALUES (6,3,5);
INSERT INTO vasarloi_rendeles_sor VALUES (6,4,6);

-- Szallito
INSERT INTO szallito VALUES (1,'Szállító1','Eger', 1555555);
INSERT INTO szallito VALUES (2,'Szállító2','Baja', 2555555);
INSERT INTO szallito VALUES (3,'Szállító3','Etyek',3555555);
INSERT INTO szallito VALUES (4,'Szállító4','Tokaj',4555555);

-- Termekjegyzek
INSERT INTO termekjegyzek VALUES (1,1,140);
INSERT INTO termekjegyzek VALUES (1,2,150);
INSERT INTO termekjegyzek VALUES (2,1,190);
INSERT INTO termekjegyzek VALUES (2,3,200);
INSERT INTO termekjegyzek VALUES (3,2,260);
INSERT INTO termekjegyzek VALUES (3,4,270);
INSERT INTO termekjegyzek VALUES (4,3,80);
INSERT INTO termekjegyzek VALUES (4,4,90);
INSERT INTO termekjegyzek VALUES (5,1,120);
INSERT INTO termekjegyzek VALUES (5,4,140);
INSERT INTO termekjegyzek VALUES (6,2,300);
INSERT INTO termekjegyzek VALUES (6,3,320);

-- Szallitoi_rendeles
INSERT INTO szallitoi_rendeles VALUES (1,TO_DATE('2019.01.23', 'YYYY.MM.DD'),TO_DATE('2019.01.24', 'YYYY.MM.DD'),1);
INSERT INTO szallitoi_rendeles VALUES (2,TO_DATE('2019.01.23', 'YYYY.MM.DD'),TO_DATE('2019.01.24', 'YYYY.MM.DD'),2);
INSERT INTO szallitoi_rendeles VALUES (3,TO_DATE('2019.01.23', 'YYYY.MM.DD'),TO_DATE('2019.01.24', 'YYYY.MM.DD'),3);
INSERT INTO szallitoi_rendeles VALUES (4,TO_DATE('2019.01.24', 'YYYY.MM.DD'),TO_DATE('2019.01.25', 'YYYY.MM.DD'),1);
INSERT INTO szallitoi_rendeles VALUES (5,TO_DATE('2019.01.24', 'YYYY.MM.DD'),TO_DATE('2019.01.25', 'YYYY.MM.DD'),2);
INSERT INTO szallitoi_rendeles VALUES (6,TO_DATE('2019.01.24', 'YYYY.MM.DD'),TO_DATE('2019.01.25', 'YYYY.MM.DD'),3);


-- Szallitoi_rendeles_sor (szrszam, cikkszam, mennyiseg)
INSERT INTO szallitoi_rendeles_sor VALUES (1, 1, 30);
INSERT INTO szallitoi_rendeles_sor VALUES (1, 2, 20);
INSERT INTO szallitoi_rendeles_sor VALUES (1, 5, 28);
INSERT INTO szallitoi_rendeles_sor VALUES (2, 3, 15);
INSERT INTO szallitoi_rendeles_sor VALUES (2, 6, 6);
INSERT INTO szallitoi_rendeles_sor VALUES (3, 4, 6);
INSERT INTO szallitoi_rendeles_sor VALUES (4, 1, 23);
INSERT INTO szallitoi_rendeles_sor VALUES (4, 2, 30);
INSERT INTO szallitoi_rendeles_sor VALUES (4, 5, 25);
INSERT INTO szallitoi_rendeles_sor VALUES (5, 3, 22);
INSERT INTO szallitoi_rendeles_sor VALUES (5, 6, 13);
INSERT INTO szallitoi_rendeles_sor VALUES (6, 4, 48);
