-- 1. jazz album count
SELECT COUNT(*) 
FROM album 
JOIN album_genre ON album.id = album_genre.album_id 
WHERE genre = 'jazz';

-- 2. oldest album release year
SELECT MIN(year) 
FROM album;

-- 3. solo artist count
SELECT COUNT(*) 
FROM artist 
WHERE type = 'Person';

-- 4. artist's w/ names longer than 5 chars
SELECT COUNT(*) 
FROM artist 
WHERE LENGTH(name) > 5;

-- 5. album count pper genre
SELECT COUNT(*) 
FROM artist 
WHERE LENGTH(name) > 5;

-- 6. albums w/ more than 20 tracks
SELECT album.title, COUNT(track.number) 
FROM album 
JOIN track ON album.id = track.album_id 
GROUP BY album.title 
HAVING COUNT(track.number) > 20 
ORDER BY COUNT(track.number) DESC, album.title ASC;

-- 7. avg years spent in group
SELECT AVG(
    CASE 
        WHEN end_year IS NOT NULL THEN end_year - begin_year
        ELSE EXTRACT(YEAR FROM NOW()) - begin_year
    END
) AS average_years
FROM artist_member_xref
WHERE begin_year IS NOT NULL;

-- 8. years w/ exactly 8 album releases
SELECT year, COUNT(*) 
FROM album 
GROUP BY year 
HAVING COUNT(*) = 8;

-- 9. max # of diff members in a group
-- why does this not work?
SELECT MAX(member_count) 
FROM (
    SELECT COUNT(*) AS member_count 
    FROM group_member 
    GROUP BY id) 
AS member_counts;

-- 10. artist w/ most recent album
SELECT artist.name, MAX(album.year) 
FROM artist 
JOIN album ON artist.id = album.artist_id 
GROUP BY artist.name 
ORDER BY MAX(album.year) DESC 
LIMIT 1;

-- 11. groups christ thile has been in
SELECT name 
FROM group_member 
WHERE name = 'Chris Thile';

-- 12. members of foo fighters
-- Im only getting massive attack here for some reason
WITH FooFightersMembers AS (
    SELECT member_id, begin_year, end_year 
    FROM artist_member_xref 
    JOIN artist ON artist.id = artist_member_xref.artist_id 
    WHERE artist.name = 'Foo Fighters'
)
SELECT artist.name, 
    CASE 
        WHEN FooFightersMembers.end_year IS NOT NULL THEN FooFightersMembers.end_year - FooFightersMembers.begin_year
        ELSE EXTRACT(YEAR FROM NOW()) - FooFightersMembers.begin_year
    END AS years
FROM FooFightersMembers
JOIN artist ON FooFightersMembers.member_id = artist.id
ORDER BY years DESC, artist.name ASC;

-- 13. amy ray's 2020 album and producing label
SELECT album.title, label.name
FROM group_member
JOIN artist_member_xref ON group_member.id = artist_member_xref.member_id
JOIN artist ON artist.id = artist_member_xref.artist_id
JOIN album ON album.artist_id = artist.id
JOIN label ON album.label_id = label.id
WHERE group_member.name = 'Amy Ray' AND album.year = 2020;

-- 14. artists w/ more than 10 songs from same label
SELECT artist.name
FROM artist
WHERE EXISTS (
    SELECT 1
    FROM album
    WHERE artist.id = album.artist_id
    GROUP BY album.label_id
    HAVING COUNT(album.id) > 10
);

