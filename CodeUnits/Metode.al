codeunit 50111 Metode
{

    procedure ExecuteMethod(var DataStream: Text)
    var
        CryptoRatesAPITable: Record "CryptoRatesAPITable";
    begin
        CryptoRatesAPITable.Reset();
        if CryptoRatesAPITable.Find('-') then
            repeat
                DataStream += '<Data>';
                If CryptoRatesAPITable.id = '' then
                    DataStream += '<id>nodata</id>'
                else
                    DataStream += '<id>' + CryptoRatesAPITable.id + '</id>';
                DataStream += '<rank>' + FORMAT(CryptoRatesAPITable.Rank) + '</rank>';
                If CryptoRatesAPITable.symbol = '' then
                    DataStream += '<symbol>nodata</symbol>'
                else
                    DataStream += '<symbol>' + CryptoRatesAPITable.symbol + '</symbol>';
                If CryptoRatesAPITable.name = '' then
                    DataStream += '<name>nodata</name>'
                else
                    DataStream += '<name>' + CryptoRatesAPITable.name + '</name>';
                DataStream += '<supply>' + CheckDecimal(CryptoRatesAPITable.supply) + '</supply>';
                If CryptoRatesAPITable.supply = 0 then
                    DataStream += '<supply>00.00</supply>'
                else
                    If CryptoRatesAPITable.maxSupply = 0 then
                        DataStream += '<maxSupply>00.00</maxSupply>'
                    else
                        DataStream += '<maxSupply>' + CheckDecimal(CryptoRatesAPITable.maxSupply) + '</maxSupply>';
                If CryptoRatesAPITable.marketCapUsd = 0 then
                    DataStream += '<marketCapUsd>00.00</marketCapUsd>'
                else
                    DataStream += '<marketCapUsd>' + CheckDecimal(CryptoRatesAPITable.marketCapUsd) + '</marketCapUsd>';
                If CryptoRatesAPITable.volumeUsd24Hr = 0 then
                    DataStream += '<volumeUsd24Hr>00.00</volumeUsd24Hr>'
                else
                    DataStream += '<volumeUsd24Hr>' + CheckDecimal(CryptoRatesAPITable.volumeUsd24Hr) + '</volumeUsd24Hr>';
                If CryptoRatesAPITable.priceUsd = 0 then
                    DataStream += '<priceUsd>00.00</priceUsd>'
                else
                    DataStream += '<priceUsd>' + CheckDecimal(CryptoRatesAPITable.priceUsd) + '</priceUsd>';
                If CryptoRatesAPITable.changePercent24Hr = 0 then
                    DataStream += '<changePercent24Hr>00.00</changePercent24Hr>'
                else
                    DataStream += '<changePercent24Hr>' + CheckDecimal(CryptoRatesAPITable.changePercent24Hr) + '</changePercent24Hr>';
                If CryptoRatesAPITable.vwap24Hr = 0 then
                    DataStream += '<vwap24Hr>00.00</vwap24Hr>'
                else
                    DataStream += '<vwap24Hr>' + CheckDecimal(CryptoRatesAPITable.vwap24Hr) + '</vwap24Hr>';
                If CryptoRatesAPITable.explorer = '' then
                    DataStream += '<explorer>nodata</explorer>'
                else
                    DataStream += '<explorer>' + CryptoRatesAPITable.explorer + '</explorer>';
                if CryptoRatesAPITable.TajmStamp = 0DT then
                    CryptoRatesAPITable.TajmStamp := CREATEDATETIME(DMY2DATE(1, 1, 2000), 120000T)
                else
                    CryptoRatesAPITable.TajmStamp := CheckDateTime(CryptoRatesAPITable.TajmStamp);
                DataStream += '<tajmStamp>' + FORMAT(CryptoRatesAPITable.TajmStamp, 0, 9) + '</tajmStamp>';
                DataStream += '</Data>';
            until CryptoRatesAPITable.Next() = 0
        else begin

        end;
    end;



    procedure CheckDateTime(dateTime: DateTime): DateTime
    var
        DefaultDate: DateTime;
    begin
        DefaultDate := dateTime;
        if dateTime < CREATEDATETIME(DMY2DATE(1, 1, 1753), 0T) then
            DefaultDate := CREATEDATETIME(DMY2DATE(1, 1, 2000), 120000T);
        if dateTime > CREATEDATETIME(DMY2DATE(31, 12, 9999), 235959T) then
            DefaultDate := CREATEDATETIME(DMY2DATE(1, 1, 2000), 120000T);

        EXIT(DefaultDate);
    end;

    procedure CheckDecimal(inDecimal: Decimal): Text
    var
    begin
        EXIT(FORMAT(Round(inDecimal, 0.000000001, '='), 0, 9));
    end;







    procedure ExportXML(var DataStream: Text)
    var
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
    begin
        DataStream := '';
        if SalesHeader.Find('-') then
            repeat
                DataStream += '<SalesHeader>';
                DataStream += '<No>' + FORMAT(SalesHeader."No.") + '</No>';
                DataStream += '<BillToName>' + SalesHeader."Bill-to Name" + '</BillToName>';
                DataStream += '<BillToAddress>' + SalesHeader."Bill-to Address" + '</BillToAddress>';
                DataStream += '<ShipToName>' + SalesHeader."Ship-to Name" + '</ShipToName>';
                DataStream += '<ShipToAddress>' + SalesHeader."Ship-to Address" + '</ShipToAddress>';
                DataStream += '<DocumentType>' + FORMAT(SalesHeader."Document Type") + '</DocumentType>';

                SalesLine.SetRange("Document No.", SalesHeader."No.");
                SalesLine.SetRange("Document Type", SalesHeader."Document Type");

                if SalesLine.Find('-') then
                    repeat
                        DataStream += '<SalesLine>';
                        DataStream += '<DocumentNo>' + SalesLine."Document No." + '</DocumentNo>';
                        DataStream += '<DocumentType>' + FORMAT(SalesLine."Document Type") + '</DocumentType>';
                        DataStream += '<QuantityInvoiced>' + FORMAT(SalesLine."Quantity Invoiced") + '</QuantityInvoiced>';
                        DataStream += '<ProfitPercent>' + FORMAT(SalesLine."Profit %") + '</ProfitPercent>';
                        DataStream += '</SalesLine>';
                    until SalesLine.Next() = 0;

                DataStream += '</SalesHeader>';
            until SalesHeader.Next() = 0;

        Message(DataStream);
    end;


    procedure UpdateRecord(No: Text; NewBillToName: Text; NewBillToAddress: Text; NewShipToName: Text; NewShipToAddress: Text; NewDocumentType: Text)
    var
        SalesHeader: Record "Sales Header";
    begin
        if SalesHeader.Get(NewDocumentType, No) then begin
            SalesHeader."Bill-to Name" := NewBillToName;
            SalesHeader."Bill-to Address" := NewBillToAddress;
            SalesHeader."Ship-to Name" := NewShipToName;
            SalesHeader."Ship-to Address" := NewShipToAddress;

            SalesHeader.Modify();
        end else
            Error('nema errora %1', No);
    end;

    procedure EvaluateDocumentType(DocumentTypeText: Text): Enum "Sales Document Type"
    begin
        case DocumentTypeText of
            'Quote':
                exit("Sales Document Type"::Quote);
            'Order':
                exit("Sales Document Type"::Order);
            'Invoice':
                exit("Sales Document Type"::Invoice);
            'Credit Memo':
                exit("Sales Document Type"::"Credit Memo");
            'Return Order':
                exit("Sales Document Type"::"Return Order");
            'Blanket Order':
                exit("Sales Document Type"::"Blanket Order");
            else
                Error('Invalid Document Type: %1', DocumentTypeText);
        end;
    end;




    procedure UpdateRecord(var DataStream: Text)
    var
        x: Text;
        SalesHeader: Record "Sales Header";
        ListaNoda: XmlNodeList;
        XmlNoda: XmlNode;
        xmlDoc: XmlDocument;
        i: Integer;
        b: Integer;
        SalesHeaderDocNo: Text;
        SalesHeaderNoText: Text;
        SalesHeaderDocType: Enum "Sales Document Type";
    begin
        XmlDocument.ReadFrom(DataStream, xmlDoc);
        if xmlDoc.SelectNodes('//UpdateRecord', ListaNoda) then begin
            if ListaNoda.Count > 0 then begin
                ListaNoda.Get(1, XmlNoda);
                x := XmlNoda.AsXmlElement().Name();
            end;

            if xmlDoc.SelectNodes('//No.', ListaNoda) then begin
                for i := 1 to ListaNoda.Count do begin
                    ListaNoda.Get(i, XmlNoda);
                    SalesHeaderNoText := XmlNoda.AsXmlElement().InnerText();
                    if xmlDoc.SelectNodes('//DocumentType', ListaNoda) then begin
                        for b := 1 to ListaNoda.Count do begin
                            ListaNoda.Get(1, XmlNoda);
                            SalesHeaderDocNo := XmlNoda.AsXmlElement().InnerText();
                        end;

                        if SalesHeaderDocNo <> '' then begin
                            if Evaluate(SalesHeaderDocType, SalesHeaderDocNo) then begin
                                if SalesHeader.Get(SalesHeaderDocType, SalesHeaderNoText) then begin
                                    if xmlDoc.SelectNodes('//BillToName', ListaNoda) then begin
                                        if ListaNoda.Count > 0 then begin
                                            ListaNoda.Get(1, XmlNoda);
                                            SalesHeader."Bill-to Name" := XmlNoda.AsXmlElement().InnerText();
                                        end;
                                    end;
                                    if xmlDoc.SelectNodes('//BillToAddress', ListaNoda) then begin
                                        if ListaNoda.Count > 0 then begin
                                            ListaNoda.Get(1, XmlNoda);
                                            SalesHeader."Ship-to Address" := XmlNoda.AsXmlElement().InnerText();
                                        end;
                                    end;
                                    if xmlDoc.SelectNodes('//ShipToName', ListaNoda) then begin
                                        if ListaNoda.Count > 0 then begin
                                            ListaNoda.Get(1, XmlNoda);
                                            SalesHeader."Ship-to Name" := XmlNoda.AsXmlElement().InnerText();
                                        end;
                                    end;
                                    if xmlDoc.SelectNodes('//ShipToAddress', ListaNoda) then begin
                                        if ListaNoda.Count > 0 then begin
                                            ListaNoda.Get(1, XmlNoda);
                                            SalesHeader."Ship-to Address" := XmlNoda.AsXmlElement().InnerText();
                                        end;
                                    end;
                                    SalesHeader.Modify();
                                end;
                            end;
                        end;
                    end;
                end;
            end;
        end;
    end;

    procedure AddRecord(var DataStream: Text)
    var
        SalesHeader: Record "Sales Header";
        ListaNoda: XmlNodeList;
        XmlNoda: XmlNode;
        xmlDoc: XmlDocument;
        NodeName: Text;
        NodeValue: Text;
        SalesHeaderNo: Text;
        i: Integer;
        SalesHeaderDocType: Enum "Sales Document Type";
    begin
        XmlDocument.ReadFrom(DataStream, xmlDoc);
        xmlDoc.SelectNodes('/AddRecord/*', ListaNoda);
        for i := 1 to ListaNoda.Count do begin
            ListaNoda.Get(i, XmlNoda);
            NodeName := XmlNoda.AsXmlElement().Name;
            NodeValue := XmlNoda.AsXmlElement().InnerText();
            case NodeName of
                'No.':
                    SalesHeaderNo := NodeValue;
                'DocumentType':
                    Evaluate(SalesHeaderDocType, NodeValue);
            end;
        end;
        if SalesHeader.Get(SalesHeaderDocType, SalesHeaderNo) then
            Error('Record sa No. %1 and Document Type %2 postoji.', SalesHeaderNo, FORMAT(SalesHeaderDocType));
        for i := 1 to ListaNoda.Count do begin
            ListaNoda.Get(i, XmlNoda);
            NodeName := XmlNoda.AsXmlElement().Name;
            NodeValue := XmlNoda.AsXmlElement().InnerText();
            case NodeName of
                'No.':
                    SalesHeader."No." := NodeValue;
                'BillToName':
                    SalesHeader."Bill-to Name" := NodeValue;
                'BillToAddress':
                    SalesHeader."Bill-to Address" := NodeValue;
                'ShipToName':
                    SalesHeader."Ship-to Name" := NodeValue;
                'ShipToAddress':
                    SalesHeader."Ship-to Address" := NodeValue;
                'DocumentType':
                    Evaluate(SalesHeader."Document Type", NodeValue);
            end;
        end;
        SalesHeader.Insert();
    end;




    procedure DeleteRecord(var DataStream: Text)
    var
        SalesHeader: Record "Sales Header";
        ListaNoda: XmlNodeList;
        XmlNoda: XmlNode;
        xmlDoc: XmlDocument;
        i: Integer;
        b: Integer;
        SalesHeaderDocNo: Text;
        SalesHeaderNoText: Text;
        SalesHeaderDocType: Enum "Sales Document Type";
        x: Text;
    begin
        XmlDocument.ReadFrom(DataStream, xmlDoc);
        if xmlDoc.SelectNodes('//DeleteRecord', ListaNoda) then begin
            if ListaNoda.Count > 0 then begin
                ListaNoda.Get(1, XmlNoda);
                x := XmlNoda.AsXmlElement().Name();
            end;

            if xmlDoc.SelectNodes('//No.', ListaNoda) then begin
                for i := 1 to ListaNoda.Count do begin
                    ListaNoda.Get(i, XmlNoda);
                    SalesHeaderNoText := XmlNoda.AsXmlElement().InnerText();
                    if xmlDoc.SelectNodes('//DocumentType', ListaNoda) then begin
                        for b := 1 to ListaNoda.Count do begin
                            ListaNoda.Get(1, XmlNoda);
                            SalesHeaderDocNo := XmlNoda.AsXmlElement().InnerText();
                        end;

                        if SalesHeaderDocNo <> '' then begin
                            if Evaluate(SalesHeaderDocType, SalesHeaderDocNo) then begin
                                if SalesHeader.Get(SalesHeaderDocType, SalesHeaderNoText) then begin
                                    SalesHeader.Delete();
                                end;
                            end;
                        end;
                    end;
                end;
            end;
        end;
    end;
}


