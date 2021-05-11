CREATE TABLE foglalas (
    foglalas_id      INTEGER NOT NULL,
    ugyfel_nev       VARCHAR2(50 CHAR) NOT NULL,
    tanfolyam_kod    VARCHAR2(20 CHAR) NOT NULL,
    foglalas_datum   DATE NOT NULL,
    resztvevo_nev    VARCHAR2(50 CHAR) NOT NULL,
    statusz          VARCHAR2(100 CHAR) NOT NULL
);

ALTER TABLE foglalas ADD CONSTRAINT foglalas_pk PRIMARY KEY ( foglalas_id );

CREATE TABLE helyszin (
    helyszin_kod   CHAR(10 CHAR) NOT NULL,
    nev            VARCHAR2(30 CHAR) NOT NULL,
    cim            VARCHAR2(100 CHAR) NOT NULL,
    telefon        VARCHAR2(20 CHAR) NOT NULL
);

ALTER TABLE helyszin ADD CONSTRAINT helyszin_pk PRIMARY KEY ( helyszin_kod );

CREATE TABLE oktato (
    oktato_kod     CHAR(10 CHAR) NOT NULL,
    nev            VARCHAR2(50 CHAR) NOT NULL,
    tanf_felelos   CHAR(1 CHAR) NOT NULL
);

ALTER TABLE oktato ADD CONSTRAINT oktato_pk PRIMARY KEY ( oktato_kod );

CREATE TABLE oktato_kijeloles (
    tanfolyam_kod   VARCHAR2(20 CHAR) NOT NULL,
    oktato_kod      CHAR(10 CHAR) NOT NULL
);

ALTER TABLE oktato_kijeloles ADD CONSTRAINT oktato_kijeloles_pk PRIMARY KEY ( tanfolyam_kod,
                                                                              oktato_kod );

CREATE TABLE resztvevo_torles (
    torles_id       INTEGER NOT NULL,
    tanfolyam_kod   VARCHAR2(20 CHAR) NOT NULL,
    ugyfel_nev      VARCHAR2(50 CHAR) NOT NULL,
    resztvevo_nev   VARCHAR2(50 CHAR) NOT NULL
);

ALTER TABLE resztvevo_torles ADD CONSTRAINT resztvevo_torles_pk PRIMARY KEY ( torles_id );

CREATE TABLE tanfolyam (
    tanfolyam_kod   VARCHAR2(20 CHAR) NOT NULL,
    tipus_kod       CHAR(10 CHAR) NOT NULL,
    kezdo_datum     DATE NOT NULL,
    vege_datum      DATE NOT NULL,
    helyszin_kod    CHAR(10 CHAR) NOT NULL
);

ALTER TABLE tanfolyam ADD CONSTRAINT tanfolyam_pk PRIMARY KEY ( tanfolyam_kod );

CREATE TABLE tanfolyam_ertekeles (
    ertekeles_id    INTEGER NOT NULL,
    tanfolyam_kod   VARCHAR2(20 CHAR) NOT NULL,
    temakor         VARCHAR2(50 CHAR) NOT NULL,
    darab           INTEGER NOT NULL,
    atlag           FLOAT NOT NULL
);

ALTER TABLE tanfolyam_ertekeles ADD CONSTRAINT tanfolyam_ertekeles_pk PRIMARY KEY ( ertekeles_id );

CREATE TABLE tanfolyam_tipus (
    tipus_kod     CHAR(10 CHAR) NOT NULL,
    nev           VARCHAR2(50 CHAR) NOT NULL,
    min_letszam   INTEGER NOT NULL,
    max_letszam   INTEGER NOT NULL,
    ar            INTEGER NOT NULL,
    oktato_kod    CHAR(10 CHAR) NOT NULL
);

ALTER TABLE tanfolyam_tipus ADD CONSTRAINT tanfolyam_tipus_pk PRIMARY KEY ( tipus_kod );

CREATE TABLE tanfolyam_tipus_arvaltozas (
    arvaltozas_id   INTEGER NOT NULL,
    tipus_kod       CHAR(10 CHAR) NOT NULL,
    kezdo_datum     DATE NOT NULL,
    ar              INTEGER NOT NULL
);

ALTER TABLE tanfolyam_tipus_arvaltozas ADD CONSTRAINT tanfolyam_tipus_arvaltozas_pk PRIMARY KEY ( arvaltozas_id );

CREATE TABLE tanfolyam_torles (
    tanfolyam_kod VARCHAR2(20 CHAR) NOT NULL
);

ALTER TABLE tanfolyam_torles ADD CONSTRAINT tanfolyam_torles_pk PRIMARY KEY ( tanfolyam_kod );

CREATE TABLE telefonos_megerosites (
    ugyfel_nev      VARCHAR2(50 CHAR) NOT NULL,
    tanfolyam_kod   VARCHAR2(20 CHAR) NOT NULL
);

ALTER TABLE telefonos_megerosites ADD CONSTRAINT telefonos_megerosites_pk PRIMARY KEY ( tanfolyam_kod,
                                                                                        ugyfel_nev );

CREATE TABLE ugyfel (
    ugyfel_nev        VARCHAR2(50 CHAR) NOT NULL,
    cim               VARCHAR2(100 CHAR) NOT NULL,
    telefon           VARCHAR2(20 CHAR) NOT NULL,
    kapcsolat_tarto   VARCHAR2(50 CHAR) NOT NULL
);

ALTER TABLE ugyfel ADD CONSTRAINT ugyfel_pk PRIMARY KEY ( ugyfel_nev );

ALTER TABLE foglalas
    ADD CONSTRAINT foglalas_tanfolyam_fk FOREIGN KEY ( tanfolyam_kod )
        REFERENCES tanfolyam ( tanfolyam_kod );

ALTER TABLE foglalas
    ADD CONSTRAINT foglalas_ugyfel_fk FOREIGN KEY ( ugyfel_nev )
        REFERENCES ugyfel ( ugyfel_nev );

ALTER TABLE oktato_kijeloles
    ADD CONSTRAINT oktato_kijeloles_oktato_fk FOREIGN KEY ( oktato_kod )
        REFERENCES oktato ( oktato_kod );

ALTER TABLE oktato_kijeloles
    ADD CONSTRAINT oktato_kijeloles_tanfolyam_fk FOREIGN KEY ( tanfolyam_kod )
        REFERENCES tanfolyam ( tanfolyam_kod );

--  ERROR: FK name length exceeds maximum allowed length(30) 
ALTER TABLE tanfolyam_ertekeles
    ADD CONSTRAINT tanfolyam_ertekeles_tanfolyam_fk FOREIGN KEY ( tanfolyam_kod )
        REFERENCES tanfolyam ( tanfolyam_kod );

ALTER TABLE tanfolyam
    ADD CONSTRAINT tanfolyam_helyszin_fk FOREIGN KEY ( helyszin_kod )
        REFERENCES helyszin ( helyszin_kod );

ALTER TABLE tanfolyam
    ADD CONSTRAINT tanfolyam_tanfolyam_tipus_fk FOREIGN KEY ( tipus_kod )
        REFERENCES tanfolyam_tipus ( tipus_kod );

--  ERROR: FK name length exceeds maximum allowed length(30) 
ALTER TABLE tanfolyam_tipus_arvaltozas
    ADD CONSTRAINT tanfolyam_tipus_arvaltozas_tanfolyam_tipus_fk FOREIGN KEY ( tipus_kod )
        REFERENCES tanfolyam_tipus ( tipus_kod );

ALTER TABLE tanfolyam_tipus
    ADD CONSTRAINT tanfolyam_tipus_oktato_fk FOREIGN KEY ( oktato_kod )
        REFERENCES oktato ( oktato_kod );

--  ERROR: FK name length exceeds maximum allowed length(30) 
ALTER TABLE telefonos_megerosites
    ADD CONSTRAINT telefonos_megerosites_tanfolyam_fk FOREIGN KEY ( tanfolyam_kod )
        REFERENCES tanfolyam ( tanfolyam_kod );

--  ERROR: FK name length exceeds maximum allowed length(30) 
ALTER TABLE telefonos_megerosites
    ADD CONSTRAINT telefonos_megerosites_ugyfel_fk FOREIGN KEY ( ugyfel_nev )
        REFERENCES ugyfel ( ugyfel_nev );