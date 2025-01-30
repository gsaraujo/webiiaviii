<?php

//session_start();
//$_SESSION["valores"] = [1,2,3,4];
//unset ($_SESSION["valores"][2]);
//
//var_dump($_SESSION["valores"]);

function somaElementos($array){
    $sum = array_sum($array);
    var_dump($sum);
    exit;
    if($sum > 0) {
        return $sum;
    } else {
        echo 0;
    }
}

//function somaElementos($array) {
//    $soma = 0;
//    if (isset($array)) {
//        echo 'a';
//        foreach ($array as $elemento) {
//            $soma += $elemento;
//        }
//        return $soma;
//    } else {
//        return 0;
//    }
//}

//function somaElementos($array) {
//    $soma = 0;
//
//    if ($array = []) {
//        return $soma;
//    }
//
//    foreach ($array as $elemento) {
//        $soma += $elemento;
//    }
//    return $soma;
//
//}

//function somaElementos($array) {
//    $soma = 0;
//
//    if ($array != null) {
//        for($i = 0; $i < count($array); $i++) {
//            $soma += $array[$i];
//        }
//        return $soma;
//    } else {
//        return 0;
//    }
//
//}e

//function somaElementos($array) {
//  $array[] = [10,20,30];
//  $array = $array[];
//
//
//}

$x = array(1,2,3,4,5);
$x = array();
echo somaElementos($x);

