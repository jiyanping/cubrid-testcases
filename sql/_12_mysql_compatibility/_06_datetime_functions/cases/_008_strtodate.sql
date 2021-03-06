SELECT STR_TO_DATE('01,5,2013','%d,%m,%Y') FROM db_root;
SELECT STR_TO_DATE('May 1, 2013','%M %d,%Y') FROM db_root;
SELECT STR_TO_DATE('a09:30:17','a%h:%i:%s') FROM db_root;
SELECT STR_TO_DATE('a09:30:17','%h:%i:%s') FROM db_root;
SELECT STR_TO_DATE('09:30:17a','%h:%i:%s') FROM db_root;
SELECT STR_TO_DATE('abc','abc') FROM db_root;
SELECT STR_TO_DATE('9','%m') FROM db_root;
SELECT STR_TO_DATE('9','%s') FROM db_root;
SELECT STR_TO_DATE('00/00/0000', '%m/%d/%Y') FROM db_root;
SELECT STR_TO_DATE('04/31/2004', '%m/%d/%Y') FROM db_root;
