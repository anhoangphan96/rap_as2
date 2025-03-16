@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interest Rate Data View'

define view entity ZI_AS2_ZRATEDATA as select from ztratedata
association to parent ZI_AS2_ZRATENAME as _RateName
    on $projection.ParentID = _RateName.ID
       
{
    key zzid as ID,
    zzparentid as ParentID, 
    zrateid as Zrateid,
    bukrs as Bukrs,
    zeffect_date as ZeffectDate,
    rate as Rate,
    erdat as Erdat,
    @Semantics.user.createdBy: true
    ernam as Ernam,
    aedat as Aedat,
    @Semantics.user.lastChangedBy: true
    aenam as Aenam,
    @Semantics.systemDateTime.lastChangedAt: true
    last_change_at as LastChangeAt,
    
    
    
    _RateName // Make association public
}
