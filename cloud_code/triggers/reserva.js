Parse.Cloud.beforeSave("Reserva", async (request) => {
    const compraProdutoId = request.object.get("idProduto");
    const compraProdutoQtd = request.object.get("quantidade");
    
    const query = new Parse.Query("Produto");
    query.equalTo("objectId", compraProdutoId);
    
    const result = await query.first();

    const qtdEmEstoque = result.get("quantidade");
    
    if (qtdEmEstoque <= 0) {
        throw "Sem unidades disponíveis."
    } else if (qtdEmEstoque < compraProdutoQtd) {
        throw "Quantidade superior ao que está disponível para compra.";
    } else {
        result.set("quantidade", qtdEmEstoque - compraProdutoQtd);

        await result.save();
    }
});