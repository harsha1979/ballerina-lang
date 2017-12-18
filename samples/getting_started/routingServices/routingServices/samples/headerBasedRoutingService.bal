package routingServices.samples;

import ballerina.net.http;

@http:configuration {basePath:"/hbr"}
service<http> headerBasedRouting {

    @http:resourceConfig {
        methods:["GET"],
        path:"/"
    }
    resource hbrResource (http:Connection con, http:Request req) {
        endpoint<http:HttpClient> nasdaqEP {
            create http:HttpClient("http://localhost:9090/nasdaqStocks", {});
        }
        endpoint<http:HttpClient> nyseEP {
            create http:HttpClient("http://localhost:9090/nyseStocks", {});
        }
        string nyseString = "nyse";
        var nameString = req.getHeader("name");
        http:Response clientResponse = {};
        http:HttpConnectorError err;
        if (nameString.value == nyseString) {
            clientResponse, err = nyseEP.post("/stocks", req);
        } else {
            clientResponse, err = nasdaqEP.post("/stocks", req);
        }
        _ = con.respond(clientResponse);
    }
}
