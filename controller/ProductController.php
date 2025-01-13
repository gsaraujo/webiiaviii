<?php


require_once "model/ProductDAO.php";
require_once "model/Product.php";
require_once "view/View.php";

class ProductController {
    private $data;

    public function getProducts() {
        $this->data = array();

        $productDAO = new ProductDAO();

        try {
            $products = $productDAO->readAll();
        } catch (PDOException $e) {
            echo $e->getMessage();
        }

        $this->data['products'] = $products;

        View::load('view/template/header.html');
        View::load('view/product/index.php', $this->data);
        View::load('view/template/footer.html');

        //return $this->data;
    }
}