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

}


