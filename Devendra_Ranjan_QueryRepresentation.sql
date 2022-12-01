/*
AUTHOR: Devendra Ranjan 11/30/2022
Searches for all artists, and their bands (if they have one) that have an artist region inside of one of the following cities
Detroit, Michigan, Compton, California, Chicago, Illinois, or Los Angeles, CaliforniaThe reason this is an outerjoin is because
I want to show all of the artists that live in these places, but also show the bands they're in if they are in one. Bands in this
database are synonymous with groups and duos any collaborative artistic effort with more than one affiliate can be classified as a band.
*/

--Uses a full outer join a where clause, a multitable join and an order by statement

select artistname [Artist Name]
	,  bandname [Band Name]
	,  artistregion [Artist Region]
from band_artist ba full join artist a
	on ba.artistid = a.artistid
full join band b
	on ba.bandid = b.bandid
--where b.labelid = a.labelid
where artistregion in ('Detroit, Michigan', 'Compton, California', 'Chicago, Illinois', 'Los Angeles, California')
order by  bandname desc, artistname, artistregion;

/*
The general consideration for an EP is 30 minutes or less, therefore this database will interact with anything 
under 1800 seconds as if it were an EP if there was an albumtype attribute (which we didn't consider at the point
of theorizing our DB). Since we didn't, this dynamic query using a set operator will differentiate what kind of 
album these are based on the length.
*/

--Uses set operator union all, and where statement

select Albumname
	 , albumlength / 60 [Minutes] 
     , albumlength % 60 [Seconds]
	 , albumlength
	 , 'EP'
--Note I am considering singles that are realesed as if they were albums EPs
from album
where albumlength < 1800
union all
select Albumname
	 , albumlength / 60  
     , albumlength % 60 
	 , albumlength
	 , 'LP'
from album
where albumlength > 1800;
