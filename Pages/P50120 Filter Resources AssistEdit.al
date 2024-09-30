page 50120 "Filter Resources - AssistEdit"
{
    Caption = 'Specify Filter Value';
    PageType = StandardDialog;
    SourceTable = "Resource Attribute";

    layout
    {
        area(content)
        {
            group(Control14)
            {
                ShowCaption = false;
                group(Control2)
                {
                    ShowCaption = false;
                    Visible = TextGroupVisible;
                    field(TextConditions; TextConditions)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Condition';
                        OptionCaption = 'Contains,Starts With,Ends With,Exact Match';
                        ToolTip = 'Specifies the condition for the filter value. Example: To specify that the value for a Resource Description attribute must start with blue, fill the fields as follows: Condition field = Starts With. Value field = blue.';
                    }
                    field(TextValue; TextValue)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Value';
                        ToolTip = 'Specifies the filter value that the condition applies to.';
                    }
                }
                group(Control9)
                {
                    ShowCaption = false;
                    Visible = NumericGroupVisible;
                    field(NumericConditions; NumericConditions)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Condition';
                        OptionCaption = '=  - Equals,..  - Range,<  - Less,<= - Less or Equal,>  - Greater,>= - Greater or Equal';
                        ToolTip = 'Specifies the condition for the filter value. Example: To specify that the value for a Quantity attribute must be higher than 10, fill the fields as follows: Condition field > Greater. Value field = 10.';

                        trigger OnValidate()
                        begin
                            UpdateGroupVisiblity();
                        end;
                    }
                    field(NumericValue; NumericValue)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Value';
                        ToolTip = 'Specifies the filter value that the condition applies to.';

                        trigger OnValidate()
                        begin
                            ValidateValueIsNumeric(NumericValue);
                        end;
                    }
                    group(Control12)
                    {
                        ShowCaption = false;
                        Visible = NumericGroupMaxValueVisible;
                        field(MaxNumericValue; MaxNumericValue)
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'To Value';
                            ToolTip = 'Specifies the end value in the range.';

                            trigger OnValidate()
                            begin
                                ValidateValueIsNumeric(MaxNumericValue);
                            end;
                        }
                    }
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetCurrRecord()
    begin
        UpdateGroupVisiblity();
    end;

    var
        TextValue: Text[240];
        TextConditions: Option Contains,"Starts With","Ends With","Exact Match";
        NumericConditions: Option "=  - Equals","..  - Range","<  - Less","<= - Less or Equal",">  - Greater",">= - Greater or Equal";
        NumericValue: Text;
        MaxNumericValue: Text;
        NumericGroupVisible: Boolean;
        NumericGroupMaxValueVisible: Boolean;
        TextGroupVisible: Boolean;

    local procedure UpdateGroupVisiblity()
    begin
        TextGroupVisible := rec.Type = rec.Type::Text;
        NumericGroupVisible := rec.Type in [rec.Type::Decimal, rec.Type::Integer];
        NumericGroupMaxValueVisible := NumericGroupVisible and (NumericConditions = NumericConditions::"..  - Range");

        OnAfterUpdateGroupVisiblity(Rec, TextGroupVisible, NumericGroupMaxValueVisible, NumericGroupVisible, NumericConditions);
    end;

    local procedure ValidateValueIsNumeric(TextValue: Text)
    var
        ValidDecimal: Decimal;
        ValidInteger: Integer;
    begin
        if rec.Type = rec.Type::Decimal then
            Evaluate(ValidDecimal, TextValue);

        if rec.Type = rec.Type::Integer then
            Evaluate(ValidInteger, TextValue);

        OnAfterValidateValueIsNumeric(Rec, TextValue);
    end;

    procedure LookupOptionValue(PreviousValue: Text): Text
    var
        ResAttributeValue: Record "Resource Attribute Value";
        SelectedResAttributeValue: Record "Resource Attribute Value";
        SelectResAttributeValue: Page "Select Res. Attribute Value";
        OptionFilter: Text;
    begin
        ResAttributeValue.SetRange("Attribute ID", rec.ID);
        SelectResAttributeValue.SetTableView(ResAttributeValue);
        SelectResAttributeValue.LOOKUPMODE(TRUE);
        SelectResAttributeValue.Editable(false);

        if not (SelectResAttributeValue.RunModal() in [ACTION::OK, ACTION::LookupOK]) then
            exit(PreviousValue);

        OptionFilter := '';
        SelectResAttributeValue.GetSelectedValue(SelectedResAttributeValue);
        if SelectedResAttributeValue.FindSet() then begin
            repeat
                if SelectedResAttributeValue.Value <> '' then
                    OptionFilter := StrSubstNo('%1|%2', SelectedResAttributeValue.Value, OptionFilter);
            until SelectedResAttributeValue.Next() = 0;
            OptionFilter := CopyStr(OptionFilter, 1, StrLen(OptionFilter) - 1);
        end;

        exit(OptionFilter);
    end;

    procedure GenerateFilter() FilterText: Text
    begin
        case rec.Type of
            rec.Type::Decimal, rec.Type::Integer:
                begin
                    if NumericValue = '' then
                        exit('');

                    if NumericConditions = NumericConditions::"..  - Range" then
                        FilterText := StrSubstNo('%1..%2', NumericValue, MaxNumericValue)
                    else
                        FilterText := StrSubstNo('%1%2', DelChr(CopyStr(Format(NumericConditions), 1, 2), '=', ' '), NumericValue);
                end;
            rec.Type::Text:
                begin
                    if TextValue = '' then
                        exit('');

                    case TextConditions of
                        TextConditions::"Starts With":
                            FilterText := StrSubstNo('@%1*', TextValue);
                        TextConditions::"Ends With":
                            FilterText := StrSubstNo('@*%1', TextValue);
                        TextConditions::Contains:
                            FilterText := StrSubstNo('@*%1*', TextValue);
                        TextConditions::"Exact Match":
                            FilterText := StrSubstNo('''%1''', TextValue);
                    end;
                end;
        end;

        OnAfterGenerateFilter(Rec, NumericValue, NumericConditions, MaxNumericValue, FilterText);
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterGenerateFilter(ResAttribute: Record "Resource Attribute"; NumericValue: Text; NumericConditions: Option "=  - Equals","..  - Range","<  - Less","<= - Less or Equal",">  - Greater",">= - Greater or Equal"; MaxNumericValue: Text; var FilterText: Text)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterValidateValueIsNumeric(ResAttribute: Record "Resource Attribute"; TextValue: Text)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterUpdateGroupVisiblity(ResAttribute: Record "Resource Attribute"; var TextGroupVisible: Boolean; var NumericGroupMaxValueVisible: Boolean; var NumericGroupVisible: Boolean; NumericConditions: Option "=  - Equals","..  - Range","<  - Less","<= - Less or Equal",">  - Greater",">= - Greater or Equal")
    begin
    end;
}

