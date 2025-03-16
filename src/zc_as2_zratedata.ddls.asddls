@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Consumption view for ZI_AS2_ZRATEDATA'
@Metadata.allowExtensions: true
define view entity ZC_AS2_ZRATEDATA as projection on ZI_AS2_ZRATEDATA
{
    
    key ID,
    Zrateid,
    Bukrs,
    ZeffectDate,
    ParentID,
    Rate,
    Erdat,
    Ernam,
    Aedat,
    Aenam,
    LastChangeAt,
    
    @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_CONCAT_HEADER'
    virtual HeaderText : abap.char(40),
    

    /* Associations */
    _RateName : redirected to parent ZC_AS2_ZRATENAME
}
