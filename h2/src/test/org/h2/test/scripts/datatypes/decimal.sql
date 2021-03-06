-- Copyright 2004-2020 H2 Group. Multiple-Licensed under the MPL 2.0,
-- and the EPL 1.0 (https://h2database.com/html/license.html).
-- Initial Developer: H2 Group
--

CREATE TABLE TEST(I NUMERIC(-1));
> exception INVALID_VALUE_2

CREATE TABLE TEST(I NUMERIC(-1, -1));
> exception INVALID_VALUE_2

CREATE TABLE TEST (N NUMERIC(3, 1)) AS VALUES (0), (0.0), (NULL);
> ok

SELECT * FROM TEST;
> N
> ----
> 0.0
> 0.0
> null
> rows: 3

DROP TABLE TEST;
> ok

SELECT CAST(10000 AS NUMERIC(5, -3));
>> 1.0E+4

CREATE DOMAIN N AS NUMERIC(10, -1);
> ok

CREATE TABLE TEST(V N);
> ok

SELECT NUMERIC_SCALE FROM INFORMATION_SCHEMA.COLUMNS WHERE COLUMN_NAME = 'V';
>> -1

DROP TABLE TEST;
> ok

DROP DOMAIN N;
> ok

CREATE TABLE TEST(I INT PRIMARY KEY, V NUMERIC(1, 3));
> ok

INSERT INTO TEST VALUES (1, 1e-3), (2, 1.1e-3), (3, 1e-4);
> update count: 3

INSERT INTO TEST VALUES (4, 1e-2);
> exception VALUE_TOO_LONG_2

TABLE TEST;
> I V
> - -----
> 1 0.001
> 2 0.001
> 3 0.000
> rows: 3

DROP TABLE TEST;
> ok

CREATE TABLE TEST(I INT PRIMARY KEY, V NUMERIC(2));
> ok

INSERT INTO TEST VALUES (1, 1e-1), (2, 2e0), (3, 3e1);
> update count: 3

TABLE TEST;
> I V
> - --
> 1 0
> 2 2
> 3 30
> rows: 3

DROP TABLE TEST;
> ok
