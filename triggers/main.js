Parse.Cloud.beforeSave("Reserva", async (request) => {
    const produtoId = request.object.get("idProduto");
    const produtoQtd = request.object.get("quantidade");
    
    const query = new Parse.Query("Produto");
    query.equalTo("objectId", produtoId);
    const result = await query.first();
    
    if (result.get("quantidade") <= 0) {
        throw "Sem unidades disponíveis."
    } else if (result.get("quantidade") < produtoQtd) {
        throw "Quantidade superior ao que está disponível para reserva.";
    } else {
        const qtd = result.get("quantidade");
        result.set("quantidade", qtd - produtoQtd);

        await result.save();
    }
});