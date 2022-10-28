-- Author: Robert Kern
-- Date: 10/28/2022
-- Desc: Contains the create statements for the Label, Band, and Artist domain tables
--       and the band_artist, song_band, and song_artist linking tables. 


-- ****** NOTES ******

-- foreign key constraints that link to tables not in my half were left
-- commented out for now.

-- select statements for testing purposes are at the bottom.

-- primary key identity() numbers can be adjusted to fit with the other half.

use master;
go
drop database MusicLibrary;
go
create database MusicLibrary;
go 
use MusicLibrary;
go 

create table LABEL (
    LabelID int identity(1000,1),
    LabelName char(20),
    DateFounded date,

    constraint label_labelid_pk primary key(LabelID) 
);
go

create table BAND (
    BandID int identity(2000,1),
    BandName char(20) not null,
    MembersNum tinyint not null,
    DateFormed date not null,
    DateDisbanded date,
    LabelID int not null,

    constraint band_bandid_pk primary key(BandID),
    constraint band_labelid_fk foreign key(LabelID) references LABEL(LabelID),
    constraint band_membersnum_ck check (MembersNum > 0)
);
go 

create table ARTIST (
    ArtistID int identity(3000, 1),
    ArtistName char(20) not null,
    ArtistRegion char(20),
    LabelID int not null,

    constraint artist_artistid_pk primary key(ArtistID),
    constraint artist_labelid_fk foreign key(LabelID) references LABEL(LabelID)
);
go

create table BAND_ARTIST (
    BandID int,
    ArtistID int,
    DateJoined date not null,
    DateLeft date,
    
    constraint band_artist_bandartistid_pk primary key(BandID, ArtistID),
    constraint band_artist_bandid_fk foreign key(BandID) references BAND(BandID),
    constraint band_artist_artistid_fk foreign key(ArtistID) references ARTIST(ArtistID)
);
go

create table SONG_BAND (
    SongID int,
    BandID int,

    constraint song_band_songbandid_pk primary key(SongID, BandID),
    -- constraint song_band_songid_fk foreign key(SongID) references SONG(SongID),
    constraint song_band_bandid_fk foreign key(BandID) references BAND(BandID)
);
go

create table SONG_ARTIST (
    SongID int,
    ArtistID int,

    constraint song_artist_songartistid_pk primary key(SongID, ArtistID),
    -- constraint song_artist_songid_fk foreign key(SongID) references SONG(SongID),
    constraint song_artist_artistid_fk foreign key(ArtistID) references ARTIST(ArtistID)
)


-- select *
-- from LABEL;
-- select *
-- from BAND;
-- select *
-- from ARTIST;
-- select *
-- from BAND_ARTIST;
-- select *
-- from SONG_BAND;
-- select *
-- from SONG_ARTIST;