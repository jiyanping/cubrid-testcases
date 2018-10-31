/* 
Test Case: truncate
delete all data and commit while loading index with oline;
create unique index should be success.
*/

MC: setup NUM_CLIENTS = 4;

C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level read committed;

C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level read committed;

C3: set transaction lock timeout INFINITE;
C3: set transaction isolation level read committed;

/* preparation */
C1: DROP TABLE IF EXISTS t1;
C1: create table t1(i int primary key,j char(10),k int);
C1: insert into t1 select rownum,rownum,rownum from db_root connect by level<=30000;
C1: COMMIT;
MC: wait until C1 ready;

/* transaction mix */

/* This dummy "describe" is important to guarantee that online index build does not complete before other transaction starts and others have chances before index build completes */
C1: describe t1;
MC: wait until C1 ready;

C2: create unique index i on t1(k) with online;
MC: wait until C2 blocked;

C3: truncate table t1;
MC: wait until C3 unblocked;

C1: commit;
MC: wait until C2 unblocked;

C3: commit;
C2: commit;

/* C2 starts scan and will demote to IX. C3 and C4 will resume */

/* C2 should be blocked to promote to SCH_M */


/* verification */
C1: select sum(set{k}) into :s from t1 ignore index (i) where k > -999 order by 1;
C1: select sum(set{k}) into :i from t1 force index (i) where k > -999 order by 1;
C1: select if (:s = :i, 'OK', 'NOK');
C1: show index from t1;
MC: wait until C1 ready;

/* exit */
C1: DROP table t1;
C1: commit;

C1: quit;
C2: quit;
C3: quit;

