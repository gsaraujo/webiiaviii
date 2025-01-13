-- phpMyAdmin SQL Dump
-- version 5.1.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Tempo de geração: 13-Jan-2025 às 03:08
-- Versão do servidor: 10.4.21-MariaDB
-- versão do PHP: 7.4.25

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Banco de dados: `db_ecommerce`
--

DELIMITER $$
--
-- Procedimentos
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_addresses_save` (`pidaddress` INT(11), `pidperson` INT(11), `pdesaddress` VARCHAR(128), `pdesnumber` VARCHAR(16), `pdescomplement` VARCHAR(32), `pdescity` VARCHAR(32), `pdesstate` VARCHAR(32), `pdescountry` VARCHAR(32), `pdeszipcode` CHAR(8), `pdesdistrict` VARCHAR(32))  BEGIN

	IF pidaddress > 0 THEN
		
		UPDATE tb_addresses
        SET
			idperson = pidperson,
            desaddress = pdesaddress,
            desnumber = pdesnumber,
            descomplement = pdescomplement,
            descity = pdescity,
            desstate = pdesstate,
            descountry = pdescountry,
            deszipcode = pdeszipcode, 
            desdistrict = pdesdistrict
		WHERE idaddress = pidaddress;
        
    ELSE
		
		INSERT INTO tb_addresses (idperson, desaddress, desnumber, descomplement, descity, desstate, descountry, deszipcode, desdistrict)
        VALUES(pidperson, pdesaddress, pdesnumber, pdescomplement, pdescity, pdesstate, pdescountry, pdeszipcode, pdesdistrict);
        
        SET pidaddress = LAST_INSERT_ID();
        
    END IF;
    
    SELECT * FROM tb_addresses WHERE idaddress = pidaddress;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_carts_save` (`pidcart` INT, `pdessessionid` VARCHAR(64), `piduser` INT, `pdeszipcode` CHAR(8), `pvlfreight` DECIMAL(10,2), `pnrdays` INT)  BEGIN

    IF pidcart > 0 THEN
        
        UPDATE tb_carts
        SET
            dessessionid = pdessessionid,
            iduser = piduser,
            deszipcode = pdeszipcode,
            vlfreight = pvlfreight,
            nrdays = pnrdays
        WHERE idcart = pidcart;
        
    ELSE
        
        INSERT INTO tb_carts (dessessionid, iduser, deszipcode, vlfreight, nrdays)
        VALUES(pdessessionid, piduser, pdeszipcode, pvlfreight, pnrdays);
        
        SET pidcart = LAST_INSERT_ID();
        
    END IF;
    
    SELECT * FROM tb_carts WHERE idcart = pidcart;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_categories_save` (`pidcategory` INT, `pdescategory` VARCHAR(64))  BEGIN
	
	IF pidcategory > 0 THEN
		
		UPDATE tb_categories
        SET descategory = pdescategory
        WHERE idcategory = pidcategory;
        
    ELSE
		
		INSERT INTO tb_categories (descategory) VALUES(pdescategory);
        
        SET pidcategory = LAST_INSERT_ID();
        
    END IF;
    
    SELECT * FROM tb_categories WHERE idcategory = pidcategory;
    
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_orders_save` (`pidorder` INT, `pidcart` INT(11), `piduser` INT(11), `pidstatus` INT(11), `pidaddress` INT(11), `pvltotal` DECIMAL(10,2))  BEGIN
	
	IF pidorder > 0 THEN
		
		UPDATE tb_orders
        SET
			idcart = pidcart,
            iduser = piduser,
            idstatus = pidstatus,
            idaddress = pidaddress,
            vltotal = pvltotal
		WHERE idorder = pidorder;
        
    ELSE
    
		INSERT INTO tb_orders (idcart, iduser, idstatus, idaddress, vltotal)
        VALUES(pidcart, piduser, pidstatus, pidaddress, pvltotal);
		
		SET pidorder = LAST_INSERT_ID();
        
    END IF;
    
    SELECT * 
    FROM tb_orders a
    INNER JOIN tb_ordersstatus b USING(idstatus)
    INNER JOIN tb_carts c USING(idcart)
    INNER JOIN tb_users d ON d.iduser = a.iduser
    INNER JOIN tb_addresses e USING(idaddress)
    WHERE idorder = pidorder;
    
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_products_save` (`pidproduct` INT(11), `pdesproduct` VARCHAR(64), `pvlprice` DECIMAL(10,2), `pvlwidth` DECIMAL(10,2), `pvlheight` DECIMAL(10,2), `pvllength` DECIMAL(10,2), `pvlweight` DECIMAL(10,2), `pdesurl` VARCHAR(128))  BEGIN
	
	IF pidproduct > 0 THEN
		
		UPDATE tb_products
        SET 
			desproduct = pdesproduct,
            vlprice = pvlprice,
            vlwidth = pvlwidth,
            vlheight = pvlheight,
            vllength = pvllength,
            vlweight = pvlweight,
            desurl = pdesurl
        WHERE idproduct = pidproduct;
        
    ELSE
		
		INSERT INTO tb_products (desproduct, vlprice, vlwidth, vlheight, vllength, vlweight, desurl) 
        VALUES(pdesproduct, pvlprice, pvlwidth, pvlheight, pvllength, pvlweight, pdesurl);
        
        SET pidproduct = LAST_INSERT_ID();
        
    END IF;
    
    SELECT * FROM tb_products WHERE idproduct = pidproduct;
    
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_userspasswordsrecoveries_create` (`piduser` INT, `pdesip` VARCHAR(45))  BEGIN
	
	INSERT INTO tb_userspasswordsrecoveries (iduser, desip)
    VALUES(piduser, pdesip);
    
    SELECT * FROM tb_userspasswordsrecoveries
    WHERE idrecovery = LAST_INSERT_ID();
    
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_usersupdate_save` (`piduser` INT, `pdesperson` VARCHAR(64), `pdeslogin` VARCHAR(64), `pdespassword` VARCHAR(256), `pdesemail` VARCHAR(128), `pnrphone` BIGINT, `pinadmin` TINYINT)  BEGIN
	
    DECLARE vidperson INT;
    
	SELECT idperson INTO vidperson
    FROM tb_users
    WHERE iduser = piduser;
    
    UPDATE tb_persons
    SET 
		desperson = pdesperson,
        desemail = pdesemail,
        nrphone = pnrphone
	WHERE idperson = vidperson;
    
    UPDATE tb_users
    SET
		deslogin = pdeslogin,
        despassword = pdespassword,
        inadmin = pinadmin
	WHERE iduser = piduser;
    
    SELECT * FROM tb_users a INNER JOIN tb_persons b USING(idperson) WHERE a.iduser = piduser;
    
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_users_delete` (`piduser` INT)  BEGIN
    
    DECLARE vidperson INT;
    
    SET FOREIGN_KEY_CHECKS = 0;
	
	SELECT idperson INTO vidperson
    FROM tb_users
    WHERE iduser = piduser;
	
    DELETE FROM tb_addresses WHERE idperson = vidperson;
    DELETE FROM tb_addresses WHERE idaddress IN(SELECT idaddress FROM tb_orders WHERE iduser = piduser);
	DELETE FROM tb_persons WHERE idperson = vidperson;
    
    DELETE FROM tb_userslogs WHERE iduser = piduser;
    DELETE FROM tb_userspasswordsrecoveries WHERE iduser = piduser;
    DELETE FROM tb_orders WHERE iduser = piduser;
    DELETE FROM tb_cartsproducts WHERE idcart IN(SELECT idcart FROM tb_carts WHERE iduser = piduser);
    DELETE FROM tb_carts WHERE iduser = piduser;
    DELETE FROM tb_users WHERE iduser = piduser;
    
    SET FOREIGN_KEY_CHECKS = 1;
    
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_users_save` (`pdesperson` VARCHAR(64), `pdeslogin` VARCHAR(64), `pdespassword` VARCHAR(256), `pdesemail` VARCHAR(128), `pnrphone` BIGINT, `pinadmin` TINYINT)  BEGIN
	
    DECLARE vidperson INT;
    
	INSERT INTO tb_persons (desperson, desemail, nrphone)
    VALUES(pdesperson, pdesemail, pnrphone);
    
    SET vidperson = LAST_INSERT_ID();
    
    INSERT INTO tb_users (idperson, deslogin, despassword, inadmin)
    VALUES(vidperson, pdeslogin, pdespassword, pinadmin);
    
    SELECT * FROM tb_users a INNER JOIN tb_persons b USING(idperson) WHERE a.iduser = LAST_INSERT_ID();
    
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Estrutura da tabela `tb_addresses`
--

CREATE TABLE `tb_addresses` (
  `idaddress` int(11) NOT NULL,
  `idperson` int(11) NOT NULL,
  `desaddress` varchar(128) NOT NULL,
  `desnumber` varchar(16) NOT NULL,
  `descomplement` varchar(32) DEFAULT NULL,
  `descity` varchar(32) NOT NULL,
  `desstate` varchar(32) NOT NULL,
  `descountry` varchar(32) NOT NULL,
  `deszipcode` char(8) NOT NULL,
  `desdistrict` varchar(32) NOT NULL,
  `dtregister` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Extraindo dados da tabela `tb_addresses`
--

INSERT INTO `tb_addresses` (`idaddress`, `idperson`, `desaddress`, `desnumber`, `descomplement`, `descity`, `desstate`, `descountry`, `deszipcode`, `desdistrict`, `dtregister`) VALUES
(1, 13, 'Avenida rua de cima', '0', NULL, 'Cidade2', 'BA', 'Brasil', '88571145', 'Bairro1', '2023-12-27 19:53:38'),
(2, 13, 'Avenida rua de baixo', '0', '', 'Cidade', 'BA', 'Brasil', '588740120', 'Bairro2', '2023-12-28 16:31:10'),
(3, 13, 'Avenida rua de baixo', '0', '', 'Cidade', 'BA', 'Brasil', '588740120', 'Bairro2', '2023-12-28 16:32:32'),
(4, 13, 'Avenida rua de baixo', '0', '', 'Cidade', 'BA', 'Brasil', '588740120', 'Bairro2', '2023-12-28 16:48:21'),
(5, 13, 'Avenida rua de baixo', '0', '', 'Cidade', 'BA', 'Brasil', '588740120', 'Bairro2', '2023-12-28 16:49:18'),
(6, 13, 'Avenida rua de baixo', '0', '', 'Cidade', 'BA', 'Brasil', '588740120', 'Bairro2', '2023-12-28 16:51:29'),
(7, 13, 'Avenida rua de baixo', '0', '', 'Cidade', 'BA', 'Brasil', '588740120', 'Bairro2', '2023-12-28 16:54:37'),
(8, 13, 'Avenida rua de baixo', '0', '', 'Cidade', 'BA', 'Brasil', '588740120', 'Bairro2', '2023-12-28 16:56:58'),
(9, 13, 'Avenida rua de baixo', '0', '', 'Cidade', 'BA', 'Brasil', '588740120', 'Bairro2', '2023-12-28 16:57:45'),
(10, 13, 'Avenida rua de baixo', '0', '', 'Cidade', 'BA', 'Brasil', '588740120', 'Bairro2', '2023-12-28 17:01:10'),
(11, 13, 'Avenida rua de baixo', '0', '', 'Cidade', 'BA', 'Brasil', '588740120', 'Bairro2', '2023-12-28 17:03:10'),
(12, 13, 'Avenida rua de baixo', '0', '', 'Cidade', 'BA', 'Brasil', '588740120', 'Bairro2', '2023-12-28 22:06:02'),
(13, 13, 'Avenida rua de baixo', '0', '', 'Cidade', 'BA', 'Brasil', '588740120', 'Bairro2', '2023-12-28 22:08:39'),
(14, 1, 'Avenida rua de baixo', '0', '', 'Cidade', 'BA', 'Brasil', '588740120', 'Bairro2', '2023-12-29 16:57:49'),
(15, 1, 'Avenida rua de baixo', '0', '', 'Cidade', 'BA', 'Brasil', '588740120', 'Bairro2', '2023-12-29 17:18:39'),
(16, 13, 'Avenida rua de cima', '181', '', 'Cidade2', 'BA', 'Brasil', '88571145', 'Bairro1', '2023-12-30 22:36:42'),
(17, 13, 'Avenida rua de cima', '181', '', 'Cidade2', 'BA', 'Brasil', '88571145', 'Bairro1', '2024-01-02 12:57:57'),
(18, 13, 'Avenida rua de cima', '', '', 'Cidade2', 'BA', 'Brasil', '88571145', 'Bairro1', '2024-01-02 13:07:30'),
(19, 13, 'Avenida rua de cima', '', '', 'Cidade2', 'BA', 'Brasil', '88571145', 'Bairro1', '2024-01-02 13:07:52'),
(20, 13, 'Avenida rua de cima', '', '', 'Cidade2', 'BA', 'Brasil', '88571145', 'Bairro1', '2024-01-02 14:14:40'),
(21, 13, 'Avenida rua de cima', '181', '', 'Cidade2', 'BA', 'Brasil', '88571145', 'Bairro1', '2024-01-02 14:16:42'),
(22, 13, 'Avenida rua de cima', '181', '', 'Cidade2', 'BA', 'Brasil', '88571145', 'Bairro1', '2024-01-02 14:18:18');

-- --------------------------------------------------------

--
-- Estrutura da tabela `tb_carts`
--

CREATE TABLE `tb_carts` (
  `idcart` int(11) NOT NULL,
  `dessessionid` varchar(64) NOT NULL,
  `iduser` int(11) DEFAULT NULL,
  `deszipcode` char(8) DEFAULT NULL,
  `vlfreight` decimal(10,2) DEFAULT NULL,
  `nrdays` int(11) DEFAULT NULL,
  `dtregister` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Extraindo dados da tabela `tb_carts`
--

INSERT INTO `tb_carts` (`idcart`, `dessessionid`, `iduser`, `deszipcode`, `vlfreight`, `nrdays`, `dtregister`) VALUES
(6, 'i991iabjp1hjk8viui3bbchsv9', NULL, '588740120', '77.48', 1, '2022-11-08 14:20:47'),
(7, '8qjl3dlc1rfr9v001late2j5m5', NULL, '588740120', '77.48', 1, '2022-11-08 18:27:02'),
(8, '6b0gegp5ql1iqarqj4j03jk2j7', 9, NULL, NULL, NULL, '2022-11-22 22:39:02'),
(9, '8eg3bucg9607s9cfn6fftuabcj', 1, NULL, NULL, NULL, '2022-12-15 13:40:22'),
(10, '8lunni037o8sm3737k1a5i7erd', NULL, NULL, NULL, NULL, '2022-12-20 13:15:12'),
(11, '5lbbtiil1rgumbp819osdhenrd', 13, NULL, NULL, NULL, '2023-12-21 01:24:51'),
(12, 's6a7t1u1i335vlj7jb7e74kd42', NULL, '40150-08', NULL, NULL, '2023-12-22 16:24:28'),
(13, '2bjvcqco166gprjuqi2t5bgmu2', NULL, '588740120', '25.00', 10, '2023-12-22 16:27:15'),
(14, 'fsa6tb0i0ala71909shnuph577', 13, '4015008', '25.00', 10, '2023-12-26 14:58:00'),
(15, '92ia32n522eegu9alqtq7qu4mq', NULL, '88571145', '25.00', 10, '2023-12-26 14:59:28'),
(16, 'nkl9t8c0s34h0nhmq8rtch6kuo', NULL, '588740120', '25.00', 10, '2023-12-28 16:28:16'),
(17, 'qrama7pt98us119mi9r9lt8vg9', NULL, '588740120', '25.00', 10, '2023-12-28 16:28:57'),
(18, '6bh8cqt2l0fcdemdaqcdf3u2f3', NULL, '588740120', '25.00', 10, '2023-12-28 16:32:19'),
(19, '3pos8q08v0g6g6oiqgpdn9o7k2', NULL, '588740120', '25.00', 10, '2023-12-28 16:54:22'),
(20, 'thr7ptib8k6l9063tiduihdreu', NULL, '588740120', '25.00', 10, '2023-12-28 22:05:48'),
(21, 'maobmo1c7oruqnsud0sd61mg9m', NULL, '588740120', '25.00', 10, '2023-12-30 22:17:13'),
(22, 'ci3r80ueus3rb4te0sjhl4d391', NULL, '588740120', '25.00', 10, '2023-12-30 22:25:56'),
(23, 'v9g1acp2l95k5ucnifkmid02a7', NULL, '88571145', '25.00', 10, '2023-12-30 22:36:16'),
(24, 'ipf7e5h3i978hdqusifj24duor', NULL, '88571145', '25.00', 10, '2024-01-02 14:16:03'),
(25, '9c4ppkgaepcb4lf0vunfde3boh', NULL, NULL, NULL, NULL, '2024-01-02 18:59:08'),
(26, '4b9o75ea8c61m778q4ea230k27', NULL, NULL, NULL, NULL, '2024-01-03 15:20:06');

-- --------------------------------------------------------

--
-- Estrutura da tabela `tb_cartsproducts`
--

CREATE TABLE `tb_cartsproducts` (
  `idcartproduct` int(11) NOT NULL,
  `idcart` int(11) NOT NULL,
  `idproduct` int(11) NOT NULL,
  `dtremoved` datetime DEFAULT NULL,
  `dtregister` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Extraindo dados da tabela `tb_cartsproducts`
--

INSERT INTO `tb_cartsproducts` (`idcartproduct`, `idcart`, `idproduct`, `dtremoved`, `dtregister`) VALUES
(24, 6, 9, NULL, '2022-11-08 14:20:54'),
(25, 7, 9, NULL, '2022-11-08 18:27:02'),
(26, 10, 9, NULL, '2022-12-20 13:15:12'),
(27, 11, 9, NULL, '2023-12-21 01:48:01'),
(28, 12, 6, NULL, '2023-12-22 16:24:28'),
(29, 13, 6, NULL, '2023-12-22 16:27:24'),
(30, 15, 6, NULL, '2023-12-26 14:59:34'),
(31, 15, 6, NULL, '2023-12-26 15:07:57'),
(32, 16, 6, NULL, '2023-12-28 16:28:16'),
(33, 17, 5, NULL, '2023-12-28 16:28:57'),
(34, 18, 5, NULL, '2023-12-28 16:32:19'),
(35, 19, 5, NULL, '2023-12-28 16:54:22'),
(36, 19, 6, NULL, '2023-12-28 16:56:34'),
(37, 20, 5, '2023-12-29 14:17:52', '2023-12-28 22:05:48'),
(38, 20, 5, '2023-12-29 14:17:53', '2023-12-28 22:08:19'),
(39, 20, 6, '2023-12-29 14:17:50', '2023-12-29 16:57:40'),
(40, 20, 3, NULL, '2023-12-29 17:18:02'),
(41, 21, 1, NULL, '2023-12-30 22:25:14'),
(42, 22, 1, NULL, '2023-12-30 22:25:59'),
(43, 23, 1, NULL, '2023-12-30 22:36:19'),
(44, 23, 9, NULL, '2024-01-02 13:07:24'),
(45, 24, 6, NULL, '2024-01-02 14:16:10'),
(46, 24, 5, NULL, '2024-01-02 14:16:19');

-- --------------------------------------------------------

--
-- Estrutura da tabela `tb_categories`
--

CREATE TABLE `tb_categories` (
  `idcategory` int(11) NOT NULL,
  `descategory` varchar(32) NOT NULL,
  `dtregister` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Extraindo dados da tabela `tb_categories`
--

INSERT INTO `tb_categories` (`idcategory`, `descategory`, `dtregister`) VALUES
(4, 'Lenovo', '2022-10-27 13:42:02'),
(5, 'Smartphone', '2022-10-27 13:42:13'),
(7, 'Abajur', '2022-10-27 14:00:06'),
(8, 'Impressora', '2022-10-27 20:26:40'),
(9, 'Nova', '2022-10-27 21:22:06'),
(10, 'Laptop', '2022-11-01 15:11:44'),
(11, 'Android', '2022-11-01 23:24:00');

-- --------------------------------------------------------

--
-- Estrutura da tabela `tb_categoriesproducts`
--

CREATE TABLE `tb_categoriesproducts` (
  `idcategory` int(11) NOT NULL,
  `idproduct` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estrutura da tabela `tb_orders`
--

CREATE TABLE `tb_orders` (
  `idorder` int(11) NOT NULL,
  `idcart` int(11) NOT NULL,
  `iduser` int(11) NOT NULL,
  `idstatus` int(11) NOT NULL,
  `idaddress` int(11) NOT NULL,
  `vltotal` decimal(10,2) NOT NULL,
  `dtregister` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Extraindo dados da tabela `tb_orders`
--

INSERT INTO `tb_orders` (`idorder`, `idcart`, `iduser`, `idstatus`, `idaddress`, `vltotal`, `dtregister`) VALUES
(1, 19, 13, 4, 7, '1160.23', '2023-12-28 16:54:37'),
(2, 19, 13, 3, 11, '3048.01', '2023-12-28 17:03:10'),
(3, 20, 13, 1, 12, '1160.23', '2023-12-28 22:06:02'),
(4, 20, 13, 1, 13, '2295.46', '2023-12-28 22:08:39'),
(6, 20, 1, 1, 15, '1974.99', '2023-12-29 17:18:39'),
(7, 23, 13, 1, 16, '1024.95', '2023-12-30 22:36:42'),
(8, 23, 13, 1, 17, '1024.95', '2024-01-02 12:57:57'),
(9, 23, 13, 1, 18, '1704.85', '2024-01-02 13:07:30'),
(10, 23, 13, 1, 19, '1704.85', '2024-01-02 13:07:52'),
(11, 23, 13, 1, 20, '1704.85', '2024-01-02 14:14:40'),
(12, 24, 13, 1, 21, '3048.01', '2024-01-02 14:16:42'),
(13, 24, 13, 1, 22, '3048.01', '2024-01-02 14:18:19');

-- --------------------------------------------------------

--
-- Estrutura da tabela `tb_ordersstatus`
--

CREATE TABLE `tb_ordersstatus` (
  `idstatus` int(11) NOT NULL,
  `desstatus` varchar(32) NOT NULL,
  `dtregister` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Extraindo dados da tabela `tb_ordersstatus`
--

INSERT INTO `tb_ordersstatus` (`idstatus`, `desstatus`, `dtregister`) VALUES
(1, 'Em Aberto', '2017-03-13 06:00:00'),
(2, 'Aguardando Pagamento', '2017-03-13 06:00:00'),
(3, 'Pago', '2017-03-13 06:00:00'),
(4, 'Entregue', '2017-03-13 06:00:00');

-- --------------------------------------------------------

--
-- Estrutura da tabela `tb_persons`
--

CREATE TABLE `tb_persons` (
  `idperson` int(11) NOT NULL,
  `desperson` varchar(64) NOT NULL,
  `desemail` varchar(128) DEFAULT NULL,
  `nrphone` bigint(20) DEFAULT NULL,
  `dtregister` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Extraindo dados da tabela `tb_persons`
--

INSERT INTO `tb_persons` (`idperson`, `desperson`, `desemail`, `nrphone`, `dtregister`) VALUES
(1, 'John Doe', 'admin@ifba.com.br', 2147483647, '2017-03-01 06:00:00'),
(7, 'Suporte', 'suporte@ifba.com.br', 1112345678, '2017-03-15 19:10:27'),
(8, 'Madalena Santana', 'email@email.com', 74447858596, '2022-10-21 15:58:25'),
(9, 'Frodo Santana', 'frodo@buriti.com.br', 85996987458, '2022-10-24 10:56:28'),
(11, 'Jolie Santana', 'jolie@buriti.com', 85558747777, '2022-10-24 11:23:10'),
(12, 'Meu Nome da Silva Sauro', 'meuemail@email.com', 0, '2022-12-15 14:58:18'),
(13, 'Alita Anjo de batalha', 'alita@alita.com', 789456123, '2023-12-21 01:24:51');

-- --------------------------------------------------------

--
-- Estrutura da tabela `tb_products`
--

CREATE TABLE `tb_products` (
  `idproduct` int(11) NOT NULL,
  `desproduct` varchar(64) NOT NULL,
  `vlprice` decimal(10,2) NOT NULL,
  `vlwidth` decimal(10,2) NOT NULL,
  `vlheight` decimal(10,2) NOT NULL,
  `vllength` decimal(10,2) NOT NULL,
  `vlweight` decimal(10,2) NOT NULL,
  `desurl` varchar(128) NOT NULL,
  `dtregister` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Extraindo dados da tabela `tb_products`
--

INSERT INTO `tb_products` (`idproduct`, `desproduct`, `vlprice`, `vlwidth`, `vlheight`, `vllength`, `vlweight`, `desurl`, `dtregister`) VALUES
(1, 'Smartphone Android 7.0', '999.95', '75.00', '151.00', '80.00', '167.00', 'smartphone-android-7.0', '2017-03-13 06:00:00'),
(2, 'SmartTV LED 4K', '3925.99', '917.00', '596.00', '288.00', '8600.00', 'smarttv-led-4k', '2017-03-13 06:00:00'),
(3, 'Notebook 14\" 4GB 1TB', '1949.99', '345.00', '23.00', '30.00', '2000.00', 'notebook-14-4gb-1tb', '2017-03-13 06:00:00'),
(5, 'Smartphone Motorola Moto G5 Plus', '1135.23', '15.20', '7.40', '0.70', '0.16', 'smartphone-motorola-moto-g5-plus', '2022-10-31 19:00:54'),
(6, 'Smartphone Moto Z Play', '1887.78', '14.10', '0.90', '1.16', '0.13', 'smartphone-moto-z-play', '2022-10-31 19:00:54'),
(7, 'Smartphone Samsung Galaxy J5 Pro', '1299.00', '14.60', '7.10', '0.80', '0.16', 'smartphone-samsung-galaxy-j5', '2022-10-31 19:00:54'),
(8, 'Smartphone Samsung Galaxy J7 Prime', '1149.00', '15.10', '7.50', '0.80', '0.16', 'smartphone-samsung-galaxy-j7', '2022-10-31 19:00:54'),
(9, 'Smartphone Samsung Galaxy J3 Dual', '679.90', '14.20', '7.10', '0.70', '0.14', 'smartphone-samsung-galaxy-j3', '2022-10-31 19:00:54');

-- --------------------------------------------------------

--
-- Estrutura da tabela `tb_productscategories`
--

CREATE TABLE `tb_productscategories` (
  `idcategory` int(11) NOT NULL,
  `idproduct` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Extraindo dados da tabela `tb_productscategories`
--

INSERT INTO `tb_productscategories` (`idcategory`, `idproduct`) VALUES
(5, 1),
(5, 5),
(5, 6),
(5, 7),
(5, 8),
(5, 9),
(10, 3),
(11, 1),
(11, 2),
(11, 5),
(11, 6),
(11, 7),
(11, 8),
(11, 9);

-- --------------------------------------------------------

--
-- Estrutura da tabela `tb_users`
--

CREATE TABLE `tb_users` (
  `iduser` int(11) NOT NULL,
  `idperson` int(11) NOT NULL,
  `deslogin` varchar(64) NOT NULL,
  `despassword` varchar(256) NOT NULL,
  `inadmin` tinyint(4) NOT NULL DEFAULT 0,
  `dtregister` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Extraindo dados da tabela `tb_users`
--

INSERT INTO `tb_users` (`iduser`, `idperson`, `deslogin`, `despassword`, `inadmin`, `dtregister`) VALUES
(1, 1, 'admin', '$2y$12$YlooCyNvyTji8bPRcrfNfOKnVMmZA9ViM2A3IpFjmrpIbp5ovNmga', 1, '2017-03-13 06:00:00'),
(7, 7, 'suporte', '$2y$12$HFjgUm/mk1RzTy4ZkJaZBe0Mc/BA2hQyoUckvm.lFa6TesjtNpiMe', 1, '2017-03-15 19:10:27'),
(8, 8, 'madalena', '$2y$12$8Fy2E5zWNXPCDwb7tyIBFOZpYfLmrvZNNFmFEBMYuS/DDFFwN0Xc2', 1, '2022-10-21 15:58:25'),
(9, 9, 'frodo', '$2y$12$Ko9AcKmWI230xbUlte28bev9Msfpr4mGDI36ULQ1nZzJ/egxsbT/m', 0, '2022-10-24 10:56:28'),
(11, 11, 'jolie', 'jolie', 1, '2022-10-24 11:23:10'),
(12, 12, 'meuemail@email.com', '$2y$12$ouTJ4wAi5NcN05pauL8JpeFyAdeUbqhXQozXWlGkpWbR9KmEzVhyq', 0, '2022-12-15 14:58:18'),
(13, 13, 'alita@alita.com', '$2y$12$S3HUQ1zRl8LrKvy/nQwM/.ELht9sIALQ2ESWshBWFSTgy1oS84dUm', 0, '2023-12-21 01:24:51');

-- --------------------------------------------------------

--
-- Estrutura da tabela `tb_userslogs`
--

CREATE TABLE `tb_userslogs` (
  `idlog` int(11) NOT NULL,
  `iduser` int(11) NOT NULL,
  `deslog` varchar(128) NOT NULL,
  `desip` varchar(45) NOT NULL,
  `desuseragent` varchar(128) NOT NULL,
  `dessessionid` varchar(64) NOT NULL,
  `desurl` varchar(128) NOT NULL,
  `dtregister` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estrutura da tabela `tb_userspasswordsrecoveries`
--

CREATE TABLE `tb_userspasswordsrecoveries` (
  `idrecovery` int(11) NOT NULL,
  `iduser` int(11) NOT NULL,
  `desip` varchar(45) NOT NULL,
  `dtrecovery` datetime DEFAULT NULL,
  `dtregister` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Extraindo dados da tabela `tb_userspasswordsrecoveries`
--

INSERT INTO `tb_userspasswordsrecoveries` (`idrecovery`, `iduser`, `desip`, `dtrecovery`, `dtregister`) VALUES
(1, 7, '127.0.0.1', NULL, '2017-03-15 19:10:59'),
(2, 7, '127.0.0.1', '2017-03-15 13:33:45', '2017-03-15 19:11:18'),
(3, 7, '127.0.0.1', '2017-03-15 13:37:35', '2017-03-15 19:37:12'),
(4, 9, '127.0.0.1', NULL, '2022-10-25 23:23:26'),
(5, 9, '127.0.0.1', NULL, '2022-10-25 23:34:56'),
(6, 9, '127.0.0.1', NULL, '2022-10-25 23:38:43'),
(7, 9, '127.0.0.1', NULL, '2022-10-25 23:58:00'),
(8, 9, '127.0.0.1', NULL, '2022-10-26 00:02:19'),
(9, 9, '127.0.0.1', NULL, '2022-10-26 00:08:41'),
(10, 9, '127.0.0.1', NULL, '2022-10-26 00:12:43'),
(11, 9, '127.0.0.1', NULL, '2022-10-26 00:25:20'),
(12, 9, '127.0.0.1', NULL, '2022-10-26 00:27:29'),
(13, 9, '127.0.0.1', '2022-10-26 09:16:38', '2022-10-26 12:02:17'),
(15, 9, '127.0.0.1', '2022-10-26 09:21:50', '2022-10-26 12:21:23'),
(16, 8, '127.0.0.1', '2022-10-26 09:24:00', '2022-10-26 12:23:45'),
(17, 8, '127.0.0.1', NULL, '2023-12-21 01:51:21');

--
-- Índices para tabelas despejadas
--

--
-- Índices para tabela `tb_addresses`
--
ALTER TABLE `tb_addresses`
  ADD PRIMARY KEY (`idaddress`),
  ADD KEY `fk_addresses_persons_idx` (`idperson`);

--
-- Índices para tabela `tb_carts`
--
ALTER TABLE `tb_carts`
  ADD PRIMARY KEY (`idcart`),
  ADD KEY `FK_carts_users_idx` (`iduser`);

--
-- Índices para tabela `tb_cartsproducts`
--
ALTER TABLE `tb_cartsproducts`
  ADD PRIMARY KEY (`idcartproduct`),
  ADD KEY `FK_cartsproducts_carts_idx` (`idcart`),
  ADD KEY `FK_cartsproducts_products_idx` (`idproduct`);

--
-- Índices para tabela `tb_categories`
--
ALTER TABLE `tb_categories`
  ADD PRIMARY KEY (`idcategory`);

--
-- Índices para tabela `tb_categoriesproducts`
--
ALTER TABLE `tb_categoriesproducts`
  ADD PRIMARY KEY (`idcategory`,`idproduct`);

--
-- Índices para tabela `tb_orders`
--
ALTER TABLE `tb_orders`
  ADD PRIMARY KEY (`idorder`),
  ADD KEY `FK_orders_users_idx` (`iduser`),
  ADD KEY `fk_orders_ordersstatus_idx` (`idstatus`),
  ADD KEY `fk_orders_carts_idx` (`idcart`),
  ADD KEY `fk_orders_addresses_idx` (`idaddress`);

--
-- Índices para tabela `tb_ordersstatus`
--
ALTER TABLE `tb_ordersstatus`
  ADD PRIMARY KEY (`idstatus`);

--
-- Índices para tabela `tb_persons`
--
ALTER TABLE `tb_persons`
  ADD PRIMARY KEY (`idperson`);

--
-- Índices para tabela `tb_products`
--
ALTER TABLE `tb_products`
  ADD PRIMARY KEY (`idproduct`);

--
-- Índices para tabela `tb_productscategories`
--
ALTER TABLE `tb_productscategories`
  ADD PRIMARY KEY (`idcategory`,`idproduct`),
  ADD KEY `fk_productscategories_products_idx` (`idproduct`);

--
-- Índices para tabela `tb_users`
--
ALTER TABLE `tb_users`
  ADD PRIMARY KEY (`iduser`),
  ADD KEY `FK_users_persons_idx` (`idperson`);

--
-- Índices para tabela `tb_userslogs`
--
ALTER TABLE `tb_userslogs`
  ADD PRIMARY KEY (`idlog`),
  ADD KEY `fk_userslogs_users_idx` (`iduser`);

--
-- Índices para tabela `tb_userspasswordsrecoveries`
--
ALTER TABLE `tb_userspasswordsrecoveries`
  ADD PRIMARY KEY (`idrecovery`),
  ADD KEY `fk_userspasswordsrecoveries_users_idx` (`iduser`);

--
-- AUTO_INCREMENT de tabelas despejadas
--

--
-- AUTO_INCREMENT de tabela `tb_addresses`
--
ALTER TABLE `tb_addresses`
  MODIFY `idaddress` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=23;

--
-- AUTO_INCREMENT de tabela `tb_carts`
--
ALTER TABLE `tb_carts`
  MODIFY `idcart` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=27;

--
-- AUTO_INCREMENT de tabela `tb_cartsproducts`
--
ALTER TABLE `tb_cartsproducts`
  MODIFY `idcartproduct` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=47;

--
-- AUTO_INCREMENT de tabela `tb_categories`
--
ALTER TABLE `tb_categories`
  MODIFY `idcategory` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT de tabela `tb_orders`
--
ALTER TABLE `tb_orders`
  MODIFY `idorder` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--
-- AUTO_INCREMENT de tabela `tb_ordersstatus`
--
ALTER TABLE `tb_ordersstatus`
  MODIFY `idstatus` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT de tabela `tb_persons`
--
ALTER TABLE `tb_persons`
  MODIFY `idperson` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--
-- AUTO_INCREMENT de tabela `tb_products`
--
ALTER TABLE `tb_products`
  MODIFY `idproduct` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT de tabela `tb_users`
--
ALTER TABLE `tb_users`
  MODIFY `iduser` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--
-- AUTO_INCREMENT de tabela `tb_userslogs`
--
ALTER TABLE `tb_userslogs`
  MODIFY `idlog` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `tb_userspasswordsrecoveries`
--
ALTER TABLE `tb_userspasswordsrecoveries`
  MODIFY `idrecovery` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=18;

--
-- Restrições para despejos de tabelas
--

--
-- Limitadores para a tabela `tb_addresses`
--
ALTER TABLE `tb_addresses`
  ADD CONSTRAINT `fk_addresses_persons` FOREIGN KEY (`idperson`) REFERENCES `tb_persons` (`idperson`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Limitadores para a tabela `tb_carts`
--
ALTER TABLE `tb_carts`
  ADD CONSTRAINT `fk_carts_users` FOREIGN KEY (`iduser`) REFERENCES `tb_users` (`iduser`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Limitadores para a tabela `tb_cartsproducts`
--
ALTER TABLE `tb_cartsproducts`
  ADD CONSTRAINT `fk_cartsproducts_carts` FOREIGN KEY (`idcart`) REFERENCES `tb_carts` (`idcart`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_cartsproducts_products` FOREIGN KEY (`idproduct`) REFERENCES `tb_products` (`idproduct`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Limitadores para a tabela `tb_orders`
--
ALTER TABLE `tb_orders`
  ADD CONSTRAINT `fk_orders_addresses` FOREIGN KEY (`idaddress`) REFERENCES `tb_addresses` (`idaddress`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_orders_carts` FOREIGN KEY (`idcart`) REFERENCES `tb_carts` (`idcart`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_orders_ordersstatus` FOREIGN KEY (`idstatus`) REFERENCES `tb_ordersstatus` (`idstatus`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_orders_users` FOREIGN KEY (`iduser`) REFERENCES `tb_users` (`iduser`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Limitadores para a tabela `tb_productscategories`
--
ALTER TABLE `tb_productscategories`
  ADD CONSTRAINT `fk_productscategories_categories` FOREIGN KEY (`idcategory`) REFERENCES `tb_categories` (`idcategory`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_productscategories_products` FOREIGN KEY (`idproduct`) REFERENCES `tb_products` (`idproduct`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Limitadores para a tabela `tb_users`
--
ALTER TABLE `tb_users`
  ADD CONSTRAINT `fk_users_persons` FOREIGN KEY (`idperson`) REFERENCES `tb_persons` (`idperson`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Limitadores para a tabela `tb_userslogs`
--
ALTER TABLE `tb_userslogs`
  ADD CONSTRAINT `fk_userslogs_users` FOREIGN KEY (`iduser`) REFERENCES `tb_users` (`iduser`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Limitadores para a tabela `tb_userspasswordsrecoveries`
--
ALTER TABLE `tb_userspasswordsrecoveries`
  ADD CONSTRAINT `fk_userspasswordsrecoveries_users` FOREIGN KEY (`iduser`) REFERENCES `tb_users` (`iduser`) ON DELETE NO ACTION ON UPDATE NO ACTION;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
