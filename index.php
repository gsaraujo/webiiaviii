<?php
include_once('classes/Produto.php');

$listaProdutos = new Produto();

var_dump($listaProdutos->lerProdutos());