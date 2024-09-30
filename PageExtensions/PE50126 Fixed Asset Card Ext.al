pageextension 50126 "Fixed Asset Card Ext" extends "Fixed Asset Card"
{
    layout
    {
        addbefore(Maintenance)
        {
            group(Rentals)
            {
                field("Resource No."; rec."Resource No.")
                {
                    Caption = 'Resource No.';
                    ApplicationArea = all;
                    trigger OnValidate()
                    begin
                        UpdateRent();
                    end;
                }
                field(Rental; Rec.Rental)
                {
                    Caption = 'Rental';
                    ApplicationArea = all;
                    Editable = false;
                }
                field(RentOn; RentOn)
                {
                    Caption = 'On Rental';
                    ApplicationArea = all;
                    Editable = false;
                }
                field(RentStart; RentStart)
                {
                    Caption = 'Rental Start Date';
                    ApplicationArea = all;
                    Editable = false;
                }
                field(RentEnd; RentEnd)
                {
                    Caption = 'Rental End Date';
                    ApplicationArea = all;
                    Editable = false;
                }
                field(RentDays; RentDays)
                {
                    Caption = 'Rental Days';
                    ApplicationArea = all;
                    Editable = false;
                }
            }
        }
    }



    var
        ResLedgEntry: record "Res. Ledger Entry";
        RentOn: boolean;
        RentStart: date;
        RentEnd: date;
        RentDays: Integer;
        Text50000: TextConst ENU = 'Resource %1 is currently on rent.';



    trigger OnAfterGetRecord()
    begin
        RentOn := false;
        RentStart := 0D;
        RentEnd := 0D;
        RentDays := 0;

        ResLedgEntry.reset;
        ResLedgEntry.SetCurrentKey("Entry No.", "Resource No.");
        ResLedgEntry.SetAscending("Entry No.", false);
        ResLedgEntry.setrange("Resource No.", rec."Resource No.");
        ResLedgEntry.setrange(Rental, true);
        ResLedgEntry.setrange("Entry Type", ResLedgEntry."Entry Type"::Rent);
        If ResLedgEntry.Findfirst() then begin
            RentOn := ResLedgEntry."On Rent";
            RentStart := ResLedgEntry."Rental Start Date";
            RentEnd := ResLedgEntry."Rental End Date";
            RentDays := ResLedgEntry."Rental Days";
        end else begin
            RentOn := false;
            RentStart := 0D;
            RentEnd := 0D;
            RentDays := 0;
        end;

        CurrPage.Update();
    end;


    local procedure UpdateRent()
    begin
        RentOn := false;
        RentStart := 0D;
        RentEnd := 0D;
        RentDays := 0;

        ResLedgEntry.reset;
        ResLedgEntry.SetCurrentKey("Entry No.", "Resource No.");
        ResLedgEntry.SetAscending("Entry No.", false);
        ResLedgEntry.setrange("Resource No.", rec."Resource No.");
        ResLedgEntry.setrange(Rental, true);
        ResLedgEntry.setrange("Entry Type", ResLedgEntry."Entry Type"::Rent);
        If ResLedgEntry.Findfirst() then begin
            RentOn := ResLedgEntry."On Rent";
            RentStart := ResLedgEntry."Rental Start Date";
            RentEnd := ResLedgEntry."Rental End Date";
            RentDays := ResLedgEntry."Rental Days";
        end else begin
            RentOn := false;
            RentStart := 0D;
            RentEnd := 0D;
            RentDays := 0;
        end;

        CurrPage.Update();
    end;

}
