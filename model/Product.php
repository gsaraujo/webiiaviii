<?php

class Product
{
    private $idproduct;
    private $desproduct;
    private $vlprice;

    /**
     * @param $idproduct
     * @param $desproduct
     * @param $vlprice
     */
    public function __construct($idproduct, $desproduct, $vlprice)
    {
        $this->idproduct = $idproduct;
        $this->desproduct = $desproduct;
        $this->vlprice = $vlprice;
    }


    /**
     * @return mixed
     */
    public function getIdproduct()
    {
        return $this->idproduct;
    }

    /**
     * @param mixed $idproduct
     */
    public function setIdproduct($idproduct)
    {
        $this->idproduct = $idproduct;
    }

    /**
     * @return mixed
     */
    public function getDesproduct()
    {
        return $this->desproduct;
    }

    /**
     * @param mixed $desproduct
     */
    public function setDesproduct($desproduct)
    {
        $this->desproduct = $desproduct;
    }

    /**
     * @return mixed
     */
    public function getVlprice()
    {
        return $this->vlprice;
    }

    /**
     * @param mixed $vlprice
     */
    public function setVlprice($vlprice)
    {
        $this->vlprice = $vlprice;
    }





}