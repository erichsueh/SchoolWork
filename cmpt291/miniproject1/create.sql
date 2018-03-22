-- Let's drop the tables in case they exist from previous runs
drop table includes;
drop table lists;
drop table retweets;
drop table mentions;
drop table hashtags;
drop table tweets;
drop table follows;
drop table users;

create table users (
  usr         int,
  pwd         char(4),
  name        char(20),
  email       char(15),
  city        char(12),
  timezone    float,
  primary key (usr)
);
create table follows (
  flwer       int,
  flwee       int,
  start_date  date,
  primary key (flwer,flwee),
  foreign key (flwer) references users,
  foreign key (flwee) references users
);
create table tweets (
  tid         int,
  writer      int,
  tdate       date,
  text        char(80),
  replyto     int,
  primary key (tid),
  foreign key (writer) references users,
  foreign key (replyto) references tweets
);
create table hashtags (
  term        char(10),
  primary key (term)
);
create table mentions (
  tid         int,
  term        char(10),
  primary key (tid,term),
  foreign key (tid) references tweets,
  foreign key (term) references hashtags
);
create table retweets (
  usr         int,
  tid         int,
  rdate       date,
  primary key (usr,tid),
  foreign key (usr) references users,
  foreign key (tid) references tweets
);
create table lists (
  lname        char(12),
  owner        int,
  primary key (lname),
  foreign key (owner) references users
);
create table includes (
  lname       char(12),
  member      int,
  primary key (lname,member),
  foreign key (lname) references lists,
  foreign key (member) references users
);

