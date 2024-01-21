codeunit 50119 MainServisCore
{
    procedure Egzekucija(var DataStream: Text)
    var
        kurcina: Text;
        data: Text;
        x: Text;

        CryptoRatesAPITable: Record "CryptoRatesAPITable";
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";

    begin
        x := DataStream;


        case x of
            'ExecuteMethod':
                begin
                    cMetode.ExecuteMethod(data);
                    DataStream := '<root>';
                    DataStream += data;
                    DataStream += '</root>';
                end;
            'ExportXML':
                begin
                    cMetode.ExportXML(data);
                    DataStream := '<root>';
                    DataStream += data;
                    DataStream += '</root>';
                end;

            else
        end;

    end;

    var
        myInt: Integer;
        cMetode: Codeunit Metode;
}

