pageextension 50145 Extenzije extends "Sales List"
{

    actions
    {


        addbefore("&Line")
        {
            action(TESTZACORE)
            {
                ApplicationArea = All;
                Caption = 'New Rates';
                Image = New;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;


                trigger OnAction()
                var
                    kurcina: Text;

                    CORETEST: Codeunit "MainServisCore";
                begin
                    kurcina := 'UpdateRecord:1001:DSADSA:DSADSA:DSADSA:DSADSA:DSADSA';



                    Message('KURAC');
                end;

            }


        }
    }
}



