codeunit 50108 "Meter Reg.-Show Ledger"
{
    TableNo = "Meter Register";

    trigger OnRun()
    begin
        MtrLedgEntry.SETRANGE("Entry No.", MtrRegister."From Entry No.", MtrRegister."To Entry No.");
    end;


    var
        MtrLedgEntry: Record "Meter Ledger Entry";
        MtrRegister: record "Meter Register";
}