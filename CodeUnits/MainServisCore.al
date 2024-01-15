codeunit 50119 MainServisCore
{
    procedure ExecuteMethod(var DataStream: Text)
    var
        kurcina: Text;
        data: Text;
        imeMetode: Text;

        CryptoRatesAPITable: Record "CryptoRatesAPITable";
    begin
        imeMetode := DataStream;


        case imeMetode of
            'ExecuteMethod':
                begin
                    cMetode.ExecuteMethod(data);
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

