<?php

class Sql
{
    public $hostname = "127.0.0.1";
    public $username = "root";
    public $password = "";
    public $dbname = "ifbawebii";

    protected $conn;

    public function __construct()
    {
        $dsn = "mysql:host=" . $this->hostname . ";dbname=" . $this->dbname;

        try {
            $this->conn = new PDO($dsn, $this->username, $this->password);
        } catch (PDOException $e) {
            echo "Connection failed: " . $e->getMessage();
        }


    }

}