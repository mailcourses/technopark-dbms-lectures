set search_path = public;
create extension if not exists moddatetime;
create extension if not exists ltree;
create extension if not exists pgcrypto;
create extension if not exists "uuid-ossp";

create schema if not exists checkpoint_movies;
set search_path = checkpoint_movies;
create table movie
(
    mid      integer not null primary key,
    title    text,
    year     integer,
    director text
);

create table reviewer
(
    rid  integer not null primary key,
    name text
);

create table rating
(
    rid        integer not null,
    mid        integer not null,
    stars      integer,
    ratingdate date,

    foreign key (rid) references reviewer (rid),
    foreign key (mid) references movie (mid)
);

insert into movie (mid, title, year, director)
values (101, 'Gone with the Wind', 1939, 'Victor Fleming'),
       (102, 'Star Wars', 1977, 'George Lucas'),
       (103, 'The Sound of Music', 1965, 'Robert Wise'),
       (104, 'E.T.', 1982, 'Steven Spielberg'),
       (105, 'Titanic', 1997, 'James Cameron'),
       (106, 'Snow White', 1937, null),
       (107, 'Avatar', 2009, 'James Cameron'),
       (108, 'Raiders of the Lost Ark', 1981, 'Steven Spielberg');

insert into reviewer (rid, name)
values (201, 'Sarah Martinez'),
       (202, 'Daniel Lewis'),
       (203, 'Brittany Harris'),
       (204, 'Mike Anderson'),
       (205, 'Chris Jackson'),
       (206, 'Elizabeth Thomas'),
       (207, 'James Cameron'),
       (208, 'Ashley White');

insert into rating (rid, mid, stars, ratingdate)
values (201, 101, 2, '2011-01-22'),
       (201, 101, 4, '2011-01-27'),
       (202, 106, 4, null),
       (203, 103, 2, '2011-01-20'),
       (203, 108, 4, '2011-01-12'),
       (203, 108, 2, '2011-01-30'),
       (204, 101, 3, '2011-01-09'),
       (205, 103, 3, '2011-01-27'),
       (205, 104, 2, '2011-01-22'),
       (205, 108, 4, null),
       (206, 107, 3, '2011-01-15'),
       (206, 106, 5, '2011-01-19'),
       (207, 107, 5, '2011-01-20'),
       (208, 104, 3, '2011-01-02');



create schema if not exists checkpoint_highschooler;
set search_path = checkpoint_highschooler;

create table highschooler
(
    id    serial primary key,
    name  text     not null,
    grade smallint not null
);
comment on table highschooler is 'Студент с уникальным ID. Имя и Класс.';

create table friend
(
    id1 int not null references highschooler (id),
    id2 int not null references highschooler (id),
    unique (id1, id2) deferrable initially deferred,
    unique (id2, id1) deferrable initially deferred
);
comment on table friend is 'Студент с ID1 друг студента с ID2. Дружба взаимная, если есть запись (123, 456), то есть и (456, 123).';

create table likes
(
    id1 int not null references highschooler (id),
    id2 int not null references highschooler (id),
    unique (id1, id2) deferrable initially deferred,
    unique (id2, id1) deferrable initially deferred
);
comment on table likes is 'Студенту с ID1 нравится студент с ID2. Симпатии не взаимны, если есть запись (123, 456), то необязательно есть (456, 123).';

insert into highschooler (id, name, grade)
values (1, 'Cassandra', 8),
       (2, 'Samantha', 8),
       (3, 'Elizabeth', 8),
       (4, 'Chris', 8),
       (5, 'Tom', 8),
       (6, 'Mike', 8),

       (7, 'Jade', 9),
       (8, 'Kitana', 9),
       (9, 'Mileena', 9),
       (10, 'Sonya', 9),
       (11, 'Jax', 9),
       (12, 'Johnny', 9),

       (13, 'Chandler', 10),
       (14, 'Monica', 10),
       (15, 'Joey', 10),
       (16, 'Phoebe', 10),
       (17, 'Ross', 10),
       (18, 'Rachel', 10),

       (19, 'Robb', 11),
       (20, 'Sansa', 11),
       (21, 'Arya', 11),
       (22, 'Brandon ', 11),
       (23, 'Rickon', 11),
       (24, 'Jon', 11)
;


alter sequence highschooler_id_seq restart with 25;

insert into friend
values (1, 2),  -- Cassandra - Samantha
       (1, 3),  -- Cassandra - Elizabeth
       (1, 4),  -- Cassandra - Chris
       (1, 5),  -- Cassandra - Tom
       (1, 6),  -- Cassandra - Mike
       (1, 7),  -- Cassandra - Jade
       (1, 13), -- Cassandra - Chandler
       (1, 19), -- Cassandra - Robb

       (2, 1), -- Samantha  - Cassandra
       (3, 1), -- Elizabeth - Cassandra
       (4, 1), -- Chris     - Cassandra
       (5, 1), -- Tom       - Cassandra
       (6, 1), -- Mike      - Cassandra
       (7, 1), -- Jade      - Cassandra
       (13, 1), -- Chandler - Cassandra
       (19, 1), -- Robb     - Cassandra

       -- all Friends TV characters are friends:
       (13, 14),
       (13, 15),
       (13, 16),
       (13, 17),
       (13, 18),
       (14, 13),
       (14, 15),
       (14, 16),
       (14, 17),
       (14, 18),
       (15, 13),
       (15, 14),
       (15, 16),
       (15, 17),
       (15, 18),
       (16, 13),
       (16, 14),
       (16, 15),
       (16, 17),
       (16, 18),
       (17, 13),
       (17, 14),
       (17, 15),
       (17, 16),
       (17, 18),
       (18, 13),
       (18, 14),
       (18, 15),
       (18, 16),
       (18, 17)
;

insert into checkpoint_highschooler.likes (id1, id2)
values (19, 1),  -- Robb - Cassandra
       (20, 12), -- Sansa - Johny
       (13, 14), -- Chandler - Monica
       (14, 13), -- Monica - Chandler
       (17, 18); -- Ross - Rachel
