Parse.Cloud.onLiveQueryEvent(async ({
    event,
    client,
    sessionToken,
    useMasterKey,
    installationId,
    clients,
    subscriptions,
    error
    }) => {
    if (event == 'ws_disconnect') {
        if (sessionToken != null) {
            const user = await Parse.User.me(sessionToken);

            const query = new Parse.Query("Live");
            query.equalTo("user", user);
            query.descending("createdAt");
    
            const result = await query.first();

            if (result != null) {
                result.set("finalizada", true);

                await result.save();
            } else {
                console.log(`####### Erro ao finalizar a Live.\nQueryResult: ${result}`);
            }
        } else {
            console.log(`####### Erro ao finalizar a Live.\nSessionToken: ${sessionToken}`)
        }
    }
});