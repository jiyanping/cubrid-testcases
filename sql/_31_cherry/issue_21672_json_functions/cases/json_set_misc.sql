SET @j = '{ "a": 1, "b": [2, 3]}';
SELECT JSON_SET(@j, '$.a', '10', '$.c', '[true, false]');
SELECT JSON_SET(@j, '$.a', json_array(@j), '$.c', json_array('true, false'));  
select json_set(@j, '$', json_array_append(@j, '$', '[true, false]'));
select json_valid(json_set(@j, '$.b', json_array_append(@j, '$', '[true, false]')));
drop table if exists t10;
create table t10(id int primary key auto_increment, name varchar collate utf8_en_ci, de json default json_array_append('{"bar": "baz", "balance": 7.77, "active":"false"}' collate utf8_en_ci, '$.balance', '{"ratio":"77%"}'));
insert into t10(id, name) values(1, '{"bar": "baz", "balance": 7.77, "active":"false"}');
insert into t10(id) values(2);
select json_set(name, '$.balance', '1') from t10; 
select json_set(name, '$.balancec', '1') from t10;
select json_set(name, '/balancec', '1') from t10; 
select json_set(name, '/balance', '1') from t10;
insert into t10(id, name) select rownum+10, json_set(name, '/balance', '1') from t10;
select json_set(@j, '$.add' , json_object('ccb', 'cc'));
update t10 set name = json_set(@j, '$.add' , json_object('ccb', 'cc'));
select * from t10 order by id;
update t10 set name=(select t10.name from t10 limit 1) where name = json_set(@j, '$.add' , json_object('ccb', 'cc'));
select * from t10 order by id;
select * from t10 where json_array_append(json_set(name, '$', '{"bar": "baz", "balance": 7.77, "active":"false"}'), '$.bar', '1') =json_array(name);
select * from t10 where json_array_append(json_set(name, '$', cast('{"bar": "baz", "balance": 7.77, "active":"false"}' as json)), '$.bar', '1') = json_array(name);
select * from t10 where json_array_append(json_set(name, '$', cast('{"bar": "baz", "balance": 7.77, "active":"false"}' as json)), '$.bar', '1') is not null order by id;
drop table if exists t;
create table t(id int, name json);
insert into t values(1, @j);
select * from t;
update t set name = json_set(name, '$.b', cast(@j as json)); 
update t set name = json_set(name, '$.c', cast(@j as json));  
select * from t;
update t set name = json_set(name, '$.c', (select json_extract(name, '$.c') from t));
update t set name = json_set(name, '$.c', json_array(true, false));
select * from t;
update t set name = json_set(name, '$.b.a', json_array(1, false)); 
update t set name = json_set(name, '$.b.a', json_array(@j, false)); 
select json_set('{}', '$.a', '"b"') ;
update t set name=json_set(name, '$.a', cast('{"schoolName": "MIT"}' as json));
select  * from t where cast(json_extract(json_set(name, '$.a', cast('{"schoolName": "MIT1"}' as json)), '$.a.schoolName') as string) = 'MIT1';

drop table if exists t;
drop table if exists t10;
drop VARIABLE @j;
 
