-- Tags: no-parallel

SET allow_experimental_window_view = 1;
DROP DATABASE IF EXISTS test_01047;
CREATE DATABASE test_01047 ENGINE=Ordinary;

DROP TABLE IF EXISTS test_01047.mt;

CREATE TABLE test_01047.mt(a Int32, b Int32, timestamp DateTime) ENGINE=MergeTree ORDER BY tuple();

SELECT '---TUMBLE---';
SELECT '||---WINDOW COLUMN NAME---';
DROP TABLE IF EXISTS test_01047.wv;
DROP TABLE IF EXISTS test_01047.`.inner.wv`;
CREATE WINDOW VIEW test_01047.wv ENGINE AggregatingMergeTree ORDER BY TUMBLE(timestamp, INTERVAL '1' SECOND) AS SELECT count(a), TUMBLE_END(wid) AS count FROM test_01047.mt GROUP BY TUMBLE(timestamp, INTERVAL '1' SECOND) as wid;
SHOW CREATE TABLE test_01047.`.inner.wv`;

SELECT '||---WINDOW COLUMN ALIAS---';
DROP TABLE IF EXISTS test_01047.wv;
DROP TABLE IF EXISTS test_01047.`.inner.wv`;
CREATE WINDOW VIEW test_01047.wv ENGINE AggregatingMergeTree ORDER BY wid AS SELECT count(a) AS count, TUMBLE(timestamp, INTERVAL '1' SECOND) AS wid FROM test_01047.mt GROUP BY wid;
SHOW CREATE TABLE test_01047.`.inner.wv`;

SELECT '||---IDENTIFIER---';
DROP TABLE IF EXISTS test_01047.wv;
DROP TABLE IF EXISTS test_01047.`.inner.wv`;
CREATE WINDOW VIEW test_01047.wv ENGINE AggregatingMergeTree ORDER BY (TUMBLE(timestamp, INTERVAL '1' SECOND), b) PRIMARY KEY TUMBLE(timestamp, INTERVAL '1' SECOND) AS SELECT count(a) AS count FROM test_01047.mt GROUP BY b, TUMBLE(timestamp, INTERVAL '1' SECOND) AS wid;
SHOW CREATE TABLE test_01047.`.inner.wv`;

SELECT '||---FUNCTION---';
DROP TABLE IF EXISTS test_01047.wv;
DROP TABLE IF EXISTS test_01047.`.inner.wv`;
CREATE WINDOW VIEW test_01047.wv ENGINE AggregatingMergeTree ORDER BY (TUMBLE(timestamp, INTERVAL '1' SECOND), plus(a, b)) PRIMARY KEY TUMBLE(timestamp, INTERVAL '1' SECOND) AS SELECT count(a) AS count FROM test_01047.mt GROUP BY plus(a, b) as _type, TUMBLE(timestamp, INTERVAL '1' SECOND) AS wid;
SHOW CREATE TABLE test_01047.`.inner.wv`;

SELECT '||---PARTITION---';
DROP TABLE IF EXISTS test_01047.wv;
DROP TABLE IF EXISTS test_01047.`.inner.wv`;
CREATE WINDOW VIEW test_01047.wv ENGINE AggregatingMergeTree ORDER BY wid PARTITION BY wid AS SELECT count(a) AS count, TUMBLE(now(), INTERVAL '1' SECOND) AS wid FROM test_01047.mt GROUP BY wid;
SHOW CREATE TABLE test_01047.`.inner.wv`;


SELECT '---HOP---';
SELECT '||---WINDOW COLUMN NAME---';
DROP TABLE IF EXISTS test_01047.wv;
DROP TABLE IF EXISTS test_01047.`.inner.wv`;
CREATE WINDOW VIEW test_01047.wv ENGINE AggregatingMergeTree ORDER BY HOP(timestamp, INTERVAL '1' SECOND, INTERVAL '3' SECOND) AS SELECT count(a) AS count, HOP_END(wid) FROM test_01047.mt GROUP BY HOP(timestamp, INTERVAL '1' SECOND, INTERVAL '3' SECOND) as wid;
SHOW CREATE TABLE test_01047.`.inner.wv`;

SELECT '||---WINDOW COLUMN ALIAS---';
DROP TABLE IF EXISTS test_01047.wv;
DROP TABLE IF EXISTS test_01047.`.inner.wv`;
CREATE WINDOW VIEW test_01047.wv ENGINE AggregatingMergeTree ORDER BY wid AS SELECT count(a) AS count, HOP(timestamp, INTERVAL '1' SECOND, INTERVAL '3' SECOND) AS wid FROM test_01047.mt GROUP BY wid;
SHOW CREATE TABLE test_01047.`.inner.wv`;

SELECT '||---IDENTIFIER---';
DROP TABLE IF EXISTS test_01047.wv;
DROP TABLE IF EXISTS test_01047.`.inner.wv`;
CREATE WINDOW VIEW test_01047.wv ENGINE AggregatingMergeTree ORDER BY (HOP(timestamp, INTERVAL '1' SECOND, INTERVAL '3' SECOND), b) PRIMARY KEY HOP(timestamp, INTERVAL '1' SECOND, INTERVAL '3' SECOND) AS SELECT count(a) AS count FROM test_01047.mt GROUP BY b, HOP(timestamp, INTERVAL '1' SECOND, INTERVAL '3' SECOND) AS wid;
SHOW CREATE TABLE test_01047.`.inner.wv`;

SELECT '||---FUNCTION---';
DROP TABLE IF EXISTS test_01047.wv;
DROP TABLE IF EXISTS test_01047.`.inner.wv`;
CREATE WINDOW VIEW test_01047.wv ENGINE AggregatingMergeTree ORDER BY (HOP(timestamp, INTERVAL '1' SECOND, INTERVAL '3' SECOND), plus(a, b)) PRIMARY KEY HOP(timestamp, INTERVAL '1' SECOND, INTERVAL '3' SECOND) AS SELECT count(a) AS count FROM test_01047.mt GROUP BY plus(a, b) as _type, HOP(timestamp, INTERVAL '1' SECOND, INTERVAL '3' SECOND) AS wid;
SHOW CREATE TABLE test_01047.`.inner.wv`;

SELECT '||---PARTITION---';
DROP TABLE IF EXISTS test_01047.wv;
DROP TABLE IF EXISTS test_01047.`.inner.wv`;
CREATE WINDOW VIEW test_01047.wv ENGINE AggregatingMergeTree ORDER BY wid PARTITION BY wid AS SELECT count(a) AS count, HOP_END(wid) FROM test_01047.mt GROUP BY HOP(now(), INTERVAL '1' SECOND, INTERVAL '3' SECOND) as wid;
SHOW CREATE TABLE test_01047.`.inner.wv`;

DROP TABLE test_01047.wv;
DROP TABLE test_01047.mt;