<?php

class Sql
{
    const HOSTNAME = "127.0.0.1";
    const USERNAME = "root";
    const PASSWORD = "";
    const DBNAME = "db_ecommerce";

    protected $conn;

    public function __construct()
    {
        $dsn = "mysql:host=" . self::HOSTNAME . ";dbname=" . self::DBNAME;

        try {
            $this->conn = new PDO($dsn, self::USERNAME, self::PASSWORD);
        } catch (PDOException $e) {
            echo "Connection failed: " . $e->getMessage();
        }


    }

}