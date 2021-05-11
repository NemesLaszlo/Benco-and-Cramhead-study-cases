CREATE TABLE szallito (
    szkod     INTEGER NOT NULL,
    nev       VARCHAR2(100 CHAR) NOT NULL,
    cim       VARCHAR2(100 CHAR) NOT NULL,
    telefon   VARCHAR2(100 CHAR) NOT NULL
);

ALTER TABLE szallito ADD CONSTRAINT szallito_pk PRIMARY KEY ( szkod );

CREATE TABLE szallitoi_rendeles (
    szrszam           INTEGER NOT NULL,
    rend_datum        DATE NOT NULL,
    beerkezes_datum   DATE,
    szkod             INTEGER NOT NULL
);

ALTER TABLE szallitoi_rendeles ADD CONSTRAINT szallitoi_rendeles_pk PRIMARY KEY ( szrszam );

CREATE TABLE szallitoi_rendeles_sor (
    szrszam     INTEGER NOT NULL,
    cikkszam    INTEGER NOT NULL,
    mennyiseg   INTEGER NOT NULL
);

CREATE TABLE szamla (
    vrszam              INTEGER NOT NULL,
    szamla_szam         INTEGER NOT NULL,
    szamla_datum        DATE NOT NULL,
    kiszallitas_datum   DATE NOT NULL,
    netto_osszeg        INTEGER NOT NULL,
    afa                 FLOAT NOT NULL,
    brutto_osszeg       FLOAT NOT NULL
);

CREATE UNIQUE INDEX szamla__idx ON
    szamla (
        vrszam
    ASC );

CREATE TABLE termek (
    cikkszam            INTEGER NOT NULL,
    megnevezes          VARCHAR2(1000 CHAR) NOT NULL,
    menny_egyseg        VARCHAR2(100 CHAR) NOT NULL,
    listaar             INTEGER NOT NULL,
    a_ar                INTEGER NOT NULL,
    b_ar                INTEGER NOT NULL,
    c_ar                INTEGER NOT NULL,
    d_ar                INTEGER NOT NULL,
    termekosztaly_nev   VARCHAR2(1000 CHAR) NOT NULL
);

ALTER TABLE termek ADD CONSTRAINT termek_pk PRIMARY KEY ( cikkszam );

CREATE TABLE termekjegyzek (
    cikkszam   INTEGER NOT NULL,
    szkod      INTEGER NOT NULL,
    ar         INTEGER NOT NULL
);

ALTER TABLE termekjegyzek ADD CONSTRAINT termekjegyzek_pk PRIMARY KEY ( cikkszam,
                                                                        szkod );

CREATE TABLE termekosztaly (
    termekosztaly_nev   VARCHAR2(1000 CHAR) NOT NULL,
    leltari_kod         INTEGER NOT NULL
);

ALTER TABLE termekosztaly ADD CONSTRAINT termekosztaly_pk PRIMARY KEY ( termekosztaly_nev );

CREATE TABLE utalas (
    utalas_id   INTEGER NOT NULL,
    vkod        INTEGER NOT NULL,
    osszeg      INTEGER NOT NULL
);

ALTER TABLE utalas ADD CONSTRAINT utalas_pk PRIMARY KEY ( utalas_id );

CREATE TABLE vasarloi_rendeles (
    vkod         INTEGER NOT NULL,
    vrszam       INTEGER NOT NULL,
    rend_datum   DATE NOT NULL
);

ALTER TABLE vasarloi_rendeles ADD CONSTRAINT vasarloi_rendeles_pk PRIMARY KEY ( vrszam );

CREATE TABLE vasarloi_rendeles_sor (
    vrszam      INTEGER NOT NULL,
    cikkszam    INTEGER NOT NULL,
    mennyiseg   INTEGER NOT NULL
);

ALTER TABLE vasarloi_rendeles_sor ADD CONSTRAINT vasarloi_rendeles_sor_pk PRIMARY KEY ( cikkszam,
                                                                                        vrszam );

CREATE TABLE vevo (
    vkod             INTEGER NOT NULL,
    nev              VARCHAR2(100 CHAR) NOT NULL,
    cim              VARCHAR2(100 CHAR) NOT NULL,
    telefon          VARCHAR2(100 CHAR) NOT NULL,
    kedvezmeny_kod   CHAR(1 CHAR),
    hitelkeret       INTEGER,
    korzet           VARCHAR2(100 CHAR) NOT NULL,
    zona             INTEGER NOT NULL,
    szall_utasitas   VARCHAR2(1000 CHAR)
);

ALTER TABLE vevo ADD CONSTRAINT vevo_pk PRIMARY KEY ( vkod );

--  ERROR: FK name length exceeds maximum allowed length(30) 
ALTER TABLE szallitoi_rendeles_sor
    ADD CONSTRAINT szallitoi_rendeles_sor_szallitoi_rendeles_fk FOREIGN KEY ( szrszam )
        REFERENCES szallitoi_rendeles ( szrszam );

ALTER TABLE szallitoi_rendeles
    ADD CONSTRAINT szallitoi_rendeles_szallito_fk FOREIGN KEY ( szkod )
        REFERENCES szallito ( szkod );

ALTER TABLE szamla
    ADD CONSTRAINT szamla_vasarloi_rendeles_fk FOREIGN KEY ( vrszam )
        REFERENCES vasarloi_rendeles ( vrszam );

ALTER TABLE termek
    ADD CONSTRAINT termek_termekosztaly_fk FOREIGN KEY ( termekosztaly_nev )
        REFERENCES termekosztaly ( termekosztaly_nev );

ALTER TABLE termekjegyzek
    ADD CONSTRAINT termekjegyzek_szallito_fk FOREIGN KEY ( szkod )
        REFERENCES szallito ( szkod );

ALTER TABLE termekjegyzek
    ADD CONSTRAINT termekjegyzek_termek_fk FOREIGN KEY ( cikkszam )
        REFERENCES termek ( cikkszam );

ALTER TABLE utalas
    ADD CONSTRAINT utalas_vevo_fk FOREIGN KEY ( vkod )
        REFERENCES vevo ( vkod );

--  ERROR: FK name length exceeds maximum allowed length(30) 
ALTER TABLE vasarloi_rendeles_sor
    ADD CONSTRAINT vasarloi_rendeles_sor_termek_fk FOREIGN KEY ( cikkszam )
        REFERENCES termek ( cikkszam );

--  ERROR: FK name length exceeds maximum allowed length(30) 
ALTER TABLE vasarloi_rendeles_sor
    ADD CONSTRAINT vasarloi_rendeles_sor_vasarloi_rendeles_fk FOREIGN KEY ( vrszam )
        REFERENCES vasarloi_rendeles ( vrszam );

ALTER TABLE vasarloi_rendeles
    ADD CONSTRAINT vasarloi_rendeles_vevo_fk FOREIGN KEY ( vkod )
        REFERENCES vevo ( vkod );