sqlite3_crash_enable 1
sqlite3_crashparams   4 /home/purple/sqlite/test/testdir/test2.db-wal
sqlite3_test_control_pending_byte 65536
 sqlite3 db test.db -vfs crash 
db eval {SELECT * FROM sqlite_master;}
set bt [btree_from_db db]
btree_set_cache_size $bt 10
db eval {SELECT randomblob(64)}
db eval {

        PRAGMA journal_mode = WAL;
        ATTACH 'test2.db' AS aux;
        CREATE TABLE t1(a PRIMARY KEY, b);
        CREATE TABLE aux.t2(a PRIMARY KEY, b);
        BEGIN;
          INSERT INTO t1 VALUES(1, 2);
          INSERT INTO t2 VALUES(1, 2);
        COMMIT;
      
}
