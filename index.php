<?php

require_once "controller/ProductController.php";

if (isset($_GET['product'])) {
    $product = new ProductController();
    switch ($_GET['product']) {
        case 'all':
            $products = $product->getProducts();
            //var_dump($products);
            break;
        case 'category':
            $products = $product->getCategories();
            break;

    }


}