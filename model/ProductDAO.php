<?php


require_once "Product.php";
require_once "config/Sql.php";

class ProductDAO extends Sql
{
    public function readAll() {

        $query = "SELECT * FROM tb_products";
        try {
            $stmt = $this->conn->prepare($query);
            $stmt->execute();
            $products = $stmt->fetchAll(PDO::FETCH_CLASS | PDO::FETCH_PROPS_LATE, 'Product', ['idproduct', 'desproduct', 'vlprice']);
            return $products;
        } catch (PDOException $e) {
            throw new PDOException($e);
        }


    }

}