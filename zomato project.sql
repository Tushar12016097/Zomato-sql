drop table if exists goldusers_signup;
CREATE TABLE goldusers_signup(userid integer,gold_signup_date date); 

INSERT INTO goldusers_signup(userid,gold_signup_date) 
 VALUES (1,'2017-09-22'),
(3,'2017-04-21');

drop table if exists users;
CREATE TABLE users(userid integer,signup_date date); 

INSERT INTO users(userid,signup_date) 
 VALUES (1,'2014-09-02'),
(2,'2015-01-15'),
(3,'2014-04-11');

drop table if exists sales;
CREATE TABLE sales(userid integer,created_date date,product_id integer); 

INSERT INTO sales(userid,created_date,product_id) 
 VALUES (1,'2017-04-19',2),
(3,'2019-12-18',1),
(2,'2020-07-20',3),
(1,'2019-10-23',2),
(1,'2018-03-19',3),
(3,'2016-12-20',2),
(1,'2016-11-09',1),
(1,'2016-05-20',3),
(2,'2017-09-24',1),
(1,'2017-03-11',2),
(1,'2016-03-11',1),
(3,'2016-11-10',1),
(3,'2017-12-07',2),
(3,'2016-12-15',2),
(2,'2017-11-08',2),
(2,'2018-09-10',3);


drop table if exists product;
CREATE TABLE product(product_id integer,product_name text,price integer); 

INSERT INTO product(product_id,product_name,price) 
 VALUES
(1,'p1',980),
(2,'p2',870),
(3,'p3',330);


select * from sales;
select * from product;
select * from goldusers_signup;
select * from users;

----Questions and Queries-----

1. What is the total amount each customer spent on zomato ? 
Select a.userid , sum(b.price) total_amt_spent from slaes a inner join product b on a.product_id=b.product_id
group by a.userid

2.  how many days has each customer visited zomato ? 
select userid,count(distinct created_date) distinct_days from sales group by userid;

3.what was the first product purchased by each customer ?
(select *,rank() over(partition by userid order created_date) rnk from sales)  

select * from 
(select *,rank() over(partition by userid order created_date) rnk from sales)  a where rnk = 1

4. what is the most purchased item on the menu and how many times was it purchased by all customers ?
select userid,count(product_id) cnt from sales where product_id = 
(select top 1 product_id,count(product_id) cnt from sales group by product_id order by count(product_id) decs)
group by userid

5. what item was the most popular for each customer ?
select * from
(select *,rank() over(partition on userid order by cnt desc) rnk from
(select userid,product_id,count(product_id) from sales group by userid, product_id)a)b
where rnk = 1 

6. Which item was purchased first by the customer after they became the member ?
select a.userid,a.created_date,a.product_id,gold_signup_date from sales a inner join goldusers_signup b on a.userid = b.userid and date>gold_signup_date;

7. which item was purchased just before the customer became a member ?
(select c.*,rank() over (partition by userid order by created_date desc)rnk from 
(select a.userid,a.created_date,a.product_id,b.gold_signup_date from sales a inner join goldusers_signup b on a.userid = b.userid and created_date<=gold_signup_date)c)d where rnk = 1;

8. what is the total orders and amount spent for each member before they became the member ? 
