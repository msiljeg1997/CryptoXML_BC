codeunit 50119 MainServisCore
{
    procedure Egzekucija(var DataStream: Text)
    var
        x: Text;
        resultData: Text;
        CryptoRatesAPITable: Record "CryptoRatesAPITable";
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
        ListaNoda: XmlNodeList;
        XmlNoda: XmlNode;
        Atribut: XmlAttribute;
        xmlDoc: XmlDocument;
        No: Text;
        i: Integer;
    begin
        XmlDocument.ReadFrom(DataStream, xmlDoc);
        if xmlDoc.SelectNodes('//UpdateRecord', ListaNoda) then begin
            if ListaNoda.Count > 0 then begin
                ListaNoda.Get(1, XmlNoda);
                x := XmlNoda.AsXmlElement().Name();
            end;

            if xmlDoc.SelectNodes('//No', ListaNoda) then begin
                for i := 1 to ListaNoda.Count do begin
                    ListaNoda.Get(i, XmlNoda);
                    No := XmlNoda.AsXmlElement().InnerText();
                    if SalesHeader.Get(No) then begin
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

            case x of
                'ExecuteMethod':
                    begin
                        DataStream := '<root>';
                        DataStream += resultData;
                        DataStream += '</root>';
                    end;
                'ExportXML':
                    begin
                        cMetode.ExportXML(resultData);
                        DataStream := '<root>';
                        DataStream += resultData;
                        DataStream += '</root>';
                    end;
                'UpdateRecord':
                    begin

                    end;
            end;
        end;
    end;

    var
        myInt: Integer;
        cMetode: Codeunit Metode;
}
