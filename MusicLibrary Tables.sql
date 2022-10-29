use master;
go
--Creates and Names the database
drop database MusicLibrary;
go
create database MusicLibrary;
go
--Switches from master to MusicLibrary
use MusicLibrary;
go
--START OF DOMAIN TABLES

--Creates the Label Table

CREATE TABLE LABEL(
	LabelID     INT,
	LabelName   CHAR(20),
	DateFounded Date,
	constraint LABEL_LabelID_pk primary key(LabelID) 
)

--Creates the Album Table

CREATE TABLE ALBUM
(
	AlbumID     INT      not null,
	AlbumLength SMALLINT not null,
	AlbumName   CHAR(20) not null,
	NumTracks   TINYINT  not null,
	ReleaseDate Date     not null,
	LabelID     INT      not null,
	constraint Album_AlbumID_pk primary key (AlbumID),
	
	constraint Label_LabelID_fk foreign key(LabelID) references LABEL(LabelID),
	
	constraint Album_Greater_zero check(AlbumLength > 0)
	-- ^^Makes sure that the albumlength attribute is greater than zero
)
--Creates Table song
CREATE TABLE SONG(
	SongID      INT      not null,
	ReleaseDate DATE     not null,
	Title       CHAR(15) not null,
	Length      SMALLINT not null,
	BPM         SMALLINT,
	SongKey     CHAR(3),
	LabelID     INT      not null,
	constraint Song_Length_zero check(Length > 0),
	constraint Song_BPM_zero check(BPM > 0),
	constraint Song_SongID_pk primary key(SongID),
	constraint Song_LabelID_fk foreign key(LabelID) references LABEL(LabelID)
)
--Creates the Genre table
CREATE TABLE GENRE(
	GenreID          INT,
	GenreName        CHAR(15)    not null,
	GenreDescription VARCHAR(50) not null,
	GenreRegionOrg   VARCHAR(20) not null,
	--Sets the primary key for genre
	constraint Genre_GenreID_pk primary key (GenreID)
)
--Creates a linking table between SONG and GENRE
-- START OF LINKING TABLES
CREATE TABLE SONG_GENRE(
	GenreID INT,
	SongID INT,
	constraint SONG_GENRE_Song_Genre_pk primary key(SongID, GenreID),
	constraint SONG_GENRE_SongID_fk foreign key (SongID) references SONG(SongID),
	constraint SONG_GENRE_GenreID_fk foreign key (GenreID) references GENRE(GenreID)
	)
CREATE TABLE SONG_ALBUM(
	SongID  INT,
	AlbumID INT,
	constraint SONG_ALBUM_Song_Album_pk primary key(SongID, AlbumID),
	constraint SONG_ALBUM_SongID_fk foreign key (SongID) references SONG(SongID),
	constraint SONG_ALBUMAlbumID_fk foreign key (AlbumID) references ALBUM(AlbumID)
)
--The Following Code was created by Robert
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
    constraint song_band_songid_fk foreign key(SongID) references SONG(SongID),
    constraint song_band_bandid_fk foreign key(BandID) references BAND(BandID)
);
go

create table SONG_ARTIST (
    SongID int,
    ArtistID int,

    constraint song_artist_songartistid_pk primary key(SongID, ArtistID),
    constraint song_artist_songid_fk foreign key(SongID) references SONG(SongID),
    constraint song_artist_artistid_fk foreign key(ArtistID) references ARTIST(ArtistID)
);
go
