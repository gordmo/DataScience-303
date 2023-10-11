-- 1. jazz album count
SELECT COUNT(*) 
FROM album 
JOIN album_genre ON album.id = album_genre.album_id 
WHERE genre = 'Jazz';

-- 2. oldest album release year
SELECT MIN(year) 
FROM album;

-- 3. solo artist count
SELECT COUNT(*) 
FROM artist 
WHERE type = 'solo';

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
-- Assuming a field end_year in group_member table to track membership duration
SELECT AVG(end_year - EXTRACT(YEAR FROM joined_date)) 
FROM group_member 
WHERE end_year IS NOT NULL;

-- 8. years w/ exactly 8 album releases
SELECT year, COUNT(*) 
FROM album 
GROUP BY year 
HAVING COUNT(*) = 8;

-- 9. max # of diff members in a group
SELECT MAX(member_count) 
FROM (
    SELECT COUNT(*) AS member_count 
    FROM group_member 
    GROUP BY id
) AS member_counts;

-- 10. artist w/ most recent album
SELECT artist.name, MAX(album.year) 
FROM artist 
JOIN album ON artist.id = album.artist_id 
GROUP BY artist.name 
ORDER BY MAX(album.year) DESC 
LIMIT 1;

-- 11. groups christ thile has been in
SELECT group_name 
FROM group_member 
WHERE name = 'Chris Thile';

-- 12. members of foo fighters
-- Assuming a field end_year in group_member table to track membership duration
SELECT name, COALESCE(end_year, EXTRACT(YEAR FROM NOW())) - EXTRACT(YEAR FROM joined_date) AS years 
FROM group_member 
WHERE group_name = 'Foo Fighters' 
ORDER BY years DESC, name ASC;

-- 13. amy ray's 2020 album and producing label
SELECT album.title, label.name 
FROM album 
JOIN artist ON album.artist_id = artist.id 
JOIN label ON album.label_id = label.id 
WHERE artist.name = 'Amy Ray' AND album.year = 2020;

-- 14. artists w/ more than 10 songs from same label
SELECT artist.name 
FROM artist 
JOIN album ON artist.id = album.artist_id 
GROUP BY artist.name, album.label_id 
HAVING COUNT(album.id) > 10;

