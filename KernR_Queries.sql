use MusicLibrary;
go
 
--Query that uses a subquery to return songs slower than the average bpm
select songtitle as [Song Title]
       , songkey as [Key]
       , bpm
       , string_agg(trim(genrename), '/') as [Genre(s)]
from song s join SONG_GENRE sg
       on s.songid = sg.songid
       join genre g
       on g.genreid = sg.genreid
where bpm <
       (select avg(bpm)
       from song)
group by SongTitle, songkey, bpm
order by songkey asc, bpm asc;
 
--Query that uses a set operator to return songs by bands and artists that have a certain genre
select songtitle as [Song Title]
       , artistname as [Artist]
       , songkey as [Key]
       , bpm
       , string_agg(trim(genrename), '/') as [Genre(s)]
from song s join SONG_GENRE sg
       on s.songid = sg.songid
       join genre g
       on g.genreid = sg.genreid
       join SONG_ARTIST sa on s.songid = sa.songid
       join artist a on a.artistid = sa.artistid
group by SongTitle, ArtistName,songkey, bpm
having string_agg(trim(genrename), '/') like '%pop%'
union
select songtitle
       , bandname
       , songkey
       , bpm
       , string_agg(trim(genrename), '/') as [Genre(s)]
from song s join SONG_GENRE sg
       on s.songid = sg.songid
       join genre g
       on g.genreid = sg.genreid
       join SONG_BAND sb on s.songid = sb.songid
       join BAND b on b.bandid = sb.bandid
group by SongTitle, BandName, songkey, bpm
having string_agg(trim(genrename), '/') like '%pop%'
order by songkey asc, bpm asc;
