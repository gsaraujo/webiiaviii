<?php
require_once "config/Sql.php";

class Produto extends Sql{

    private $cod_produto;
    private $desc_produto;
    private $valor_produto;
    private $quantidade_estoque;
    private $imagem_produto;


    public function lerProdutos() {
        $sql = "SELECT * FROM produtos";
        try {
            $stmt = $this->conn->prepare($sql);
            $stmt->execute();
            $produtos = $stmt->fetchAll(PDO::FETCH_CLASS | PDO::FETCH_PROPS_LATE, 'Produto', ['cod_produto', 'desc_produto', 'valor_produto','quantidade_estoque', 'imagem_produto']);
            //var_dump($produtos);
            //exit;
            return $produtos;
        } catch (PDOException $e) {
            throw new PDOException($e);
        }
    }


}