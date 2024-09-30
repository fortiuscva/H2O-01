page 50114 "Resource Attribute Values"
{
    Caption = 'Resource Attribute Values';
    DataCaptionFields = "Attribute ID";
    PageType = List;
    SourceTable = "Resource Attribute Value";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                ShowCaption = false;
                field(Value; rec.Value)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the resource attribute.';
                }
                field(Blocked; rec.Blocked)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies that the attribute value cannot be assigned to a resource. Resources to which the attribute value is already assigned are not affected.';
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            group(Process)
            {
                Caption = 'Process';
                action(ResAttributeValueTranslations)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Translations';
                    Image = Translations;
                    RunObject = Page "Res. Attr. Value Translations";
                    RunPageLink = "Attribute ID" = FIELD("Attribute ID"),
                                  ID = FIELD(ID);
                    ToolTip = 'Opens a window in which you can specify the translations of the selected resource attribute value.';
                }
            }
        }
        area(Promoted)
        {
            group(Category_Process)
            {
                Caption = 'Process';

                actionref(ResAttributeValueTranslations_Promoted; ResAttributeValueTranslations)
                {
                }
            }
        }
    }

    trigger OnOpenPage()
    var
        AttributeID: Integer;
    begin
        if rec.GetFilter("Attribute ID") <> '' then
            AttributeID := rec.GetRangeMin("Attribute ID");
        if AttributeID <> 0 then begin
            rec.FilterGroup(2);
            rec.SetRange("Attribute ID", AttributeID);
            rec.FilterGroup(0);
        end;
    end;
}

