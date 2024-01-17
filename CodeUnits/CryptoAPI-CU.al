codeunit 50123 JSONCodeUnit
{



    procedure GetApiData()
    var
        Client: HttpClient;
        Response: HttpResponseMessage;
        JObject: JsonObject;
        JArray: JsonArray;
        JToken: JsonToken;
        TextReponse: Text;
        i: Integer;
        myRecord: Record "CryptoRatesAPITable";
    begin
        if client.Get('https://api.coincap.io/v2/assets', Response) then begin
            if Response.HttpStatusCode = 200 then begin
                Response.Content.ReadAs(TextReponse);

                JObject.ReadFrom(TextReponse);

                if JObject.Get('data', JToken) then begin
                    JArray := JToken.AsArray();

                    for i := 0 to JArray.Count() - 1 do begin
                        JArray.Get(i, JToken);
                        if JToken.IsObject() then
                            ProcessJToken(JToken.AsObject())

                        else
                            Error('JSON token is not an object');
                    end;
                end;

            end else
                error('The http call failed');
        end;

    end;

    procedure GetApiData2()
    var
        Client: HttpClient;
        Response: HttpResponseMessage;
        JObject: JsonObject;
        JArray: JsonArray;
        JToken: JsonToken;
        TextReponse: Text;
        i: Integer;
        myRecord: Record "XMLCryptoDataTableFromCore";
    begin

        if client.Get('http://2a0c:5a84:e804:d800:11b0:470:a6ca:909c:5168/api/BCCommunication/api/dohvatiSve', Response) then begin
            if Response.HttpStatusCode = 200 then begin
                Response.Content.ReadAs(TextReponse);

                JObject.ReadFrom(TextReponse);

                if JObject.Get('data', JToken) then begin
                    JArray := JToken.AsArray();

                    for i := 0 to JArray.Count() - 1 do begin
                        JArray.Get(i, JToken);
                        if JToken.IsObject() then
                            ProcessJToken2(JToken.AsObject())

                        else
                            Error('JSON token is not an object');
                    end;
                end;

            end else
                error('The http call failed', Response.HttpStatusCode);
        end;

    end;



    procedure ExportXML()
    var
        CryptoRatesAPITable: Record "CryptoRatesAPITable";
        SpremanjeText: Text;
        XmlText: Text;
        //SAVING VARS
        FileName: Text;
        OutStream: OutStream;
        InStream: InStream;
        TempBlob: Codeunit "Temp Blob";

    begin
        XmlText := '<?xml version="1.0" encoding="UTF-8"?>''<CryptoRates>';
        if CryptoRatesAPITable.Find('-') then
            repeat
                XmlText += '<RateForCurrency>';
                XMLText += '<id>' + CryptoRatesAPITable.id + '</id>';
                XMLText += '<Rank>' + FORMAT(CryptoRatesAPITable.Rank) + '</Rank>';
                XMLText += '<symbol>' + CryptoRatesAPITable.symbol + '</symbol>';
                XMLText += '<name>' + CryptoRatesAPITable.name + '</name>';
                XMLText += '<supply>' + DecimalToString15(CryptoRatesAPITable.supply) + '</supply>';
                XMLText += '<maxSupply>' + DecimalToString15(CryptoRatesAPITable.maxSupply) + '</maxSupply>';
                XMLText += '<marketCapUsd>' + DecimalToString15(CryptoRatesAPITable.marketCapUsd) + '</marketCapUsd>';
                XMLText += '<volumeUsd24Hr>' + DecimalToString15(CryptoRatesAPITable.volumeUsd24Hr) + '</volumeUsd24Hr>';
                XMLText += '<priceUsd>' + DecimalToString15(CryptoRatesAPITable.priceUsd) + '</priceUsd>';
                XMLText += '<changePercent24Hr>' + DecimalToString15(CryptoRatesAPITable.changePercent24Hr) + '</changePercent24Hr>';
                XMLText += '<vwap24Hr>' + DecimalToString15(CryptoRatesAPITable.vwap24Hr) + '</vwap24Hr>';
                XMLText += '<explorer>' + CryptoRatesAPITable.explorer + '</explorer>';
                XMLText += '<TajmStamp>' + FORMAT(CryptoRatesAPITable.TajmStamp) + '</TajmStamp>';
                XMLText += '</RateForCurrency>';
            until CryptoRatesAPITable.Next() = 0;
        XMLText += '</CryptoRates>';

        //SAVE
        TempBlob.CreateOutStream(OutStream);
        OutStream.WriteText(XmlText);
        TempBlob.CreateInStream(InStream);
        FileName := 'YourFile.xml';
        DownloadFromStream(InStream, 'Save XML', 'XML Files (*.xml)|*.xml', FileName, FileName);
    end;

    procedure ProcessJToken2(Jobjekt: JsonObject)
    var
        MyRecord: Record "XMLCryptoDataTableFromCore";
        JsonToken: JsonToken;
        DecimalValue: Decimal;
        TextValue: Text;
    begin

        MyRecord.Init();
        MyRecord.TajmStamp := CurrentDateTime();

        if Jobjekt.Get('id', JsonToken) then
            MyRecord.id := JsonToken.AsValue().AsText();
        if Jobjekt.Get('rank', JsonToken) and Evaluate(DecimalValue, JsonToken.AsValue().AsText()) then
            MyRecord.rank := DecimalValue;
        if Jobjekt.Get('symbol', JsonToken) then
            MyRecord.symbol := JsonToken.AsValue().AsText();
        if Jobjekt.Get('name', JsonToken) then
            MyRecord.name := JsonToken.AsValue().AsText();
        if Jobjekt.Get('supply', JsonToken) and Evaluate(DecimalValue, JsonToken.AsValue().AsText()) then
            MyRecord.supply := DecimalValue;
        if Jobjekt.Get('maxSupply', JsonToken) then
            if JsonToken.IsValue() AND JsonToken.AsValue().IsNull then
                MyRecord.maxSupply := 0
            else
                if Evaluate(DecimalValue, JsonToken.AsValue().AsText()) then
                    MyRecord.maxSupply := DecimalValue;
        if Jobjekt.Get('marketCapUsd', JsonToken) and Evaluate(DecimalValue, JsonToken.AsValue().AsText()) then
            MyRecord.marketCapUsd := DecimalValue;
        if Jobjekt.Get('volumeUsd24Hr', JsonToken) and Evaluate(DecimalValue, JsonToken.AsValue().AsText()) then
            MyRecord.volumeUsd24Hr := DecimalValue;
        if Jobjekt.Get('priceUsd', JsonToken) and Evaluate(DecimalValue, JsonToken.AsValue().AsText()) then
            MyRecord.priceUsd := DecimalValue;
        if Jobjekt.Get('changePercent24Hr', JsonToken) and Evaluate(DecimalValue, JsonToken.AsValue().AsText()) then
            MyRecord.changePercent24Hr := DecimalValue;
        if Jobjekt.Get('vwap24Hr', JsonToken) then
            if JsonToken.IsValue() AND JsonToken.AsValue().IsNull then
                MyRecord.vwap24Hr := 0
            else
                if Evaluate(DecimalValue, JsonToken.AsValue().AsText()) then
                    MyRecord.vwap24Hr := DecimalValue;
        if Jobjekt.Get('explorer', JsonToken) then
            if JsonToken.IsValue() and not JsonToken.AsValue().IsNull then
                MyRecord.explorer := JsonToken.AsValue().AsText();

        MyRecord.Insert();

    end;

    procedure ProcessJToken(Jobjekt: JsonObject)
    var
        MyRecord: Record "CryptoRatesAPITable";
        JsonToken: JsonToken;
        DecimalValue: Decimal;
        TextValue: Text;
    begin

        MyRecord.Init();
        MyRecord.TajmStamp := CurrentDateTime();

        if Jobjekt.Get('id', JsonToken) then
            MyRecord.id := JsonToken.AsValue().AsText();
        if Jobjekt.Get('rank', JsonToken) and Evaluate(DecimalValue, JsonToken.AsValue().AsText()) then
            MyRecord.rank := DecimalValue;
        if Jobjekt.Get('symbol', JsonToken) then
            MyRecord.symbol := JsonToken.AsValue().AsText();
        if Jobjekt.Get('name', JsonToken) then
            MyRecord.name := JsonToken.AsValue().AsText();
        if Jobjekt.Get('supply', JsonToken) and Evaluate(DecimalValue, JsonToken.AsValue().AsText()) then
            MyRecord.supply := DecimalValue;
        if Jobjekt.Get('maxSupply', JsonToken) then
            if JsonToken.IsValue() AND JsonToken.AsValue().IsNull then
                MyRecord.maxSupply := 0
            else
                if Evaluate(DecimalValue, JsonToken.AsValue().AsText()) then
                    MyRecord.maxSupply := DecimalValue;
        if Jobjekt.Get('marketCapUsd', JsonToken) and Evaluate(DecimalValue, JsonToken.AsValue().AsText()) then
            MyRecord.marketCapUsd := DecimalValue;
        if Jobjekt.Get('volumeUsd24Hr', JsonToken) and Evaluate(DecimalValue, JsonToken.AsValue().AsText()) then
            MyRecord.volumeUsd24Hr := DecimalValue;
        if Jobjekt.Get('priceUsd', JsonToken) and Evaluate(DecimalValue, JsonToken.AsValue().AsText()) then
            MyRecord.priceUsd := DecimalValue;
        if Jobjekt.Get('changePercent24Hr', JsonToken) and Evaluate(DecimalValue, JsonToken.AsValue().AsText()) then
            MyRecord.changePercent24Hr := DecimalValue;
        if Jobjekt.Get('vwap24Hr', JsonToken) then
            if JsonToken.IsValue() AND JsonToken.AsValue().IsNull then
                MyRecord.vwap24Hr := 0
            else
                if Evaluate(DecimalValue, JsonToken.AsValue().AsText()) then
                    MyRecord.vwap24Hr := DecimalValue;
        if Jobjekt.Get('explorer', JsonToken) then
            if JsonToken.IsValue() and not JsonToken.AsValue().IsNull then
                MyRecord.explorer := JsonToken.AsValue().AsText();

        MyRecord.Insert();

    end;


    procedure ExportXmlToFile(XmlText: Text; FileName: Text)
    var
        InStream: InStream;
        OutStream: OutStream;
        TempBlob: Codeunit "Temp Blob";
    begin
        TempBlob.CreateOutStream(OutStream);
        OutStream.WriteText(XmlText);
        TempBlob.CreateInStream(InStream);
        DownloadFromStream(InStream, 'Export XML', '', 'XML Files (*.xml)|*.xml', FileName);
    end;


    procedure ExportXML2()
    var
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
        XmlText: Text;
    begin
        XmlText := '<?xml version="1.0" encoding="UTF-8"?>' + '<Root>';

        if SalesHeader.Find('-') then
            repeat
                XmlText += '<SalesHeader>';
                XmlText += '<No>' + SalesHeader."No." + '</No>';
                XmlText += '<BillToName>' + SalesHeader."Bill-to Name" + '</BillToName>';
                XmlText += '<BillToAddress>' + SalesHeader."Bill-to Address" + '</BillToAddress>';
                XmlText += '<ShipToName>' + SalesHeader."Ship-to Name" + '</ShipToName>';
                XmlText += '<ShipToAddress>' + SalesHeader."Ship-to Address" + '</ShipToAddress>';

                if SalesLine.Find('-') then
                    repeat
                        XmlText += '<SalesLine>';
                        XmlText += '<DocumentNo>' + SalesLine."Document No." + '</DocumentNo>';
                        XmlText += '<LineNo>' + FORMAT(SalesLine."Line No.") + '</LineNo>';
                        XmlText += '<QuantityInvoiced>' + FORMAT(SalesLine."Quantity Invoiced") + '</QuantityInvoiced>';
                        XmlText += '<ShipmentNo>' + SalesLine."Shipment No." + '</ShipmentNo>';
                        XmlText += '<ProfitPercent>' + FORMAT(SalesLine."Profit %") + '</ProfitPercent>';
                        XmlText += '</SalesLine>';
                    until SalesLine.Next() = 0;

                XmlText += '</SalesHeader>';
            until SalesHeader.Next() = 0;

        XmlText += '</Root>';
    end;

    //POMOCNA PROCEDURA ZA DECIMALNA MJESTA
    procedure DecimalToString15(decimalValue: Decimal): Text
    begin
        exit(STRSUBSTNO('%1', decimalValue));
    end;

    var
        myInt: Integer;


    /*
        procedure SendDataToDotNetCore(cryptoData: Record "CryptoRatesAPITable")
        var
            Client: HttpClient;
            Content: HttpContent;
            Response: HttpResponseMessage;
            JsonObject: JsonObject;
            JsonText: Text;
        begin
            // convert record to a JSON object
            JsonObject := ConvertRecordToJson(cryptoData);

            // convert JSON object to text
            JsonObject.WriteTo(JsonText);

            // save text to the HTTP content
            Content.WriteFrom(JsonText);

            // post to the .NET Core API
            if not Client.Post('http://localhost:5073/api/crypto', Content, Response) then
                Error('failed to send data to dotnet...');
        end;

        procedure ConvertRecordToJson(cryptoData: Record "CryptoRatesAPITable"): JsonObject
        var
            JsonObject: JsonObject;
        begin

            JsonObject.Add('id', cryptoData.id);
            JsonObject.Add('Rank', cryptoData.Rank);
            JsonObject.Add('symbol', cryptoData.symbol);
            JsonObject.Add('name', cryptoData.name);
            JsonObject.Add('supply', cryptoData.supply);
            JsonObject.Add('maxSupply', cryptoData.maxSupply);
            JsonObject.Add('marketCapUsd', cryptoData.marketCapUsd);
            JsonObject.Add('volumeUsd24Hr', cryptoData.volumeUsd24Hr);
            JsonObject.Add('priceUsd', cryptoData.priceUsd);
            JsonObject.Add('changePercent24Hr', cryptoData.changePercent24Hr);
            JsonObject.Add('vwap24Hr', cryptoData.vwap24Hr);
            JsonObject.Add('explorer', cryptoData.explorer);
            JsonObject.Add('TajmStamp', Format(cryptoData.TajmStamp));
            exit(JsonObject);
        end;
    */
}