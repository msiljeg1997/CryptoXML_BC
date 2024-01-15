// pageextension 50108 PageExtensionCurrencies extends Currencies
// {
//     layout
//     {
//         addbefore(ExchangeRateAmt)
//         {
//             field(exchangerateamt2; Rec.exchangerateamt2)
//             {
//                 ApplicationArea = All;
//                 Caption = 'Exchange Rate Amount DVOJKA';
//             }
//         }
//     }

//     actions
//     {
//         addbefore("Exchange Rate Services")
//         {
//             action(NewRates)
//             {
//                 ApplicationArea = All;
//                 Caption = 'New Rates';
//                 Image = New;
//                 Promoted = true;
//                 PromotedCategory = Category4;
//                 PromotedIsBig = true;

//                 trigger OnAction()
//                 var
//                     NewCurrencysAPI: Codeunit "Codeunit za Currency";
//                 begin
//                     NewCurrencysAPI.GetApiData();
//                 end;

//             }


//         }

//         addbefore("Exchange Rate Services")
//         {
//             action(TESTZACORE)
//             {
//                 ApplicationArea = All;
//                 Caption = 'New Rates';
//                 Image = New;
//                 Promoted = true;
//                 PromotedCategory = Category4;
//                 PromotedIsBig = true;


//                 trigger OnAction()
//                 var
//                     kurcina: Text;

//                     CORETEST: Codeunit "MainServisCore";
//                 begin
//                     kurcina := '';

//                     CORETEST.ExecuteMethod(kurcina);
//                 end;

//             }


//         }
//     }
// }



