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
