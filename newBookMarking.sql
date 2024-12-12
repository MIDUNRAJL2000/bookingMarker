CREATE TABLE users(
user_id SERIAL PRIMARY KEY,
user_name VARCHAR(50) NOT NULL,
email VARCHAR(35),
created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);
SELECT * from users;

CREATE TABLE collections(
collection_id Serial Primary key,
name VARCHAR(40) NOT NULL,
owner_id INT REFERENCES users(user_id)
);

select * from collections;

CREATE TABLE bookmarks(
bookmark_id SERIAL PRIMARY KEY,
title VARCHAR(70) NOT NULL,
url VARCHAR(100) NOT NULL,
date DATE,
collection_id INT REFERENCES collections(collection_id),
book_owner INT references users(user_id)
);

select * from bookmarks;



create table tags(
tag_id serial Primary key,
name VARCHAR(80) NOT NULL
);

SELECT * FROM tags;

create table bookmark_tags(
book_id SERIAL PRIMARY KEY,
books_id INT REFERENCES bookmarks(bookmark_id),
tags_id INT REFERENCES tags(tag_id)
);

select * from bookmark_tags;

create table collection_shares(
collections_id SERIAL Primary key,
collection_date DATE,
collect_id INT REFERENCES collections(collection_id),
users_id INT REFERENCES users(user_id)
);

select * from collection_shares;

INSERT INTO users(user_name, email)
VALUES
('midun','midun123@gmail.com'),
('rahul','abghi123@gmail.com'),
('gokul','sashank242@gmail.com'),
('hari','srk242@gmail.com'),
('syam','sasuk242@gmail.com'),
('swapnil','har542@gmail.com'),
('reshma','asha001@gmail.com');

INSERT INTO collections( name, owner_id ) VALUES
('Development Resources', 1),
('Deploy Resources', 2),
('Design Resources', 2),
('Styling Resources', 3),
('DEV Resources', 4),
('Storage Resources', 6),
('AWS Resources', 5),
('Simulation Resources', 1);

INSERT INTO bookmarks(title, url, date, book_owner, collection_id) VALUES
('Autocad', 'https://autodesk12z.com', '11-12-23',1,1),
('Ansys', 'https://ansys12z.com', '10-2-23',1,2),
('NextJs', 'https://nextJs12z.com', '12-9-23',2,3),
('PowerBI', 'https://powerBI12z.com', '3-4-23',3,3),
('Python', 'https://python12z.com', '30-9-23',2,4),
('Java', 'https://java12z.com', '10-4-23',1,4);

INSERT INTO tags(name) VALUES
('Development'),
('Deploy'),
('Host'),
('Test'),
('UnitTest'),
('Simulation');

INSERT INTO bookmark_tags(books_id, tags_id) VALUES
(1,1),
(3,1),
(1,2),
(2,3),
(1,4),
(2,2);

INSERT INTO collection_shares(collection_date, collect_id, users_id) VALUES
('12-2-23',1,2),
('1-3-23',2,1),
('2-4-23',1,3),
('22-4-23',2,2),
('10-9-23',1,4),
('11-11-23',2,3);

SELECT bm.title, t.name, bm.url from bookmarks bm
INNER JOIN collections coll
ON coll.collection_id = bm.collection_id
INNER JOIN bookmark_tags bt
on bt.books_id = bm.bookmark_id
inner join tags t
on t.tag_id = bt.tags_id
where coll.name = 'Development Resources';

SELECT t.name, COUNT(t.tag_id)
from tags t
INNER JOIN bookmark_tags bt
on bt.tags_id = t.tag_id
group by t.name
order by count(t.tag_id) DESC
limit 10;

SELECT coll.name, us.email, count(DISTINCT bm.bookmark_id) from collections coll
inner join users us
on coll.owner_id = us.user_id
inner join bookmarks bm
on bm.collection_id = coll.collection_id
inner join collection_shares cs
on cs.collect_id = coll.collection_id
group by coll.name, us.email;


select us.user_name, us.email, count(bm.bookmark_id) as bookmarks_created,
count(cs.collections_id) as collections_shared from users us
join bookmarks bm on us.user_id = bm.book_owner
join collection_shares cs on us.user_id = cs.users_id
where bm.date > NOW() - INTERVAL '30 days'
and cs.collection_date > NOW() - INTERVAL '30 days'
group by us.user_name, us.email
order by collections_shared DESC;
