SELECT * from product where price >= all(SELECT price from account);
SELECT * from product where price =  (SELECT max(price) from account);
SELECT * from product where price in (SELECT min(price) from account);

SELECT oid from item group by oid having count(*) >= all(SELECT count(*) from item group by oid);

SELECT * from ptag where tag =  ' ' or tag = ' ';

