<div class="container">
    <div class="table-wrapper">
        <div class="table-title">
            <div class="row">
                <div class="col-sm-6">
                    <h2>Products</h2>
                </div>
                <div class="col-sm-6">
                    <i class="material-icons">&#xE147;</i> <span>Add New Product</span></a>
                </div>
            </div>
        </div>
        <table>
            <thead>
            <tr>
                <th>#</th>
                <th>Name</th>
                <th>Price</th>
                <th>Actions</th>
            </tr>
            </thead>
            <tbody>
            <?php $products = $data['products']; ?>
            <?php foreach ($products as $product) : ?>
                <tr>
                    <td><?php echo $product->getIdproduct(); ?></td>
                    <td><a href="index.php?product=show&id=<?php echo $product->getIdproduct(); ?>"><?= $product->getDesproduct(); ?></a></td>
                    <td><?php echo 'R$'.$product->getVlprice(); ?></td>
                    <td>
                        <i class="material-icons" data-toggle="tooltip" title="Edit">&#xE254;</i>
                        <i class="material-icons" data-toggle="tooltip" title="Delete">&#xE872;</i>
                    </td>
                </tr>
            <?php endforeach ?>
            </tbody>
        </table>
    </div>
</div>