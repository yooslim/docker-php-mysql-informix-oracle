<?php

/*
 * ORACLE DSN WITH PDO TEST
 * */

$oracle = [
    'host'      => '127.0.0.1',
    'database'  => 'test_database',
    'username'  => 'test_user',
    'password'  => 'test_password'
];


try {
    $conn = new PDO('oci:dbname=//' . $oracle['host'] . '/' . $oracle['database'], $oracle['username'], $oracle['password']);
} catch(PDOException $e) {
    echo 'ERROR: ' . $e->getMessage();
}

/*
 * INFORMIX DSN WITH PDO TEST
 * */

$informix = [
    'host'      => '127.0.0.1',
    'service'   => '9091',
    'server'    => 'test_server_name',
    'database'  => 'test_database',
    'protocol'  => 'olsoctcp',
    'username'  => 'test_user',
    'password'  => 'test_password',
];

try {
    $dbh = new PDO('informix:host=' . $informix['host'] . ';service=' . $informix['service'] . ';server=' . $informix['server'] . ';database=' . $informix['database'] . ';protocol=' . $informix['protocol'] . ';', $informix['username'], $informix['password']);
}
catch (PDOException $e)
{
    echo $e->getMessage();
}
