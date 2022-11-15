-- Author: Robert Kern, Devendra Ranjan, Jenna Joseph, Theresa Khouri
-- Date: 10/29/2022
-- Desc: Contains the create statements for the MusicLibrary Database 
--		 Including the domain tables: 	Label, Band, Artist, Album, Song, and Genre
--		 and the linking tables: 		Song_Band, Song_Artist, Song_Genre, Song_Album, and Band_Artist
 

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


-- ###### START OF DOMAIN TABLES ######

--  Devendra's Code:

--Creates the Label Table
CREATE TABLE LABEL(
	LabelID     INT identity(1000, 1),
	LabelName   CHAR(40),
	DateFounded Date,
	constraint LABEL_LabelID_pk primary key(LabelID) 
);
go

-- Changed LabelName from CHAR(20) to CHAR(40) (Jenna 11/9/2022)

--Creates the Album Table
CREATE TABLE ALBUM
(
	AlbumID     INT      identity(2000, 1),
	AlbumLength SMALLINT not null,
	AlbumName   CHAR(35) not null,
	NumTracks   TINYINT  not null,
	ReleaseDate Date     not null,
	LabelID     INT      not null,
	constraint Album_AlbumID_pk primary key (AlbumID),

	constraint Label_LabelID_fk foreign key(LabelID) references LABEL(LabelID)
	on update cascade 
	on delete no action,
	
	constraint Album_Greater_zero check(AlbumLength > 0)
	-- ^^Makes sure that the albumlength attribute is greater than zero
);
go

-- Changed AlbumName from CHAR(20) to CHAR(35) (Jenna 11/9/2022)

--Creates Table song
CREATE TABLE SONG(
	SongID      INT      identity(3000, 1),
	ReleaseDate DATE     not null,
	SongTitle       CHAR(35) not null,
	SongLength      SMALLINT not null,
	BPM         SMALLINT,
	SongKey     CHAR(15),
	LabelID     INT      not null,
	constraint Song_Length_zero check(SongLength > 0),
	constraint Song_BPM_zero check(BPM > 0),
	constraint Song_SongID_pk primary key(SongID),
	constraint Song_LabelID_fk foreign key(LabelID) references LABEL(LabelID)
        on update cascade
        on delete no action

);
go

-- Should the song table be linked with the album table? (Jenna 11/9/2022)
-- Changed Title and Length to SongTitle and SongLength for clarity (Jenna 11/9/2022)
-- Changed SongKey from Char(3) to Char(15) (Jenna 11/9/2022)
-- Changed SongTitle from Char(15) to Char(35) (Jenna 11/9/2022)

--Creates the Genre table
CREATE TABLE GENRE(
	GenreID          INT 		 identity(4000, 1),
	GenreName        CHAR(15)    not null,
	GenreDescription VARCHAR(50) not null,	
	GenreRegionOrg   VARCHAR(20) not null,
	--Sets the primary key for genre
	constraint Genre_GenreID_pk primary key (GenreID)
);
go

--  Robert's Code:

create table BAND (
    BandID int identity(5000,1),
    BandName char(20) not null,
    MembersNum tinyint not null,
    DateFormed date not null,
    DateDisbanded date,
    LabelID int not null,

    constraint band_bandid_pk primary key(BandID),
    constraint band_labelid_fk foreign key(LabelID) references LABEL(LabelID)
	on update cascade 
	on delete no action,
    constraint band_membersnum_ck check (MembersNum > 0)
);
go 

create table ARTIST (
    ArtistID int identity(6000, 1),
    ArtistName char(20) not null,
    ArtistRegion char(20),
    LabelID int not null,

    constraint artist_artistid_pk primary key(ArtistID),
    constraint artist_labelid_fk foreign key(LabelID) references LABEL(LabelID)
	on update cascade 
	on delete no action
);
go
-- ###### END OF DOMAIN TABLES ######


-- ###### START OF LINKING TABLES ######

--  Devendra's Code:

--Creates a linking table between SONG and GENRE
CREATE TABLE SONG_GENRE(
	GenreID INT,
	SongID INT,
	constraint SONG_GENRE_Song_Genre_pk primary key(SongID, GenreID),
	constraint SONG_GENRE_SongID_fk foreign key (SongID) references SONG(SongID)
	on update cascade 
	on delete no action
	,
	constraint SONG_GENRE_GenreID_fk foreign key (GenreID) references GENRE(GenreID)
	on update cascade
	on delete no action
);
go

CREATE TABLE SONG_ALBUM(
	SongID  INT,
	AlbumID INT,
	constraint SONG_ALBUM_Song_Album_pk primary key(SongID, AlbumID),
	constraint SONG_ALBUM_SongID_fk foreign key (SongID) references SONG(SongID)
	on delete no action
	,
	constraint SONG_ALBUM_AlbumID_fk foreign key (AlbumID) references ALBUM(AlbumID)
	on update cascade 
	on delete no action
);
go

--  Robert's Code:
create table BAND_ARTIST (
    BandID int,
    ArtistID int,
    DateJoined date not null,
    DateLeft date,
    
    constraint band_artist_bandartistid_pk primary key(BandID, ArtistID),
    constraint band_artist_bandid_fk foreign key(BandID) references BAND(BandID)
	on delete no action
	,
    constraint band_artist_artistid_fk foreign key(ArtistID) references ARTIST(ArtistID)
	on update cascade 
	on delete no action
);
go

create table SONG_BAND (
    SongID int,
    BandID int,

    constraint song_band_songbandid_pk primary key(SongID, BandID),
    constraint song_band_songid_fk foreign key(SongID) references SONG(SongID)
	on delete no action
	,
    constraint song_band_bandid_fk foreign key(BandID) references BAND(BandID)
	on update cascade 
	on delete no action
);
go

create table SONG_ARTIST (
    SongID int,
    ArtistID int,

    constraint song_artist_songartistid_pk primary key(SongID, ArtistID),
    constraint song_artist_songid_fk foreign key(SongID) references SONG(SongID) 
        on update cascade 
        on delete no action
	,
    constraint song_artist_artistid_fk foreign key(ArtistID) references ARTIST(ArtistID)
	on delete no action
);
go
-- ###### END OF LINKING TABLES ######

-- Author: Jenna Joseph and Theresa Khouri
-- Date: 11/9/2022
-- Desc: Contains the insert statements for the MusicLibrary Database 

-- ###### START OF DATA INSERTION ######
-- Start of Jenna's code


INSERT INTO label (
	LabelName,
	DateFounded)
VALUES
	('Homewood Records',
	'1976'),
	('Plopscotch Records',
	'2014'),
	('Reprise',
	'1960'),
	('On and On Records',
	'2001'),
	('Mute Records',
	'1978'),
	('Moon Records',
	'1982'),
	('Warner Home Video',
	'1978'),
	('Nonesuch Records',
	'1964'),
	('V2 Records',
	'1996'),
	('Sire',
	'1966'),
	('Nice Life',
	'2016'),
	('Atlantic Records',
	'1947'),
	('A&M',
	'1962'),
	('Interscope',
	'1990'),
	('Rhino',
	'1978'),
	('Columbia Records',
	'1889'),
	('Capitol Studios',
	'1956'),
	('Atlantic Records UK',
	'2004'),
	('Young Money Entertainment',
	'2016'),
	('Warner Records',
	'1958'),
	('Lisn Music',
	'2009'),
	('Arista Nashville',
	'1989'),
	('TuneCore',
	'2005'),
	('Griselda Records',
	'2012'),
	('EMPIRE',
	NULL),
	('Universal Music Group',
	'1934-09-01'),
	('Motown',
	'1959-01-12'),
	('Boyz Entertainment LLC',
	NULL),
	('Money is not Everything Entertainment',
	NULL),
	('RCA Records',
	'1900-01-09'),
	('Roadrunner Records',
	'1980'),
	('Ruthless Records',
	'1986'),
	('Sony Music Entertainment',
	'1929-09-09'),
	('Dreamville Records',
	'2007'),
	('Lost Kids LLC',
	NULL),
	('Stones Throw Records',
	'1996'),
	('Kedar Entertainment Group',
	'1995'),
	('LaFace Records',
	'1989'),
	('Fueled by Ramen LLC',
	'1996'),
	('Def Jam Recordings',
	'1982')
	;
go

-- I'm listing length of songs and albums in seconds for now (Jenna 11/9/2022)
INSERT INTO album (
	AlbumLength,
	AlbumName,
	NumTracks,
	ReleaseDate,
	LabelID)
VALUES
	(1855,
	'Mother Earth''s Plantasia',
	10,
	'1976',
	1000),
	(521,
	'Baby Hotline/Tea Errors',
	2,
	'2019-03-21',
	1001),
	(2172,
	'Sundown',
	10,
	'1974-01-01',
	1002),
	(3645,
	'Tetra',
	14,
	'2012-09-03',
	1003),
	(2644,
	'Music for the Masses',
	14,
	'1987-09-28',
	1004),
	(2534,
	'Variety',
	11,
	'1984-04-25',
	1005),
	(521,
	'BLOODY STREAM',
	2,
	'2013-01-30',
	1006),
	(2483,
	'Attack & Release',
	12,
	'2008-04-01',
	/*1007 and */1008),
-- Any possible way to include two foreign keys on one entry? What to do about records with multiple labels... (Jenna 11/9/2022)
	(2318,
	'Little Creatures',
	9,
	'1985-06-10',
	1009),
	(1998,
	'Cuz I Love You',
	11,
	'2019-04-19',
	/*1010 and */1011),
	(4200,
	'Superunknown',
	15,
	'1994-03-08',
	1012),
	(3900,
	'Audioslave',
	14,
	'2002-11-18',
	1013),
	(261,
	'The Promise',
	1,
	'2017-03-10',
	1022),
	(2823,
	'Purple',
	11,
	'1994-06-07',
	1011),
	(2310,
	'Time Out',
	7,
	'1959-12-14',
	1015),
	(139,
	'Act Naturally',
	1,
	'1963-03-11',
	1016),
	(2797,
	'Fine Line',
	12,
	'2019-12-13',
	1015),
	(2760,
	'Divide',
	12,
	'2017-03-03',
	1011),
	(4874,
	'Views',
	20,
	'2016-04-29',
	1018),
	(3107,
	'Who Hurt You?',
	17,
	'2022-08-12',
	1019),
	(3300,
	'Blown Away',
	14,
	'2012-05-01',
	1021),
	(2982,
	'10',
	12,
	'2022-10-28',
	1023),
	(3161,
	'Call Me If You Get Lost',
	16,
	'2021-07-25',
	1015),
	(1440,
	'On & On',
	5,
	'1997',
	1036),
	(2104,
	'What''s Going On',
	9,
	'1971-05-21',
	1026),
	(2336,
	'Come Get It!',
	8,
	'1978-04-20',
	1026),
	(939,
	'Testers',
	7,
	'2019-04-09',
	1027),
	(3287,
	'Flawless Like Me',
	24,
	'2022-09-23',
	1024),
	(1227,
	'2 Faced',
	8,
	'2019-10-17',
	1028),
	(4387,
	'Stankonia',
	24,
	'2000-10-30',
	1037),
	(2333,
	'Riot!',
	11,
	'2007-06-12',
	1038),
	(3612,
	'Vol. 3: (The Subliminal Verses)',
	14,
	'2004-05-25',
	1030),
	(2907,
	'Straight Outta Compton',
	10,
	'1988-08-08',
	1031),
	(3780,
	'The OF Tape Vol. 2',
	18,
	'2012-03-20',
	1032),
	(3323,
	'Mirrorland',
	14,
	'2019-09-06',
	1033),
	(2026,
	'Remember My Name',
	10,
	'2015-06-02',
	1039),
	(3604,
	'The Forever Story',
	15,
	'2022-08-26',
	1033),
	(4680,
	'Wasteland',
	19,
	'2022-07-08',
	1034),
	(4680,
	'To Pimp A Butterfly',
	16,
	'2015-03-16',
	1013),
	(1977,
	'Yessir Whatever',
	12,
	'2013-06-18',
	1035)
	;
go


INSERT INTO song (
	ReleaseDate,
	SongTitle,
	SongLength,
	BPM,
	SongKey,
	LabelID)
VALUES
	('1976-01-01',
	'Plantasia',
	201,
	175,
	'A-flat major',
	1000),
	('2019-03-21',
	'Baby Hotline',
	290,
	120,
	'C major',
	1001),
	('1974-01-01',
	'Carefree Highway',
	225,
	85,
	'E major',
	1002),
	('2012-09-28',
	'Down The Road',
	207,
	111,
	'D minor',
	1003),
	('1987-09-28',
	'Behind The Wheel',
	318,
	125,
	'D minor',
	1004),
	('1984-04-25',
	'Plastic Love',
	291,
	103,
	'D minor',
	1005),
	('2013-01-30',
	'BLOODY STREAM',
	261,
	130,
	'A-flat major',
	1006),
	('2008-04-01',
	'Psychotic Girl',
	251,
	81,
	'D minor',
	1008),
	('1985-06-10',
	'Road to Nowhere',
	259,
	110,
	'D major',
	1009),
	('2019-04-19',
	'Juice',
	195,
	120,
	'G major',
	1011),
	('1994-03-08',
	'Spoonman',
	247,
	93,
	'G major',
	1012),
	('2002-11-18',
	'I am the Highway',
	335,
	175,
	'A minor',
	1013),
	('2017-03-10',
	'The Promise',
	261,
	146,
	'F minor',
	1022),
	('1994-06-07',
	'Big Empty',
	294,
	122,
	'C major',
	1011),
	('1959-12-14',
	'Take Five',
	324,
	174,
	'A-flat minor',
	1015),
	('1963-03-11',
	'Act Naturally',
	139,
	92,
	'G major',
	1016),
	('2019-12-13',
	'Adore You',
	207,
	99,
	'A-flat major',
	1015),
	('2017-03-03',
	'Perfect',
	263,
	95,
	'A-flat major',
	1011),
	('2016-04-29',
	'One Dance',
	173,
	104,
	'C-sharp major',
	1018),
	('2022-08-12',
	'It''s You',
	212,
	96,
	'B minor',
	1019),
	('2012-05-01',
	'Blown Away',
	240,
	137,
	'A minor',
	1021),
	('2022-10-28',
	'FlyGod Jr. (feat. DJ Drama)',
	202,
	140,
	'G minor',
	1023),
	('2021-07-25',
	'Lemonhead (feat. 42 Dugg)',
	130,
	137,
	'C-sharp major',
	1015),
	('1997',
	'On & On',
	226,
	80,
	'B minor',
	1025),
	('1971-05-21',
	'What''s Happening Brother',
	204,
	98,
	'F minor',
	1026),
	('1978-04-20',
	'Mary Jane',
	297,
	94,
	'B minor',
	1026),
	('2019-04-09',
	'Ghetto Boy Intro',
	160,
	97,
	'F-sharp minor',
	1027),
	('2022-09-23',
	'White House (feat. Babyface Ray)',
	108,
	137,
	'D major',
	1024),
	('2022-09-23',
	'Legendary',
	161,
	131,
	'B major',
	1028),
	('2000-10-30',
	'B.O.B. - Bombs Over Baghdad',
	304,
	154,
	'A major',
	1037),
	('2007-06-12',
	'Misery Business',
	211,
	173,
	'C-sharp major',
	1038),
	('2004-05-25',
	'Vermilion',
	316,
	168,
	'B minor',
	1030),
	('1988-08-08',
	'Straight Outta Compton',
	258,
	103,
	'A-flat major',
	1031),
	('2012-03-20',
	'Ya Know (feat. The Internet)',
	240,
	110,
	'G minor',
	1032),
	('2019-09-06',
	'LaLa Challenge',
	231,
	140,
	'B minor',
	1033),
	('2015-06-02',
	'Why Me',
	232,
	124,
	'D major',
	1039),
	('2022-07-08',
	'LOOSE CHANGE',
	226,
	85,
	'C-sharp minor',
	1034),
	('2015-03-16',
	'The Blacker the Berry',
	328,
	88,
	'B-flat major',
	1013),
	('2013-06-18',
	'Astronaut',
	129,
	89,
	'C-sharp major',
	1035);
go


-- Start of Theresa's code
insert into artist(
	ArtistName, ArtistRegion, LabelID
)
VALUES
	('Dave Brubeck', 'Concord, California', 1015),
	('Harry Styles', 'Redditch, England', 1015),
	('Buck Owens', 'Messa, Arizona', 1016),
	('Don Rich', 'Olympis, Washington',1016),
	('Doyle Holly', 'Perkins, Oklahoma', 1016),
	('Tom Brumley', 'Stella, Missouri', 1016),
	('Willie Cantu', 'California', 1016),
	('Doyle Kurtsinger', NULL, 1016),
	('Jerry Brightman', 'Akron,Ohio', 1016),
	('Jim Shaw', 'Michigan', 1016),
	('Jerry Wiggins', 'Oklahoma', 1016),
	('Jay Maness', 'California', 1016),
	('Jana Jae', 'Montana', 1016),
	('Wayne Wilson', 'West Virgina', 1016),
	('Merle Haggard', 'California', 1016),
	('Ronnie Jackson', NULL, 1016),
	('Jay McDonald', NULL, 1016),
	('Ken Presley',NULL, 1016),
	('Kenny Pierce', NULL, 1016),
	('Wayne Stone', 'North Carolina', 1016),
	('Buck Dupree', 'North Carolina', 1016),
	('George French', 'Wisconsin', 1016),
	('Ron Jackson', 'New Jersey', 1016),
	('Fred Gates', 'Detroit, Michigan', 1016),
	('David Wulfkuehler', NULL, 1016),
	('Rick Taylor', NULL, 1016),
	('Terry Christopherson', 'France', 1016),
    ('Ed Sheeran', 'England', 1015),
    ('Drake', 'Toronto, Canada', 1018),
    ('Ali Gatie', 'Aden, Yemen', 1019),
    ('Carrie Underwood', 'Muskogee, Oklahoma', 1021),
    ('Mort Garson', 'California', 1000),
	('Jack Stauber', 'McKean, Pennsylvania', 1001 ),
    ('Gordon Lighfoot', 'Orillia, Canada', 1002 ),
    ('Guillaume Jaulen', 'Paris, France',1003),
	('Sylvain Richard', 'Nantes, France', 1003),
	('Thomas Le Vexier', 'Nantes, France', 1003),
	('Martin Gore', 'United Kingdom',1004),
	('Dave Gahan', 'United Kingdom', 1004),
	('Vince Clarke','United kingdom', 1004),
	('Andy Fletcher', 'United Kingdom', 1004),
	('Alan Wilder', 'United Kingdom', 1004),
	('Mariya Takeuchi','Japan', 1005),
	('Kazusou Oda','Hiroshima, Japan', 1006),
	('Dan Auerbach', 'Akron, Ohio', 1008),
	('Patrick Carney', 'Akron, Ohio', 1008),
	('David Byrne', 'United Kingdom',1009),
	('Chris Frantz', 'Tennessee', 1009),
	('Tina Weymouth', 'Coronado, California', 1009),
	('Jerry Harrison', 'Milwaukee, Wisconsin', 1009),
	('Melissa Jefferson', 'Detroit, Michigan',1011),
	('Chris Cornell', 'Seattle, Washignton',1022),
	('Kim Thayil', 'Seattle, Washignton', 1012),
	('Hiro Yamamoto', 'Seattle, Washignton', 1012),
	('Matt Cameron', 'California', 1012),
	('Ben Shepherd', 'Okinawa, Japan', 1012),
	('Jason Everman', 'Ouzinkie, Alaska', 1012),
	('Scott Sundquist', 'Aberdeen, Washington', 1012),
	('Tom Morello', 'Harlem, New York', 1013),
	('Tim Commerford', 'Irvine, California', 1013),
	('Brad Wilk', 'Portland, Oregon', 1013),
	('Scott Weiland', 'San Jose, California', 1011),
	('Chester Bennington', 'Phoenix Arizona', 1011),
	('Jeff Gutt', 'Michigan', 1011),
	('Dean DeLeo' , 'Newark, New Jersey',1011),
	('Robert Deleo', 'New Jersey',1011),
	('Eric Kretz', 'San Jose, California', 1011),
	('Alvin Lamar Worthy', 'Buffalo, New York', 1023),
	('Tyree Cinque Simmons', 'Philadelphia', 1023),
	('Tyler Gregory Okonma', 'California', 1015),
	('Dion Marquise Hayes', 'Detroit, Michigan', 1015),
	('Erica Abi Wright', 'Dallas, Texas', 1025),
	('Marvin Gaye', 'Washignton, DC', 1026),
	('Rick James', 'Buffalo, New York', 1026),
	('Damario McCullough', 'Flint, Michigan', 1028),
	('Lucki Camel Jr.', 'Chicago, Illinois',1024),
	('Marcellus Register', 'Detroit, Michigan', 1024),
	('André Benjamin', 'Atlanta, Georgia',  1037),
	('Hayley Williams', 'Mississippi', 1038),
	('Taylor York', 'Nashville, Tennessee',1038),
	('Josh Farro', 'New Jersey', 1038),
	('Zac Farro', 'New Jersey', 1038),
	('Jeremey Davis', 'Arkansas', 1038),
	('Aaron Gillespie', 'Clearwater, Florida', 1038),
	('Hunter Lamb', 'Nashville, Tennessee', 1038),
	('Jason Bynum', 'Nasville, Tennessee', 1038),
	('John Hembree', 'Orlando Florida', 1038),
	('Josh Freese', 'Orlando Florida', 1038),
	('John Howard', 'Pennsylvania', 1038),
	('Corey Taylor', 'Des Moines, Iowa', 1030),
	('Joey Jordison','Des Moines, Iowa', 1030),
	('Mick Thomson', 'Des Moines, Iowa', 1030),
	('Shawn Crahan', 'Des Moines, Iowa', 1030),
	('Sid Wilson', 'Des Moines, Iowa', 1030),
	('Paul Gray', 'California', 1030),
	('Jim Root', 'Las Vegas, Nevada', 1030),
	('Chris Fehn', ' Des Moines, Iowa', 1030),
	('Craig Jones', 'Des Moines, Iowa', 1030),
	('Jay weinberg', 'New Jersey', 1030),
	('Alessandro Venturell', 'United Kingdom', 1030),
	('Michael Pfaff', 'New Jersey', 1030),
	('Anders Colsefni', 'Des Moines, Iowa', 1030),
	('Kun Nong', 'Unknown', 1030),
	('Donnie Steele', 'Des Moines, Iowa', 1030),
	('Greg Welts', 'Des Moines, Iowa', 1030),
	('Josh Brainard', 'Des Moines, Iowa', 1030),
	('Brandon Darner', 'Des Moines, Iowa', 1030),
	('Eric Wright (Easy -E', 'Compton, California', 1031),
	('Andre Young(Dr. Dre)', 'Compton, California', 1031),
	('OShea Jackson', 'Los Angeles, Cal', 1031),
	('Lorenzo Patterson', 'Compton, California', 1031),
	('Antoine Carraby', 'Los Angeles, Cal', 1031),
	('Tracy Curry', 'Dallas, Texas', 1031),
	('Kim Nazel', 'Compton, Cal', 1031),
	('Travis Bennett(Taco)', 'Los Angeles, Cal', 1032),
	('Sydney Bennett','Los Angeles, Cal', 1032),
	('Lucas Vercetti', 'Los Angeles, Cal', 1032),
	('Lionel Boyce (L-Boy)', 'Los Angeles, Cal', 1032),
	('Christopher Francis', 'Long Beach, Cal', 1032),
	('Davon Wilson)', 'Los Angeles, Cal', 1032),
	('Thebe Kgositsile' ,'Chicago, Illinois', 1032),
	('Gerard Long (Hodgy)', 'Trenton, New Jersey', 1032),
	('Na-Kel Smith', 'Los Angeles, Cal', 1032),
	('Left Brain', 'Los Angeles, Cal', 1032),
	('Dominique Cole', 'Inglewood, Cal', 1032),
	('Micheal Griffin II', 'Los Angeles, Cal', 1032),
	('Casey Jones', 'Inglewood, Cal', 1032),
	('Sagan Lockhart)', 'Los Angeles, Cal', 1032),
	('Hal Williams(Vritra)', 'Los Angeles, Cal', 1032),
	('Matthew Martin','Atlanta, Georgia',1032),
	('Brandun DeShay', 'Chicago, Illinois', 1032),
	('Johnny Venus', 'Atlanta, Georgia',1033),
	('Eian Parker','Atlanta, Georgia', 1033),
	('Durk Banks', 'Chicago,Illinois', 1033),
	('Christopher Wood', 'Columbia, Maryland',1034),
	('Kendrick Lamar', 'Compton, Cali',1013),
	('Otis Jackson', 'Oxnard, Cal', 1035);



insert into genre(
GenreName, GenreDescription, GenreRegionOrg
)
Values
	('Country', 'Music based in rural American culture.', 'Southern USA'),
	('Pop', 'Music with mass commercial appeal.', 'United States'),
	('Jazz', 'Complex music with polyrhythm and improvisation.','United States'),
	('R&B','Smooth, modern music with soul, funk and pop.','United States'),
	('Dancehall', 'Inspired by reggae with an emphasis on rhythm.','Jamaica'),
	('Alt Pop','Pop-inspired indie music.','United States'),
	('Gangsta Rap', 'Music based in American street gang culture.','United States'),
	('Soul','Music with r&b and gospel elements.','United States'),
	('Trap', 'Music with percussive beats and heavy bass.','Southern USA'),
	('Drum&Bass','Fast, syncopated beats with heavy basslines.', 'UK'),
	('Hardcore HipHop','Characterized by confrontation and aggression.','USA'),
	('ConsciousHipHop','Hiphop with lyrics dealing with social issues.','USA'),
	('Grunge', 'Loud, distorted music with a "sludgy" feel.','USA'),
	('Heavy metal','Aggressive and intense rock music.', 'USA'),
	('Hard rock','Heavier and more aggressive rock music.', 'USA'),
	('Stoner rock', 'Psychedelic and raw rock music.', 'USA'),
	('Trip Hop', 'Psychedelic fusion of hip hop and electronica.','Europe'),
	('Hip-Hop','Stylized rhythmic music with rap vocals.', 'New York'),
	('Folk Pop', 'Musical style that is acoustic based.', 'USA,Eurpoe'),
	('Electric', 'Music made using electronic instruments.', 'Germany'),
	('Experimental', 'Music made to push existing boundaries.', 'Eurpoe, USA'),
	('Ambient', 'Music emphasizing atmosphere and mood.', 'United Kingdom'),
	('Progressive Pop','Complex musical arrangements within pop music.', 'Europe'),
	('Psychedelic Pop', 'Music with elements of psychedelic rock and pop.', 'United States'),
	('Hypnagogic Pop', 'Music made to evoke nostalgia for the 1970s/1980s.', 'United States'),
	('Folk Rock', 'Acoustic music based in traditional songwriting.', 'USA, Canada, Eurpoe'),
	('Turntablism', 'Music manipulated and remixed by a DJ.',  'Europe'),
	('French House', 'French house music.',  'France'),
	('Electropop', 'Densely layed and compressed synthesizer music.', 'United Kingdom'),
	('Blues Rock','Fusion of electric blues and rock music.', 'USA, United Kingdom'),
	('Dance Rock','Disco dance of rock music.', 'United States'),
	('Alternate Dance','Musical of mixed rock.', 'United States'),
	('City Pop', 'Contemporary Japanese pop with Western influence.', 'Japan'),
	('J-Pop','Japanese pop music.', 'Japan'),
	('Acid Jazz', 'Combination of funk, hip hop, jazz and disco.',  'Europe'),
	('Blues Rock', 'Fusion of electric blues and rock music.',  'USA, Uniited Kingdom'),
	('Garage Rock', 'Rock music with an unsophisticated sound.',  'USA'),
	('Pop Rock', 'Pop music with rock and roll influence',  'USA'),
	('New Wave','Experimental rock music from the 70s to 90s.', 'Europe'),
	('Funk', 'Jazz influenced, emphasizing hypnotic groove.', 'USA'),
	('Rap', 'Music with rhythmically spoken word lyrics.', 'USA');

go
insert into band(
BandName, MembersNum, DateFormed, DateDisbanded, LabelID
)
Values
	('C2C','3','1998', NULL ,1003),
	('Depeche Mode','5','1980', NULL ,1004),
	('Black Keys','2','2001', NULL ,1008),
	('Talking Heads','4','1975','2002',1009),
	('Stone Temple Pilots','6','1989',NULL, 1011),
	('Soundgarden','7','1984','2018', 1012),
	('Audioslave', '4','2001', '2007', 1013),
	('OutKast', '2', '1992','2014', 1029),
	('Paramore', '3','2004',NULL, 1011),
	('Slipknot', '9', '1995',NULL, 1030),
	('N.W.A', '6', '1987','1991', 1031),
	('Odd Future','11', '2007', NULL,1032),
	('Earthgang', '2','2008',NULL, 1033),
	('The Buckaroos', '25', '1965', '1970', 1016);

select *
from artist;

select *
from band;

SELECT *
FROM label;

SELECT *
FROM album;

SELECT *
FROM song;

select *
from genre;
