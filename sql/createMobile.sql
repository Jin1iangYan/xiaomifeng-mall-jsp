create database mobileDatabase;
use mobileDatabase;

create table user(
    logname char(30) not null,
    password varchar(30) character set utf8,
    phone char(20),
    address char(50) character set gb2312,
    realname char(60) character set gb2312,
    primary key(logname)
);

create table mobileClassify(
    id int not null auto_increment,
    name varchar(50) character set gb2312,
    primary key(id)
);

create table mobileForm(
    mobile_version char(30) not null,
    mobile_name varchar(50) character set gb2312,
    mobile_made varchar(20) character set gb2312,
    mobile_price float,
    mobile_mess varchar(600) character set gb2312,
    mobile_pic varchar(20) character set gb2312,
    id int not null auto_increment,
    primary key(mobile_version),
    foreign key(id) references mobileClassify(id)
);

create table shoppingForm(
    goodsId char(30) not null,
    logname char(30) not null,
    goodsName varchar(50) character set gb2312,
    goodsPrice float,
    goodsAmount int,
    foreign key(logname) references user(logname)
);

create table orderForm(
    orderNumber int not null auto_increment,
    logname char(30) character set gb2312,
    mess varchar(5000) character set gb2312,
    primary key(orderNumber)
);