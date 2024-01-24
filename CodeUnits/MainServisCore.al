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
        b: Integer;
        SalesHeaderDocNo: Text;
        SalesHeaderNo: Integer;
        SalesHeaderNoText: Text;
        SalesHeaderDocType: Enum "Sales Document Type";
    begin
        x := DataStream;
        case true of
            true:
                begin
                    if x.StartsWith('ExecuteMethod') then begin
                        cMetode.ExecuteMethod(resultData);
                        DataStream := '<root>';
                        DataStream += resultData;
                        DataStream += '</root>';
                    end
                    else
                        if x.StartsWith('ExportXML') then begin
                            cMetode.ExportXML(resultData);
                            DataStream := '<root>';
                            DataStream += resultData;
                            DataStream += '</root>';
                        end
                        else
                            if x.StartsWith('<UpdateRecord>') then begin
                                cMetode.UpdateRecord(DataStream);
                            end;
                end;
        end;
    end;




    var
        myInt: Integer;
        cMetode: Codeunit Metode;
}
